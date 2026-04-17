---
title: "RTextButton"
description: "API documentation for RTextButton class from r_text_button"
category: "Classes"
library: "r_text_button"
outline: [2, 3]
---

# RTextButton

<div class="member-signature"><div class="member-signature-code"><span class="kw">class</span> <span class="fn">RTextButton</span></div></div>

A headless text button component.

This widget handles all button behavior (focus, keyboard, pointer input)
but delegates visual rendering to a [RButtonRenderer](/api/src_renderers_button_r_button_renderer/RButtonRenderer) capability.

The renderer is obtained from [HeadlessThemeProvider](/api/src_theme_headless_theme_provider/HeadlessThemeProvider). If no renderer
is available, a `MissingCapabilityException` is thrown with clear
instructions on how to fix it.

## Controlled/Uncontrolled {#controlleduncontrolled}

The button follows Flutter's standard patterns:

- `onPressed == null` or `disabled == true` → button is disabled
- Disabled state is reflected in semantics and prevents all interaction

## Keyboard {#keyboard}

- Space: triggers onPressed on key up (standard button behavior)
- Enter: triggers onPressed immediately (activation)

## Activation Source (v1 policy) {#activation-source-v1-policy}

The button has a single activation source: `GestureDetector` for pointer
and `Focus.onKeyEvent` for keyboard.

Accessibility activation is component-owned as well:
the widget exposes `SemanticsAction.tap` and maps it to [onPressed](/api/src_presentation_r_text_button/RTextButton#prop-onpressed).

## Example {#example}

```dart
RTextButton(
  onPressed: () => print('Pressed!'),
  child: Text('Click me'),
)
```

## Constructors {#section-constructors}

### RTextButton() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rtextbutton}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RTextButton</span>({</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">key</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">child</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">onPressed</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">disabled</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">variant</span> = RButtonVariant.outlined,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">size</span> = RButtonSize.medium,</span><span class="member-signature-line">  <a href="/api/src_presentation_r_button_style/RButtonStyle" class="type-link">RButtonStyle</a>? <span class="param">style</span>,</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">semanticLabel</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">autofocus</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">focusNode</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">slots</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">overrides</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const RTextButton({
  super.key,
  required this.child,
  this.onPressed,
  this.disabled = false,
  this.variant = RButtonVariant.outlined,
  this.size = RButtonSize.medium,
  this.style,
  this.semanticLabel,
  this.autofocus = false,
  this.focusNode,
  this.slots,
  this.overrides,
});
```
:::

## Properties {#section-properties}

### autofocus <span class="docs-badge docs-badge-tip">final</span> {#prop-autofocus}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">autofocus</span></div></div>

Whether the button should be focused initially.

:::details Implementation
```dart
final bool autofocus;
```
:::

### child <span class="docs-badge docs-badge-tip">final</span> {#prop-child}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">child</span></div></div>

The button's content (typically a Text widget).

:::details Implementation
```dart
final Widget child;
```
:::

### disabled <span class="docs-badge docs-badge-tip">final</span> {#prop-disabled}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">disabled</span></div></div>

Whether the button is explicitly disabled.

When true, the button will not respond to input even if [onPressed](/api/src_presentation_r_text_button/RTextButton#prop-onpressed)
is provided.

:::details Implementation
```dart
final bool disabled;
```
:::

### focusNode <span class="docs-badge docs-badge-tip">final</span> {#prop-focusnode}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">focusNode</span></div></div>

Optional focus node for external focus management.

:::details Implementation
```dart
final FocusNode? focusNode;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_presentation_r_text_button/RTextButton#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_presentation_r_text_button/RTextButton#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_presentation_r_text_button/RTextButton#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_presentation_r_text_button/RTextButton#operator-equals).
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

If a subclass overrides [hashCode](/api/src_presentation_r_text_button/RTextButton#prop-hashcode), it should override the
[operator ==](/api/src_presentation_r_text_button/RTextButton#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### isDisabled <span class="docs-badge docs-badge-tip">no setter</span> {#prop-isdisabled}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isDisabled</span></div></div>

Whether the button is effectively disabled.

A button is disabled if [disabled](/api/src_presentation_r_text_button/RTextButton#prop-disabled) is true OR [onPressed](/api/src_presentation_r_text_button/RTextButton#prop-onpressed) is null.

:::details Implementation
```dart
bool get isDisabled => disabled || onPressed == null;
```
:::

### onPressed <span class="docs-badge docs-badge-tip">final</span> {#prop-onpressed}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">onPressed</span></div></div>

Called when the button is activated.

If null, the button is considered disabled.

:::details Implementation
```dart
final VoidCallback? onPressed;
```
:::

### overrides <span class="docs-badge docs-badge-tip">final</span> {#prop-overrides}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">overrides</span></div></div>

Per-instance override bag for preset customization.

Allows "style on this specific button" without API pollution.
See `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`.

:::details Implementation
```dart
final RenderOverrides? overrides;
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

Semantic label for accessibility.

If not provided, the button's child text content is used.

:::details Implementation
```dart
final String? semanticLabel;
```
:::

### size <span class="docs-badge docs-badge-tip">final</span> {#prop-size}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">size</span></div></div>

Size variant of the button.

:::details Implementation
```dart
final RButtonSize size;
```
:::

### slots <span class="docs-badge docs-badge-tip">final</span> {#prop-slots}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">slots</span></div></div>

Optional visual slots for partial customization.

:::details Implementation
```dart
final RButtonSlots? slots;
```
:::

### style <span class="docs-badge docs-badge-tip">final</span> {#prop-style}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_presentation_r_button_style/RButtonStyle" class="type-link">RButtonStyle</a>? <span class="fn">style</span></div></div>

Simple, Flutter-like styling sugar.

Internally converted to `RenderOverrides.only(RButtonOverrides.tokens(...))`.
If [overrides](/api/src_presentation_r_text_button/RTextButton#prop-overrides) is provided, it takes precedence over this style.

:::details Implementation
```dart
final RButtonStyle? style;
```
:::

### variant <span class="docs-badge docs-badge-tip">final</span> {#prop-variant}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">variant</span></div></div>

Visual variant of the button.

:::details Implementation
```dart
final RButtonVariant variant;
```
:::

## Methods {#section-methods}

### createState() {#createstate}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="fn">createState</span>()</div></div>

:::details Implementation
```dart
@override
State<RTextButton> createState() => _RTextButtonState();
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

