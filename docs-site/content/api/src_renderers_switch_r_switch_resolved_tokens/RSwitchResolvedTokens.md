---
title: "RSwitchResolvedTokens"
description: "API documentation for RSwitchResolvedTokens class from r_switch_resolved_tokens"
category: "Classes"
library: "r_switch_resolved_tokens"
outline: [2, 3]
---

# RSwitchResolvedTokens <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RSwitchResolvedTokens</span></div></div>

Resolved visual tokens for switch rendering.

## Constructors {#section-constructors}

### RSwitchResolvedTokens() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rswitchresolvedtokens}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RSwitchResolvedTokens</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">trackSize</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">trackBorderRadius</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">trackOutlineColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">trackOutlineWidth</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">activeTrackColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">inactiveTrackColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">thumbSizeUnselected</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">thumbSizeSelected</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">thumbSizePressed</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">thumbSizeTransition</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">activeThumbColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">inactiveThumbColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">thumbPadding</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">disabledOpacity</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">pressOverlayColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">pressOpacity</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">minTapTargetSize</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">stateLayerRadius</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">stateLayerColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">thumbIcon</span>,</span><span class="member-signature-line">  <a href="/api/src_renderers_switch_r_switch_motion_tokens/RSwitchMotionTokens" class="type-link">RSwitchMotionTokens</a>? <span class="param">motion</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const RSwitchResolvedTokens({
  required this.trackSize,
  required this.trackBorderRadius,
  required this.trackOutlineColor,
  required this.trackOutlineWidth,
  required this.activeTrackColor,
  required this.inactiveTrackColor,
  required this.thumbSizeUnselected,
  required this.thumbSizeSelected,
  required this.thumbSizePressed,
  required this.thumbSizeTransition,
  required this.activeThumbColor,
  required this.inactiveThumbColor,
  required this.thumbPadding,
  required this.disabledOpacity,
  required this.pressOverlayColor,
  required this.pressOpacity,
  required this.minTapTargetSize,
  required this.stateLayerRadius,
  required this.stateLayerColor,
  this.thumbIcon,
  this.motion,
});
```
:::

## Properties {#section-properties}

### activeThumbColor <span class="docs-badge docs-badge-tip">final</span> {#prop-activethumbcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">activeThumbColor</span></div></div>

Thumb color when switch is on.

:::details Implementation
```dart
final Color activeThumbColor;
```
:::

### activeTrackColor <span class="docs-badge docs-badge-tip">final</span> {#prop-activetrackcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">activeTrackColor</span></div></div>

Track color when switch is on.

:::details Implementation
```dart
final Color activeTrackColor;
```
:::

### disabledOpacity <span class="docs-badge docs-badge-tip">final</span> {#prop-disabledopacity}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span> <span class="fn">disabledOpacity</span></div></div>

Opacity applied when disabled (0.0-1.0).

:::details Implementation
```dart
final double disabledOpacity;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_renderers_switch_r_switch_resolved_tokens/RSwitchResolvedTokens#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_renderers_switch_r_switch_resolved_tokens/RSwitchResolvedTokens#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_renderers_switch_r_switch_resolved_tokens/RSwitchResolvedTokens#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_renderers_switch_r_switch_resolved_tokens/RSwitchResolvedTokens#operator-equals).
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

