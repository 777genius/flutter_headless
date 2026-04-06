## V1 Decisions (зафиксировано перед реализацией) (part 2)

Back: [Index](../V1_DECISIONS.md)

## Breaking Changes

### 1. FocusPolicy replaces isModal

**Before (0.5):**
\`\`\`dart
OverlayShowRequest(isModal: true, ...)
\`\`\`

**After (0.6):**
\`\`\`dart
OverlayShowRequest(
  focusPolicy: ModalFocusPolicy(trap: true, restoreOnClose: true),
  ...
)
\`\`\`

**Automated fix:** `dart fix --apply` (если codemod доступен)
```

**Breaking Change Communication:**
1. Announce в CHANGELOG за **2+ версии** до removal
2. Deprecation warning в analyzer
3. Migration guide в `docs/migrations/`
4. Release notes с пошаговой инструкцией

**Оценка:** 9/10

---

### 10) Тесты v1: behavior + a11y

**Решение (зафиксировано):**
- основной фокус тестов: state transitions, keyboard, focus, dismiss, semantics.

**Оценка:** 9/10

---

### 11) Naming Conventions — единые правила именования

**Решение (зафиксировано):**

Единый стиль именования для всего проекта:

**Компоненты:**
| Тип | Паттерн | Пример |
|-----|---------|--------|
| Headless widget | `R*` prefix | `RTextButton`, `RDropdownButton`, `RDialog` |
| Renderer impl | `*Renderer` suffix | `TextButtonRenderer`, `DialogRenderer` |
| Spec (value object) | `*Spec` suffix | `TextButtonSpec`, `DialogSpec` |
| Capability | `*Capability` suffix | `ButtonCapability`, `DialogCapability` |

**Events (domain):**
| Тип события | Паттерн | Пример |
|------------|---------|--------|
| Произошедшее | Past tense | `Pressed`, `Opened`, `Selected`, `Closed` |
| Запрос на действие | Noun + `Request` | `ShowRequest`, `CloseRequest` |
| Результат операции | `Operation` + result | `OperationSucceeded`, `OperationFailed` |

```dart
// ✅ Правильные имена events:
sealed class ButtonEvent {
  const ButtonEvent();
}
final class Pressed extends ButtonEvent { ... }
final class Released extends ButtonEvent { ... }

sealed class OverlayControlEvent {
  const OverlayControlEvent();
}
final class RequestShowOverlay extends OverlayControlEvent { ... }
final class RequestCloseOverlay extends OverlayControlEvent { ... }
```

**State:**
| Тип | Паттерн | Пример |
|-----|---------|--------|
| Component state | `*State` suffix | `ButtonState`, `DropdownButtonState` |
| Phase/Mode | `*Phase` / `*Mode` | `OverlayPhase`, `SelectionMode` |

```dart
// ✅ Правильные имена state:
@immutable
class ButtonState {
  final bool isPressed;   // past tense для boolean
  final bool wasOpened;   // для "было открыто ранее"
}

enum OverlayPhase { opening, open, closing, closed }
```

**Foundation механизмы:**
| Тип | Паттерн | Пример |
|-----|---------|--------|
| Controller | `*Controller` | `OverlayController`, `ListboxController` |
| Host widget | `*Host` | `AnchoredOverlayEngineHost` |
| Handle | `*Handle` | `OverlayHandle` |
| Policy | `*Policy` | `FocusPolicy`, `DismissPolicy` |
| Navigation command | Imperative verb | `MoveHighlight`, `JumpToFirst` |

**Tokens:**
| Тип | Паттерн | Пример |
|-----|---------|--------|
| Raw token | Descriptive noun | `spacing8`, `radiusMd`, `durationFast` |
| Semantic token | role + property | `actionPrimaryBg`, `surfaceRaisedBg` |

**Private/Internal (не для внешнего использования):**
| Тип | Паттерн | Пример |
|-----|---------|--------|
| Private helper | `_*` prefix (Dart) | `_TypeaheadHandler`, `_PositionCalculator` |
| Internal file | `*_internal.dart` | `overlay_internal.dart`, `focus_internal.dart` |
| Internal class | `@internal` annotation | `@internal class LayoutEngine` |
| Test-only | `@visibleForTesting` | Публичный доступ только для тестов |

```dart
// Пример правильного именования internal helpers:
class ListboxController {
  final _TypeaheadHandler _typeahead = _TypeaheadHandler();  // ✅ private
  final ItemRegistry _registry;  // ✅ private field, публичный тип
}

// В отдельном файле:
// lib/src/overlay/overlay_internal.dart
@internal
class PositionCalculator { ... }  // ✅ internal, не для внешнего API
```

**Оценка:** 8/10

---

