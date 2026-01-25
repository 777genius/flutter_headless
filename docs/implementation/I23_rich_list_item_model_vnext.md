## I23 — Rich List Item Model (vNext): Typed item anatomy + features for listbox/select-like components

### Цель

Сделать “богатые” списки (страны/аватары/подзаголовки/префиксы телефонов) **удобно кастомизируемыми** в headless‑подходе:

- без `index -> countries[index]` хака в slots,
- без раздувания контрактов сотнями “жёстких” полей,
- с **типобезопасным** расширением item‑данных,
- сохраняя архитектуру: **поведение в `R*`**, **визуал в renderer**, **listbox/typeahead механика — в foundation**.

Результат: разработчик приложения один раз описывает mapping `T -> item model` (адаптер), а дальше получает разные дизайны через `slots`/`overrides`/subtree capability overrides, не форкая поведение.

---

## Не‑цели (чтобы не расползлось)

- Не переносим baseline UI/разметку в компоненты: всё “богатое” — через renderer/slots.
- Не тащим `Widget`, `BuildContext`, `TextStyle`, `Color` в foundation‑модели.
- Не делаем combobox/search input (это отдельная итерация/компонент).
- Не меняем overlay/close contract и ownership правила.

---

## Контекст и проблема

Сейчас dropdown‑паттерн “select-like” в репозитории — это `headless_dropdown_button` + renderer contract в `headless_contracts`.
Item‑данные для renderer минимальны (практически `label + disabled + index`), поэтому богатые кейсы (например страны: флаг + имя + `+код`) вынуждают:

- замыкаться на внешний список через `index`,
- дублировать mapping логики в разных местах,
- терять типизацию для доменных полей (dialCode, iso2, и т.п.) или уходить в `Object payload`.

При этом в `headless_foundation` уже есть listbox primitives:

- `ListboxItemId`
- `ListboxItemMeta { id, isDisabled, typeaheadLabel }`
- `ListboxController` (navigation + typeahead) — matching идёт по `typeaheadLabel`

Значит правильный фундамент — **унифицированная item‑модель рядом с listbox**, а не “внутри темы”.

---

## Решение (выбранный вариант)

### TL;DR

1) В `headless_foundation/src/listbox/` вводим универсальную item‑модель:

- `HeadlessContent` — типизированные “атомы контента” (без `Widget`)
- `HeadlessItemKey<T>` + `HeadlessItemFeatures` — типобезопасные расширения (без строковых ключей)
- `HeadlessListItemModel` — единый контракт айтема для listbox/menu/select‑паттернов
- `HeadlessItemAdapter<T>` — DRY адаптер с optional полями + фабрики `simple(...)` (без `(_) => null`)

2) В `headless_contracts` dropdown contracts заменяют `RDropdownItem` на `HeadlessListItemModel`.

3) В `headless_dropdown_button` public API появляется “golden path”:

```dart
RDropdownButton<Country>(
  items: countries,
  itemAdapter: countryItemAdapter,
  value: selected,
  onChanged: setSelected,
)
```

4) Presets (Material/Cupertino) и conformance tests мигрируют на новую модель.

---

## Public surface и расположение файлов (чтобы не нарушить guardrails)

### Куда кладём типы

- `headless_foundation`:
  - `lib/src/listbox/headless_content.dart`
  - `lib/src/listbox/headless_item_features.dart`
  - `lib/src/listbox/headless_list_item_model.dart`
  - `lib/src/listbox/headless_item_adapter.dart`
  - `lib/src/listbox/typeahead_label.dart`
  - правка: `lib/src/listbox/listbox_controller.dart` (добавить `setMetas`)

### Как экспортируем (MUST)

Нельзя заставлять пользователей импортить `package:headless_foundation/src/...`.

Поэтому:
- если публичного `listbox.dart` ещё нет — **создать** `packages/headless_foundation/lib/listbox.dart` и экспортировать оттуда listbox‑контракты (включая новые типы)
- либо (если вы держите один entrypoint) — добавить re-export в `packages/headless_foundation/lib/headless_foundation.dart`
- `headless_contracts`, `headless_theme` и компоненты импортят **только** публичный entrypoint (`package:headless_foundation/headless_foundation.dart` или `package:headless_foundation/listbox.dart`), но не `src/`.

---

## API изменения и миграция (dropdown)

Так как библиотека ещё не выпущена — breaking допустим. Важно заранее зафиксировать “какой путь теперь канонический”.

### Было (legacy, удалено)

Legacy API: список value+label entries (удалённый путь).

Ограничение: богатый UI вынужден доставать доменные данные по индексу.

### Станет (vNext, canonical)

```dart
RDropdownButton<Country>(
  value: selected,
  onChanged: setSelected,
  items: countries,
  itemAdapter: countryItemAdapter,
)
```

### Advanced API (когда нужен полный контроль на item‑уровне)

```dart
RDropdownButton<Country>(
  value: selected,
  onChanged: setSelected,
  options: [
    for (final c in countries)
      RDropdownOption(value: c, item: countryItemAdapter.build(c)),
  ],
)
```

Решение по судьбе `RDropdownEntry<T>`:
- удалён (breaking допустим, т.к. pre‑release).

---

## Продолжение (разбивка по частям)

Файл ограничен до 300 строк по правилам репозитория. Продолжение вынесено в отдельные части:

- [I23 (часть 2) — Foundation: инварианты + `HeadlessContent`/features/model](./I23_rich_list_item_model_vnext_part_2_foundation_model.md)
- [I23 (часть 3) — Foundation: `HeadlessItemAdapter<T>`, typeahead, `ListboxController.setMetas`](./I23_rich_list_item_model_vnext_part_3_foundation_adapter.md)
- [I23 (часть 4) — Интеграция: `headless_theme`/`headless_dropdown_button`/presets/tests/guardrails](./I23_rich_list_item_model_vnext_part_4_integration_and_tests.md)
- [I23 (часть 5) — Пример Country select + порядок реализации + DoD](./I23_rich_list_item_model_vnext_part_5_example_and_plan.md)

