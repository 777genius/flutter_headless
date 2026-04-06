## V1 Decisions (зафиксировано перед реализацией) (part 1) (part 4)

Back: [Index](../V1_DECISIONS.md)

- `anchored_overlay_engine` должен поддерживать **closing phase**:
  - инициировать закрытие (dismiss/esc/outside tap),
  - дать рендереру отрисовать exit‑анимацию,
  - удалить subtree только после завершения exit (по сигналу/таймаут‑политике).

**Почему:** это предотвращает типовую проблему headless UI, где exit‑анимации ломаются из-за мгновенного unmount.

**Оценка:** 9/10

---

### 8.4) AI/MCP metadata v1: `LLM.txt` для пакетов (документируем инварианты)

**Решение (зафиксировано):**
- В каждом publishable package добавляем короткий `LLM.txt` (или `docs/LLM.md`, если нужны ссылки/markdown):
  - **назначение** пакета и “что он НЕ делает”
  - **инварианты** (focus/dismiss/overlay/state resolution)
  - **минимальные примеры** правильного использования
  - **антипаттерны** (что точно нельзя)

**Оценка:** 8.5/10  
**Почему:** повышает шанс консистентной генерации/интеграции, особенно при использовании AI/агентов.

---

### 8.4.1) Figma MCP: политика v1

**Решение (зафиксировано):**
- В v1 **не делаем** прямую интеграцию с Figma MCP (не завязываемся на внешний API/процессы).
- В v1 делаем **MCP-friendly export** на нашей стороне:
  - `LLM.txt` (инварианты/примеры/антипаттерны),
  - W3C tokens import/export как основной формат для дизайна/кода.

**Оценка:** 9/10  
**Почему:** максимальный фокус на core инвариантах, при этом остаёмся “AI-friendly” без внешней зависимости.

---

### 8.4.2) CLI tooling v1: только skeleton (без генерации UI логики)

**Решение (зафиксировано):**
- CLI может генерировать только **каркасы** (структуру пакета, файлы‑заглушки, wiring), но **не генерирует** готовые виджеты/ThemeData и не встраивает UI‑логику.
- Любой “генерим UI” считаем анти‑паттерном для Headless.

**Оценка:** 8.5/10  
**Почему:** ускоряет старт бренда/рендерера без архитектурного вреда и без ломания headless‑контрактов.

---

### 8.5) a11y testing v1: helpers + обязательный manual слой

**Решение (зафиксировано):**
- Добавляем `headless_test` (или аналогичный пакет) с a11y test helpers:
  - assertions для semantics роли/лейблов,
  - проверки focusability/keyboard сценариев,
  - helpers для overlay‑сценариев (trap/restore/ensureVisible).
- Фиксируем правило: автоматизация ловит только часть проблем → **manual keyboard + screen reader** проверки входят в release checklist.

**Оценка:** 8.5/10

### 9) Версионирование: Lockstep SemVer

**Решение (зафиксировано):**
- Все пакеты monorepo публикуются с **одной версией `X.Y.Z`**.

**Deprecation policy (зафиксировано):**

Правила устаревания API:
- `@Deprecated` annotation с указанием версии и альтернативы
- Минимум **2 minor версии** между deprecation и removal
- Breaking changes = **major version bump**

```dart
// Пример правильного deprecation:
@Deprecated('Use focusPolicy instead. Will be removed in 2.0.0')
final bool isModal;

// Новое API:
final FocusPolicy focusPolicy;
```

**Исключения:**
- Security fixes могут нарушать deprecation period
- Pre-1.0 API может меняться чаще (minor = breaking allowed)

**API Stability Levels (зафиксировано):**

| Аннотация | Гарантия | Применение |
|-----------|----------|------------|
| `@stable` (default) | Breaking only in major | Public API, contracts |
| `@experimental` | May change in minor | New features, beta API |
| `@internal` | No guarantees | Implementation details |

```dart
// Использование аннотаций:
import 'package:meta/meta.dart';

/// Stable API — breaking changes только в major version
@sealed
class ButtonSpec { ... }

/// Experimental — может измениться в minor
@experimental
class AnimationPolicy { ... }

/// Internal — не для внешнего использования
@internal
class OverlayPositionCalculator { ... }
```

**API Stability Matrix v1.0 (зафиксировано):**

Конкретное распределение стабильности по контрактам:

