---
title: "CupertinoHeadlessTheme"
description: "API documentation for CupertinoHeadlessTheme class from cupertino_headless_theme"
category: "Classes"
library: "cupertino_headless_theme"
outline: [2, 3]
---

# CupertinoHeadlessTheme

<div class="member-signature"><div class="member-signature-code"><span class="kw">class</span> <span class="fn">CupertinoHeadlessTheme</span></div></div>

Cupertino (iOS) theme preset for Headless components.

Implements [HeadlessTheme](/api/src_theme_headless_theme/HeadlessTheme) and provides iOS-styled capabilities:

- [RButtonRenderer](/api/src_renderers_button_r_button_renderer/RButtonRenderer) via [CupertinoFlutterParityButtonRenderer](/api/src_button_cupertino_flutter_parity_button_renderer/CupertinoFlutterParityButtonRenderer) (parity visual port)
- [RButtonTokenResolver](/api/src_renderers_button_r_button_token_resolver/RButtonTokenResolver) via [CupertinoButtonTokenResolver](/api/src_button_cupertino_button_token_resolver/CupertinoButtonTokenResolver)
- [RDropdownButtonRenderer](/api/src_renderers_dropdown_r_dropdown_button_renderer/RDropdownButtonRenderer) via [CupertinoDropdownRenderer](/api/src_dropdown_cupertino_dropdown_renderer/CupertinoDropdownRenderer)
- [RDropdownTokenResolver](/api/src_renderers_dropdown_r_dropdown_token_resolver/RDropdownTokenResolver) via [CupertinoDropdownTokenResolver](/api/src_dropdown_cupertino_dropdown_token_resolver/CupertinoDropdownTokenResolver)

Usage:

```dart
HeadlessThemeProvider(
  theme: CupertinoHeadlessTheme(),
  child: MyApp(),
)
```

For scoped customization:

```dart
HeadlessThemeProvider(
  theme: CupertinoHeadlessTheme.dark(),
  child: DarkSection(),
)
```

## Constructors {#section-constructors}

### CupertinoHeadlessTheme() {#ctor-cupertinoheadlesstheme}

<div class="member-signature"><div class="member-signature-code"><span class="fn">CupertinoHeadlessTheme</span>({<span class="type">dynamic</span> <span class="param">brightness</span>})</div></div>

Creates a Cupertino theme preset with optional customization.

`brightness` - Optional brightness (light/dark). Defaults to system.

:::details Implementation
```dart
CupertinoHeadlessTheme({
  Brightness? brightness,
})  : _brightness = brightness,
      _tapTargetPolicy = const CupertinoTapTargetPolicy(),
      _buttonRenderer = const CupertinoFlutterParityButtonRenderer(),
      _buttonTokenResolver = CupertinoButtonTokenResolver(
        brightness: brightness,
      ),
      _checkboxRenderer = const CupertinoCheckboxRenderer(),
      _checkboxTokenResolver = CupertinoCheckboxTokenResolver(
        brightness: brightness,
      ),
      _checkboxListTileRenderer = const CupertinoCheckboxListTileRenderer(),
      _checkboxListTileTokenResolver = CupertinoCheckboxListTileTokenResolver(
        brightness: brightness,
      ),
      _switchRenderer = const CupertinoSwitchRenderer(),
      _switchTokenResolver = CupertinoSwitchTokenResolver(
        brightness: brightness,
      ),
      _switchListTileRenderer = const CupertinoSwitchListTileRenderer(),
      _switchListTileTokenResolver = CupertinoSwitchListTileTokenResolver(
        brightness: brightness,
      ),
      _dropdownRenderer = const CupertinoDropdownRenderer(),
      _dropdownTokenResolver = CupertinoDropdownTokenResolver(
        brightness: brightness,
      ),
      _textFieldRenderer = const CupertinoTextFieldRenderer(),
      _textFieldTokenResolver = CupertinoTextFieldTokenResolver(
        brightness: brightness,
      ),
      _pressableSurfaceFactory = const CupertinoPressableSurface();
```
:::

### CupertinoHeadlessTheme.dark() <span class="docs-badge docs-badge-tip">factory</span> {#dark}

<div class="member-signature"><div class="member-signature-code"><span class="kw">factory</span> <span class="fn">CupertinoHeadlessTheme.dark</span>()</div></div>

Creates a dark variant of the Cupertino theme.

:::details Implementation
```dart
factory CupertinoHeadlessTheme.dark() {
  return CupertinoHeadlessTheme(
    brightness: Brightness.dark,
  );
}
```
:::

### CupertinoHeadlessTheme.light() <span class="docs-badge docs-badge-tip">factory</span> {#light}

<div class="member-signature"><div class="member-signature-code"><span class="kw">factory</span> <span class="fn">CupertinoHeadlessTheme.light</span>()</div></div>

Creates a light variant of the Cupertino theme.

:::details Implementation
```dart
factory CupertinoHeadlessTheme.light() {
  return CupertinoHeadlessTheme(
    brightness: Brightness.light,
  );
}
```
:::

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_cupertino_headless_theme/CupertinoHeadlessTheme#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_cupertino_headless_theme/CupertinoHeadlessTheme#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_cupertino_headless_theme/CupertinoHeadlessTheme#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_cupertino_headless_theme/CupertinoHeadlessTheme#operator-equals).
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

If a subclass overrides [hashCode](/api/src_cupertino_headless_theme/CupertinoHeadlessTheme#prop-hashcode), it should override the
[operator ==](/api/src_cupertino_headless_theme/CupertinoHeadlessTheme#operator-equals) operator as well to maintain consistency.

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

<div class="member-signature"><div class="member-signature-code"><a href="/api/src_cupertino_headless_theme/CupertinoHeadlessTheme" class="type-link">CupertinoHeadlessTheme</a> <span class="fn">copyWith</span>({<span class="type">dynamic</span> <span class="param">brightness</span>})</div></div>

Creates a copy of this theme with specified overrides.

:::details Implementation
```dart
CupertinoHeadlessTheme copyWith({
  Brightness? brightness,
}) {
  return CupertinoHeadlessTheme(
    brightness: brightness ?? _brightness,
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

