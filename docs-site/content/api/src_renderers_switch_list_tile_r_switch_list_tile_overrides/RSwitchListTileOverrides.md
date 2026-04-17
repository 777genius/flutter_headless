---
title: "RSwitchListTileOverrides"
description: "API documentation for RSwitchListTileOverrides class from r_switch_list_tile_overrides"
category: "Classes"
library: "r_switch_list_tile_overrides"
outline: [2, 3]
---

# RSwitchListTileOverrides <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RSwitchListTileOverrides</span></div></div>

Per-instance override contract for SwitchListTile components.

## Constructors {#section-constructors}

### RSwitchListTileOverrides() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rswitchlisttileoverrides}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RSwitchListTileOverrides</span>({</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">contentPadding</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">minHeight</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">horizontalGap</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">verticalGap</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">titleStyle</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">subtitleStyle</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">disabledOpacity</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">pressOverlayColor</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">pressOpacity</span>,</span><span class="member-signature-line">  <a href="/api/src_renderers_switch_list_tile_r_switch_list_tile_motion_tokens/RSwitchListTileMotionTokens" class="type-link">RSwitchListTileMotionTokens</a>? <span class="param">motion</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">rippleShape</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">splashRadius</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">overlayColor</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const RSwitchListTileOverrides({
  this.contentPadding,
  this.minHeight,
  this.horizontalGap,
  this.verticalGap,
  this.titleStyle,
  this.subtitleStyle,
  this.disabledOpacity,
  this.pressOverlayColor,
  this.pressOpacity,
  this.motion,
  this.rippleShape,
  this.splashRadius,
  this.overlayColor,
});
```
:::

### RSwitchListTileOverrides.tokens() <span class="docs-badge docs-badge-tip">factory</span> <span class="docs-badge docs-badge-tip">const</span> {#tokens}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="kw">factory</span> <span class="fn">RSwitchListTileOverrides.tokens</span>({</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">contentPadding</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">minHeight</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">horizontalGap</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">verticalGap</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">titleStyle</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">subtitleStyle</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">disabledOpacity</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">pressOverlayColor</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">pressOpacity</span>,</span><span class="member-signature-line">  <a href="/api/src_renderers_switch_list_tile_r_switch_list_tile_motion_tokens/RSwitchListTileMotionTokens" class="type-link">RSwitchListTileMotionTokens</a>? <span class="param">motion</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">rippleShape</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">splashRadius</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">overlayColor</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const factory RSwitchListTileOverrides.tokens({
  EdgeInsetsGeometry? contentPadding,
  double? minHeight,
  double? horizontalGap,
  double? verticalGap,
  TextStyle? titleStyle,
  TextStyle? subtitleStyle,
  double? disabledOpacity,
  Color? pressOverlayColor,
  double? pressOpacity,
  RSwitchListTileMotionTokens? motion,
  ShapeBorder? rippleShape,
  double? splashRadius,
  WidgetStateProperty<Color?>? overlayColor,
}) = RSwitchListTileOverrides;
```
:::

## Properties {#section-properties}

### contentPadding <span class="docs-badge docs-badge-tip">final</span> {#prop-contentpadding}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">contentPadding</span></div></div>

:::details Implementation
```dart
final EdgeInsetsGeometry? contentPadding;
```
:::

### disabledOpacity <span class="docs-badge docs-badge-tip">final</span> {#prop-disabledopacity}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span>? <span class="fn">disabledOpacity</span></div></div>

:::details Implementation
```dart
final double? disabledOpacity;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_renderers_switch_list_tile_r_switch_list_tile_overrides/RSwitchListTileOverrides#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_renderers_switch_list_tile_r_switch_list_tile_overrides/RSwitchListTileOverrides#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_renderers_switch_list_tile_r_switch_list_tile_overrides/RSwitchListTileOverrides#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_renderers_switch_list_tile_r_switch_list_tile_overrides/RSwitchListTileOverrides#operator-equals).
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

If a subclass overrides [hashCode](/api/src_renderers_switch_list_tile_r_switch_list_tile_overrides/RSwitchListTileOverrides#prop-hashcode), it should override the
[operator ==](/api/src_renderers_switch_list_tile_r_switch_list_tile_overrides/RSwitchListTileOverrides#operator-equals) operator as well to maintain consistency.

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
    contentPadding != null ||
    minHeight != null ||
    horizontalGap != null ||
    verticalGap != null ||
    titleStyle != null ||
    subtitleStyle != null ||
    disabledOpacity != null ||
    pressOverlayColor != null ||
    pressOpacity != null ||
    motion != null ||
    rippleShape != null ||
    splashRadius != null ||
    overlayColor != null;
```
:::

### horizontalGap <span class="docs-badge docs-badge-tip">final</span> {#prop-horizontalgap}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span>? <span class="fn">horizontalGap</span></div></div>

:::details Implementation
```dart
final double? horizontalGap;
```
:::

### minHeight <span class="docs-badge docs-badge-tip">final</span> {#prop-minheight}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span>? <span class="fn">minHeight</span></div></div>

:::details Implementation
```dart
final double? minHeight;
```
:::

### motion <span class="docs-badge docs-badge-tip">final</span> {#prop-motion}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_switch_list_tile_r_switch_list_tile_motion_tokens/RSwitchListTileMotionTokens" class="type-link">RSwitchListTileMotionTokens</a>? <span class="fn">motion</span></div></div>

:::details Implementation
```dart
final RSwitchListTileMotionTokens? motion;
```
:::

### overlayColor <span class="docs-badge docs-badge-tip">final</span> {#prop-overlaycolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">overlayColor</span></div></div>

State-dependent overlay color for interaction feedback.

:::details Implementation
```dart
final WidgetStateProperty<Color?>? overlayColor;
```
:::

### pressOpacity <span class="docs-badge docs-badge-tip">final</span> {#prop-pressopacity}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span>? <span class="fn">pressOpacity</span></div></div>

:::details Implementation
```dart
final double? pressOpacity;
```
:::

### pressOverlayColor <span class="docs-badge docs-badge-tip">final</span> {#prop-pressoverlaycolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">pressOverlayColor</span></div></div>

:::details Implementation
```dart
final Color? pressOverlayColor;
```
:::

### rippleShape <span class="docs-badge docs-badge-tip">final</span> {#prop-rippleshape}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">rippleShape</span></div></div>

Custom shape for ripple/splash effects (Material).

:::details Implementation
```dart
final ShapeBorder? rippleShape;
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

### splashRadius <span class="docs-badge docs-badge-tip">final</span> {#prop-splashradius}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span>? <span class="fn">splashRadius</span></div></div>

Custom splash radius for ripple effects (Material).

:::details Implementation
```dart
final double? splashRadius;
```
:::

### subtitleStyle <span class="docs-badge docs-badge-tip">final</span> {#prop-subtitlestyle}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">subtitleStyle</span></div></div>

:::details Implementation
```dart
final TextStyle? subtitleStyle;
```
:::

### titleStyle <span class="docs-badge docs-badge-tip">final</span> {#prop-titlestyle}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">titleStyle</span></div></div>

:::details Implementation
```dart
final TextStyle? titleStyle;
```
:::

### verticalGap <span class="docs-badge docs-badge-tip">final</span> {#prop-verticalgap}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span>? <span class="fn">verticalGap</span></div></div>

:::details Implementation
```dart
final double? verticalGap;
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

