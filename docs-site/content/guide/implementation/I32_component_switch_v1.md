## I32 — Component v1: Switch (Material/Cupertino parity, Flutter-like API)

### Цель

Добавить headless-компоненты `RSwitch` и `RSwitchListTile`, которые:
- ведёт себя предсказуемо (POLA) и знакомо Flutter‑сообществу по неймингу/семантике,
- держит **поведение отдельно от визуала** (renderer contracts + capability discovery),
- поддерживает **per-instance overrides** и typed slots,
- имеет минимальные conformance-тесты (a11y/keyboard/disabled/missing capability).

Справка по Flutter API:
- Material `Switch`: `https://api.flutter.dev/flutter/material/Switch-class.html`
- `CupertinoSwitch`: `https://api.flutter.dev/flutter/cupertino/CupertinoSwitch-class.html`

### Ссылки на правила репозитория

- Архитектура/границы: `docs/ARCHITECTURE.md` (см. parts в `docs/implementation/other/`)
- Spec-first: `docs/SPEC_V1.md`
- Conformance: `docs/CONFORMANCE.md`
- ROI/не раздувать API: `docs/MUST.md` (P0.4)
- Контракты v1 решения: `docs/v1_decisions/V1_DECISIONS.md`
- Skeleton компонента: `docs/implementation/I20_component_skeleton_v1.md`
- Reference реализация паттерна: `packages/components/headless_checkbox/*`

---

## Что делаем

### 1) Публичный API компонента (`RSwitch`) — Flutter-like, но без раздувания

#### 1.1 Виджет

Создаём `RSwitch` в `packages/components/headless_switch`:

- **MUST**: `RSwitch` — controlled компонент (value приходит снаружи).
- **MUST**: disabled = `onChanged == null`.
- **MUST**: single activation source:
  - pointer/keyboard/focus обрабатывает `RSwitch` через `HeadlessPressableRegion`,
  - renderer **не** вызывает `onChanged` напрямую и не создаёт второй путь активации.
- **MUST**: root Semantics задаёт компонент (не renderer).

Предлагаемый API v1 (минимум):
- `value: bool` (required)
- `onChanged: ValueChanged<bool>?` (nullable = disabled)
- `thumbIcon: WidgetStateProperty<Icon?>?` (Flutter-like sugar → overrides, Material 3 feature)
- `focusNode: FocusNode?`
- `autofocus: bool = false`
- `mouseCursor: MouseCursor?`
- `semanticLabel: String?`
- `style: RSwitchStyle?` (sugar слой → overrides)
- `slots: RSwitchSlots?` (typed slots)
- `overrides: RenderOverrides?` (per-instance override bag)

Примечание по “Switch.adaptive”:
- в нашем headless‑подходе “adaptive” достигается выбором preset’а (`HeadlessMaterialApp`/`HeadlessCupertinoApp`), а не отдельным виджетом.
- v1: **не добавляем** `RSwitch.adaptive`, чтобы не создавать второй смысловой слой.

#### 1.2 A11y / Semantics

`RSwitch` должен объявлять:
- `enabled` (зависит от `onChanged`)
- `toggled` (зависит от `value`)
- `label` (из `semanticLabel`)

Цель: чтобы screen readers воспринимали его как toggle/switch, а не checkbox.

#### 1.3 Keyboard

Используем `HeadlessPressableRegion` (как в `RCheckbox`), чтобы получить:
- Space/Enter → toggle (ровно 1 вызов `onChanged` на активацию)
- disabled → не активируется

---

#### 1.4 `RSwitchListTile` — делаем сразу (как у checkbox)

По аналогии с `RCheckboxListTile` добавляем `RSwitchListTile` в том же пакете компонента.

Инварианты:
- **MUST**: single activation source — вся строка (tile) обрабатывает input и вызывает `onChanged`.
- **MUST**: внутри не должно быть второго pressable‑корня (indicator — только визуал).
- **MUST**: renderer не вызывает user callbacks.

Минимальный API v1 (Flutter‑знакомый, но без раздувания):
- `value: bool` (required)
- `onChanged: ValueChanged<bool>?` (nullable = disabled)
- `title: Widget` (required)
- `subtitle: Widget?`
- `secondary: Widget?`
- `contentPadding: EdgeInsetsGeometry?`
- `selected: bool = false`
- `focusNode: FocusNode?`
- `autofocus: bool = false`
- `mouseCursor: MouseCursor?`
- `semanticLabel: String?`
- `style: RSwitchListTileStyle?` (sugar → overrides)
- `slots: RSwitchListTileSlots?`
- `overrides: RenderOverrides?`

Semantics (root):
- `enabled` отражает `onChanged != null`
- `toggled` отражает `value`
- `label` берётся из `semanticLabel` (если задан)

---

