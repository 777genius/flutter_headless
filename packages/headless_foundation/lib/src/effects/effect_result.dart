import 'package:flutter/foundation.dart';

import 'effect_key.dart';

/// Result of effect execution.
///
/// Dispatched as result events after effect completes.
/// Result events are delivered asynchronously (microtask/post-frame)
/// to prevent synchronous reducer recursion.
sealed class EffectResult<T> {
  const EffectResult({required this.key});

  /// Key of the effect that produced this result.
  final EffectKey key;

  /// Create succeeded result.
  factory EffectResult.succeeded(EffectKey key, T value) = EffectSucceeded<T>;

  /// Create failed result.
  factory EffectResult.failed(EffectKey key, Object error, StackTrace stack) =
      EffectFailed<T>;

  /// Create cancelled result.
  factory EffectResult.cancelled(EffectKey key) = EffectCancelled<T>;
}

/// Effect completed successfully.
@immutable
final class EffectSucceeded<T> extends EffectResult<T> {
  const EffectSucceeded(EffectKey key, this.value) : super(key: key);

  /// The result value.
  final T value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EffectSucceeded<T> &&
        other.key == key &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(key, value);

  @override
  String toString() => 'EffectSucceeded($key, $value)';
}

/// Effect failed with error.
@immutable
final class EffectFailed<T> extends EffectResult<T> {
  const EffectFailed(EffectKey key, this.error, this.stackTrace)
      : super(key: key);

  /// The error that occurred.
  final Object error;

  /// Stack trace of the error.
  final StackTrace stackTrace;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EffectFailed<T> && other.key == key && other.error == error;
  }

  @override
  int get hashCode => Object.hash(key, error);

  @override
  String toString() => 'EffectFailed($key, $error)';
}

/// Effect was cancelled before completion.
@immutable
final class EffectCancelled<T> extends EffectResult<T> {
  const EffectCancelled(EffectKey key) : super(key: key);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EffectCancelled<T> && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => 'EffectCancelled($key)';
}
