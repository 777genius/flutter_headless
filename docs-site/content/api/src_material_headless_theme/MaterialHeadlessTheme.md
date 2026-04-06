---
title: "MaterialHeadlessTheme"
description: "API documentation for MaterialHeadlessTheme class from material_headless_theme"
category: "Classes"
library: "material_headless_theme"
outline: [2, 3]
---

# MaterialHeadlessTheme

<div class="member-signature"><div class="member-signature-code"><span class="kw">class</span> <span class="fn">MaterialHeadlessTheme</span></div></div>

Material 3 theme preset for Headless components.

Implements [HeadlessTheme](/api/src_theme_headless_theme/HeadlessTheme) and provides Material-styled capabilities:

- [RButtonRenderer](/api/src_renderers_button_r_button_renderer/RButtonRenderer) via [MaterialFlutterParityButtonRenderer](/api/src_button_material_flutter_parity_button_renderer/MaterialFlutterParityButtonRenderer) (parity-by-reuse)
- [RButtonTokenResolver](/api/src_renderers_button_r_button_token_resolver/RButtonTokenResolver) via [MaterialButtonTokenResolver](/api/src_button_material_button_token_resolver/MaterialButtonTokenResolver)
- [RDropdownButtonRenderer](/api/src_renderers_dropdown_r_dropdown_button_renderer/RDropdownButtonRenderer) via [MaterialDropdownRenderer](/api/src_dropdown_material_dropdown_renderer/MaterialDropdownRenderer)
- [RDropdownTokenResolver](/api/src_renderers_dropdown_r_dropdown_token_resolver/RDropdownTokenResolver) via [MaterialDropdownTokenResolver](/api/src_dropdown_material_dropdown_token_resolver/MaterialDropdownTokenResolver)
- [RTextFieldRenderer](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldRenderer) via [MaterialTextFieldRenderer](/api/src_textfield_material_text_field_renderer/MaterialTextFieldRenderer)
- [RTextFieldTokenResolver](/api/src_renderers_textfield_r_text_field_token_resolver/RTextFieldTokenResolver) via [MaterialTextFieldTokenResolver](/api/src_textfield_material_text_field_token_resolver/MaterialTextFieldTokenResolver)

Usage:

```dart
HeadlessThemeProvider(
  theme: MaterialHeadlessTheme(),
  child: MyApp(),
)
```

For scoped customization:

```dart
HeadlessThemeProvider(
  theme: MaterialHeadlessTheme.copyWith(
    colorScheme: darkColorScheme,
  ),
  child: DarkSection(),
)
```

## Constructors {#section-constructors}

### MaterialHeadlessTheme() {#ctor-materialheadlesstheme}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="fn">MaterialHeadlessTheme</span>({</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">colorScheme</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">textTheme</span>,</span><span class="member-signature-line">  <a href="/api/src_material_headless_defaults/MaterialHeadlessDefaults" class="type-link">MaterialHeadlessDefaults</a>? <span class="param">defaults</span>,</span><span class="member-signature-line">});</span></div></div>

Creates a Material 3 theme preset with optional customization.

`colorScheme` - Custom color scheme (defaults to Material 3 baseline).
`textTheme` - Custom text theme.
`defaults` - User-friendly defaults for component policies.

:::details Implementation
```dart
MaterialHeadlessTheme({
  ColorScheme? colorScheme,
  TextTheme? textTheme,
  MaterialHeadlessDefaults? defaults,
})  : _colorScheme = colorScheme,
      _textTheme = textTheme,
      _defaults = defaults,
      _tapTargetPolicy = const MaterialTapTargetPolicy(),
      _buttonRenderer = const MaterialFlutterParityButtonRenderer(),
      _buttonTokenResolver = MaterialButtonTokenResolver(
        colorScheme: colorScheme,
        textTheme: textTheme,
        defaults: defaults?.button,
      ),
      _checkboxRenderer = const MaterialCheckboxRenderer(),
      _checkboxTokenResolver = MaterialCheckboxTokenResolver(
        colorScheme: colorScheme,
      ),
      _checkboxListTileRenderer = MaterialCheckboxListTileRenderer(
        defaults: defaults?.listTile,
      ),
      _checkboxListTileTokenResolver = MaterialCheckboxListTileTokenResolver(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      _switchRenderer = const MaterialSwitchRenderer(),
      _switchTokenResolver = MaterialSwitchTokenResolver(
        colorScheme: colorScheme,
      ),
      _switchListTileRenderer = MaterialSwitchListTileRenderer(
        defaults: defaults?.listTile,
      ),
      _switchListTileTokenResolver = MaterialSwitchListTileTokenResolver(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      _dropdownRenderer = const MaterialDropdownRenderer(),
      _dropdownTokenResolver = MaterialDropdownTokenResolver(
        colorScheme: colorScheme,
        textTheme: textTheme,
        defaults: defaults?.dropdown,
      ),
      _textFieldRenderer = const MaterialTextFieldRenderer(),
      _textFieldTokenResolver = MaterialTextFieldTokenResolver(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      _autocompleteSelectedValuesRenderer =
          const MaterialAutocompleteSelectedValuesRenderer(),
      _pressableSurfaceFactory = const MaterialInkPressableSurface();
```
:::

