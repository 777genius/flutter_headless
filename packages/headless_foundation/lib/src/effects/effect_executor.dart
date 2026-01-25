import 'dart:async';

import 'effect.dart';
import 'effect_result.dart';

/// Callback for receiving effect results.
typedef EffectResultCallback = void Function(EffectResult<dynamic> result);

/// Executor for running effects outside reducer.
///
/// Key responsibilities:
/// - Deduplicate effects with same key within batch (last wins)
/// - Coalesce effects when [Effect.coalescable] is true
/// - Cancel pending effects by key
/// - Dispatch result events asynchronously (microtask) to prevent recursion
///
/// Usage:
/// ```dart
/// final executor = EffectExecutor(
///   onResult: (result) => dispatch(ResultEvent(result)),
/// );
///
/// // From reducer: return effects
/// executor.execute([
///   OpenOverlayEffect(...),
///   FetchDataEffect(...),
/// ]);
/// ```
///
/// See `docs/ARCHITECTURE.md` → "Единый стандарт поведения… (E1)"
class EffectExecutor {
  EffectExecutor({
    required EffectResultCallback onResult,
  }) : _onResult = onResult;

  final EffectResultCallback _onResult;

  /// Currently pending async operations (by exact key).
  final Map<EffectKey, _PendingOperation> _pending = {};

  /// Execute a batch of effects.
  ///
  /// Effects are deduplicated by key (last wins for coalescable effects).
  /// Results are dispatched asynchronously via [onResult] callback.
  void execute(List<Effect<dynamic>> effects) {
    if (effects.isEmpty) return;

    // Dedupe/coalesce: group by key, last wins for coalescable
    final deduped = _dedupeEffects(effects);

    // Execute each effect
    for (final effect in deduped) {
      _executeOne(effect);
    }
  }

  /// Cancel pending effect(s) by key.
  ///
  /// This is a one-shot operation: only cancels currently in-flight async
  /// operations. Future effects with the same key will NOT be affected.
  ///
  /// If [key] has opId, cancels only that specific operation.
  /// If [key] has no opId, cancels all operations matching category+targetId.
  void cancel(EffectKey key) {
    // Find and cancel matching pending operations
    final toCancel = <EffectKey>[];
    for (final pendingKey in _pending.keys) {
      if (key.matches(pendingKey)) {
        toCancel.add(pendingKey);
      }
    }

    for (final cancelKey in toCancel) {
      final pending = _pending.remove(cancelKey);
      pending?.cancel();
      // Dispatch cancelled result asynchronously
      _dispatchResult(EffectResult<dynamic>.cancelled(cancelKey));
    }
  }

  /// Check if an effect with given key is pending.
  bool isPending(EffectKey key) {
    for (final pendingKey in _pending.keys) {
      if (key.matches(pendingKey)) {
        return true;
      }
    }
    return false;
  }

  /// Dispose executor and cancel all pending operations.
  void dispose() {
    for (final pending in _pending.values) {
      pending.cancel();
    }
    _pending.clear();
  }

  List<Effect<dynamic>> _dedupeEffects(List<Effect<dynamic>> effects) {
    // For coalescable effects: last one with same key wins
    // For non-coalescable: all execute
    final byKey = <EffectKey, Effect<dynamic>>{};
    final nonCoalescable = <Effect<dynamic>>[];

    for (final effect in effects) {
      if (effect.coalescable) {
        byKey[effect.key] = effect; // Last wins
      } else {
        nonCoalescable.add(effect);
      }
    }

    return [...byKey.values, ...nonCoalescable];
  }

  void _executeOne(Effect<dynamic> effect) {
    final key = effect.key;

    try {
      final result = effect.execute();

      if (result is Future<dynamic>) {
        _handleAsync(key, result);
      } else {
        // Sync effect - dispatch result immediately (but async)
        _dispatchResult(EffectResult<dynamic>.succeeded(key, result));
      }
    } catch (e, st) {
      _dispatchResult(EffectResult<dynamic>.failed(key, e, st));
    }
  }

  void _handleAsync(EffectKey key, Future<dynamic> future) {
    final completer = Completer<void>();
    final operation = _PendingOperation(completer);

    _pending[key] = operation;

    future.then((value) {
      _pending.remove(key);

      // Check if cancelled while in flight (via operation state, not global set)
      if (operation.isCancelled) {
        // Already dispatched Cancelled when cancel() was called
        return;
      }

      _dispatchResult(EffectResult<dynamic>.succeeded(key, value));
    }).catchError((Object error, StackTrace stack) {
      _pending.remove(key);

      // Check if cancelled
      if (operation.isCancelled) {
        return;
      }

      _dispatchResult(EffectResult<dynamic>.failed(key, error, stack));
    });
  }

  void _dispatchResult(EffectResult<dynamic> result) {
    // Dispatch asynchronously to prevent synchronous reducer recursion
    scheduleMicrotask(() {
      _onResult(result);
    });
  }
}

/// Internal: tracks a pending async operation.
class _PendingOperation {
  _PendingOperation(this._completer);

  final Completer<void> _completer;
  bool _cancelled = false;

  bool get isCancelled => _cancelled;

  void cancel() {
    _cancelled = true;
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }
}
