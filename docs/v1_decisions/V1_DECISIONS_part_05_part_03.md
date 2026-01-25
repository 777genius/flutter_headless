## V1 Decisions (зафиксировано перед реализацией) (part 5) (part 3)

Back: [Index](../V1_DECISIONS.md)


**Создание темы:**
```dart
final theme = MapRenderlessTheme(
  capabilities: {
    ButtonCapability: MyButtonCapability(),
    DropdownCapability: MyDropdownCapability(),
    DialogCapability: MyDialogCapability(),
    // Новые capabilities добавляются аддитивно — без breaking changes
  },
);
```

**Использование в компоненте:**
```dart
class _RTextButtonState extends State<RTextButton> {
  @override
  Widget build(BuildContext context) {
    final theme = RenderlessTheme.of(context);
    // Capability Discovery — получаем нужную capability по типу
    final buttons = theme.requireCapability<ButtonCapability>();
    final renderer = buttons.getTextButtonRenderer(widget.spec);

    return renderer.build(TextButtonRenderRequest(
      spec: widget.spec,
      states: _interactionController.states,
      semantics: TextButtonSemantics(label: widget.label),
      callbacks: TextButtonCallbacks(onPressed: widget.onPressed),
    ));
  }
}
```

**Преимущества:**
- Новые capabilities добавляются аддитивно (без breaking changes)
- Каждая capability может иметь свои дефолты
- Тема собирается композицией — можно переопределить только нужные части
- Легко тестировать — можно мокать отдельные capabilities

#### 0.2) `anchored_overlay_engine`: AnchoredOverlayEngineHost/Controller/Handle (минимум)

**Инварианты (v1):**
- Overlay независим от Navigator/Route.
- Overlay поддерживает stacking и корректный dismiss верхнего слоя.
- Overlay lifecycle обязателен для анимаций: `opening/open/closing/closed` как `ValueListenable` (R1).
- Close contract A1 обязателен: `close()` не удаляет subtree сразу; завершение — через явный сигнал.
- Есть fail-safe таймаут, чтобы overlay не завис навсегда в `closing`.

**Минимальный набор (v1):**
- `AnchoredOverlayEngineHost` — виджет-хост в дереве, владеет слоями.
- `OverlayController` — API для управления overlays (imperative `show()/close*()`).
  Event-driven слой может быть добавлен как sugar поверх этого API (аддитивно).
- `OverlayHandle`:
  - `ValueListenable<OverlayPhase> phase` (read-only)
  - `bool get isOpen`

**Event-driven API (опционально, v1.1+):**

Текущая реализация v1 использует imperative `show()/close*()` как самый понятный UX для юзеров Flutter.
Если понадобится строгая интеграция с E1 (events → reducer → effects), можно добавить event-driven слой как сахар
над тем же механизмом (без ломания базового API).

```dart
/// События управления overlay
sealed class OverlayControlEvent {
  const OverlayControlEvent();
}

/// Запрос на показ overlay
final class RequestShowOverlay extends OverlayControlEvent {
  final OverlayShowRequest request;
  const RequestShowOverlay(this.request);
}

/// Запрос на закрытие overlay
final class RequestCloseOverlay extends OverlayControlEvent {
  final CloseReason reason;
  const RequestCloseOverlay(this.reason);
}

/// Exit-анимация завершена (от renderer)
final class AnimationCompleted extends OverlayControlEvent {
  const AnimationCompleted();
}

/// OverlayController принимает events
abstract class OverlayController {
  /// Диспатчит событие управления overlay.
  /// Возвращает OverlayHandle для RequestShowOverlay, null для остальных.
  OverlayHandle? dispatch(OverlayControlEvent event);

  /// Convenience method (sugar over dispatch)
  OverlayHandle show(OverlayShowRequest request) =>
    dispatch(RequestShowOverlay(request))!;
}

/// Причины закрытия
sealed class CloseReason {
  const CloseReason();
}

final class DismissedByUser extends CloseReason {
  const DismissedByUser();
}

final class ClosedProgrammatically extends CloseReason {
  const ClosedProgrammatically();
}

final class OutsideTap extends CloseReason {
  const OutsideTap();
}

final class EscapeKey extends CloseReason {
  const EscapeKey();
}

final class FocusLost extends CloseReason {
  const FocusLost();
}
```

