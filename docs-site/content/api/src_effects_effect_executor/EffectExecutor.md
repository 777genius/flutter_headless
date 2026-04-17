---
title: "EffectExecutor"
description: "API documentation for EffectExecutor class from effect_executor"
category: "Classes"
library: "effect_executor"
outline: [2, 3]
---

# EffectExecutor

<div class="member-signature"><div class="member-signature-code"><span class="kw">class</span> <span class="fn">EffectExecutor</span></div></div>

Executor for running effects outside reducer.

Key responsibilities:

- Deduplicate effects with same key within batch (last wins)
- Coalesce effects when [Effect.coalescable](/api/src_effects_effect/Effect#prop-coalescable) is true
- Cancel pending effects by key
- Dispatch result events asynchronously (microtask) to prevent recursion

Usage:

```dart
final executor = EffectExecutor(
  onResult: (result) => dispatch(ResultEvent(result)),
);

// From reducer: return effects
executor.execute([
  OpenOverlayEffect(...),
  FetchDataEffect(...),
]);
```

See `docs/ARCHITECTURE.md` → "Единый стандарт поведения… (E1)"

## Constructors {#section-constructors}

### EffectExecutor() {#ctor-effectexecutor}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="fn">EffectExecutor</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">void</span> <span class="type">Function</span>(<a href="/api/src_effects_effect_result/EffectResult" class="type-link">EffectResult</a>&lt;<span class="type">dynamic</span>&gt; <span class="param">result</span>) <span class="param">onResult</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
EffectExecutor({
  required EffectResultCallback onResult,
}) : _onResult = onResult;
```
:::

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_effects_effect_executor/EffectExecutor#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_effects_effect_executor/EffectExecutor#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_effects_effect_executor/EffectExecutor#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_effects_effect_executor/EffectExecutor#operator-equals).
The hash code of an object should only change if the object changes
in a way that affects equality.
There are no further requirements for the hash codes.
They need not be consistent between executions of the same program
and there are no distribution guarantees.

Objects that are not equal are allowed to have the same hash code.
It is even technically allowed that all instances have the same hash code,
but if clashes happen too often,
it may reduce the efficiency of hash-based data structures
like [HashSet](https://api.flutter.dev/flutter/dart-collection/HashSet-class.html) or [HashMap](https://api.flutter.dev/flutter/dart-collection/HashMap-class.html).

If a subclass overrides [hashCode](/api/src_effects_effect_executor/EffectExecutor#prop-hashcode), it should override the
[operator ==](/api/src_effects_effect_executor/EffectExecutor#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### runtimeType <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-runtimetype}

<div class="member-signature"><div class="member-signature-code"><span class="type">Type</span> <span class="kw">get</span> <span class="fn">runtimeType</span></div></div>

A representation of the runtime type of the object.

*Inherited from Object.*

:::details Implementation
```dart
external Type get runtimeType;
```
:::

## Methods {#section-methods}

### cancel() {#cancel}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">cancel</span>(<a href="/api/src_effects_effect_key/EffectKey" class="type-link">EffectKey</a> <span class="param">key</span>)</div></div>

Cancel pending effect(s) by key.

This is a one-shot operation: only cancels currently in-flight async
operations. Future effects with the same key will NOT be affected.

If `key` has opId, cancels only that specific operation.
If `key` has no opId, cancels all operations matching category+targetId.

:::details Implementation
```dart
void cancel(EffectKey key) {
  &#47;&#47; Find and cancel matching pending operations
  final toCancel = <EffectKey>[];
  for (final pendingKey in _pending.keys) {
    if (key.matches(pendingKey)) {
      toCancel.add(pendingKey);
    }
  }

  for (final cancelKey in toCancel) {
    final pending = _pending.remove(cancelKey);
    pending?.cancel();
    &#47;&#47; Dispatch cancelled result asynchronously
    _dispatchResult(EffectResult<dynamic>.cancelled(cancelKey));
  }
}
```
:::

### dispose() {#dispose}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">dispose</span>()</div></div>

Dispose executor and cancel all pending operations.

:::details Implementation
```dart
void dispose() {
  for (final pending in _pending.values) {
    pending.cancel();
  }
  _pending.clear();
}
```
:::

### execute() {#execute}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">execute</span>(<span class="type">List</span>&lt;<a href="/api/src_effects_effect/Effect" class="type-link">Effect</a>&lt;<span class="type">dynamic</span>&gt;&gt; <span class="param">effects</span>)</div></div>

Execute a batch of effects.

Effects are deduplicated by key (last wins for coalescable effects).
Results are dispatched asynchronously via `onResult` callback.

:::details Implementation
```dart
void execute(List<Effect<dynamic>> effects) {
  if (effects.isEmpty) return;

  &#47;&#47; Dedupe&#47;coalesce: group by key, last wins for coalescable
  final deduped = _dedupeEffects(effects);

  &#47;&#47; Execute each effect
  for (final effect in deduped) {
    _executeOne(effect);
  }
}
```
:::

### isPending() {#ispending}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="fn">isPending</span>(<a href="/api/src_effects_effect_key/EffectKey" class="type-link">EffectKey</a> <span class="param">key</span>)</div></div>

Check if an effect with given key is pending.

:::details Implementation
```dart
bool isPending(EffectKey key) {
  for (final pendingKey in _pending.keys) {
    if (key.matches(pendingKey)) {
      return true;
    }
  }
  return false;
}
```
:::

### noSuchMethod() <span class="docs-badge docs-badge-info">inherited</span> {#nosuchmethod}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="fn">noSuchMethod</span>(<span class="type">Invocation</span> <span class="param">invocation</span>)</div></div>

Invoked when a nonexistent method or property is accessed.

A dynamic member invocation can attempt to call a member which
doesn't exist on the receiving object. Example:

```dart
dynamic object = 1;
object.add(42); // Statically allowed, run-time error
```

This invalid code will invoke the `noSuchMethod` method
of the integer `1` with an [Invocation](https://api.flutter.dev/flutter/dart-core/Invocation-class.html) representing the
`.add(42)` call and arguments (which then throws).

Classes can override [noSuchMethod](https://api.flutter.dev/flutter/dart-core/Object/noSuchMethod.html) to provide custom behavior
for such invalid dynamic invocations.

A class with a non-default [noSuchMethod](https://api.flutter.dev/flutter/dart-core/Object/noSuchMethod.html) invocation can also
omit implementations for members of its interface.
Example:

```dart
class MockList<T> implements List<T> {
  noSuchMethod(Invocation invocation) {
    log(invocation);
    super.noSuchMethod(invocation); // Will throw.
  }
}
void main() {
  MockList().add(42);
}
```

This code has no compile-time warnings or errors even though
the `MockList` class has no concrete implementation of
any of the `List` interface methods.
Calls to `List` methods are forwarded to `noSuchMethod`,
so this code will `log` an invocation similar to
`Invocation.method(#add, [42])` and then throw.

If a value is returned from `noSuchMethod`,
it becomes the result of the original invocation.
If the value is not of a type that can be returned by the original
invocation, a type error occurs at the invocation.

The default behavior is to throw a [NoSuchMethodError](https://api.flutter.dev/flutter/dart-core/NoSuchMethodError-class.html).

*Inherited from Object.*

:::details Implementation
```dart
@pragma("vm:entry-point")
@pragma("wasm:entry-point")
external dynamic noSuchMethod(Invocation invocation);
```
:::

### toString() <span class="docs-badge docs-badge-info">inherited</span> {#tostring}

<div class="member-signature"><div class="member-signature-code"><span class="type">String</span> <span class="fn">toString</span>()</div></div>

A string representation of this object.

Some classes have a default textual representation,
often paired with a static `parse` function (like [int.parse](https://api.flutter.dev/flutter/dart-core/int/parse.html)).
These classes will provide the textual representation as
their string representation.

Other classes have no meaningful textual representation
that a program will care about.
Such classes will typically override `toString` to provide
useful information when inspecting the object,
mainly for debugging or logging.

*Inherited from Object.*

:::details Implementation
```dart
external String toString();
```
:::

## Operators {#section-operators}

### operator ==() <span class="docs-badge docs-badge-info">inherited</span> {#operator-equals}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="fn">operator ==</span>(<span class="type">Object</span> <span class="param">other</span>)</div></div>

The equality operator.

The default behavior for all [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)s is to return true if and
only if this object and `other` are the same object.

Override this method to specify a different equality relation on
a class. The overriding method must still be an equivalence relation.
That is, it must be:

- Total: It must return a boolean for all arguments. It should never throw.

- Reflexive: For all objects `o`, `o == o` must be true.

- Symmetric: For all objects `o1` and `o2`, `o1 == o2` and `o2 == o1` must
either both be true, or both be false.

- Transitive: For all objects `o1`, `o2`, and `o3`, if `o1 == o2` and
`o2 == o3` are true, then `o1 == o3` must be true.

The method should also be consistent over time,
so whether two objects are equal should only change
if at least one of the objects was modified.

If a subclass overrides the equality operator, it should override
the [hashCode](https://api.flutter.dev/flutter/dart-core/Object/hashCode.html) method as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external bool operator ==(Object other);
```
:::

