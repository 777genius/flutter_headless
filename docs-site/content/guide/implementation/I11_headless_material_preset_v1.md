## I11 — Preset v1: `headless_material` (renderers + token resolvers + overrides)

### Цель

Сделать “быстрый прод‑старт” без написания renderers с нуля:
- предоставить **Material 3 preset** как отдельный пакет, который реализует capabilities из `headless_contracts`,
- поддержать **максимальную кастомизацию** через:
  - contract overrides (`RButtonOverrides`, `RDropdownOverrides`) — каноничный SOLID‑путь,
  - scoped theme (локальная тема через `HeadlessThemeProvider`),
  - slots (структурные overrides),
  - и только как advanced: preset‑specific overrides (Material).

### Ссылки

- Архитектура и границы: `docs/ARCHITECTURE.md`
- Контракты v1: `docs/V1_DECISIONS.md` (0.1 renderer contracts, Token Resolution Layer)
- Per-instance гибкость: `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`
- ROI/P0: `docs/MUST.md` (раздел про P0 “приземление”)
- Spec/Conformance: `docs/SPEC_V1.md`, `docs/CONFORMANCE.md`
- Итерации: `docs/implementation/I08_token_resolution_and_render_requests_v1.md`, `I09_apply_resolved_tokens_button_dropdown_v1.md`, `I10_conformance_reports_v1.md`

---

## Что делаем

### 1) Создать пакет `packages/headless_material`

#### 1.1 Правила зависимостей

`headless_material` может зависеть от:
- `flutter` (sdk)
- `headless_contracts` (contracts)
- `headless_theme` (capability discovery/runtime helpers)
- `headless_foundation` (если нужно для overlay helpers)
- `headless_tokens` (опционально, если preset реально делает собственный маппинг raw→semantic→resolved; для v1 можно начать без этого)

`headless_material` НЕ должен быть зависимостью core пакетов.

#### 1.2 Публичный API пакета

Минимум v1:
- `MaterialHeadlessTheme` (implements `HeadlessTheme`):
  - отдаёт capabilities:
    - `RButtonRenderer`
    - `RButtonTokenResolver`
    - `RDropdownButtonRenderer` (**non-generic**)
    - `RDropdownTokenResolver` (**non-generic**)
- (опционально) `MaterialHeadlessDefaults` — дефолтные настройки preset'а (density/shape/typography policy)
- (опционально) `MaterialHeadlessOverrides` — preset‑specific override типы (advanced)

#### 1.3 Non-generic dropdown contract (v1 policy)

**Dropdown renderer/resolver contracts v1 — non-generic by design.**

`RDropdownButton<T>` хранит `T` и делает mapping `value ↔ index`. Renderer работает только с UI данными (labels/indices/disabled/state/tokens).

Capability lookup простой, без workarounds:
```dart
// Правильно — простые типы без generics
theme.capability<RDropdownButtonRenderer>()
theme.capability<RDropdownTokenResolver>()

// ЗАПРЕЩЕНО — workarounds
// theme.capability<RDropdownButtonRenderer<dynamic>>()
// typeName.startsWith('RDropdownButtonRenderer')
```

Preset renderer/resolver **не должны** принимать/использовать `value` типа T — только label/indices.

Тонкий момент (важно):
- **каноничная кастомизация** должна работать без импорта `headless_material` типов в "обычном" коде компонентов.
  - Пользователь может зависеть от `headless_material`, это нормально.
  - Но в *per-instance* overrides по умолчанию используем контрактные `R*Overrides`.

---

### 2) Button: `RButtonTokenResolver` + `RButtonRenderer` (Material 3)

#### 2.1 Resolver: детерминированный state→tokens

Реализовать `RButtonTokenResolver` так, чтобы:
- вход: `spec + states + constraints + overrides`
- выход: `RButtonResolvedTokens`
- deterministic: одинаковые входы → одинаковый output

Приоритеты (v1):
1) **per-instance contract overrides**: `overrides.get<RButtonOverrides>()`
2) theme defaults / preset defaults

> **Note**: Preset-specific overrides (например `MaterialButtonOverrides`) могут быть добавлены в будущих версиях как advanced-слой.

Тонкие моменты:
- overrides должны влиять на resolved tokens **без сайд‑эффектов** и без зависимости от order build.
- `constraints` (min hit target) должны учитываться, но **не ломать** дизайн: увеличиваем `minSize`, не меняя padding “магически”.

#### 2.2 Renderer: использование Material 3 виджетов без double-invoke

Renderer должен:
- строить визуал (shape, colors, typography, ink),
- **не быть источником активации** (см. policy из компонентов: single activation source).

