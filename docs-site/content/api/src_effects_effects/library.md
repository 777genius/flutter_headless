---
title: "effects"
description: "API documentation for the effects library"
outline: [2, 3]
---

# effects

Effects executor system (E1 standard).

Provides side-effect execution outside reducers:

- [Effect](/api/src_effects_effect/Effect) - base effect type with key for dedupe
- [EffectKey](/api/src_effects_effect_key/EffectKey) - deterministic key for dedupe/cancel
- [EffectResult](/api/src_effects_effect_result/EffectResult) - result types (Succeeded/Failed/Cancelled)
- [EffectExecutor](/api/src_effects_effect_executor/EffectExecutor) - executes effects, dispatches results

See `docs/ARCHITECTURE.md` → "Единый стандарт поведения… (E1)"

## Classes {#section-classes}

| Class | Description |
|---|---|
| [AsyncEffect\<T\>](/api/src_effects_effect/AsyncEffect) | Asynchronous effect (returns Future). |
| [Effect\<T\>](/api/src_effects_effect/Effect) | Base class for all effects. |
| [EffectCancelled\<T\>](/api/src_effects_effect_result/EffectCancelled) | Effect was cancelled before completion. |
| [EffectCategory](/api/src_effects_effect/EffectCategory) | Common effect categories. |
| [EffectExecutor](/api/src_effects_effect_executor/EffectExecutor) | Executor for running effects outside reducer. |
| [EffectFailed\<T\>](/api/src_effects_effect_result/EffectFailed) | Effect failed with error. |
| [EffectKey](/api/src_effects_effect_key/EffectKey) | Key for effect deduplication and cancellation. |
| [EffectResult\<T\>](/api/src_effects_effect_result/EffectResult) | Result of effect execution. |
| [EffectSucceeded\<T\>](/api/src_effects_effect_result/EffectSucceeded) | Effect completed successfully. |
| [SyncEffect\<T\>](/api/src_effects_effect/SyncEffect) | Synchronous effect (completes immediately). |
| [VoidEffect](/api/src_effects_effect/VoidEffect) | Effect that produces no result value (side-effect only). |

## Typedefs {#section-typedefs}

| Typedef | Description |
|---|---|
| [EffectResultCallback](/api/src_effects_effect_executor/EffectResultCallback) | Callback for receiving effect results. |

