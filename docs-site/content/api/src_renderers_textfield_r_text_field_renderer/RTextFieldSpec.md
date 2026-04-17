---
title: "RTextFieldSpec"
description: "API documentation for RTextFieldSpec class from r_text_field_renderer"
category: "Classes"
library: "r_text_field_renderer"
outline: [2, 3]
---

# RTextFieldSpec <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RTextFieldSpec</span></div></div>

TextField specification (static, from widget props).

Contains text content metadata and display options.
This is the "what" of the field (not the "how" — that's the renderer).

## Constructors {#section-constructors}

### RTextFieldSpec() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rtextfieldspec}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RTextFieldSpec</span>({</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">placeholder</span>,</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">label</span>,</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">helperText</span>,</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">errorText</span>,</span><span class="member-signature-line">  <a href="/api/src_renderers_textfield_r_text_field_renderer/RTextFieldVariant" class="type-link">RTextFieldVariant</a> <span class="param">variant</span> = RTextFieldVariant.filled,</span><span class="member-signature-line">  <span class="type">int</span>? <span class="param">maxLines</span> = <span class="num-lit">1</span>,</span><span class="member-signature-line">  <span class="type">int</span>? <span class="param">minLines</span>,</span><span class="member-signature-line">  <a href="/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode" class="type-link">RTextFieldOverlayVisibilityMode</a> <span class="param">clearButtonMode</span> = RTextFieldOverlayVisibilityMode.never,</span><span class="member-signature-line">  <a href="/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode" class="type-link">RTextFieldOverlayVisibilityMode</a> <span class="param">prefixMode</span> = RTextFieldOverlayVisibilityMode.always,</span><span class="member-signature-line">  <a href="/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode" class="type-link">RTextFieldOverlayVisibilityMode</a> <span class="param">suffixMode</span> = RTextFieldOverlayVisibilityMode.always,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const RTextFieldSpec({
  this.placeholder,
  this.label,
  this.helperText,
  this.errorText,
  this.variant = RTextFieldVariant.filled,
  this.maxLines = 1,
  this.minLines,
  this.clearButtonMode = RTextFieldOverlayVisibilityMode.never,
  this.prefixMode = RTextFieldOverlayVisibilityMode.always,
  this.suffixMode = RTextFieldOverlayVisibilityMode.always,
});
```
:::

## Properties {#section-properties}

### clearButtonMode <span class="docs-badge docs-badge-tip">final</span> {#prop-clearbuttonmode}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode" class="type-link">RTextFieldOverlayVisibilityMode</a> <span class="fn">clearButtonMode</span></div></div>

Visibility mode for the clear button.

Defaults to [RTextFieldOverlayVisibilityMode.never](/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode#value-never).
Cupertino typically uses [RTextFieldOverlayVisibilityMode.whileEditing](/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode#value-whileediting).

:::details Implementation
```dart
final RTextFieldOverlayVisibilityMode clearButtonMode;
```
:::

### errorText <span class="docs-badge docs-badge-tip">final</span> {#prop-errortext}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span>? <span class="fn">errorText</span></div></div>

Error text (shown below field, replaces helper when set).

:::details Implementation
```dart
final String? errorText;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldSpec#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldSpec#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldSpec#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldSpec#operator-equals).
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

If a subclass overrides [hashCode](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldSpec#prop-hashcode), it should override the
[operator ==](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldSpec#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### helperText <span class="docs-badge docs-badge-tip">final</span> {#prop-helpertext}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span>? <span class="fn">helperText</span></div></div>

Helper text (shown below field).

:::details Implementation
```dart
final String? helperText;
```
:::

### isMultiline <span class="docs-badge docs-badge-tip">no setter</span> {#prop-ismultiline}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isMultiline</span></div></div>

Whether this is a multiline field.

:::details Implementation
```dart
bool get isMultiline => maxLines == null || maxLines! > 1;
```
:::

### label <span class="docs-badge docs-badge-tip">final</span> {#prop-label}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span>? <span class="fn">label</span></div></div>

Label text (shown above or floating).

:::details Implementation
```dart
final String? label;
```
:::

### maxLines <span class="docs-badge docs-badge-tip">final</span> {#prop-maxlines}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">int</span>? <span class="fn">maxLines</span></div></div>

Maximum number of lines.

Defaults to 1 (single-line). Set to null for unlimited.

:::details Implementation
```dart
final int? maxLines;
```
:::

### minLines <span class="docs-badge docs-badge-tip">final</span> {#prop-minlines}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">int</span>? <span class="fn">minLines</span></div></div>

Minimum number of lines.

Only meaningful for multiline fields.

:::details Implementation
```dart
final int? minLines;
```
:::

### placeholder <span class="docs-badge docs-badge-tip">final</span> {#prop-placeholder}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span>? <span class="fn">placeholder</span></div></div>

Placeholder text shown when field is empty.

:::details Implementation
```dart
final String? placeholder;
```
:::

### prefixMode <span class="docs-badge docs-badge-tip">final</span> {#prop-prefixmode}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode" class="type-link">RTextFieldOverlayVisibilityMode</a> <span class="fn">prefixMode</span></div></div>

Visibility mode for the prefix widget.

Defaults to [RTextFieldOverlayVisibilityMode.always](/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode#value-always).

:::details Implementation
```dart
final RTextFieldOverlayVisibilityMode prefixMode;
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

### suffixMode <span class="docs-badge docs-badge-tip">final</span> {#prop-suffixmode}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode" class="type-link">RTextFieldOverlayVisibilityMode</a> <span class="fn">suffixMode</span></div></div>

Visibility mode for the suffix widget.

Defaults to [RTextFieldOverlayVisibilityMode.always](/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode#value-always).

:::details Implementation
```dart
final RTextFieldOverlayVisibilityMode suffixMode;
```
:::

### variant <span class="docs-badge docs-badge-tip">final</span> {#prop-variant}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_textfield_r_text_field_renderer/RTextFieldVariant" class="type-link">RTextFieldVariant</a> <span class="fn">variant</span></div></div>

Visual variant of the field.

This is an intent. Each preset (Material/Cupertino/...) maps it to
platform-specific visuals.

:::details Implementation
```dart
final RTextFieldVariant variant;
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

