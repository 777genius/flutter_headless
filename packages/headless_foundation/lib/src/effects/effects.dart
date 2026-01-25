/// Effects executor system (E1 standard).
///
/// Provides side-effect execution outside reducers:
/// - [Effect] - base effect type with key for dedupe
/// - [EffectKey] - deterministic key for dedupe/cancel
/// - [EffectResult] - result types (Succeeded/Failed/Cancelled)
/// - [EffectExecutor] - executes effects, dispatches results
///
/// See `docs/ARCHITECTURE.md` → "Единый стандарт поведения… (E1)"
library;

export 'effect.dart';
export 'effect_key.dart';
export 'effect_result.dart';
export 'effect_executor.dart';