**Почему event-driven:**
- Совместимо с E1 pattern (events + pure reducer)
- Можно перехватить/трансформировать через stateReducer
- Тестируемость — events легко создавать и проверять
- Convenience methods (`show()`, `close()`) остаются как sugar

**Show request (v1):**
- `OverlayShowRequest`:
  - `anchor`: `OverlayAnchor` (**зафиксировано**, см. ниже)
  - `placement`: предпочитаемое размещение (`bottomStart` и т.п.)
  - `middleware`: пайплайн позиционирования (offset/flip/shift/…)
  - `dismissPolicy`: outside tap / Esc / focus-loss (конфиг)
  - `focusPolicy`: `FocusPolicy` — заменяет boolean `isModal` (**зафиксировано**)
  - `builder`: строит содержимое overlay (и имеет доступ к handle/phase через scope)

**FocusPolicy (зафиксировано):**

Вместо boolean `isModal` используем sealed class для более гранулярного контроля фокуса:

```dart
/// Политика управления фокусом для overlay
sealed class FocusPolicy {
  const FocusPolicy();
}

/// Modal overlay: захватывает и удерживает фокус
final class ModalFocusPolicy extends FocusPolicy {
  /// Включить focus trap (фокус не уходит за пределы overlay)
  final bool trap;

  /// Восстановить фокус на trigger при закрытии
  final bool restoreOnClose;

  /// Куда ставить initial focus при открытии (null = первый focusable)
  final FocusNode? initialFocus;

  const ModalFocusPolicy({
    this.trap = true,
    this.restoreOnClose = true,
    this.initialFocus,
  });
}

/// Non-modal overlay: фокус остаётся свободным
final class NonModalFocusPolicy extends FocusPolicy {
  /// Восстановить фокус на trigger при закрытии.
  ///
  /// По умолчанию true (POLA): закрыли dropdown/tooltip → фокус возвращается.
  final bool restoreOnClose;

  const NonModalFocusPolicy({
    this.restoreOnClose = true,
  });
}
```

**Миграция с isModal:**
```dart
// Старое API (deprecated):
OverlayShowRequest(isModal: true, ...)

// Новое API:
OverlayShowRequest(
  focusPolicy: ModalFocusPolicy(
    trap: true,
    restoreOnClose: true,
  ),
  ...
)

// Вычисление isModal для обратной совместимости:
bool get isModal => focusPolicy is ModalFocusPolicy &&
    (focusPolicy as ModalFocusPolicy).trap;
```

**Почему sealed class вместо boolean:**
- Позволяет задать `initialFocus` для конкретных сценариев (dialog с фокусом на Cancel)
- Разделяет `trap` и `restoreOnClose` — не всегда нужны вместе
- Exhaustive matching в Dart 3.x

**DismissPolicy (зафиксировано):**

Политика закрытия overlay через внешние триггеры (outside tap / Esc / focus loss):

```dart
/// Триггеры закрытия overlay
enum DismissTrigger {
  /// Tap/click вне overlay
  outsideTap,

  /// Нажатие Escape
  escapeKey,

  /// Потеря фокуса (для non-modal overlays)
  focusLoss,
}

/// Политика закрытия overlay
sealed class DismissPolicy {
  const DismissPolicy();

  /// Overlay не закрывается автоматически
  static const DismissPolicy none = _NoDismissPolicy();

  /// Overlay закрывается по указанным триггерам
  factory DismissPolicy.byTriggers(Set<DismissTrigger> triggers) =
      DismissByTriggers;

  /// Стандартная политика для modal: outsideTap + escapeKey
  static const DismissPolicy modal = DismissByTriggers({
    DismissTrigger.outsideTap,
    DismissTrigger.escapeKey,
  });

  /// Стандартная политика для non-modal: + focusLoss
  static const DismissPolicy nonModal = DismissByTriggers({
    DismissTrigger.outsideTap,
    DismissTrigger.escapeKey,
    DismissTrigger.focusLoss,
  });
}

final class _NoDismissPolicy extends DismissPolicy {
  const _NoDismissPolicy();
}

final class DismissByTriggers extends DismissPolicy {
  final Set<DismissTrigger> triggers;
  const DismissByTriggers(this.triggers);

  bool get dismissOnOutsideTap => triggers.contains(DismissTrigger.outsideTap);
  bool get dismissOnEscapeKey => triggers.contains(DismissTrigger.escapeKey);
  bool get dismissOnFocusLoss => triggers.contains(DismissTrigger.focusLoss);
}
```
