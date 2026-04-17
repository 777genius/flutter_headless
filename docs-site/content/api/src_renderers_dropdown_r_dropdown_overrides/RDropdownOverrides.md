---
title: "RDropdownOverrides"
description: "API documentation for RDropdownOverrides class from r_dropdown_overrides"
category: "Classes"
library: "r_dropdown_overrides"
outline: [2, 3]
---

# RDropdownOverrides <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RDropdownOverrides</span></div></div>

Per-instance override contract for Dropdown components.

This is the preset-agnostic override type that lives in headless_theme.
Users can use this to customize a specific dropdown instance without
depending on preset-specific types.

Note: Preset-specific overrides (e.g., MaterialDropdownOverrides) may be
added in future versions as an advanced customization layer.

Usage:

```dart
RDropdownButton<String>(
  value: value,
  onChanged: setValue,
  items: items,
  overrides: RenderOverrides({
    RDropdownOverrides: RDropdownOverrides.tokens(
      triggerBackgroundColor: Colors.grey,
    ),
  }),
);
```

See `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`.

## Constructors {#section-constructors}

### RDropdownOverrides() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rdropdownoverrides}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RDropdownOverrides</span>({</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerTextStyle</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerForegroundColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerBackgroundColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerBorderColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerPadding</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerMinSize</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerBorderRadius</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerIconColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">menuBackgroundColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">menuBorderColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">menuBorderRadius</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">menuElevation</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">menuMaxHeight</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">menuPadding</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">itemTextStyle</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">itemPadding</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">itemMinHeight</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const RDropdownOverrides({
  &#47;&#47; Trigger
  this.triggerTextStyle,
  this.triggerForegroundColor,
  this.triggerBackgroundColor,
  this.triggerBorderColor,
  this.triggerPadding,
  this.triggerMinSize,
  this.triggerBorderRadius,
  this.triggerIconColor,
  &#47;&#47; Menu
  this.menuBackgroundColor,
  this.menuBorderColor,
  this.menuBorderRadius,
  this.menuElevation,
  this.menuMaxHeight,
  this.menuPadding,
  &#47;&#47; Item
  this.itemTextStyle,
  this.itemPadding,
  this.itemMinHeight,
});
```
:::

### RDropdownOverrides.tokens() <span class="docs-badge docs-badge-tip">factory</span> <span class="docs-badge docs-badge-tip">const</span> {#tokens}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="kw">factory</span> <span class="fn">RDropdownOverrides.tokens</span>({</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerTextStyle</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerForegroundColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerBackgroundColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerBorderColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerPadding</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerMinSize</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerBorderRadius</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">triggerIconColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">menuBackgroundColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">menuBorderColor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">menuBorderRadius</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">menuElevation</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">menuMaxHeight</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">menuPadding</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">itemTextStyle</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">itemPadding</span>,</span><span class="member-signature-line">  <span class="type">double</span>? <span class="param">itemMinHeight</span>,</span><span class="member-signature-line">})</span></div></div>

Factory for token-level overrides.

This is the canonical way to override dropdown visuals at the contract level.

:::details Implementation
```dart
const factory RDropdownOverrides.tokens({
  &#47;&#47; Trigger
  TextStyle? triggerTextStyle,
  Color? triggerForegroundColor,
  Color? triggerBackgroundColor,
  Color? triggerBorderColor,
  EdgeInsetsGeometry? triggerPadding,
  Size? triggerMinSize,
  BorderRadius? triggerBorderRadius,
  Color? triggerIconColor,
  &#47;&#47; Menu
  Color? menuBackgroundColor,
  Color? menuBorderColor,
  BorderRadius? menuBorderRadius,
  double? menuElevation,
  double? menuMaxHeight,
  EdgeInsetsGeometry? menuPadding,
  &#47;&#47; Item
  TextStyle? itemTextStyle,
  EdgeInsetsGeometry? itemPadding,
  double? itemMinHeight,
}) = RDropdownOverrides;
```
:::

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_renderers_dropdown_r_dropdown_overrides/RDropdownOverrides#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_renderers_dropdown_r_dropdown_overrides/RDropdownOverrides#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_renderers_dropdown_r_dropdown_overrides/RDropdownOverrides#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_renderers_dropdown_r_dropdown_overrides/RDropdownOverrides#operator-equals).
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

If a subclass overrides [hashCode](/api/src_renderers_dropdown_r_dropdown_overrides/RDropdownOverrides#prop-hashcode), it should override the
[operator ==](/api/src_renderers_dropdown_r_dropdown_overrides/RDropdownOverrides#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### hasOverrides <span class="docs-badge docs-badge-tip">no setter</span> {#prop-hasoverrides}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">hasOverrides</span></div></div>

Whether any override is set.

:::details Implementation
```dart
bool get hasOverrides =>
    triggerTextStyle != null ||
    triggerForegroundColor != null ||
    triggerBackgroundColor != null ||
    triggerBorderColor != null ||
    triggerPadding != null ||
    triggerMinSize != null ||
    triggerBorderRadius != null ||
    triggerIconColor != null ||
    menuBackgroundColor != null ||
    menuBorderColor != null ||
    menuBorderRadius != null ||
    menuElevation != null ||
    menuMaxHeight != null ||
    menuPadding != null ||
    itemTextStyle != null ||
    itemPadding != null ||
    itemMinHeight != null;
