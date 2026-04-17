---
title: "MaterialSwitchTrackAndThumb"
description: "API documentation for MaterialSwitchTrackAndThumb class from material_switch_track_and_thumb"
category: "Classes"
library: "material_switch_track_and_thumb"
outline: [2, 3]
---

# MaterialSwitchTrackAndThumb <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">MaterialSwitchTrackAndThumb</span></div></div>

Internal widget that renders the track + thumb (with animations) and provides
the thumb center for state-layer positioning.

## Constructors {#section-constructors}

### MaterialSwitchTrackAndThumb() <span class="docs-badge docs-badge-tip">const</span> {#ctor-materialswitchtrackandthumb}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">MaterialSwitchTrackAndThumb</span>({</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">key</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">tokens</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">trackColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">outlineColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">outlineWidth</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">thumbColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">thumbIcon</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">thumbIconColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">hasIcon</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">isDragging</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">isPressed</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">isRtl</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">visualValue</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span>? <span class="param">dragT</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">Duration</span> <span class="param">animationDuration</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">Duration</span> <span class="param">thumbToggleDuration</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">stateLayerColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">showStateLayer</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">slots</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">spec</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">state</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const MaterialSwitchTrackAndThumb({
  super.key,
  required this.tokens,
  required this.trackColor,
  required this.outlineColor,
  required this.outlineWidth,
  required this.thumbColor,
  required this.thumbIcon,
  required this.thumbIconColor,
  required this.hasIcon,
  required this.isDragging,
  required this.isPressed,
  required this.isRtl,
  required this.visualValue,
  required this.dragT,
  required this.animationDuration,
  required this.thumbToggleDuration,
  required this.stateLayerColor,
  required this.showStateLayer,
  required this.slots,
  required this.spec,
  required this.state,
});
```
:::

## Properties {#section-properties}

### animationDuration <span class="docs-badge docs-badge-tip">final</span> {#prop-animationduration}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">Duration</span> <span class="fn">animationDuration</span></div></div>

:::details Implementation
```dart
final Duration animationDuration;
```
:::

### dragT <span class="docs-badge docs-badge-tip">final</span> {#prop-dragt}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span>? <span class="fn">dragT</span></div></div>

:::details Implementation
```dart
final double? dragT;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_switch_material_switch_track_and_thumb/MaterialSwitchTrackAndThumb#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_switch_material_switch_track_and_thumb/MaterialSwitchTrackAndThumb#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_switch_material_switch_track_and_thumb/MaterialSwitchTrackAndThumb#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_switch_material_switch_track_and_thumb/MaterialSwitchTrackAndThumb#operator-equals).
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

If a subclass overrides [hashCode](/api/src_switch_material_switch_track_and_thumb/MaterialSwitchTrackAndThumb#prop-hashcode), it should override the
[operator ==](/api/src_switch_material_switch_track_and_thumb/MaterialSwitchTrackAndThumb#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### hasIcon <span class="docs-badge docs-badge-tip">final</span> {#prop-hasicon}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">hasIcon</span></div></div>

:::details Implementation
```dart
final bool hasIcon;
```
:::

### isDragging <span class="docs-badge docs-badge-tip">final</span> {#prop-isdragging}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">isDragging</span></div></div>

:::details Implementation
```dart
final bool isDragging;
```
:::

### isPressed <span class="docs-badge docs-badge-tip">final</span> {#prop-ispressed}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">isPressed</span></div></div>

:::details Implementation
```dart
final bool isPressed;
```
:::

### isRtl <span class="docs-badge docs-badge-tip">final</span> {#prop-isrtl}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">isRtl</span></div></div>

:::details Implementation
```dart
final bool isRtl;
```
:::

### outlineColor <span class="docs-badge docs-badge-tip">final</span> {#prop-outlinecolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">outlineColor</span></div></div>

:::details Implementation
```dart
final Color outlineColor;
```
:::

### outlineWidth <span class="docs-badge docs-badge-tip">final</span> {#prop-outlinewidth}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span> <span class="fn">outlineWidth</span></div></div>

:::details Implementation
```dart
final double outlineWidth;
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

### showStateLayer <span class="docs-badge docs-badge-tip">final</span> {#prop-showstatelayer}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">showStateLayer</span></div></div>

:::details Implementation
```dart
final bool showStateLayer;
```
:::

### slots <span class="docs-badge docs-badge-tip">final</span> {#prop-slots}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">slots</span></div></div>

:::details Implementation
```dart
final RSwitchSlots? slots;
```
:::

### spec <span class="docs-badge docs-badge-tip">final</span> {#prop-spec}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">spec</span></div></div>

:::details Implementation
```dart
final RSwitchSpec spec;
```
:::

### state <span class="docs-badge docs-badge-tip">final</span> {#prop-state}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">state</span></div></div>

:::details Implementation
```dart
final RSwitchState state;
```
:::

### stateLayerColor <span class="docs-badge docs-badge-tip">final</span> {#prop-statelayercolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">stateLayerColor</span></div></div>

:::details Implementation
```dart
final Color? stateLayerColor;
```
:::

### thumbColor <span class="docs-badge docs-badge-tip">final</span> {#prop-thumbcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">thumbColor</span></div></div>

:::details Implementation
```dart
final Color thumbColor;
```
:::

### thumbIcon <span class="docs-badge docs-badge-tip">final</span> {#prop-thumbicon}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">thumbIcon</span></div></div>

:::details Implementation
```dart
final Widget? thumbIcon;
```
:::

### thumbIconColor <span class="docs-badge docs-badge-tip">final</span> {#prop-thumbiconcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">thumbIconColor</span></div></div>

:::details Implementation
```dart
final Color thumbIconColor;
```
:::

### thumbToggleDuration <span class="docs-badge docs-badge-tip">final</span> {#prop-thumbtoggleduration}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">Duration</span> <span class="fn">thumbToggleDuration</span></div></div>

:::details Implementation
```dart
final Duration thumbToggleDuration;
```
:::

### tokens <span class="docs-badge docs-badge-tip">final</span> {#prop-tokens}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">tokens</span></div></div>

:::details Implementation
```dart
final RSwitchResolvedTokens tokens;
```
:::

### trackColor <span class="docs-badge docs-badge-tip">final</span> {#prop-trackcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">trackColor</span></div></div>

:::details Implementation
```dart
final Color trackColor;
```
:::

### visualValue <span class="docs-badge docs-badge-tip">final</span> {#prop-visualvalue}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">visualValue</span></div></div>

:::details Implementation
```dart
final bool visualValue;
```
:::

## Methods {#section-methods}

### createState() {#createstate}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="fn">createState</span>()</div></div>

:::details Implementation
```dart
@override
State<MaterialSwitchTrackAndThumb> createState() =>
    _MaterialSwitchTrackAndThumbState();
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

