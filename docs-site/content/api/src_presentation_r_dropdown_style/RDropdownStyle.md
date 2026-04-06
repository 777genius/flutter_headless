---
title: "RDropdownStyle"
description: "API documentation for RDropdownStyle class from r_dropdown_style"
category: "Classes"
library: "r_dropdown_style"
outline: [2, 3]
---

# RDropdownStyle <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RDropdownStyle</span></div></div>

Simple, Flutter-like styling sugar for [RDropdownButton](/api/src_presentation_r_dropdown_button/RDropdownButton).

This type is NOT a new renderer contract.
It is a convenience layer that is internally converted to
`RenderOverrides.only(RDropdownOverrides.tokens(...))`.

Priority (strong -> weak):

1. `overrides: RenderOverrides(...)`
2. `style: RDropdownStyle(...)`
3. theme/preset defaults (token resolvers)

## Constructors {#section-constructors}

### RDropdownStyle() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rdropdownstyle}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RDropdownStyle</span>({</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerTextStyle</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerForegroundColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerBackgroundColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerBorderColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerPadding</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerMinSize</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">triggerRadius</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerBorderRadius</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerIconColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">menuBackgroundColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">menuBorderRadius</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">itemTextStyle</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const RDropdownStyle({
  this.triggerTextStyle,
  this.triggerForegroundColor,
  this.triggerBackgroundColor,
  this.triggerBorderColor,
  this.triggerPadding,
  this.triggerMinSize,
  this.triggerRadius,
  this.triggerBorderRadius,
  this.triggerIconColor,
  this.menuBackgroundColor,
  this.menuBorderRadius,
  this.itemTextStyle,
}) : assert(
        triggerRadius == null || triggerBorderRadius == null,
        'Provide either triggerRadius or triggerBorderRadius, not both.',
      );
```
:::

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_presentation_r_dropdown_style/RDropdownStyle#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_presentation_r_dropdown_style/RDropdownStyle#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_presentation_r_dropdown_style/RDropdownStyle#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_presentation_r_dropdown_style/RDropdownStyle#operator-equals).
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

If a subclass overrides [hashCode](/api/src_presentation_r_dropdown_style/RDropdownStyle#prop-hashcode), it should override the
[operator ==](/api/src_presentation_r_dropdown_style/RDropdownStyle#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### itemTextStyle <span class="docs-badge docs-badge-tip">final</span> {#prop-itemtextstyle}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">itemTextStyle</span></div></div>

:::details Implementation
```dart
final TextStyle? itemTextStyle;
```
:::

### menuBackgroundColor <span class="docs-badge docs-badge-tip">final</span> {#prop-menubackgroundcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">menuBackgroundColor</span></div></div>

:::details Implementation
```dart
final Color? menuBackgroundColor;
```
:::

### menuBorderRadius <span class="docs-badge docs-badge-tip">final</span> {#prop-menuborderradius}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">menuBorderRadius</span></div></div>

:::details Implementation
```dart
final BorderRadius? menuBorderRadius;
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

### triggerBackgroundColor <span class="docs-badge docs-badge-tip">final</span> {#prop-triggerbackgroundcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">triggerBackgroundColor</span></div></div>

:::details Implementation
```dart
final Color? triggerBackgroundColor;
```
:::

### triggerBorderColor <span class="docs-badge docs-badge-tip">final</span> {#prop-triggerbordercolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">triggerBorderColor</span></div></div>

:::details Implementation
```dart
final Color? triggerBorderColor;
```
:::

### triggerBorderRadius <span class="docs-badge docs-badge-tip">final</span> {#prop-triggerborderradius}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">triggerBorderRadius</span></div></div>

:::details Implementation
```dart
final BorderRadius? triggerBorderRadius;
```
:::

### triggerForegroundColor <span class="docs-badge docs-badge-tip">final</span> {#prop-triggerforegroundcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">triggerForegroundColor</span></div></div>

:::details Implementation
```dart
final Color? triggerForegroundColor;
```
:::

### triggerIconColor <span class="docs-badge docs-badge-tip">final</span> {#prop-triggericoncolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">triggerIconColor</span></div></div>

:::details Implementation
```dart
final Color? triggerIconColor;
```
:::

### triggerMinSize <span class="docs-badge docs-badge-tip">final</span> {#prop-triggerminsize}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">triggerMinSize</span></div></div>

:::details Implementation
```dart
final Size? triggerMinSize;
```
:::

### triggerPadding <span class="docs-badge docs-badge-tip">final</span> {#prop-triggerpadding}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">triggerPadding</span></div></div>

:::details Implementation
```dart
final EdgeInsetsGeometry? triggerPadding;
```
:::

### triggerRadius <span class="docs-badge docs-badge-tip">final</span> {#prop-triggerradius}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span>? <span class="fn">triggerRadius</span></div></div>

:::details Implementation
```dart
final double? triggerRadius;
```
:::

### triggerTextStyle <span class="docs-badge docs-badge-tip">final</span> {#prop-triggertextstyle}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">triggerTextStyle</span></div></div>

:::details Implementation
```dart
final TextStyle? triggerTextStyle;
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

### toOverrides() {#tooverrides}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="fn">toOverrides</span>()</div></div>

:::details Implementation
```dart
RDropdownOverrides toOverrides() {
  final resolvedTriggerRadius = triggerBorderRadius ??
      (triggerRadius == null
          ? null
          : BorderRadius.all(Radius.circular(triggerRadius!)));

  return RDropdownOverrides.tokens(
    triggerTextStyle: triggerTextStyle,
    triggerForegroundColor: triggerForegroundColor,
    triggerBackgroundColor: triggerBackgroundColor,
    triggerBorderColor: triggerBorderColor,
    triggerPadding: triggerPadding,
    triggerMinSize: triggerMinSize,
    triggerBorderRadius: resolvedTriggerRadius,
    triggerIconColor: triggerIconColor,
    menuBackgroundColor: menuBackgroundColor,
    menuBorderRadius: menuBorderRadius,
    itemTextStyle: itemTextStyle,
  );
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