```
:::

### itemMinHeight <span class="docs-badge docs-badge-tip">final</span> {#prop-itemminheight}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span>? <span class="fn">itemMinHeight</span></div></div>

Override for item minimum height.

:::details Implementation
```dart
final double? itemMinHeight;
```
:::

### itemPadding <span class="docs-badge docs-badge-tip">final</span> {#prop-itempadding}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">itemPadding</span></div></div>

Override for item padding.

:::details Implementation
```dart
final EdgeInsetsGeometry? itemPadding;
```
:::

### itemTextStyle <span class="docs-badge docs-badge-tip">final</span> {#prop-itemtextstyle}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">itemTextStyle</span></div></div>

Override for item text style.

:::details Implementation
```dart
final TextStyle? itemTextStyle;
```
:::

### menuBackgroundColor <span class="docs-badge docs-badge-tip">final</span> {#prop-menubackgroundcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">menuBackgroundColor</span></div></div>

Override for menu background color.

:::details Implementation
```dart
final Color? menuBackgroundColor;
```
:::

### menuBorderColor <span class="docs-badge docs-badge-tip">final</span> {#prop-menubordercolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">menuBorderColor</span></div></div>

Override for menu border color.

:::details Implementation
```dart
final Color? menuBorderColor;
```
:::

### menuBorderRadius <span class="docs-badge docs-badge-tip">final</span> {#prop-menuborderradius}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">menuBorderRadius</span></div></div>

Override for menu border radius.

:::details Implementation
```dart
final BorderRadius? menuBorderRadius;
```
:::

### menuElevation <span class="docs-badge docs-badge-tip">final</span> {#prop-menuelevation}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span>? <span class="fn">menuElevation</span></div></div>

Override for menu elevation/shadow.

:::details Implementation
```dart
final double? menuElevation;
```
:::

### menuMaxHeight <span class="docs-badge docs-badge-tip">final</span> {#prop-menumaxheight}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">double</span>? <span class="fn">menuMaxHeight</span></div></div>

Override for menu max height.

:::details Implementation
```dart
final double? menuMaxHeight;
```
:::

### menuPadding <span class="docs-badge docs-badge-tip">final</span> {#prop-menupadding}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">menuPadding</span></div></div>

Override for menu content padding.

:::details Implementation
```dart
final EdgeInsetsGeometry? menuPadding;
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

Override for trigger background color.

:::details Implementation
```dart
final Color? triggerBackgroundColor;
```
:::

### triggerBorderColor <span class="docs-badge docs-badge-tip">final</span> {#prop-triggerbordercolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">triggerBorderColor</span></div></div>

Override for trigger border color.

:::details Implementation
```dart
final Color? triggerBorderColor;
```
:::

### triggerBorderRadius <span class="docs-badge docs-badge-tip">final</span> {#prop-triggerborderradius}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">triggerBorderRadius</span></div></div>

Override for trigger border radius.

:::details Implementation
```dart
final BorderRadius? triggerBorderRadius;
```
:::

### triggerForegroundColor <span class="docs-badge docs-badge-tip">final</span> {#prop-triggerforegroundcolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">triggerForegroundColor</span></div></div>

Override for trigger foreground color.

:::details Implementation
```dart
final Color? triggerForegroundColor;
```
:::

### triggerIconColor <span class="docs-badge docs-badge-tip">final</span> {#prop-triggericoncolor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">triggerIconColor</span></div></div>

Override for dropdown arrow icon color.

:::details Implementation
```dart
final Color? triggerIconColor;
```
:::

### triggerMinSize <span class="docs-badge docs-badge-tip">final</span> {#prop-triggerminsize}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">triggerMinSize</span></div></div>

Override for trigger minimum size (accessibility).

:::details Implementation
```dart
final Size? triggerMinSize;
```
:::

### triggerPadding <span class="docs-badge docs-badge-tip">final</span> {#prop-triggerpadding}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">triggerPadding</span></div></div>

Override for trigger padding.

:::details Implementation
```dart
final EdgeInsetsGeometry? triggerPadding;
```
:::

### triggerTextStyle <span class="docs-badge docs-badge-tip">final</span> {#prop-triggertextstyle}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">triggerTextStyle</span></div></div>

Override for trigger text style.

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

