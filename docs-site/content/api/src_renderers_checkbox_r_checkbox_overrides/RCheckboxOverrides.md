---
title: "RCheckboxOverrides"
description: "API documentation for RCheckboxOverrides class from r_checkbox_overrides"
category: "Classes"
library: "r_checkbox_overrides"
outline: [2, 3]
---

# RCheckboxOverrides <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RCheckboxOverrides</span></div></div>

Per-instance override contract for Checkbox components.

This is the preset-agnostic override type that lives in headless_contracts.
Users can customize a specific checkbox instance without depending on
preset-specific types.

## Constructors {#section-constructors}

### RCheckboxOverrides() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rcheckboxoverrides}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RCheckboxOverrides</span>({</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">boxSize</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">borderRadius</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">borderWidth</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">borderColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">activeColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">inactiveColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">checkColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">indeterminateColor</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">disabledOpacity</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">pressOverlayColor</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">pressOpacity</span>,</span><span class="member-signature-line">  <a href="/api/src_renderers_checkbox_r_checkbox_motion_tokens/RCheckboxMotionTokens" class="type-link">RCheckboxMotionTokens</a>? <span class="param">motion</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">minTapTargetSize</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const RCheckboxOverrides({
  this.boxSize,
  this.borderRadius,
  this.borderWidth,
  this.borderColor,
  this.activeColor,
  this.inactiveColor,
  this.checkColor,
  this.indeterminateColor,
  this.disabledOpacity,
  this.pressOverlayColor,
  this.pressOpacity,
  this.motion,
  this.minTapTargetSize,
});
```
:::

### RCheckboxOverrides.tokens() <span class="docs-badge docs-badge-tip">factory</span> <span class="docs-badge docs-badge-tip">const</span> {#tokens}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="kw">factory</span> <span class="fn">RCheckboxOverrides.tokens</span>({</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">boxSize</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">borderRadius</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">borderWidth</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">borderColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">activeColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">inactiveColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">checkColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">indeterminateColor</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">disabledOpacity</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">pressOverlayColor</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">pressOpacity</span>,</span><span class="member-signature-line">  <a href="/api/src_renderers_checkbox_r_checkbox_motion_tokens/RCheckboxMotionTokens" class="type-link">RCheckboxMotionTokens</a>? <span class="param">motion</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">minTapTargetSize</span>,</span><span class="member-signature-line">})</span></div></div>

Factory for token-level overrides.

:::details Implementation
```dart
const factory RCheckboxOverrides.tokens({
  double? boxSize,
  BorderRadius? borderRadius,
  double? borderWidth,
  Color? borderColor,
  Color? activeColor,
  Color? inactiveColor,
  Color? checkColor,
  Color? indeterminateColor,
  double? disabledOpacity,
  Color? pressOverlayColor,
  double? pressOpacity,
  RCheckboxMotionTokens? motion,
  Size? minTapTargetSize,
}) = RCheckboxOverrides;
```
:::

## Properties {#section-properties}

### activeColor <span class="docs-badge docs-badge-tip">final</span> {#prop-activecolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">activeColor</span></div></div>

Fill color for checked state.

:::details Implementation
```dart
final Color? activeColor;
```
:::

### borderColor <span class="docs-badge docs-badge-tip">final</span> {#prop-bordercolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">borderColor</span></div></div>

Border color.

:::details Implementation
```dart
final Color? borderColor;
```
:::

### borderRadius <span class="docs-badge docs-badge-tip">final</span> {#prop-borderradius}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">borderRadius</span></div></div>

Corner radius for the checkbox box.

:::details Implementation
```dart
final BorderRadius? borderRadius;
```
:::

### borderWidth <span class="docs-badge docs-badge-tip">final</span> {#prop-borderwidth}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span>? <span class="fn">borderWidth</span></div></div>

Border width.

:::details Implementation
```dart
final double? borderWidth;
```
:::

### boxSize <span class="docs-badge docs-badge-tip">final</span> {#prop-boxsize}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span>? <span class="fn">boxSize</span></div></div>

Visual size of the checkbox square.

:::details Implementation
```dart
final double? boxSize;
```
:::

### checkColor <span class="docs-badge docs-badge-tip">final</span> {#prop-checkcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">checkColor</span></div></div>

Color for the checkmark glyph.

:::details Implementation
```dart
final Color? checkColor;
```
:::

### disabledOpacity <span class="docs-badge docs-badge-tip">final</span> {#prop-disabledopacity}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span>? <span class="fn">disabledOpacity</span></div></div>

Opacity applied when disabled (0.0-1.0).

:::details Implementation
```dart
final double? disabledOpacity;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_renderers_checkbox_r_checkbox_overrides/RCheckboxOverrides#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_renderers_checkbox_r_checkbox_overrides/RCheckboxOverrides#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_renderers_checkbox_r_checkbox_overrides/RCheckboxOverrides#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_renderers_checkbox_r_checkbox_overrides/RCheckboxOverrides#operator-equals).
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

If a subclass overrides [hashCode](/api/src_renderers_checkbox_r_checkbox_overrides/RCheckboxOverrides#prop-hashcode), it should override the
[operator ==](/api/src_renderers_checkbox_r_checkbox_overrides/RCheckboxOverrides#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### hasOverrides <span class="docs-badge docs-badge-tip">no setter</span> {#prop-hasoverrides}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">hasOverrides</span></div></div>

:::details Implementation
```dart
bool get hasOverrides =>
    boxSize != null ||
    borderRadius != null ||
    borderWidth != null ||
    borderColor != null ||
    activeColor != null ||
    inactiveColor != null ||
    checkColor != null ||
    indeterminateColor != null ||
    disabledOpacity != null ||
    pressOverlayColor != null ||
    pressOpacity != null ||
    motion != null ||
    minTapTargetSize != null;
```
:::

### inactiveColor <span class="docs-badge docs-badge-tip">final</span> {#prop-inactivecolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">inactiveColor</span></div></div>

Fill color for unchecked state.

:::details Implementation
```dart
final Color? inactiveColor;
```
:::

### indeterminateColor <span class="docs-badge docs-badge-tip">final</span> {#prop-indeterminatecolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">indeterminateColor</span></div></div>

Color for indeterminate glyph.

:::details Implementation
```dart
final Color? indeterminateColor;
```
:::

### minTapTargetSize <span class="docs-badge docs-badge-tip">final</span> {#prop-mintaptargetsize}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">minTapTargetSize</span></div></div>

Minimum tap target size (WCAG/platform policy).

:::details Implementation
```dart
final Size? minTapTargetSize;
```
:::

### motion <span class="docs-badge docs-badge-tip">final</span> {#prop-motion}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_checkbox_r_checkbox_motion_tokens/RCheckboxMotionTokens" class="type-link">RCheckboxMotionTokens</a>? <span class="fn">motion</span></div></div>

Motion tokens for visual transitions.

:::details Implementation
```dart
final RCheckboxMotionTokens? motion;
```
:::

### pressOpacity <span class="docs-badge docs-badge-tip">final</span> {#prop-pressopacity}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span>? <span class="fn">pressOpacity</span></div></div>

Opacity for pressed feedback (Cupertino-style).

:::details Implementation
```dart
final double? pressOpacity;
```
:::

### pressOverlayColor <span class="docs-badge docs-badge-tip">final</span> {#prop-pressoverlaycolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">pressOverlayColor</span></div></div>

Overlay color for press feedback (Material-style).

:::details Implementation
```dart
final Color? pressOverlayColor;
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

