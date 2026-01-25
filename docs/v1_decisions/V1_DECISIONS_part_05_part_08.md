## V1 Decisions (зафиксировано перед реализацией) (part 5) (part 8)

Back: [Index](../V1_DECISIONS.md)


**Гарантии (sync):**
- Sync effects выполняются в порядке выше, один за другим
- Async effects (RunOperation) **не блокируют** — только запускают
- `notifyListeners()` вызывается **ПОСЛЕ** всех sync effects
- Executor **idempotent** — повторный вызов с теми же effects безопасен

**Async Ordering Guarantees (зафиксировано):**

Что происходит когда async operation завершается и result event приходит?

```
Timeline:
─────────────────────────────────────────────────────────────────────
│ dispatch(event1) │ reducer → effects │ executor.execute() │ notifyListeners() │
─────────────────────────────────────────────────────────────────────
                                                    ↑
                              Async result может прийти сюда
                              (до notifyListeners) ────────────┐
                                                               ↓
                              Или сюда (после) ────────────────┤
                                                               ↓
```

**Гарантии async ordering:**

1. **Sync effects** выполняются в строгом порядке категорий (overlay → focus → semantics → scheduling)

2. **Async result event** может прийти в **любой момент** (не детерминировано)

3. **Если result приходит ДО `notifyListeners()`:**
   - Result event диспатчится **в той же frame** (синхронно вложенно)
   - Это безопасно — state ещё не отрендерен

4. **Если result приходит ПОСЛЕ `notifyListeners()`:**
   - Result event диспатчится **в следующей frame**
   - Использует `scheduleMicrotask` для избежания setState during build

5. **Deduplication:** Если та же операция (`opKey`) запущена повторно:
   - Предыдущий result **игнорируется** (cancelled semantics)
   - Только последний result диспатчится

6. **Cancellation:** `CancelOperationEffect` помечает операцию как cancelled:
   - Если result ещё не пришёл — будет проигнорирован
   - Если уже пришёл — no-op

**Код гарантий в executor:**

```dart
class EffectsExecutor {
  final _pendingOps = <Object, _PendingOp>{};
  bool _isExecuting = false;

  void execute(
    List<Effect> effects, {
    required void Function(ComponentEvent) onResultEvent,
  }) {
    _isExecuting = true;

    // Execute sync effects in order
    for (final effect in effects) {
      switch (effect) {
        case RunOperationEffect(:final opKey, :final operation, :final timeout):
          _runAsync(opKey, operation, timeout, onResultEvent);
        case CancelOperationEffect(:final opKey):
          _pendingOps[opKey]?.cancelled = true;
          _pendingOps.remove(opKey);
        default:
          _executeSyncEffect(effect);
      }
    }

    _isExecuting = false;
    // notifyListeners() вызывается ПОСЛЕ этого в компоненте
  }

  void _runAsync<T>(
    Object opKey,
    Future<T> Function() operation,
    Duration? timeout,
    void Function(ComponentEvent) onResultEvent,
  ) {
    // Cancel previous if exists
    _pendingOps[opKey]?.cancelled = true;

    final pending = _PendingOp();
    _pendingOps[opKey] = pending;

    final future = timeout != null
        ? operation().timeout(timeout)
        : operation();

    future.then((result) {
      if (pending.cancelled) return; // Deduplication
      _pendingOps.remove(opKey);

      final event = OperationSucceeded(opKey, result);

      // Гарантия 3 & 4: dispatch timing
      if (_isExecuting) {
        // Редкий случай: result пришёл синхронно (mock/test)
        onResultEvent(event);
      } else {
        // Стандартный случай: schedule для следующей microtask
        scheduleMicrotask(() => onResultEvent(event));
      }
    }).catchError((error) {
      if (pending.cancelled) return;
      _pendingOps.remove(opKey);

      final event = OperationFailed(opKey, error);
      scheduleMicrotask(() => onResultEvent(event));
    });
  }
}

class _PendingOp {
  bool cancelled = false;
}
```

**Почему scheduleMicrotask, не addPostFrameCallback:**
- `scheduleMicrotask` выполняется в конце текущего event loop tick
- `addPostFrameCallback` ждёт следующего frame (16ms delay)
- Для UI responsiveness нужен быстрый dispatch

**Dart контракт:**

```dart
/// Executor для side effects
class EffectsExecutor {
  /// Выполняет список эффектов в правильном порядке
  void execute(
    List<Effect> effects, {
    required void Function(ComponentEvent) onResultEvent,
  });

  /// Отменяет все pending async operations (при dispose)
  void cancelAll();
}

/// Базовый sealed class для эффектов
sealed class Effect {
  const Effect();
}

// ============ Overlay effects (приоритет 1) ============

final class ShowOverlayEffect extends Effect {
  final OverlayShowRequest request;
  const ShowOverlayEffect(this.request);
}

final class UpdateOverlayEffect extends Effect {
  final OverlayHandle handle;
  final OverlayUpdateRequest request; // placement, middleware changes
  const UpdateOverlayEffect(this.handle, this.request);
}

final class CloseOverlayEffect extends Effect {
  final OverlayHandle handle;
  final CloseReason reason;
  const CloseOverlayEffect(this.handle, this.reason);
}

// ============ Focus effects (приоритет 2) ============

final class RequestFocusEffect extends Effect {
  final FocusNode node;
  const RequestFocusEffect(this.node);
}

final class RestoreFocusEffect extends Effect {
  final FocusNode? savedFocus;
  const RestoreFocusEffect(this.savedFocus);
}

final class TrapFocusEffect extends Effect {
  final FocusNode scopeNode;
  const TrapFocusEffect(this.scopeNode);
}

final class ReleaseFocusTrapEffect extends Effect {
  final FocusNode scopeNode;
  const ReleaseFocusTrapEffect(this.scopeNode);
}

// ============ Semantics effects (приоритет 3) ============

final class AnnounceEffect extends Effect {
  final String message;
  final TextDirection textDirection;
  const AnnounceEffect(this.message, {this.textDirection = TextDirection.ltr});
}

// ============ Scheduling effects (приоритет 4) ============

final class PostFrameEffect extends Effect {
  final VoidCallback callback;
  const PostFrameEffect(this.callback);
}

final class CoalesceNextFrameEffect extends Effect {
  final Object coalescingKey;
  final VoidCallback callback;
  const CoalesceNextFrameEffect(this.coalescingKey, this.callback);
}

// ============ Async effects — A1 (не блокируют) ============

final class RunOperationEffect<T> extends Effect {
  final Object opKey;
  final Future<T> Function() operation;
  final Duration? timeout; // default: AsyncPolicy.operationTimeout
  const RunOperationEffect(this.opKey, this.operation, {this.timeout});
}

final class CancelOperationEffect extends Effect {
  final Object opKey;
  const CancelOperationEffect(this.opKey);
}

// ============ Haptic effects (optional, v1.1+) ============

// @experimental
// final class HapticEffect extends Effect {
//   final HapticFeedbackType type;
//   const HapticEffect(this.type);
// }
```

**completeClose() контракт:**
- **Кто вызывает:** Renderer после exit-анимации
- **Fail-safe:** если renderer не вызвал за N секунд, overlay закрывается автоматически

```dart
// В renderer:
if (phase.value == OverlayPhase.closing) {
  return AnimatedContainer(
    duration: theme.duration.fast,
    onEnd: () => scope.handle.completeClose(), // ← Renderer обязан вызвать
  );
}
```
