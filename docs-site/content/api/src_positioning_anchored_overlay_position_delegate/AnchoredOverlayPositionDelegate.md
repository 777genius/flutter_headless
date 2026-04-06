---
title: "AnchoredOverlayPositionDelegate"
description: "API documentation for AnchoredOverlayPositionDelegate class from anchored_overlay_position_delegate"
category: "Classes"
library: "anchored_overlay_position_delegate"
outline: [2, 3]
---

# AnchoredOverlayPositionDelegate <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">AnchoredOverlayPositionDelegate</span></div></div>

Простое позиционирование overlay относительно anchor rect с учетом viewport.

Цель: стабильное поведение и корректный hit-testing (в отличие от layer-based
follower), чтобы и в тестах, и в runtime позиция была одинаковой.

## Constructors {#section-constructors}

### AnchoredOverlayPositionDelegate() {#ctor-anchoredoverlaypositiondelegate}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="fn">AnchoredOverlayPositionDelegate</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">viewportRect</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">anchorRect</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">preferredWidth</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">padding</span> = <span class="kw">const</span> EdgeInsets.all(<span class="num-lit">8</span>),</span><span class="member-signature-line">  <span class="type">double</span> <span class="param">minSpaceToPreferBelow</span> = <span class="num-lit">150.0</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
AnchoredOverlayPositionDelegate({
  required this.viewportRect,
  required this.anchorRect,
  required this.preferredWidth,
  this.padding = const EdgeInsets.all(8),
  this.minSpaceToPreferBelow = 150.0,
});
```
:::

## Properties {#section-properties}

### anchorRect <span class="docs-badge docs-badge-tip">final</span> {#prop-anchorrect}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">anchorRect</span></div></div>

:::details Implementation
```dart
final Rect anchorRect;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_positioning_anchored_overlay_position_delegate/AnchoredOverlayPositionDelegate#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_positioning_anchored_overlay_position_delegate/AnchoredOverlayPositionDelegate#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_positioning_anchored_overlay_position_delegate/AnchoredOverlayPositionDelegate#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_positioning_anchored_overlay_position_delegate/AnchoredOverlayPositionDelegate#operator-equals).
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

If a subclass overrides [hashCode](/api/src_positioning_anchored_overlay_position_delegate/AnchoredOverlayPositionDelegate#prop-hashcode), it should override the
[operator ==](/api/src_positioning_anchored_overlay_position_delegate/AnchoredOverlayPositionDelegate#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### minSpaceToPreferBelow <span class="docs-badge docs-badge-tip">final</span> {#prop-minspacetopreferbelow}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span> <span class="fn">minSpaceToPreferBelow</span></div></div>

:::details Implementation
```dart
final double minSpaceToPreferBelow;
```
:::

### padding <span class="docs-badge docs-badge-tip">final</span> {#prop-padding}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">padding</span></div></div>

:::details Implementation
```dart
final EdgeInsets padding;
```
:::

### preferredWidth <span class="docs-badge docs-badge-tip">final</span> {#prop-preferredwidth}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span> <span class="fn">preferredWidth</span></div></div>

:::details Implementation
```dart
final double preferredWidth;
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

### viewportRect <span class="docs-badge docs-badge-tip">final</span> {#prop-viewportrect}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">viewportRect</span></div></div>

:::details Implementation
```dart
final Rect viewportRect;
```
:::

## Methods {#section-methods}

### getConstraintsForChild() {#getconstraintsforchild}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="fn">getConstraintsForChild</span>(<span class="type">dynamic</span> <span class="param">constraints</span>)</div></div>

:::details Implementation
```dart
@override
BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
  final leftBound = viewportRect.left + padding.left;
  final rightBound = viewportRect.right - padding.right;
  final topBound = viewportRect.top + padding.top;
  final bottomBound = viewportRect.bottom - padding.bottom;

  final maxWidth = (rightBound - leftBound).clamp(0.0, double.infinity);

  final spaceBelow =
      (bottomBound - anchorRect.bottom).clamp(0.0, double.infinity);
  final spaceAbove = (anchorRect.top - topBound).clamp(0.0, double.infinity);

  final shouldFlip =
      spaceBelow < minSpaceToPreferBelow && spaceAbove > spaceBelow;
  final maxHeight =
      (shouldFlip ? spaceAbove : spaceBelow).clamp(0.0, double.infinity);

  return BoxConstraints(
    minWidth: 0,
    maxWidth: maxWidth,
    minHeight: 0,
    maxHeight: maxHeight,
  );
}
```
:::

### getPositionForChild() {#getpositionforchild}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="fn">getPositionForChild</span>(<span class="type">dynamic</span> <span class="param">size</span>, <span class="type">dynamic</span> <span class="param">childSize</span>)</div></div>

:::details Implementation
```dart
@override
Offset getPositionForChild(Size size, Size childSize) {
  final leftBound = viewportRect.left + padding.left;
  final rightBound = viewportRect.right - padding.right;
  final topBound = viewportRect.top + padding.top;
  final bottomBound = viewportRect.bottom - padding.bottom;

  final width = childSize.width;
  final height = childSize.height;

  &#47;&#47; Horizontal: align to anchor left, then shift into bounds.
  var dx = anchorRect.left;
  if (dx + width > rightBound) dx = rightBound - width;
  if (dx < leftBound) dx = leftBound;

  final spaceBelow =
      (bottomBound - anchorRect.bottom).clamp(0.0, double.infinity);
  final spaceAbove = (anchorRect.top - topBound).clamp(0.0, double.infinity);
  final shouldFlip =
      spaceBelow < minSpaceToPreferBelow && spaceAbove > spaceBelow;

  &#47;&#47; Vertical: place below by default; flip above when needed; then clamp.
  var dy = shouldFlip ? (anchorRect.top - height) : anchorRect.bottom;
  if (dy + height > bottomBound) dy = bottomBound - height;
  if (dy < topBound) dy = topBound;

  return Offset(dx - viewportRect.left, dy - viewportRect.top);
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

### shouldRelayout() {#shouldrelayout}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="fn">shouldRelayout</span>(<a href="/api/src_positioning_anchored_overlay_position_delegate/AnchoredOverlayPositionDelegate" class="type-link">AnchoredOverlayPositionDelegate</a> <span class="param">oldDelegate</span>)</div></div>

:::details Implementation
```dart
@override
bool shouldRelayout(covariant AnchoredOverlayPositionDelegate oldDelegate) {
  return oldDelegate.viewportRect != viewportRect ||
      oldDelegate.anchorRect != anchorRect ||
      oldDelegate.preferredWidth != preferredWidth ||
      oldDelegate.padding != padding ||
      oldDelegate.minSpaceToPreferBelow != minSpaceToPreferBelow;
}
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