### 2) Contracts: renderer / tokens / overrides (в `headless_contracts`)

Добавляем отдельный вертикальный срез контракта, по аналогии с checkbox:

#### 2.1 Public export

- `packages/headless_contracts/lib/switch.dart` (barrel) → экспортит `src/renderers/switch/switch.dart`
- `packages/headless_contracts/lib/src/renderers/renderers.dart` — добавить экспорт switch контрактов (как сделано для checkbox)

#### 2.2 Renderer contract

Новые файлы:
- `packages/headless_contracts/lib/src/renderers/switch/switch.dart` (barrel)
- `packages/headless_contracts/lib/src/renderers/switch/r_switch_renderer.dart`
- `packages/headless_contracts/lib/src/renderers/switch/r_switch_semantics.dart`
- `packages/headless_contracts/lib/src/renderers/switch/r_switch_motion_tokens.dart`
- `packages/headless_contracts/lib/src/renderers/switch/r_switch_resolved_tokens.dart`
- `packages/headless_contracts/lib/src/renderers/switch/r_switch_overrides.dart`
- `packages/headless_contracts/lib/src/renderers/switch/r_switch_token_resolver.dart`

`RSwitchRenderer`:
- `Widget render(RSwitchRenderRequest request)`

`RSwitchRenderRequest` (v1):
- `context`
- `spec`
- `state`
- `semantics` (optional)
- `slots` (optional)
- `visualEffects` (optional)
- `resolvedTokens` (optional, при strict policy может быть required)
- `constraints` (optional)
- `overrides` (optional)

`RSwitchSpec` (static, из props):
- `value: bool`
- `semanticLabel: String?`

`RSwitchState` (interaction state):
- `isPressed/isHovered/isFocused/isDisabled/isSelected`
  - `isSelected` = `spec.value` (POLA: “on” = selected state для state resolution)

#### 2.3 Tokens / Resolver

`RSwitchResolvedTokens` (минимум v1, без попытки покрыть 100 параметров Flutter):
- `minTapTargetSize: Size`
- `disabledOpacity: double`
- `pressOverlayColor: Color` (или nullable + fallback)
- `pressOpacity: double?` (для cupertino primitive)
- `motion: RSwitchMotionTokens?` (`stateChangeDuration`)

Track/thumb геометрия и цвета (как “минимально полезный” контракт):
- `trackSize: Size` (width/height)
- `trackBorderRadius: BorderRadius`
- `trackOutlineColor: Color`
- `trackOutlineWidth: double`
- `activeTrackColor: Color`
- `inactiveTrackColor: Color`
- `thumbSize: Size`
- `thumbBorderRadius: BorderRadius`
- `activeThumbColor: Color`
- `inactiveThumbColor: Color`

Material 3 `thumbIcon` (архитектурно правильно):
- `thumbIcon` **не кладём** в `RSwitchSpec` (это визуальная настройка, не поведение).
- В `RSwitch` это Flutter-like параметр **как sugar**, который конвертируется в
  `RenderOverrides.only(RSwitchOverrides.tokens(thumbIcon: ...))`.
- Визуальный “источник истины” для renderer’а — `RSwitchResolvedTokens` (см. ниже).

Добавляем в `RSwitchResolvedTokens` опциональное поле:
  - `thumbIcon: WidgetStateProperty<Icon?>?`
- поддерживаем его через `RSwitchOverrides.tokens(thumbIcon: ...)` (и через `thumbIcon` sugar параметр).

`RSwitchTokenResolver`:
- вход: `context/spec/states/constraints/overrides`
- выход: `RSwitchResolvedTokens` (deterministic)

#### 2.4 Overrides

Добавляем `RSwitchOverrides.tokens(...)` (contract overrides), чтобы:
- менять токены per‑instance без импорта preset‑пакета,
- сохранять additive-only эволюцию.

Важно:
- overrides влияют на `resolvedTokens`, не на поведение/семантику.

---

#### 2.5 Contracts для `RSwitchListTile`

Отдельный набор контрактов, как у checkbox_list_tile:

- `packages/headless_contracts/lib/switch_list_tile.dart` (barrel)
- `packages/headless_contracts/lib/src/renderers/switch_list_tile/*`
  - `switch_list_tile.dart` (barrel)
  - `r_switch_list_tile_renderer.dart`
  - `r_switch_list_tile_semantics.dart`
  - `r_switch_list_tile_motion_tokens.dart`
  - `r_switch_list_tile_resolved_tokens.dart`
  - `r_switch_list_tile_overrides.dart`
  - `r_switch_list_tile_token_resolver.dart`

`RSwitchListTileRenderRequest` (v1):
- `context/spec/state`
- `switchIndicator: Widget` (маленький визуальный индикатор без pressable‑корня)
- `title/subtitle/secondary`
- `semantics/slots/visualEffects/resolvedTokens/constraints/overrides`

