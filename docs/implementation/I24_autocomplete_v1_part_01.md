## I24 — Autocomplete v1: composable “TextField + Menu” (Flutter-like API) без дублирования логики (part 1)

Back: [Index](./I24_autocomplete_v1.md)

## I24 — Autocomplete v1: composable “TextField + Menu” (Flutter-like API) без дублирования логики

### Цель

Сделать `RAutocomplete<T>` (идеологически и по неймингу близко к Flutter `Autocomplete`) как headless‑компонент‑конструктор:

- **Input**: редактируемый текст (EditableText ownership в компоненте; визуал — через `RTextFieldRenderer`).
- **Options menu**: то же popover‑меню, что и у dropdown (визуал — через `RDropdownButtonRenderer`, но используем только `menu` target).
- **Glue/behavior**: один компонент, который соединяет input + menu и держит инварианты (focus/keyboard/a11y/close contract/perf).

Ключевой принцип: **не копировать** overlay/listbox/menu‑механику “ещё раз”. Общие куски должны жить в `anchored_overlay_engine` и `headless_foundation` как re-usable primitives.

---

## TL;DR (решение)

- `RAutocomplete<T>` — отдельный компонентный пакет (как и dropdown/textfield), но:
  - **не зависит** от `headless_dropdown_button` и `headless_textfield` (DAG).
  - использует **те же contracts** (`headless_contracts`) и primitives (`headless_foundation`).
- Визуально:
  - input рисуется через `RTextFieldRenderer` (contracts),
  - меню рисуется через `RDropdownButtonRenderer` (contracts) **в режиме menu-only**.
- Поведенчески:
  - список ведёт себя как listbox (highlight/disabled/wrap-around),
  - open/close соблюдают overlay close contract,
  - focus по умолчанию остаётся в input (важно для IME и UX).

---

## Не‑цели (v1)

- **Async options** (debounce/cancel/streaming) — только sync `optionsBuilder`, как у Flutter `Autocomplete`.
- **Multi-select**.
- **Free solo** (ввод произвольного значения как “валидный выбор”) — отдельный режим/итерация.
- **Виртуализация списка** (renderer concern).
- **Сложные platform IME нюансы** сверх того, что даёт `EditableText` (мы не ломаем composition и не перехватываем лишние keys).

---

## Контекст (что уже есть)

- `anchored_overlay_engine`: overlay engine.
- `headless_foundation`: listbox navigation/typeahead (+ `ListboxController.setMetas`).
- `headless_contracts`: renderer contracts + tokens/overrides/slots для dropdown и textfield.
- `headless_theme`: capability discovery/runtime helpers (доставка capabilities, policies).
- `I23`: rich item model (`HeadlessListItemModel` + `HeadlessItemAdapter`) — база для rich options.

Важно: Autocomplete ≠ “Dropdown с search”. Это **другой trigger** (EditableText), но **то же меню**.

---

## Принципиальная архитектура Autocomplete

### Что переиспользуем (без component→component deps)

- **Overlay lifecycle + close contract**: `anchored_overlay_engine`.
- **Listbox механика**: `headless_foundation/listbox` (highlight, wrap-around, typeahead buffer как утилита).
- **UI contracts**:
  - input: `RTextFieldRenderer` / `RTextFieldRenderRequest` (`headless_contracts`)
  - menu: `RDropdownMenuRenderRequest` / `RDropdownButtonRenderer` (`headless_contracts`)

### Что НЕ переиспользуем напрямую

- `RDropdownButton` как “движок меню” — у него pressable trigger и другая focus/keyboard модель.
- `RTextField` как готовый виджет — иначе появится component→component dependency.

`RAutocomplete` строит `EditableText` сам, но используя те же foundation owners/паттерны.

---

## Public API `RAutocomplete<T>` (Flutter-like)

### Канонический путь (recommended)

```dart
RAutocomplete<Country>(
  optionsBuilder: (text) {
    final q = text.text.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return countries.where((c) => c.name.toLowerCase().contains(q));
  },
  itemAdapter: countryItemAdapter,
  onSelected: (c) => setState(() => selected = c),
  placeholder: 'Страна',
)
```

### Предлагаемый API v1 (намеренно компактный)

Семантически близко к Flutter `Autocomplete`:

- `final Iterable<T> Function(TextEditingValue textEditingValue) optionsBuilder;`
- `final ValueChanged<T>? onSelected;`
- `final TextEditingController? controller;` (optional external)
- `final FocusNode? focusNode;` (optional external)
- `final bool autofocus;`
- `final bool disabled;` (дополнительно к `onSelected == null`)
- `final bool readOnly;`
- `final TextEditingValue? initialValue;` (используется только если `controller == null`)

Item anatomy:
- `final HeadlessItemAdapter<T> itemAdapter;` (обязателен)

Минимум spec:
- `final String? placeholder;`
- `final String? semanticLabel;`

Wiring для визуала (конструктор):
- `final RTextFieldSlots? fieldSlots;`
- `final RenderOverrides? fieldOverrides;`
- `final RDropdownButtonSlots? menuSlots;`
- `final RenderOverrides? menuOverrides;`

Политики:
- `final bool openOnFocus;` (default: true)
- `final bool openOnInput;` (default: true)
- `final bool openOnTap;` (default: true)
- `final bool closeOnSelected;` (default: true)
- `final int? maxOptions;` (default: null)

Примечание: overrides разделены на `fieldOverrides` и `menuOverrides`, чтобы не было “протекания” контрактов.

---

## Ключевой thin moment: синхронизация “выбор ↔ текст”

