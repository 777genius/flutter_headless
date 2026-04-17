---
title: "RCheckboxListTile"
description: "API documentation for RCheckboxListTile class from r_checkbox_list_tile"
category: "Classes"
library: "r_checkbox_list_tile"
outline: [2, 3]
---

# RCheckboxListTile

<div class="member-signature"><div class="member-signature-code"><span class="kw">class</span> <span class="fn">RCheckboxListTile</span></div></div>

A headless checkbox list tile component.

Single activation source: the whole row handles input and toggles value.

## Constructors {#section-constructors}

### RCheckboxListTile() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rcheckboxlisttile}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RCheckboxListTile</span>({</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">key</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span>? <span class="param">value</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">onChanged</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">title</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">subtitle</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">secondary</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">tristate</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">controlAffinity</span> = RCheckboxControlAffinity.platform,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">dense</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">isThreeLine</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">selected</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">selectedColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">contentPadding</span>,</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">semanticLabel</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">isError</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">focusNode</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">autofocus</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">mouseCursor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">textDirection</span>,</span><span class="member-signature-line">  <a href="/api/src_presentation_r_checkbox_list_tile_style/RCheckboxListTileStyle" class="type-link">RCheckboxListTileStyle</a>? <span class="param">style</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">slots</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">overrides</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const RCheckboxListTile({
  super.key,
  required this.value,
  required this.onChanged,
  required this.title,
  this.subtitle,
  this.secondary,
  this.tristate = false,
  this.controlAffinity = RCheckboxControlAffinity.platform,
  this.dense = false,
  this.isThreeLine = false,
  this.selected = false,
  this.selectedColor,
  this.contentPadding,
  this.semanticLabel,
  this.isError = false,
  this.focusNode,
  this.autofocus = false,
  this.mouseCursor,
  this.textDirection,
  this.style,
  this.slots,
  this.overrides,
})  : assert(
        tristate || value != null,
        'If tristate is false, value must be non-null.',
      ),
      assert(
        !isThreeLine || subtitle != null,
        'If isThreeLine is true, subtitle must be provided.',
      );
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

### contentPadding <span class="docs-badge docs-badge-tip">final</span> {#prop-contentpadding}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">contentPadding</span></div></div>

:::details Implementation
```dart
final EdgeInsetsGeometry? contentPadding;
```
:::

### controlAffinity <span class="docs-badge docs-badge-tip">final</span> {#prop-controlaffinity}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">controlAffinity</span></div></div>

:::details Implementation
```dart
final RCheckboxControlAffinity controlAffinity;
```
:::

### dense <span class="docs-badge docs-badge-tip">final</span> {#prop-dense}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">dense</span></div></div>

:::details Implementation
```dart
final bool dense;
```
:::

### focusNode <span class="docs-badge docs-badge-tip">final</span> {#prop-focusnode}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">focusNode</span></div></div>

:::details Implementation
```dart
final FocusNode? focusNode;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_presentation_r_checkbox_list_tile/RCheckboxListTile#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_presentation_r_checkbox_list_tile/RCheckboxListTile#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_presentation_r_checkbox_list_tile/RCheckboxListTile#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_presentation_r_checkbox_list_tile/RCheckboxListTile#operator-equals).
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

If a subclass overrides [hashCode](/api/src_presentation_r_checkbox_list_tile/RCheckboxListTile#prop-hashcode), it should override the
[operator ==](/api/src_presentation_r_checkbox_list_tile/RCheckboxListTile#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### isDisabled <span class="docs-badge docs-badge-tip">no setter</span> {#prop-isdisabled}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isDisabled</span></div></div>

:::details Implementation
```dart
bool get isDisabled => onChanged == null;
```
:::

### isError <span class="docs-badge docs-badge-tip">final</span> {#prop-iserror}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">isError</span></div></div>

:::details Implementation
```dart
final bool isError;
```
:::

### isThreeLine <span class="docs-badge docs-badge-tip">final</span> {#prop-isthreeline}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">isThreeLine</span></div></div>

:::details Implementation
```dart
final bool isThreeLine;
```
:::

### mouseCursor <span class="docs-badge docs-badge-tip">final</span> {#prop-mousecursor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">mouseCursor</span></div></div>

:::details Implementation
```dart
final MouseCursor? mouseCursor;
```
:::

### onChanged <span class="docs-badge docs-badge-tip">final</span> {#prop-onchanged}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">onChanged</span></div></div>

:::details Implementation
```dart
final ValueChanged<bool?>? onChanged;
```
:::

### overrides <span class="docs-badge docs-badge-tip">final</span> {#prop-overrides}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">overrides</span></div></div>

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

### secondary <span class="docs-badge docs-badge-tip">final</span> {#prop-secondary}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">secondary</span></div></div>

:::details Implementation
```dart
final Widget? secondary;
```
:::

### selected <span class="docs-badge docs-badge-tip">final</span> {#prop-selected}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">selected</span></div></div>

:::details Implementation
```dart
final bool selected;
```
:::

### selectedColor <span class="docs-badge docs-badge-tip">final</span> {#prop-selectedcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">selectedColor</span></div></div>

:::details Implementation
```dart
final Color? selectedColor;
```
:::

### semanticLabel <span class="docs-badge docs-badge-tip">final</span> {#prop-semanticlabel}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span>? <span class="fn">semanticLabel</span></div></div>

:::details Implementation
```dart
final String? semanticLabel;
```
:::

### slots <span class="docs-badge docs-badge-tip">final</span> {#prop-slots}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">slots</span></div></div>

:::details Implementation
```dart
final RCheckboxListTileSlots? slots;
```
:::

### style <span class="docs-badge docs-badge-tip">final</span> {#prop-style}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_presentation_r_checkbox_list_tile_style/RCheckboxListTileStyle" class="type-link">RCheckboxListTileStyle</a>? <span class="fn">style</span></div></div>

Simple, Flutter-like styling sugar.

Internally converted to
`RenderOverrides.only(RCheckboxListTileOverrides.tokens(...))`.
If [overrides](/api/src_presentation_r_checkbox_list_tile/RCheckboxListTile#prop-overrides) is provided, it takes precedence over this style.

:::details Implementation
```dart
final RCheckboxListTileStyle? style;
```
:::

### subtitle <span class="docs-badge docs-badge-tip">final</span> {#prop-subtitle}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">subtitle</span></div></div>

:::details Implementation
```dart
final Widget? subtitle;
```
:::

### textDirection <span class="docs-badge docs-badge-tip">final</span> {#prop-textdirection}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">textDirection</span></div></div>

:::details Implementation
```dart
final TextDirection? textDirection;
```
:::

### title <span class="docs-badge docs-badge-tip">final</span> {#prop-title}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">title</span></div></div>

:::details Implementation
```dart
final Widget title;
```
:::

### tristate <span class="docs-badge docs-badge-tip">final</span> {#prop-tristate}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">tristate</span></div></div>

:::details Implementation
```dart
final bool tristate;
```
:::

### value <span class="docs-badge docs-badge-tip">final</span> {#prop-value}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span>? <span class="fn">value</span></div></div>

:::details Implementation
```dart
final bool? value;
```
:::

## Methods {#section-methods}

### createState() {#createstate}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="fn">createState</span>()</div></div>

:::details Implementation
```dart
@override
State<RCheckboxListTile> createState() => _RCheckboxListTileState();
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

