import 'dart:async';

import 'effect_key.dart';
import 'effect_result.dart';

export 'effect_key.dart';

/// Base class for all effects.
///
/// Effects are side-effects that should be executed outside the reducer.
/// The reducer remains pure - it returns effects, executor runs them.
///
/// Each effect has a [key] for deduplication and cancellation.
/// Effects with the same key within a batch are deduplicated (last wins).
///
/// See `docs/ARCHITECTURE.md` → "Единый стандарт поведения… (E1)"
abstract class Effect<T> {
  const Effect();

  /// Unique key for this effect (for dedupe/cancel).
  EffectKey get key;

  /// Execute the effect and return result.
  ///
  /// This method should be idempotent-safe (defensive to re-execution).
  /// Exceptions are caught by executor and converted to [EffectResult.failed].
  FutureOr<T> execute();

  /// Whether this effect can be coalesced with another of same key.
  ///
  /// When true, if multiple effects with same key are in batch,
  /// only the last one executes (coalesce/last-wins).
  bool get coalescable => true;
}

/// Synchronous effect (completes immediately).
abstract class SyncEffect<T> extends Effect<T> {
  const SyncEffect();

  @override
  T execute();
}

/// Asynchronous effect (returns Future).
abstract class AsyncEffect<T> extends Effect<T> {
  const AsyncEffect();

  @override
  Future<T> execute();
}

/// Effect that produces no result value (side-effect only).
abstract class VoidEffect extends Effect<void> {
  const VoidEffect();
}

/// Common effect categories.
abstract class EffectCategory {
  static const String overlay = 'overlay';
  static const String focus = 'focus';
  static const String announce = 'announce';
  static const String reposition = 'reposition';
  static const String fetch = 'fetch';
  static const String navigation = 'navigation';
}