Flutter `Autocomplete` хранит выбор через **текст** (при выборе опции он просто проставляет текст и закрывает меню).
Для стабильного UX в v1 фиксируем правила:

### 1) Что считать “selected”

`RAutocomplete` хранит внутренний `selectedId` (derived из выбранного `T` через `itemAdapter.id`).

### 2) Что происходит при выборе опции

При `selectIndex(i)`:

- берём `option = options[i]`
- **вызываем** `onSelected(option)` (если не disabled)
- **синхронизируем текст**:
  - `controller.value = TextEditingValue(text: itemAdapter.primaryText(option), selection: конец строки, composing: empty)`
- обновляем `selectedId = itemAdapter.id(option)`
- закрываем меню (если `closeOnSelected`)

### 3) Что происходит при ручном редактировании текста

Если пользователь изменил текст (и это не программная установка текста при select):

- если новый текст **не равен** displayText выбранной опции → `selectedId = null`
- это предотвращает “ложный selected checkmark” при уже изменённом запросе

### 3.1) Тонкость: как отличить “пользовательский ввод” от “программной установки текста”

После `selectIndex` мы **обязаны** не ловить свой же `controller` listener как “пользователь изменил текст”, иначе:
- мы тут же сбросим `selectedId`,
- можем “переоткрыть” меню из-за `openOnInput`.

Решение v1 (MUST):
- внутренний флаг `isApplyingSelectionText` (или `suppressNextTextChange`),
- при программной установке текста:
  - поставить флаг,
  - обновить controller,
  - снять флаг на следующем microtask/post-frame.

Параллельно держим `lastSelectedDisplayText`, чтобы сравнение было O(1) и не зависело от `T`.

### 4) Что если optionsBuilder больше не содержит selectedId

`selectedIndex = null`, highlight определяется как first enabled (при open).

---

## Ещё один тонкий момент: открытие меню по tap при уже сфокусированном input

Сценарий:
- input уже `focused`,
- пользователь кликает в поле мышью (или тапаем на мобиле),
- `openOnFocus` не срабатывает (фокус не менялся),
- `openOnInput` не срабатывает (текст не менялся),
→ меню не откроется, хотя пользователь “ожидает подсказки”.

Поэтому `openOnTap` (default: true) — MUST для предсказуемого UX.

Правило:
- если `openOnTap == true` и `options.isNotEmpty` → open menu
- но **не открывать** если компонент disabled.

---

## Renderer contracts: как склеить визуал без нового renderer

### Input (textfield)

`RAutocomplete` строит `EditableText` и отдаёт его в `RTextFieldRenderer` через `RTextFieldRenderRequest.input` (как и `RTextField` компонент).

### Menu (dropdown menu-only)

Overlay строит **только** dropdown menu:

- `RDropdownMenuRenderRequest` (из `headless_contracts`)
- `items: List<HeadlessListItemModel>` (из `itemAdapter.build`)
- `state.selectedIndex/highlightedIndex` (derived)
- `commands.selectIndex(index)` вызывает select flow выше

Триггер dropdown renderer **не используется**.

---

## Focus model (критично для Autocomplete)

В отличие от dropdown, **фокус по умолчанию остаётся на input**.

Почему:
- IME/composition устойчивее,
- ввод текста не “прыгает” между FocusNode,
- ожидаемое поведение Autocomplete в Flutter/Material.

Следствия:
- keyboard handler живёт на стороне input‑поддерева (не в меню FocusNode)
- меню остаётся кликабельным указателем
- Esc/стрелки/Enter обрабатываются компонентом, а не menu Focus

Опционально позже (v1.1): режим “menu takes focus” для readOnly сценариев.

---

## Keyboard (тонкие моменты)

Правила v1 (POLA, близко к Flutter ожиданиям):

- `ArrowDown`:
  - если меню закрыто и есть options → открыть и highlight initial
  - если меню открыто → highlightNext (wrap-around, skipping disabled)
- `ArrowUp`: аналогично вверх
- `Enter`:
  - если меню открыто и есть highlighted → selectHighlighted
  - иначе: не вмешиваться (чтобы не ломать submit форм)
- `Escape`:
  - если меню открыто → close menu (без изменения selection/text)
  - иначе: пропустить дальше
- `Tab`:
  - close menu и отдать управление фокусу системе
- Typeahead:
  - default: выключен (потому что ввод = сам текст)
  - режим readOnly (если включим) может реюзать listbox typeahead.

IME guardrail:
- Не перехватывать “все keys”. Обрабатываем только конкретные (Up/Down/Enter/Escape/Tab).

---

## A11y / Semantics (тонкие моменты)

Минимум v1:

- Root вокруг input: `Semantics(expanded: menuOpen, label: semanticLabel, textField: true)`
- Items в меню: `Semantics(selected/enabled/label)` где
  - `label = item.semanticsLabel ?? item.primaryText`

Ограничение v1:
- С “focus stays in input” screen reader navigation по опциям может отличаться от идеала. Это ок для v1, но нужно явно зафиксировать как follow-up для SLA/conformance в v1.1.

---

## Производительность (тонкие моменты)

Риски:

- `optionsBuilder` может быть дорогим.
- `itemAdapter.build` может быть дорогим.

Правила v1:
- options пересчитываются только при изменении `TextEditingValue` (и/или focus policy), а не на каждый unrelated build.
- mapping в `HeadlessListItemModel` кэшируется по:
  - list identity + length + signature (как сделано в dropdown resolver).
- listbox metas синхронизируются только при изменении options списка.

---

