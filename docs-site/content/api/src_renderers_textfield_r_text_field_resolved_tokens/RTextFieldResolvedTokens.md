---
title: "RTextFieldResolvedTokens"
description: "API documentation for RTextFieldResolvedTokens class from r_text_field_resolved_tokens"
category: "Classes"
library: "r_text_field_resolved_tokens"
outline: [2, 3]
---

# RTextFieldResolvedTokens <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RTextFieldResolvedTokens</span></div></div>

Resolved visual tokens for TextField rendering.

These are the final computed values that a renderer uses.
Token resolution flow: spec + states → resolver → tokens → renderer.

All fields are required to ensure preset interoperability.

## Constructors {#section-constructors}

### RTextFieldResolvedTokens() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rtextfieldresolvedtokens}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RTextFieldResolvedTokens</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">containerPadding</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">containerBackgroundColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">containerBorderColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">containerBorderRadius</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">containerBorderWidth</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">containerElevation</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">Duration</span> <span class="param">containerAnimationDuration</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">labelStyle</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">labelColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">helperStyle</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">helperColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">errorStyle</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">errorColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">messageSpacing</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">textStyle</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">textColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">placeholderStyle</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">placeholderColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">cursorColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">selectionColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">disabledOpacity</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">iconColor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">double</span> <span class="param">iconSpacing</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">minSize</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const RTextFieldResolvedTokens({
  &#47;&#47; Container
  required this.containerPadding,
  required this.containerBackgroundColor,
  required this.containerBorderColor,
  required this.containerBorderRadius,
  required this.containerBorderWidth,
  required this.containerElevation,
  required this.containerAnimationDuration,
  &#47;&#47; Label &#47; Helper &#47; Error
  required this.labelStyle,
  required this.labelColor,
  required this.helperStyle,
  required this.helperColor,
  required this.errorStyle,
  required this.errorColor,
  required this.messageSpacing,
  &#47;&#47; Input
  required this.textStyle,
  required this.textColor,
  required this.placeholderStyle,
  required this.placeholderColor,
  required this.cursorColor,
  required this.selectionColor,
  required this.disabledOpacity,
  &#47;&#47; Icons &#47; Slots
  required this.iconColor,
  required this.iconSpacing,
  &#47;&#47; Sizing
  required this.minSize,
});
```
:::

## Properties {#section-properties}

### containerAnimationDuration <span class="docs-badge docs-badge-tip">final</span> {#prop-containeranimationduration}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">Duration</span> <span class="fn">containerAnimationDuration</span></div></div>

:::details Implementation
```dart
final Duration containerAnimationDuration;
```
:::

### containerBackgroundColor <span class="docs-badge docs-badge-tip">final</span> {#prop-containerbackgroundcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">containerBackgroundColor</span></div></div>

:::details Implementation
```dart
final Color containerBackgroundColor;
```
:::

### containerBorderColor <span class="docs-badge docs-badge-tip">final</span> {#prop-containerbordercolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">containerBorderColor</span></div></div>

:::details Implementation
```dart
final Color containerBorderColor;
```
:::

### containerBorderRadius <span class="docs-badge docs-badge-tip">final</span> {#prop-containerborderradius}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">containerBorderRadius</span></div></div>

:::details Implementation
```dart
final BorderRadius containerBorderRadius;
```
:::

### containerBorderWidth <span class="docs-badge docs-badge-tip">final</span> {#prop-containerborderwidth}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span> <span class="fn">containerBorderWidth</span></div></div>

:::details Implementation
```dart
final double containerBorderWidth;
```
:::

### containerElevation <span class="docs-badge docs-badge-tip">final</span> {#prop-containerelevation}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span> <span class="fn">containerElevation</span></div></div>

:::details Implementation
```dart
final double containerElevation;
```
:::

### containerPadding <span class="docs-badge docs-badge-tip">final</span> {#prop-containerpadding}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">containerPadding</span></div></div>

:::details Implementation
```dart
final EdgeInsetsGeometry containerPadding;
```
:::

### cursorColor <span class="docs-badge docs-badge-tip">final</span> {#prop-cursorcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">cursorColor</span></div></div>

:::details Implementation
```dart
final Color cursorColor;
```
:::

### disabledOpacity <span class="docs-badge docs-badge-tip">final</span> {#prop-disabledopacity}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span> <span class="fn">disabledOpacity</span></div></div>

:::details Implementation
```dart
final double disabledOpacity;
```
:::

### errorColor <span class="docs-badge docs-badge-tip">final</span> {#prop-errorcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">errorColor</span></div></div>

:::details Implementation
```dart
final Color errorColor;
```
:::

### errorStyle <span class="docs-badge docs-badge-tip">final</span> {#prop-errorstyle}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">errorStyle</span></div></div>

:::details Implementation
```dart
final TextStyle errorStyle;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_renderers_textfield_r_text_field_resolved_tokens/RTextFieldResolvedTokens#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_renderers_textfield_r_text_field_resolved_tokens/RTextFieldResolvedTokens#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_renderers_textfield_r_text_field_resolved_tokens/RTextFieldResolvedTokens#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_renderers_textfield_r_text_field_resolved_tokens/RTextFieldResolvedTokens#operator-equals).
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

