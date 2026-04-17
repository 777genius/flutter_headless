---
title: "CapabilityOverrides"
description: "API documentation for CapabilityOverrides class from capability_overrides"
category: "Classes"
library: "capability_overrides"
outline: [2, 3]
---

# CapabilityOverrides <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">CapabilityOverrides</span></div></div>

Type-safe override bag for theme capabilities.

Important: this is NOT per-instance rendering overrides.
Use [RenderOverrides](/api/src_renderers_render_overrides/RenderOverrides) for per-widget token/visual overrides.

This bag is intended for subtree-scoped capability replacement, e.g.
replacing `RDropdownButtonRenderer` on a specific screen.

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_theme_capability_overrides/CapabilityOverrides#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_theme_capability_overrides/CapabilityOverrides#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_theme_capability_overrides/CapabilityOverrides#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_theme_capability_overrides/CapabilityOverrides#operator-equals).
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

If a subclass overrides [hashCode](/api/src_theme_capability_overrides/CapabilityOverrides#prop-hashcode), it should override the
[operator ==](/api/src_theme_capability_overrides/CapabilityOverrides#operator-equals) operator as well to maintain consistency.

:::details Implementation
```dart
@override
int get hashCode => Object.hashAll(_overrides.entries);
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

### get() {#get}

<div class="member-signature"><div class="member-signature-code"><span class="type">T</span>? <span class="fn">get&lt;T&gt;</span>()</div></div>

Get override by type.

Returns null if no override of this type is registered.

:::details Implementation
```dart
T? get<T>() {
  final value = _overrides[T];
  if (value == null) return null;
  return value as T;
}
```
:::

### has() {#has}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="fn">has&lt;T&gt;</span>()</div></div>

Check if an override of the given type exists.

:::details Implementation
```dart
bool has<T>() => _overrides.containsKey(T);
```
:::

### merge() {#merge}

<div class="member-signature"><div class="member-signature-code"><a href="/api/src_theme_capability_overrides/CapabilityOverrides" class="type-link">CapabilityOverrides</a> <span class="fn">merge</span>(<a href="/api/src_theme_capability_overrides/CapabilityOverrides" class="type-link">CapabilityOverrides</a> <span class="param">other</span>)</div></div>

Create a new bag with additional overrides merged (the other wins).

:::details Implementation
```dart
CapabilityOverrides merge(CapabilityOverrides other) {
  if (identical(this, other)) return this;
  if (_overrides.isEmpty) return other;
  if (other._overrides.isEmpty) return this;
  return CapabilityOverrides._(
    <Type, Object>{..._overrides, ...other._overrides},
  );
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

### with_() {#with_}

<div class="member-signature"><div class="member-signature-code"><a href="/api/src_theme_capability_overrides/CapabilityOverrides" class="type-link">CapabilityOverrides</a> <span class="fn">with_&lt;T extends Object&gt;</span>(<span class="type">T</span> <span class="param">value</span>)</div></div>

Create a new bag with one override added or replaced.

:::details Implementation
```dart
CapabilityOverrides with_<T extends Object>(T value) {
  if (_overrides[T] == value) return this;
  return CapabilityOverrides._(<Type, Object>{..._overrides, T: value});
}
```
:::

## Operators {#section-operators}

### operator ==() <span class="docs-badge docs-badge-info">override</span> {#operator-equals}

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
the [hashCode](/api/src_theme_capability_overrides/CapabilityOverrides#prop-hashcode) method as well to maintain consistency.

:::details Implementation
```dart
@override
bool operator ==(Object other) {
  if (identical(this, other)) return true;
  return other is CapabilityOverrides &&
      mapEquals(_overrides, other._overrides);
}
```
:::

## Static Methods {#section-static-methods}

### build() {#build}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><a href="/api/src_theme_capability_overrides/CapabilityOverrides" class="type-link">CapabilityOverrides</a> <span class="fn">build</span>(</span><span class="member-signature-line">  <span class="type">void</span> <span class="type">Function</span>(<a href="/api/src_theme_capability_overrides/CapabilityOverridesBuilder" class="type-link">CapabilityOverridesBuilder</a> <span class="param">b</span>) <span class="param">f</span>,</span><span class="member-signature-line">);</span></div></div>

Build overrides using a type-safe builder.

This avoids exposing a `Map<Type, Object>` constructor, which would make
it easy to accidentally store mismatched types and crash later on cast.

:::details Implementation
```dart
static CapabilityOverrides build(
    void Function(CapabilityOverridesBuilder b) f) {
  final b = CapabilityOverridesBuilder._();
  f(b);
  return CapabilityOverrides._(Map<Type, Object>.unmodifiable(b._map));
}
```
:::

### only() {#only}

<div class="member-signature"><div class="member-signature-code"><a href="/api/src_theme_capability_overrides/CapabilityOverrides" class="type-link">CapabilityOverrides</a> <span class="fn">only&lt;T extends Object&gt;</span>(<span class="type">T</span> <span class="param">value</span>)</div></div>

Convenience helper for the common case: one capability override.

This is type-safe: key and value share the same generic type `T`.

:::details Implementation
```dart
static CapabilityOverrides only<T extends Object>(T value) {
  return CapabilityOverrides._(<Type, Object>{T: value});
}
```
:::

## Constants {#section-constants}

### empty {#prop-empty}

<div class="member-signature"><div class="member-signature-code"><span class="kw">const</span> <a href="/api/src_theme_capability_overrides/CapabilityOverrides" class="type-link">CapabilityOverrides</a> <span class="fn">empty</span></div></div>

Empty overrides.

:::details Implementation
```dart
static const CapabilityOverrides empty =
    CapabilityOverrides._(<Type, Object>{});
```
:::

