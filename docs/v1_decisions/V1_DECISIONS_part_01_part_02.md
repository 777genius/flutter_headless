## V1 Decisions (зафиксировано перед реализацией) (part 1) (part 2)

Back: [Index](../V1_DECISIONS.md)

## V1 Decisions (зафиксировано перед реализацией)

Этот документ фиксирует решения, которые мы приняли **до начала реализации**, чтобы не переписывать архитектуру в процессе.

### Связанные документы

| Документ | Содержание | Ключевые секции |
|----------|-----------|-----------------|
| [`ARCHITECTURE.md`](./ARCHITECTURE.md) | Monorepo/DDD/SOLID правила | [Dual API policy](./ARCHITECTURE.md#dual-api-policy-d2a-сейчас-путь-к-d2b-потом), [CI Pipeline](./ARCHITECTURE.md#ci-pipeline-integration-github-actions), [Bounded Contexts](./ARCHITECTURE.md#bounded-contexts-ddd) |
| [`MUST.md`](./MUST.md) | ROI приоритеты | Focus management (9/10), Animations (9/10), Positioning pipeline (8.5/10) |
| [`RESEARCH.md`](./RESEARCH.md) | Анализ конкурентов | [React Aria findings](./RESEARCH.md#react-aria-enterprise-но-тяжёлый-и-конфликтный), [Zag.js findings](./RESEARCH.md#zagjs--ark-ui-fsm-без-удобных-async-и-state-sharing), [Radix findings](./RESEARCH.md#radix-ui-perf-и-типобезопасность-композиции) |
| [`SPEC_V1.md`](./SPEC_V1.md) | Нормативная спецификация для community-компонентов | Требования совместимости (conformance) и правила для сторонних пакетов |
| [`CONFORMANCE.md`](./CONFORMANCE.md) | Как заявлять Headless‑совместимость | Минимальный чеклист и обязательные тесты |
| [`README.md`](../README.md) | Структура репозитория | Roadmap, базовые задачи |

### Оглавление (Quick Links)

**Contracts (0.1-0.7):**
- [0.1 Renderer contracts](#01-headless_contracts-renderer-contracts--capability-discovery-минимум)
- [0.2 Overlay](#02-anchored_overlay_engine-anchoredoverlayenginehostcontrollerhandle-минимум)
- [0.3 Listbox](#03-headless_foundationlistbox-itemregistry--navigationtypeahead-минимум)
- [0.4 State Resolution](#04-headless_foundationstate_resolution-нормализация-и-приоритеты-widgetstate-минимум)
- [0.5 Test helpers](#05-headless_test-a11yoverlayfocuskeyboard-helpers-минимум)
- [0.6 Interactions](#06-headless_foundationinteractions-interactioncontroller-зафиксировано)
- [0.7 Effects Executor](#07-effects-executor-contract-зафиксировано)

**Архитектура:**
- [Token Resolution Layer](#token-resolution-layer--ownership-зафиксировано)
- [Dual API (D2a/D2b)](#dual-api-d2a-сейчас-путь-к-d2b-потом--зафиксировано)
- [E1 (Events + Reducer + Effects)](#единый-стандарт-поведения-v1-e1-events--pure-reducer--effects)
- [API Stability Matrix](#api-stability-matrix-v10-зафиксировано)
- [Sealed vs Open Boundaries](#sealed-vs-open-boundaries-зафиксировано)

**Policies:**
- [Versioning (SemVer)](#9-версионирование-lockstep-semver)
- [Error Handling](#error-handling-policy-зафиксировано)
- [Migration Guides](#migration-guides-зафиксировано)

---

### 1) Нейминг: Flutter‑like API, но без конфликтов имён

**Решение (зафиксировано):** компоненты называем с префиксом `R*`:
- `RTextButton`
- `RDropdownButton<T>`
- (далее: `RDialog`, …)

---

### 1.1) Нет отдельного Select/Combobox в v1 (зафиксировано)

**Решение:** отдельный компонент `RSelect` **не используется**. Select-like сценарии покрываются `RDropdownButton`.

**Правило для доков:** упоминания “Select/Combobox” относятся к *menu-like паттернам* и должны читаться как `DropdownButton`.

**Оценка:** 9/10  
**Почему:** пропсы и семантика — как у Flutter (POLA), но имена не конфликтуют со стандартными `TextButton/DropdownButton`.

---

### 2) “Строго headless” как базовый принцип

**Решение (зафиксировано):**
- `R*` компоненты отвечают за **поведение/состояния/a11y** и сбор “spec/state”.
- **Структура/визуал** живут в renderer’ах.
- **Overlay‑механика** (stacking/positioning/dismiss/focus) живёт в `headless_foundation`, а визуальные части оверлеев — в renderer’ах.

**Оценка:** 9/10  
**Почему:** это единственный способ реально держать multi-brand без форков и копий.

---

### 3) Renderer presets — отдельные пакеты (не core)

**Решение (зафиксировано):**
- “базовые” renderer’ы (например, Material/Cupertino‑style) живут в **preset‑пакетах**, а core остаётся чистым (unstyled).

**Оценка:** 9/10  
**Почему:** adoption выше, зависимости ниже, core не навязывает визуал.

**Практика монорепо (имена):**
- `packages/headless_material/` — Material 3 preset renderer implementations.
- `packages/headless_cupertino/` — Cupertino preset renderer implementations.
- `packages/headless_test/` — опциональный пакет с test helpers (a11y/overlay/focus/keyboard).
- `tools/headless_cli/` — optional tooling: W3C import + skeleton generation (без UI логики).

---

### 4) Renderer contracts + Slots override: Replace + Decorate

**Решение (зафиксировано):**
- Renderer API строим как **гибрид**: один entrypoint `render(request)` + **slots** для точечного override.
- Slots поддерживают **Replace** и **Decorate**.

**Оценка:** 9/10  
**Почему:** позволяет переопределять отдельные части (Menu/Item/Surface) без переписывания всего renderer’а.

#### Рекомендуемая форма (пример контрактов, не реализация)

**Dropdown renderer/resolver contracts v1 — non-generic by design.**
`RDropdownButton<T>` хранит `T` и делает mapping `value ↔ index`. Renderer работает только с UI item‑моделью (без `T`).

```dart
// Non-generic renderer contract
abstract interface class RDropdownButtonRenderer {
  Widget render(RDropdownButtonRenderRequest request);
}

final class RDropdownButtonRenderRequest {
  final BuildContext context;
  final RDropdownButtonSpec spec;
  final RDropdownButtonState state;  // uses selectedIndex, not selectedValue
  final List<HeadlessListItemModel> items; // UI-only item anatomy
  final RDropdownCommands commands; // uses selectIndex(int)
  final RDropdownButtonSlots? slots;
  final RDropdownResolvedTokens? resolvedTokens;
  final BoxConstraints? constraints;

  const RDropdownButtonRenderRequest({
    required this.context,
    required this.spec,
    required this.state,
    required this.items,
    required this.callbacks,
    this.slots,
    this.resolvedTokens,
    this.constraints,
  });
}

// Item without value — UI-only
// HeadlessListItemModel живёт в headless_foundation/listbox

// Callbacks use indices, not values
final class RDropdownCommands {
  final void Function(int index) onSelectIndex;
  final void Function(int index) onHighlight;
  final VoidCallback onOpen;
  final VoidCallback onClose;
  final VoidCallback onCompleteClose;
}

final class RDropdownButtonSlots {
  final SlotOverride<RDropdownAnchorContext>? anchor;
  final SlotOverride<RDropdownMenuContext>? menu;
  final SlotOverride<RDropdownMenuItemContext>? item;
  final SlotOverride<RDropdownMenuSurfaceContext>? menuSurface;

  const RDropdownButtonSlots({
    this.anchor,
    this.menu,
    this.item,
    this.menuSurface,
  });
}

/// Базовый класс для переопределения слотов.
/// В sealed class метод без тела — abstract по определению Dart 3.
sealed class SlotOverride<C> {
  const SlotOverride();

  /// [ctx] — контекст слота (состояние, callbacks, etc.)
  /// [defaults] — функция для получения дефолтного виджета
  Widget build(C ctx, Widget Function(C) defaults);
}

/// Полная замена слота — дефолт игнорируется (intentional).
/// LSP: Контракт build() соблюдён, но семантика — "full takeover".
final class Replace<C> extends SlotOverride<C> {
  final Widget Function(C ctx) builder;
  const Replace(this.builder);
  @override
  Widget build(C ctx, Widget Function(C) defaults) => builder(ctx);
}

/// Обёртка вокруг дефолта — получаем child и можем обернуть/модифицировать.
final class Decorate<C> extends SlotOverride<C> {
  final Widget Function(C ctx, Widget child) builder;
  const Decorate(this.builder);
  @override
  Widget build(C ctx, Widget Function(C) defaults) => builder(ctx, defaults(ctx));
}

/// Расширение дефолта — применяем трансформацию к context перед вызовом defaults.
/// Полезно когда нужно изменить параметры, но сохранить структуру дефолта.
final class Enhance<C> extends SlotOverride<C> {
  final C Function(C ctx) enhancer;
  const Enhance(this.enhancer);
  @override
  Widget build(C ctx, Widget Function(C) defaults) => defaults(enhancer(ctx));
}
```

**LSP Clarification:**
- `Replace` — intentionally ignores `defaults` (full takeover semantics)
- `Decorate` — wraps the default widget (wrapper semantics)
- `Enhance` — modifies context, keeps default structure (enhancement semantics)

Все три варианта соблюдают контракт `build()`, но с разной семантикой использования дефолта.

**Правило POLA:** slots должны быть **опциональными**, а дефолты — предсказуемыми.

---

### 5) Renderer отдельно от Theme (два scope‑объекта, но один provider)

**Решение (зафиксировано):**
- Theme (tokens/политики) и Renderers (визуал/структура) — **раздельны**.
- Для UX пользователя делаем один “root/provider”, который кладёт оба в дерево.

**Оценка:** 9/10  
**Почему:** один набор default renderers можно шарить на множество брендов.

---

### 6) Overlay: без зависимости от навигации

**Решение (зафиксировано):**
- overlay‑механизм должен быть независим от Navigator/Route.
- в core — отдельный пакет `anchored_overlay_engine`, вставка по умолчанию через Flutter `OverlayPortal` (без зависимости от Navigator).

**Оценка:** 9/10  
**Почему:** минимальные зависимости, универсальность для будущих меню/tooltip/autocomplete.

---

### 6.1) Overlay API v1: `AnchoredOverlayEngineHost` + `OverlayController` + `OverlayHandle`

**Решение (зафиксировано):**
- Базовая точка входа — `AnchoredOverlayEngineHost` в дереве (владеет слоями).
- Взаимодействие компонентов с оверлеями — через `OverlayController` (получение из scope/host).
- Показ любого оверлея возвращает `OverlayHandle`:
  - `close()` / `isOpen`
  - опционально `update(...)` (если потребуется для reposition без пересоздания)

**Инварианты (важно для “без миграций”):**
- **Нет зависимости от Navigator/Route** вообще.
- **Явное ownership**: кто открыл — тот держит handle и закрывает (без скрытых глобалей).
- **Stacking**: поддержка стека оверлеев (dialog поверх menu и т.п.).
- **Dismiss policy** поддерживается механизмом (outside tap / Esc / потеря фокуса) и конфигурируется из компонентов.
