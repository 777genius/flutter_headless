---
title: "RTextFieldState"
description: "API documentation for RTextFieldState class from r_text_field_renderer"
category: "Classes"
library: "r_text_field_renderer"
outline: [2, 3]
---

# RTextFieldState <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RTextFieldState</span></div></div>

TextField interaction state.

Derived from component's internal state, exposed as simple flags
for renderer convenience.

## Constructors {#section-constructors}

### RTextFieldState() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rtextfieldstate}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RTextFieldState</span>({</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">isFocused</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">isHovered</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">isDisabled</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">isReadOnly</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">hasText</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">isError</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">isObscured</span> = <span class="kw">false</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const RTextFieldState({
  this.isFocused = false,
  this.isHovered = false,
  this.isDisabled = false,
  this.isReadOnly = false,
  this.hasText = false,
  this.isError = false,
  this.isObscured = false,
});
```
:::

### RTextFieldState.fromWidgetStates() <span class="docs-badge docs-badge-tip">factory</span> {#fromwidgetstates}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">factory</span> <span class="fn">RTextFieldState.fromWidgetStates</span>(</span><span class="member-signature-line">  <span class="type">Set</span>&lt;<span class="type">dynamic</span>&gt; <span class="param">states</span>, {</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">hasText</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">isError</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">isObscured</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">isReadOnly</span> = <span class="kw">false</span>,</span><span class="member-signature-line">})</span></div></div>

Create state from Flutter's WidgetState set + text field specifics.

:::details Implementation
```dart
factory RTextFieldState.fromWidgetStates(
  Set<WidgetState> states, {
  bool hasText = false,
  bool isError = false,
  bool isObscured = false,
  bool isReadOnly = false,
}) {
  final decoded = WidgetStateHelper.fromWidgetStates(states);
  return RTextFieldState(
    isFocused: decoded.isFocused,
    isHovered: decoded.isHovered,
    isDisabled: decoded.isDisabled,
    isReadOnly: isReadOnly,
    hasText: hasText,
    isError: isError,
    isObscured: isObscured,
  );
}
```
:::

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldState#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldState#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldState#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldState#operator-equals).
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

If a subclass overrides [hashCode](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldState#prop-hashcode), it should override the
[operator ==](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldState#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### hasText <span class="docs-badge docs-badge-tip">final</span> {#prop-hastext}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">hasText</span></div></div>

Whether the field contains text.

Used for floating label behavior.

:::details Implementation
```dart
final bool hasText;
```
:::

### isDisabled <span class="docs-badge docs-badge-tip">final</span> {#prop-isdisabled}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">isDisabled</span></div></div>

Whether the field is disabled.

:::details Implementation
```dart
final bool isDisabled;
```
:::

### isError <span class="docs-badge docs-badge-tip">final</span> {#prop-iserror}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">isError</span></div></div>

Whether the field has an error.

Derived from errorText presence in spec.

:::details Implementation
```dart
final bool isError;
```
:::

### isFocused <span class="docs-badge docs-badge-tip">final</span> {#prop-isfocused}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">isFocused</span></div></div>

Whether the field has keyboard focus.

:::details Implementation
```dart
final bool isFocused;
```
:::

### isHovered <span class="docs-badge docs-badge-tip">final</span> {#prop-ishovered}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">isHovered</span></div></div>

Whether the pointer is hovering over the field.

:::details Implementation
```dart
final bool isHovered;
```
:::

### isObscured <span class="docs-badge docs-badge-tip">final</span> {#prop-isobscured}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">isObscured</span></div></div>

Whether the text is obscured (password mode).

:::details Implementation
```dart
final bool isObscured;
```
:::

### isReadOnly <span class="docs-badge docs-badge-tip">final</span> {#prop-isreadonly}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">isReadOnly</span></div></div>

Whether the field is read-only.

:::details Implementation
```dart
final bool isReadOnly;
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

### toWidgetStates() {#towidgetstates}

<div class="member-signature"><div class="member-signature-code"><span class="type">Set</span>&lt;<span class="type">dynamic</span>&gt; <span class="fn">toWidgetStates</span>()</div></div>

Convert to Flutter's WidgetState set.

:::details Implementation
```dart
Set<WidgetState> toWidgetStates() {
  return WidgetStateHelper.toWidgetStates(
    isFocused: isFocused,
    isHovered: isHovered,
    isDisabled: isDisabled,
    isError: isError,
  );
}
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