### MaterialHeadlessTheme.dark() <span class="docs-badge docs-badge-tip">factory</span> {#dark}

<div class="member-signature"><div class="member-signature-code"><span class="kw">factory</span> <span class="fn">MaterialHeadlessTheme.dark</span>()</div></div>

Creates a dark variant of the Material theme.

:::details Implementation
```dart
factory MaterialHeadlessTheme.dark() {
  return MaterialHeadlessTheme(
    colorScheme: const ColorScheme.dark(),
  );
}
```
:::

### MaterialHeadlessTheme.light() <span class="docs-badge docs-badge-tip">factory</span> {#light}

<div class="member-signature"><div class="member-signature-code"><span class="kw">factory</span> <span class="fn">MaterialHeadlessTheme.light</span>()</div></div>

Creates a light variant of the Material theme.

:::details Implementation
```dart
factory MaterialHeadlessTheme.light() {
  return MaterialHeadlessTheme(
    colorScheme: const ColorScheme.light(),
  );
}
```
:::

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_material_headless_theme/MaterialHeadlessTheme#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_material_headless_theme/MaterialHeadlessTheme#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_material_headless_theme/MaterialHeadlessTheme#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_material_headless_theme/MaterialHeadlessTheme#operator-equals).
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

If a subclass overrides [hashCode](/api/src_material_headless_theme/MaterialHeadlessTheme#prop-hashcode), it should override the
[operator ==](/api/src_material_headless_theme/MaterialHeadlessTheme#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
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

### capability() {#capability}

<div class="member-signature"><div class="member-signature-code"><span class="type">T</span>? <span class="fn">capability&lt;T&gt;</span>()</div></div>

:::details Implementation
```dart
@override
T? capability<T>() {
  &#47;&#47; Accessibility capabilities
  if (T == HeadlessTapTargetPolicy) {
    return _tapTargetPolicy as T;
  }

  &#47;&#47; Button capabilities
  if (T == RButtonRenderer) {
    return _buttonRenderer as T;
  }
  if (T == RButtonTokenResolver) {
    return _buttonTokenResolver as T;
  }

  &#47;&#47; Checkbox capabilities
  if (T == RCheckboxRenderer) {
    return _checkboxRenderer as T;
  }
  if (T == RCheckboxTokenResolver) {
    return _checkboxTokenResolver as T;
  }
  if (T == RCheckboxListTileRenderer) {
    return _checkboxListTileRenderer as T;
  }
  if (T == RCheckboxListTileTokenResolver) {
    return _checkboxListTileTokenResolver as T;
  }

  &#47;&#47; Switch capabilities
  if (T == RSwitchRenderer) {
    return _switchRenderer as T;
  }
  if (T == RSwitchTokenResolver) {
    return _switchTokenResolver as T;
  }
  if (T == RSwitchListTileRenderer) {
    return _switchListTileRenderer as T;
  }
  if (T == RSwitchListTileTokenResolver) {
    return _switchListTileTokenResolver as T;
  }

  &#47;&#47; Dropdown capabilities (non-generic contracts)
  if (T == RDropdownButtonRenderer) {
    return _dropdownRenderer as T;
  }
  if (T == RDropdownTokenResolver) {
    return _dropdownTokenResolver as T;
  }

  &#47;&#47; TextField capabilities
  if (T == RTextFieldRenderer) {
    return _textFieldRenderer as T;
  }
  if (T == RTextFieldTokenResolver) {
    return _textFieldTokenResolver as T;
  }

  &#47;&#47; Autocomplete capabilities
  if (T == RAutocompleteSelectedValuesRenderer) {
    return _autocompleteSelectedValuesRenderer as T;
  }

  &#47;&#47; Interaction capabilities
  if (T == HeadlessPressableSurfaceFactory) {
    return _pressableSurfaceFactory as T;
  }

  &#47;&#47; No capability found
  return null;
}
```
:::

### copyWith() {#copywith}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><a href="/api/src_material_headless_theme/MaterialHeadlessTheme" class="type-link">MaterialHeadlessTheme</a> <span class="fn">copyWith</span>({</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">colorScheme</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">textTheme</span>,</span><span class="member-signature-line">  <a href="/api/src_material_headless_defaults/MaterialHeadlessDefaults" class="type-link">MaterialHeadlessDefaults</a>? <span class="param">defaults</span>,</span><span class="member-signature-line">});</span></div></div>

Creates a copy of this theme with specified overrides.

:::details Implementation
```dart
MaterialHeadlessTheme copyWith({
  ColorScheme? colorScheme,
  TextTheme? textTheme,
  MaterialHeadlessDefaults? defaults,
}) {
  return MaterialHeadlessTheme(
    colorScheme: colorScheme ?? _colorScheme,
    textTheme: textTheme ?? _textTheme,
    defaults: defaults ?? _defaults,
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