Правило v1:
- renderer может использовать `InkResponse`/`Material`/`DecoratedBox` для эффекта,
- но не должен самостоятельно вызывать `callbacks.onPressed` от pointer/key событий.

Тонкий момент:
- если хочется использовать `FilledButton` напрямую, он сам обрабатывает onPressed.
  - Тогда нужно либо:
    - передавать туда `onPressed: null` и делать внешний hit testing (сложно),
    - либо признать, что в preset renderer `FilledButton` используется только как “skin” через `ButtonStyleButton` API,
    - либо написать минимальный material‑look-alike renderer (часто проще и безопаснее).

Для v1 предпочтение: **безопасность/предсказуемость** (не ловить double invoke), даже если это чуть больше кода.

---

### 3) Dropdown: `RDropdownTokenResolver` + `RDropdownButtonRenderer` (non-generic)

#### 3.1 Resolver

Аналогично button:
- вход: `spec + triggerStates + overlayPhase + constraints + overrides`
- выход: `RDropdownResolvedTokens` (trigger/menu/item)
- **non-generic**: resolver не знает про `T`, только UI данные

Приоритеты (v1):
1) `RDropdownOverrides` (contract)
2) defaults

> **Note**: Preset-specific overrides (например `MaterialDropdownOverrides`) могут быть добавлены в будущих версиях.

Тонкие моменты:
- `overlayPhase` влияет на trigger tokens (например borderColor “opened”).
- `menuMaxHeight` из overrides должен отражаться в `resolvedTokens.menu.maxHeight` и/или `constraints`.

#### 3.2 Renderer

Renderer обязан поддержать 2 renderTarget'а:
- `trigger` (в основном дереве)
- `menu` (в overlay)

**non-generic**: renderer получает `List<HeadlessListItemModel>` (UI-only), `selectedIndex`/`highlightedIndex`, `onSelectIndex(int)`.

Close contract:
- при `state.overlayPhase == closing` renderer должен инициировать exit (если есть анимация),
- и **обязательно** вызвать `callbacks.onCompleteClose()` по завершении (или сразу, если нет анимаций).

Тонкие моменты:
- menuSurface и item должны быть кастомизируемы через slots.
- item визуально должен уметь отображать:
  - highlighted
  - selected
  - disabled

---

### 4) Scoped theme (локальная композиция)

В v1 достаточно:
- вложить `HeadlessThemeProvider(theme: MaterialHeadlessTheme(...))` локально в subtree.

Если preset хочет “частичное наследование”, вводим `MaterialHeadlessTheme.copyWith(...)` (v1‑friendly).

---

### 5) Тесты (минимум для v1 preset)

Тестируем не “пиксели”, а провода/инварианты:

#### T1 — tokens flow
- token resolver реально вызывается
- renderer реально получает `resolvedTokens`
- per-instance `R*Overrides` меняют output

#### T2 — no double invoke
- нажатие/клавиатура вызывает `onPressed/onChanged` ровно 1 раз

#### T3 — close contract
- dropdown: `close()` → closing → renderer вызывает `onCompleteClose` → closed

---

## Артефакты итерации

- `packages/headless_material/pubspec.yaml`
- `packages/headless_material/lib/headless_material.dart`
- `packages/headless_material/lib/src/material_headless_theme.dart`
- `packages/headless_material/lib/src/button/*` (renderer + resolver)
- `packages/headless_material/lib/src/dropdown/*` (renderer + resolver)
- `packages/headless_material/test/*` (минимальные тесты)

---

## Критерии готовности (DoD)

- `headless_material` подключается в `apps/example` и даёт рабочие Button/Dropdown без написания custom renderers.
- Per-instance contract overrides (`RButtonOverrides`, `RDropdownOverrides`) работают.
- Dropdown соблюдает close contract (closing→completeClose→closed).
- Тесты пакета + monorepo тесты проходят (`dart run melos run test`).

---

## Чеклист (PR-ready)

- [ ] Создан пакет `headless_material` и добавлен в `melos`.
- [ ] Реализован `MaterialHeadlessTheme` (capability composition, simple type checks).
- [ ] Реализован `RButtonTokenResolver` (deterministic, учитывает overrides/constraints).
- [ ] Реализован `RButtonRenderer` (без double invoke).
- [ ] Реализован `RDropdownTokenResolver` (**non-generic**, trigger/menu/item tokens).
- [ ] Реализован `RDropdownButtonRenderer` (**non-generic**, trigger/menu + close contract).
- [ ] Capability lookup: `capability<RDropdownButtonRenderer>()` — без workarounds.
- [ ] Тесты: tokens flow + per-instance overrides + close contract + no double invoke.
- [ ] Документация: краткий README/LLM.txt для `headless_material` (purpose + how-to).