If a subclass overrides [hashCode](/api/src_renderers_textfield_r_text_field_resolved_tokens/RTextFieldResolvedTokens#prop-hashcode), it should override the
[operator ==](/api/src_renderers_textfield_r_text_field_resolved_tokens/RTextFieldResolvedTokens#operator-equals) operator as well to maintain consistency.

:::details Implementation
```dart
@override
int get hashCode => Object.hashAll([
      containerPadding,
      containerBackgroundColor,
      containerBorderColor,
      containerBorderRadius,
      containerBorderWidth,
      containerElevation,
      containerAnimationDuration,
      labelStyle,
      labelColor,
      helperStyle,
      helperColor,
      errorStyle,
      errorColor,
      messageSpacing,
      textStyle,
      textColor,
      placeholderStyle,
      placeholderColor,
      cursorColor,
      selectionColor,
      disabledOpacity,
      iconColor,
      iconSpacing,
      minSize,
    ]);
```
:::

### helperColor <span class="docs-badge docs-badge-tip">final</span> {#prop-helpercolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">helperColor</span></div></div>

:::details Implementation
```dart
final Color helperColor;
```
:::

### helperStyle <span class="docs-badge docs-badge-tip">final</span> {#prop-helperstyle}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">helperStyle</span></div></div>

:::details Implementation
```dart
final TextStyle helperStyle;
```
:::

### iconColor <span class="docs-badge docs-badge-tip">final</span> {#prop-iconcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">iconColor</span></div></div>

:::details Implementation
```dart
final Color iconColor;
```
:::

### iconSpacing <span class="docs-badge docs-badge-tip">final</span> {#prop-iconspacing}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span> <span class="fn">iconSpacing</span></div></div>

:::details Implementation
```dart
final double iconSpacing;
```
:::

### labelColor <span class="docs-badge docs-badge-tip">final</span> {#prop-labelcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">labelColor</span></div></div>

:::details Implementation
```dart
final Color labelColor;
```
:::

### labelStyle <span class="docs-badge docs-badge-tip">final</span> {#prop-labelstyle}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">labelStyle</span></div></div>

:::details Implementation
```dart
final TextStyle labelStyle;
```
:::

### messageSpacing <span class="docs-badge docs-badge-tip">final</span> {#prop-messagespacing}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span> <span class="fn">messageSpacing</span></div></div>

:::details Implementation
```dart
final double messageSpacing;
```
:::

### minSize <span class="docs-badge docs-badge-tip">final</span> {#prop-minsize}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">minSize</span></div></div>

:::details Implementation
```dart
final Size minSize;
```
:::

### placeholderColor <span class="docs-badge docs-badge-tip">final</span> {#prop-placeholdercolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">placeholderColor</span></div></div>

:::details Implementation
```dart
final Color placeholderColor;
```
:::

### placeholderStyle <span class="docs-badge docs-badge-tip">final</span> {#prop-placeholderstyle}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">placeholderStyle</span></div></div>

:::details Implementation
```dart
final TextStyle placeholderStyle;
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

### selectionColor <span class="docs-badge docs-badge-tip">final</span> {#prop-selectioncolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">selectionColor</span></div></div>

:::details Implementation
```dart
final Color selectionColor;
```
:::

### textColor <span class="docs-badge docs-badge-tip">final</span> {#prop-textcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">textColor</span></div></div>

:::details Implementation
```dart
final Color textColor;
```
:::

### textStyle <span class="docs-badge docs-badge-tip">final</span> {#prop-textstyle}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">textStyle</span></div></div>

:::details Implementation
```dart
final TextStyle textStyle;
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
the [hashCode](/api/src_renderers_textfield_r_text_field_resolved_tokens/RTextFieldResolvedTokens#prop-hashcode) method as well to maintain consistency.

:::details Implementation
```dart
@override
bool operator ==(Object other) {
  if (identical(this, other)) return true;
  return other is RTextFieldResolvedTokens &&
      other.containerPadding == containerPadding &&
      other.containerBackgroundColor == containerBackgroundColor &&
      other.containerBorderColor == containerBorderColor &&
      other.containerBorderRadius == containerBorderRadius &&
      other.containerBorderWidth == containerBorderWidth &&
      other.containerElevation == containerElevation &&
      other.containerAnimationDuration == containerAnimationDuration &&
      other.labelStyle == labelStyle &&
      other.labelColor == labelColor &&
      other.helperStyle == helperStyle &&
      other.helperColor == helperColor &&
      other.errorStyle == errorStyle &&
      other.errorColor == errorColor &&
      other.messageSpacing == messageSpacing &&
      other.textStyle == textStyle &&
      other.textColor == textColor &&
      other.placeholderStyle == placeholderStyle &&
      other.placeholderColor == placeholderColor &&
      other.cursorColor == cursorColor &&
      other.selectionColor == selectionColor &&
      other.disabledOpacity == disabledOpacity &&
      other.iconColor == iconColor &&
      other.iconSpacing == iconSpacing &&
      other.minSize == minSize;
}
```
:::