---

### 3) Component package: `packages/components/headless_switch`

#### 3.1 Структура (golden path)

```
packages/components/headless_switch/
  lib/
    headless_switch.dart
    src/
      presentation/
        r_switch.dart
        r_switch_list_tile.dart
        r_switch_indicator.dart
      (optional) r_switch_style.dart
      (optional) r_switch_list_tile_style.dart
  test/
  README.md
  LLM.txt
  CONFORMANCE_REPORT.md
```

#### 3.2 Поведение/ownership (как в `RCheckbox`)

`RSwitch` владеет:
- `HeadlessFocusNodeOwner` (external focusNode не dispose)
- `HeadlessPressableController` + `HeadlessPressableVisualEffectsController`

Алгоритм активации:
- если disabled → no-op
- иначе `onChanged?.call(!value)`

Missing capability behaviour:
- debug/test: `FlutterError.reportError` + placeholder widget
- release: не крэшить (политика из `headless_checkbox`)

Style sugar:
- `RSwitchStyle` конвертируется в `RenderOverrides.only(RSwitchOverrides.tokens(...))`
- `thumbIcon` (параметр) конвертируется в `RSwitchOverrides.tokens(thumbIcon: ...)`
- приоритет: `overrides` > (`thumbIcon`/`style` sugar) > theme defaults

`RSwitchListTile`:
- владеет тем же набором (focus/pressable/visualEffects),
- pressable корень находится на tile, `r_switch_indicator.dart` — чисто визуал,
- toggle делает `onChanged?.call(!value)`,
- semantics задаются на уровне компонента (tile), renderer не дублирует root semantics.

---

### 4) Presets: Material/Cupertino реализации

#### 4.1 `headless_material`

Добавить:
- `packages/headless_material/lib/switch.dart` (публичный экспорт)
- `packages/headless_material/lib/src/switch/material_switch_renderer.dart`
- `packages/headless_material/lib/src/switch/material_switch_token_resolver.dart`
- регистрацию capabilities в `MaterialHeadlessTheme`:
  - `RSwitchRenderer`
  - `RSwitchTokenResolver`

Политика v1 (как в checkbox renderer):
- renderer **не** вызывает callbacks пользователя
- все визуальные значения берёт из `resolvedTokens`
- уважает `HeadlessMotionTheme` и `HeadlessRendererPolicy(requireResolvedTokens)`

Material 3 “thumbIcon”:
- поддерживаем через `resolvedTokens.thumbIcon` (опционально)
- дефолт в preset: `null` (не меняем поведение без явной настройки)
- renderer применяет `thumbIcon` только как визуальный элемент (без input/semantics)

#### 4.2 `headless_cupertino`

Аналогично:
- `packages/headless_cupertino/lib/switch.dart`
- `packages/headless_cupertino/lib/src/switch/cupertino_switch_renderer.dart`
- `packages/headless_cupertino/lib/src/switch/cupertino_switch_token_resolver.dart`
- capabilities в `CupertinoHeadlessTheme`

Cupertino‑специфика:
- при наличии `pressOpacity` используем существующий primitive (как `CupertinoCheckboxRenderer` использует `CupertinoPressableOpacity`)

Для list tile (Material/Cupertino parity):
- `packages/headless_material/lib/switch_list_tile.dart`
- `packages/headless_material/lib/src/switch_list_tile/material_switch_list_tile_renderer.dart`
- `packages/headless_material/lib/src/switch_list_tile/material_switch_list_tile_token_resolver.dart`
- `packages/headless_cupertino/lib/switch_list_tile.dart`
- `packages/headless_cupertino/lib/src/switch_list_tile/cupertino_switch_list_tile_renderer.dart`
- `packages/headless_cupertino/lib/src/switch_list_tile/cupertino_switch_list_tile_token_resolver.dart`
- зарегистрировать capabilities в соответствующих HeadlessTheme:
  - `RSwitchListTileRenderer`
  - `RSwitchListTileTokenResolver`

---

### 5) Slots (typed) — минимальный набор для структуры/иконок

По аналогии с checkbox (Decorate-first), предлагаем `RSwitchSlots` v1:
- `track` (Decorate/Replace)
- `thumb` (Decorate/Replace)
- `pressOverlay` (Decorate/Replace)

`thumbIcon` в v1 не делаем отдельным slot’ом:
- это визуальный параметр, который идёт через `resolvedTokens.thumbIcon` + overrides,
- `thumb` slot остаётся способом вмешаться в структуру thumb (например, обернуть/добавить overlay-слой), если нужно.

В v1 держим набор маленьким (P0.4: не раздувать API).

Для `RSwitchListTileSlots` v1 (как минимум):
- `tile` (Decorate/Replace) — оборачивает весь ряд
- `indicator` (Decorate/Replace) — оборачивает `switchIndicator`