If a subclass overrides [hashCode](/api/src_renderers_switch_r_switch_resolved_tokens/RSwitchResolvedTokens#prop-hashcode), it should override the
[operator ==](/api/src_renderers_switch_r_switch_resolved_tokens/RSwitchResolvedTokens#operator-equals) operator as well to maintain consistency.

:::details Implementation
```dart
@override
int get hashCode => Object.hash(
      trackSize,
      trackBorderRadius,
      trackOutlineColor,
      trackOutlineWidth,
      activeTrackColor,
      inactiveTrackColor,
      thumbSizeUnselected,
      thumbSizeSelected,
      thumbSizePressed,
      thumbSizeTransition,
      activeThumbColor,
      inactiveThumbColor,
      thumbPadding,
      disabledOpacity,
      pressOverlayColor,
      pressOpacity,
      minTapTargetSize,
      stateLayerRadius,
      stateLayerColor,
    );
```
:::

### inactiveThumbColor <span class="docs-badge docs-badge-tip">final</span> {#prop-inactivethumbcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">inactiveThumbColor</span></div></div>

Thumb color when switch is off.

:::details Implementation
```dart
final Color inactiveThumbColor;
```
:::

### inactiveTrackColor <span class="docs-badge docs-badge-tip">final</span> {#prop-inactivetrackcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">inactiveTrackColor</span></div></div>

Track color when switch is off.

:::details Implementation
```dart
final Color inactiveTrackColor;
```
:::

### minTapTargetSize <span class="docs-badge docs-badge-tip">final</span> {#prop-mintaptargetsize}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">minTapTargetSize</span></div></div>

Minimum tap target size.

:::details Implementation
```dart
final Size minTapTargetSize;
```
:::

### motion <span class="docs-badge docs-badge-tip">final</span> {#prop-motion}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_switch_r_switch_motion_tokens/RSwitchMotionTokens" class="type-link">RSwitchMotionTokens</a>? <span class="fn">motion</span></div></div>

Motion tokens for visual transitions.

:::details Implementation
```dart
final RSwitchMotionTokens? motion;
```
:::

### pressOpacity <span class="docs-badge docs-badge-tip">final</span> {#prop-pressopacity}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span> <span class="fn">pressOpacity</span></div></div>

Opacity for pressed feedback (Cupertino-style).

:::details Implementation
```dart
final double pressOpacity;
```
:::

### pressOverlayColor <span class="docs-badge docs-badge-tip">final</span> {#prop-pressoverlaycolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">pressOverlayColor</span></div></div>

Overlay color for press feedback (Material-style).

:::details Implementation
```dart
final Color pressOverlayColor;
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

### stateLayerColor <span class="docs-badge docs-badge-tip">final</span> {#prop-statelayercolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">stateLayerColor</span></div></div>

State layer color as WidgetStateProperty.
Resolves to primary (selected) or onSurface (unselected) with opacity.

:::details Implementation
```dart
final WidgetStateProperty<Color?> stateLayerColor;
```
:::

### stateLayerRadius <span class="docs-badge docs-badge-tip">final</span> {#prop-statelayerradius}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span> <span class="fn">stateLayerRadius</span></div></div>

Radius of the state layer (radial reaction) around thumb.
Material 3: 20.0 px

:::details Implementation
```dart
final double stateLayerRadius;
```
:::

### thumbIcon <span class="docs-badge docs-badge-tip">final</span> {#prop-thumbicon}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">thumbIcon</span></div></div>

Optional icon displayed on the thumb.

:::details Implementation
```dart
final WidgetStateProperty<Icon?>? thumbIcon;
```
:::

### thumbPadding <span class="docs-badge docs-badge-tip">final</span> {#prop-thumbpadding}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span> <span class="fn">thumbPadding</span></div></div>

Padding between thumb and track edge during drag.

Material: 4.0, Cupertino: 2.0.

:::details Implementation
```dart
final double thumbPadding;
```
:::

### thumbSizePressed <span class="docs-badge docs-badge-tip">final</span> {#prop-thumbsizepressed}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">thumbSizePressed</span></div></div>

Thumb size when pressed or dragging.
Material 3: Size(28, 28)

:::details Implementation
```dart
final Size thumbSizePressed;
```
:::

### thumbSizeSelected <span class="docs-badge docs-badge-tip">final</span> {#prop-thumbsizeselected}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">thumbSizeSelected</span></div></div>

Thumb size when switch is ON (selected).
Material 3: Size(24, 24)

:::details Implementation
```dart
final Size thumbSizeSelected;
```
:::

### thumbSizeTransition <span class="docs-badge docs-badge-tip">final</span> {#prop-thumbsizetransition}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">thumbSizeTransition</span></div></div>

Transitional thumb size during toggle animation (stretched phase).
Material 3: Size(34, 22)

:::details Implementation
```dart
final Size thumbSizeTransition;
```
:::

### thumbSizeUnselected <span class="docs-badge docs-badge-tip">final</span> {#prop-thumbsizeunselected}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">thumbSizeUnselected</span></div></div>

Thumb size when switch is OFF (unselected).
Material 3: Size(16, 16)

:::details Implementation
```dart
final Size thumbSizeUnselected;
```
:::

### trackBorderRadius <span class="docs-badge docs-badge-tip">final</span> {#prop-trackborderradius}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">trackBorderRadius</span></div></div>

Corner radius for the track.

:::details Implementation
```dart
final BorderRadius trackBorderRadius;
```
:::

### trackOutlineColor <span class="docs-badge docs-badge-tip">final</span> {#prop-trackoutlinecolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">trackOutlineColor</span></div></div>

Outline color for the track.

:::details Implementation
```dart
final Color trackOutlineColor;
```
:::

### trackOutlineWidth <span class="docs-badge docs-badge-tip">final</span> {#prop-trackoutlinewidth}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span> <span class="fn">trackOutlineWidth</span></div></div>

Outline width for the track.

:::details Implementation
```dart
final double trackOutlineWidth;
```
:::

### trackSize <span class="docs-badge docs-badge-tip">final</span> {#prop-tracksize}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">trackSize</span></div></div>

Size of the track (background).

:::details Implementation
```dart
final Size trackSize;
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
the [hashCode](/api/src_renderers_switch_r_switch_resolved_tokens/RSwitchResolvedTokens#prop-hashcode) method as well to maintain consistency.

:::details Implementation
```dart
@override
bool operator ==(Object other) {
  if (identical(this, other)) return true;
  return other is RSwitchResolvedTokens &&
      other.trackSize == trackSize &&
      other.trackBorderRadius == trackBorderRadius &&
      other.trackOutlineColor == trackOutlineColor &&
      other.trackOutlineWidth == trackOutlineWidth &&
      other.activeTrackColor == activeTrackColor &&
      other.inactiveTrackColor == inactiveTrackColor &&
      other.thumbSizeUnselected == thumbSizeUnselected &&
      other.thumbSizeSelected == thumbSizeSelected &&
      other.thumbSizePressed == thumbSizePressed &&
      other.thumbSizeTransition == thumbSizeTransition &&
      other.activeThumbColor == activeThumbColor &&
      other.inactiveThumbColor == inactiveThumbColor &&
      other.thumbPadding == thumbPadding &&
      other.disabledOpacity == disabledOpacity &&
      other.pressOverlayColor == pressOverlayColor &&
      other.pressOpacity == pressOpacity &&
      other.minTapTargetSize == minTapTargetSize &&
      other.stateLayerRadius == stateLayerRadius &&
      other.stateLayerColor == stateLayerColor &&
      other.thumbIcon == thumbIcon &&
      other.motion == motion;
}
```
:::

