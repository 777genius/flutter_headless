---
title: "HeadlessThemeProvider"
description: "API documentation for HeadlessThemeProvider class from headless_theme_provider"
category: "Classes"
library: "headless_theme_provider"
outline: [2, 3]
---

# HeadlessThemeProvider

<div class="member-signature"><div class="member-signature-code"><span class="kw">class</span> <span class="fn">HeadlessThemeProvider</span></div></div>

Provides [HeadlessTheme](/api/src_theme_headless_theme/HeadlessTheme) to descendant widgets.

Wrap your app (or a subtree) with this widget to make the theme
available via [HeadlessThemeProvider.of](/api/src_theme_headless_theme_provider/HeadlessThemeProvider#of) or [HeadlessThemeProvider.themeOf](/api/src_theme_headless_theme_provider/HeadlessThemeProvider#themeof).

Example:

```dart
HeadlessThemeProvider(
  theme: MyCustomTheme(),
  child: MaterialApp(...),
)
```

## Constructors {#section-constructors}

### HeadlessThemeProvider() <span class="docs-badge docs-badge-tip">const</span> {#ctor-headlessthemeprovider}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">HeadlessThemeProvider</span>({</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">key</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_theme_headless_theme/HeadlessTheme" class="type-link">HeadlessTheme</a> <span class="param">theme</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">child</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const HeadlessThemeProvider({
  super.key,
  required this.theme,
  required super.child,
});
```
:::

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_theme_headless_theme_provider/HeadlessThemeProvider#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_theme_headless_theme_provider/HeadlessThemeProvider#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_theme_headless_theme_provider/HeadlessThemeProvider#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_theme_headless_theme_provider/HeadlessThemeProvider#operator-equals).
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

If a subclass overrides [hashCode](/api/src_theme_headless_theme_provider/HeadlessThemeProvider#prop-hashcode), it should override the
[operator ==](/api/src_theme_headless_theme_provider/HeadlessThemeProvider#operator-equals) operator as well to maintain consistency.

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

### theme <span class="docs-badge docs-badge-tip">final</span> {#prop-theme}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_theme_headless_theme/HeadlessTheme" class="type-link">HeadlessTheme</a> <span class="fn">theme</span></div></div>

The theme to provide to descendants.

:::details Implementation
```dart
final HeadlessTheme theme;
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

### updateShouldNotify() {#updateshouldnotify}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="fn">updateShouldNotify</span>(<a href="/api/src_theme_headless_theme_provider/HeadlessThemeProvider" class="type-link">HeadlessThemeProvider</a> <span class="param">oldWidget</span>)</div></div>

:::details Implementation
```dart
@override
bool updateShouldNotify(HeadlessThemeProvider oldWidget) {
  return theme != oldWidget.theme;
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

## Static Methods {#section-static-methods}

### capabilityOf() {#capabilityof}

<div class="member-signature"><div class="member-signature-code"><span class="type">T</span> <span class="fn">capabilityOf&lt;T&gt;</span>(<span class="type">dynamic</span> <span class="param">context</span>, {<span class="kw">required</span> <span class="type">String</span> <span class="param">componentName</span>})</div></div>

Convenience method to get a required capability from the theme.

Combines [themeOf](/api/src_theme_headless_theme_provider/HeadlessThemeProvider#themeof) + [requireCapability](/api/src_theme_require_capability/requireCapability) in one call.
This is the recommended way for components to access capabilities.

Example:

```dart
final renderer = HeadlessThemeProvider.capabilityOf<RButtonRenderer>(
  context,
  componentName: 'RTextButton',
);
```

:::details Implementation
```dart
static T capabilityOf<T>(
  BuildContext context, {
  required String componentName,
}) {
  final theme = themeOf(context);
  return requireCapability<T>(theme, componentName: componentName);
}
```
:::

### maybeCapabilityOf() {#maybecapabilityof}

<div class="member-signature"><div class="member-signature-code"><span class="type">T</span>? <span class="fn">maybeCapabilityOf&lt;T&gt;</span>(<span class="type">dynamic</span> <span class="param">context</span>, {<span class="kw">required</span> <span class="type">String</span> <span class="param">componentName</span>})</div></div>

Safe capability lookup.

- In debug/profile: asserts with a detailed, searchable error.
- In release: returns null (callers should render a fallback and report).

:::details Implementation
```dart
static T? maybeCapabilityOf<T>(
  BuildContext context, {
  required String componentName,
}) {
  final provider =
      context.dependOnInheritedWidgetOfExactType<HeadlessThemeProvider>();
  final theme = provider?.theme;
  if (theme == null) {
    assert(() {
      throw const MissingThemeException();
    }());
    return null;
  }
  final capability = theme.capability<T>();
  if (capability == null) {
    assert(() {
      throw MissingCapabilityException(
        capabilityType: T.toString(),
        componentName: componentName,
      );
    }());
    return null;
  }
  return capability;
}
```
:::

### of() {#of}

<div class="member-signature"><div class="member-signature-code"><a href="/api/src_theme_headless_theme/HeadlessTheme" class="type-link">HeadlessTheme</a>? <span class="fn">of</span>(<span class="type">dynamic</span> <span class="param">context</span>)</div></div>

Get the [HeadlessTheme](/api/src_theme_headless_theme/HeadlessTheme) from the widget tree.

Returns null if no [HeadlessThemeProvider](/api/src_theme_headless_theme_provider/HeadlessThemeProvider) is found.
Prefer [themeOf](/api/src_theme_headless_theme_provider/HeadlessThemeProvider#themeof) when you expect the theme to always be present.

:::details Implementation
```dart
static HeadlessTheme? of(BuildContext context) {
  final provider =
      context.dependOnInheritedWidgetOfExactType<HeadlessThemeProvider>();
  return provider?.theme;
}
```
:::

### themeOf() {#themeof}

<div class="member-signature"><div class="member-signature-code"><a href="/api/src_theme_headless_theme/HeadlessTheme" class="type-link">HeadlessTheme</a> <span class="fn">themeOf</span>(<span class="type">dynamic</span> <span class="param">context</span>)</div></div>

Get the [HeadlessTheme](/api/src_theme_headless_theme/HeadlessTheme) from the widget tree.

Throws [MissingThemeException](/api/src_theme_headless_theme_provider/MissingThemeException) if no [HeadlessThemeProvider](/api/src_theme_headless_theme_provider/HeadlessThemeProvider) is found.
Use this when the theme is required (most component use cases).

:::details Implementation
```dart
static HeadlessTheme themeOf(BuildContext context) {
  final theme = of(context);
  if (theme == null) {
    assert(() {
      throw const MissingThemeException();
    }());
    return const _MissingHeadlessTheme();
  }
  return theme;
}
```
:::