| Контракт / API | Стабильность | Когда может меняться |
|----------------|--------------|----------------------|
| **Foundation contracts** | | |
| `OverlayController` / `OverlayHandle` | `@stable` | major only |
| `FocusPolicy` (sealed class) | `@stable` | major only |
| `StateResolutionPolicy` | `@stable` | major only |
| `HeadlessWidgetStateMap<T>` | `@stable` | major only |
| `ListboxController` | `@stable` | major only |
| `InteractionController` | `@stable` | major only |
| **Theme contracts** | | |
| `RenderlessTheme.capability<T>()` | `@stable` | major only |
| `ButtonCapability` | `@stable` | major only |
| `DropdownCapability` | `@stable` | major only |
| `DialogCapability` | `@stable` | major only |
| `*Renderer.build(request)` | `@stable` | major only |
| **Tokens** | | |
| `SemanticToken<T>` | `@stable` | major only |
| Raw token extension types | `@stable` | major only |
| **Experimental (v1.0)** | | |
| `EffectsExecutor` (internal) | `@experimental` | minor/major |
| `AnimationPolicy` | `@experimental` | minor/major |
| Positioning middleware pipeline | `@experimental` | minor/major |
| **Internal (не для внешнего использования)** | | |
| `OverlayPositionCalculator` | `@internal` | любая версия |
| `TypeaheadBuffer` | `@internal` | любая версия |
| `*_internal.dart` файлы | `@internal` | любая версия |

**Инвариант:** `@stable` контракты составляют ~80% public API. Добавление нового `@stable` API — **аддитивно**, не ломает существующий код.

**Sealed vs Open Boundaries (зафиксировано):**

Некоторые типы **sealed** (закрыты для расширения), другие **open** (можно наследовать):

| Тип | Boundary | Почему | Расширяемость |
|-----|----------|--------|---------------|
| **sealed** | | | |
| `FocusPolicy` | sealed | Exhaustive matching (Modal/NonModal) | Новые варианты = minor version |
| `DismissPolicy` | sealed | Конечный набор триггеров | Новые варианты = minor version |
| `CloseReason` | sealed | Предсказуемый набор причин | Новые причины = minor version |
| `OverlayAnchor` | sealed | Конечные стратегии anchoring | Новые anchor types = minor |
| `ListboxNavigation` | sealed | Конечный набор навигации | Новые команды = minor |
| `Effect` | sealed | Конечный набор side effects | Новые effects = minor |
| `OperationResult` | sealed | Success/Failed/Timeout/Cancelled | Не расширяемо |
| **open** | | | |
| `StateResolutionPolicy` | open | Пользователь кастомизирует приоритеты | Наследование разрешено |
| `ButtonCapability` | abstract | Пользователь реализует свои renderers | Реализация обязательна |
| `*Renderer` | abstract | Пользователь реализует visual | Реализация обязательна |
| `SemanticToken<T>` | abstract | Пользователь добавляет свои токены | Расширение разрешено |
| `RenderlessTheme` | abstract | Пользователь создаёт свои темы | Расширение разрешено |

**Правила добавления вариантов в sealed:**
- Новый вариант в sealed class = **minor** version bump
- Это не breaking (exhaustive switch получит compiler warning)
- Но требует адаптации user кода для обработки нового случая

**Когда использовать sealed:**
```dart
// ✅ sealed — когда набор вариантов конечен и контролируется библиотекой
sealed class OverlayPhase { opening, open, closing, closed }

// ✅ abstract — когда пользователь должен реализовать
abstract class ButtonRenderer {
  Widget build(ButtonRenderRequest request);
}

// ❌ НЕ ДЕЛАЙ sealed если пользователь должен расширять
sealed class UserTheme extends RenderlessTheme {...}  // НЕПРАВИЛЬНО
```

**Исключение — SlotOverride:**

`SlotOverride` — sealed, но LSP нарушается intentionally в `Replace`:

```dart
sealed class SlotOverride<C> {
  Widget build(C ctx, Widget Function(C) defaults);
}

// Replace intentionally игнорирует defaults — это by design
final class Replace<C> extends SlotOverride<C> {
  final Widget replacement;
  Widget build(C ctx, Widget Function(C) defaults) => replacement;
}

// Enhance использует defaults — стандартное LSP поведение
final class Enhance<C> extends SlotOverride<C> {
  final Widget Function(Widget child, C ctx) enhancer;
  Widget build(C ctx, Widget Function(C) defaults) =>
    enhancer(defaults(ctx), ctx);
}
```

**Почему это допустимо:**
- `Replace` — "полная замена", семантически другое поведение
- Документировано как intentional exception
- Пользователь выбирает `Replace` vs `Enhance` осознанно

**Migration Guides (зафиксировано):**

При breaking changes обязательно создаём migration guide:

```
docs/migrations/
├── 0.5-to-0.6.md    # Гайд миграции с 0.5 на 0.6
├── 1.0-to-2.0.md    # Major version migration
└── ...
```

Формат migration guide:
```markdown
# Migration from 0.5 to 0.6

