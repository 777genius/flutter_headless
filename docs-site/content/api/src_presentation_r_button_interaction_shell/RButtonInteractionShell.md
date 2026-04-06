---
title: "RButtonInteractionShell"
description: "API documentation for RButtonInteractionShell class from r_button_interaction_shell"
category: "Classes"
library: "r_button_interaction_shell"
outline: [2, 3]
---

# RButtonInteractionShell

<div class="member-signature"><div class="member-signature-code"><span class="kw">class</span> <span class="fn">RButtonInteractionShell</span></div></div>

## Constructors {#section-constructors}

### RButtonInteractionShell() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rbuttoninteractionshell}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RButtonInteractionShell</span>({</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">key</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">context</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">isDisabled</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">String</span>? <span class="param">semanticLabel</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">controller</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">focusNode</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">autofocus</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">onActivate</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">visualEffects</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">child</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const RButtonInteractionShell({
  super.key,
  required this.context,
  required this.isDisabled,
  required this.semanticLabel,
  required this.controller,
  required this.focusNode,
  required this.autofocus,
  required this.onActivate,
  required this.visualEffects,
  required this.child,
});
```
:::

## Properties {#section-properties}

### autofocus <span class="docs-badge docs-badge-tip">final</span> {#prop-autofocus}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">autofocus</span></div></div>

:::details Implementation
```dart
final bool autofocus;
```
:::

### child <span class="docs-badge docs-badge-tip">final</span> {#prop-child}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">child</span></div></div>

:::details Implementation
```dart
final Widget child;
```
:::

### context <span class="docs-badge docs-badge-tip">final</span> {#prop-context}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">context</span></div></div>

:::details Implementation
```dart
final BuildContext context;
```
:::

### controller <span class="docs-badge docs-badge-tip">final</span> {#prop-controller}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">controller</span></div></div>

:::details Implementation
```dart
final HeadlessPressableController controller;
```
:::

### focusNode <span class="docs-badge docs-badge-tip">final</span> {#prop-focusnode}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">focusNode</span></div></div>

:::details Implementation
```dart
final FocusNode focusNode;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_presentation_r_button_interaction_shell/RButtonInteractionShell#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_presentation_r_button_interaction_shell/RButtonInteractionShell#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_presentation_r_button_interaction_shell/RButtonInteractionShell#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_presentation_r_button_interaction_shell/RButtonInteractionShell#operator-equals).
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

If a subclass overrides [hashCode](/api/src_presentation_r_button_interaction_shell/RButtonInteractionShell#prop-hashcode), it should override the
[operator ==](/api/src_presentation_r_button_interaction_shell/RButtonInteractionShell#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### isDisabled <span class="docs-badge docs-badge-tip">final</span> {#prop-isdisabled}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">isDisabled</span></div></div>

:::details Implementation
```dart
final bool isDisabled;
```
:::

### onActivate <span class="docs-badge docs-badge-tip">final</span> {#prop-onactivate}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">onActivate</span></div></div>

:::details Implementation
```dart
final VoidCallback onActivate;
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

### semanticLabel <span class="docs-badge docs-badge-tip">final</span> {#prop-semanticlabel}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span>? <span class="fn">semanticLabel</span></div></div>

:::details Implementation
```dart
final String? semanticLabel;
```
:::

### visualEffects <span class="docs-badge docs-badge-tip">final</span> {#prop-visualeffects}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">visualEffects</span></div></div>

:::details Implementation
```dart
final HeadlessPressableVisualEffectsController visualEffects;
```
:::

## Methods {#section-methods}

### build() {#build}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="fn">build</span>(<span class="type">dynamic</span> <span class="param">context</span>)</div></div>

:::details Implementation
```dart
@override
Widget build(BuildContext context) {
  final tapTargetSize = _resolveTapTargetSize(this.context);
  return Semantics(
    button: true,
    enabled: !isDisabled,
    label: semanticLabel,
    onTap: isDisabled ? null : onActivate,
    child: HeadlessPressableRegion(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      enabled: !isDisabled,
      cursorWhenEnabled: SystemMouseCursors.click,
      cursorWhenDisabled: SystemMouseCursors.forbidden,
      onActivate: onActivate,
      visualEffects: visualEffects,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: tapTargetSize.width,
          minHeight: tapTargetSize.height,
        ),
        child: Center(widthFactor: 1.0, heightFactor: 1.0, child: child),
      ),
    ),
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