---

## Тесты (минимум для conformance)

Добавить в `packages/components/headless_switch/test/`:

- **T1 — Semantics**:
  - `toggled` отражает `value`
  - `enabled` отражает `onChanged != null`
  - `label` берётся из `semanticLabel`
- **T2 — Keyboard**:
  - Space/Enter вызывает `onChanged` ровно 1 раз
  - disabled не вызывает
- **T3 — Missing capability**:
  - без `HeadlessThemeProvider` / без `RSwitchRenderer` — возвращается diagnostic widget и репортится ошибка
- **T4 — Overrides flow (smoke)**:
  - `style` конвертируется в overrides
  - `thumbIcon` (параметр) конвертируется в overrides
  - unconsumed overrides репортятся в debug (как в checkbox)

Для `RSwitchListTile` добавить минимум:
- **T5 — ListTile semantics**:
  - `toggled/enabled/label` корректны
- **T6 — ListTile activation**:
  - активация (tap/Space/Enter) вызывает `onChanged` ровно 1 раз и передаёт `!value`
  - disabled не вызывает

Примечание:
- тестируем поведение, не пиксели (no golden-first).
- тестовые файлы могут быть больше 300 строк, если так проще держать related сценарии вместе;
  дробим только когда становится сложно навигировать/ревьюить.

---

## Что НЕ делаем в v1 (YAGNI)

- Не покрываем весь "набор параметров" Flutter `Switch`/`CupertinoSwitch` (100+ полей) — расширяем аддитивно через tokens/overrides/slots.
- Не добавляем отдельную "adaptive" ветку на уровне виджета.

---

## API v1 заморожен (policy)

**Публичный API `RSwitch` и `RSwitchListTile` зафиксирован.** Новые параметры в конструкторы виджетов не добавляем.

### Путь расширения (только через слои абстракции)

| Что нужно | Куда добавлять |
|-----------|----------------|
| Новый визуальный параметр | `RSwitchOverrides.tokens(...)` / `RSwitchListTileOverrides.tokens(...)` |
| Новый layout/spacing | `RSwitchResolvedTokens` + resolver |
| Структурная кастомизация | `RSwitchSlots` / `RSwitchListTileSlots` |
| Preset-specific advanced | `MaterialSwitchOverrides` / `CupertinoSwitchOverrides` |

### Почему

- **Не раздувать виджет-слой** — это главный принцип headless (P0.4 из MUST.md).
- **Additive-only эволюция** — tokens/overrides/slots можно расширять без breaking changes.
- **Избежать "Flutter SwitchListTile syndrome"** — там 30+ параметров, большинство редко используются.

### Исключения

- Баг-фиксы, которые требуют изменения сигнатуры (крайне редко).
- Явный RFC с обоснованием и апрувом.

---

## Решённые вопросы

1) **Нужно ли тянуть дополнительные флаги `SwitchListTile` в v1?**
   - ✅ **Решение:** API v1 заморожен. Текущие параметры (`controlAffinity/dense/isThreeLine`) остаются, но новые не добавляем. Расширение — только через overrides/tokens/slots.

---

## Артефакты итерации (что должно появиться в git)

**Contracts**:
- `packages/headless_contracts/lib/switch.dart`
- `packages/headless_contracts/lib/src/renderers/switch/*`
- `packages/headless_contracts/lib/switch_list_tile.dart`
- `packages/headless_contracts/lib/src/renderers/switch_list_tile/*`

**Component**:
- `packages/components/headless_switch/*` (widget + README + tests + LLM + conformance report)

**Presets**:
- `packages/headless_material/lib/switch.dart` + `src/switch/*` + theme wiring
- `packages/headless_material/lib/switch_list_tile.dart` + `src/switch_list_tile/*` + theme wiring
- `packages/headless_cupertino/lib/switch.dart` + `src/switch/*` + theme wiring
- `packages/headless_cupertino/lib/switch_list_tile.dart` + `src/switch_list_tile/*` + theme wiring

**Facade**:
- экспорт `RSwitch` из `packages/headless/lib/headless.dart` (и/или отдельный barrel, как принято в репо)
- экспорт `RSwitchListTile` из `packages/headless/lib/headless.dart` (и/или отдельный barrel)

---

## Критерии готовности (DoD)

- `RSwitch` работает в `apps/example` под Material и Cupertino preset.
- `RSwitchListTile` работает в `apps/example` под Material и Cupertino preset.
- Нет double invoke: один путь активации.
- Есть conformance тесты T1–T3 (минимум) и они зелёные, плюс базовые `RSwitchListTile` тесты (T5–T6).
- Per-instance overrides проходят через token resolver и доходят до renderer.
- Guardrails проходят (LLM.txt / CONFORMANCE_REPORT.md на месте, DAG не нарушен).

