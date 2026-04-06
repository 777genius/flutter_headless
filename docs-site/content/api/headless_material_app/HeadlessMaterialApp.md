---
title: "HeadlessMaterialApp"
description: "API documentation for HeadlessMaterialApp class from headless_material_app"
category: "Classes"
library: "headless_material_app"
outline: [2, 3]
---

# HeadlessMaterialApp

<div class="member-signature"><div class="member-signature-code"><span class="kw">class</span> <span class="fn">HeadlessMaterialApp</span></div></div>

MaterialApp bootstrap for Headless.

What it does:

- Provides [HeadlessThemeProvider](/api/src_theme_headless_theme_provider/HeadlessThemeProvider) with [MaterialHeadlessTheme](/api/src_material_headless_theme/MaterialHeadlessTheme) by default.
- Installs [AnchoredOverlayEngineHost](/api/src_host_anchored_overlay_engine_host/AnchoredOverlayEngineHost) (required for overlay-based components).
- Manages [OverlayController](/api/src_controller_overlay_controller/OverlayController) lifecycle unless you pass one.

Intended to reduce onboarding boilerplate:
`HeadlessThemeProvider` + `AnchoredOverlayEngineHost` + `MaterialApp(...)`.

## Constructors {#section-constructors}

### HeadlessMaterialApp() <span class="docs-badge docs-badge-tip">const</span> {#ctor-headlessmaterialapp}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">HeadlessMaterialApp</span>({</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">key</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">headlessTheme</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">overlayController</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">enableAutoRepositionTicker</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">requireResolvedTokens</span> = <span class="kw">true</span>,</span><span class="member-signature-line">  <span class="type">String</span> <span class="param">title</span> = <span class="str-lit">''</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">debugShowCheckedModeBanner</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">theme</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">darkTheme</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">themeMode</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">color</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">home</span>,</span><span class="member-signature-line">  <span class="type">Map</span>&lt;<span class="type">String</span>, <span class="type">dynamic</span>&gt; <span class="param">routes</span> = const &lt;String, WidgetBuilder&gt;{},</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">initialRoute</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">onGenerateRoute</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">onUnknownRoute</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">navigatorKey</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">scaffoldMessengerKey</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">builder</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">locale</span>,</span><span class="member-signature-line">  <span class="type">Iterable</span>&lt;<span class="type">dynamic</span>&gt;? <span class="param">localizationsDelegates</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">localeResolutionCallback</span>,</span><span class="member-signature-line">  <span class="type">Iterable</span>&lt;<span class="type">dynamic</span>&gt; <span class="param">supportedLocales</span> = const &lt;Locale&gt;[Locale('en', 'US')],</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const HeadlessMaterialApp({
  super.key,
  this.headlessTheme,
  this.overlayController,
  this.enableAutoRepositionTicker = false,
  this.requireResolvedTokens = true,
  this.title = '',
  this.debugShowCheckedModeBanner = false,
  this.theme,
  this.darkTheme,
  this.themeMode,
  this.color,
  this.home,
  this.routes = const <String, WidgetBuilder>{},
  this.initialRoute,
  this.onGenerateRoute,
  this.onUnknownRoute,
  this.navigatorKey,
  this.scaffoldMessengerKey,
  this.builder,
  this.locale,
  this.localizationsDelegates,
  this.localeResolutionCallback,
  this.supportedLocales = const <Locale>[Locale('en', 'US')],
});
```
:::

## Properties {#section-properties}

### builder <span class="docs-badge docs-badge-tip">final</span> {#prop-builder}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">builder</span></div></div>

:::details Implementation
```dart
final TransitionBuilder? builder;
```
:::

### color <span class="docs-badge docs-badge-tip">final</span> {#prop-color}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">color</span></div></div>

:::details Implementation
```dart
final Color? color;
```
:::

### darkTheme <span class="docs-badge docs-badge-tip">final</span> {#prop-darktheme}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">darkTheme</span></div></div>

:::details Implementation
```dart
final ThemeData? darkTheme;
```
:::

### debugShowCheckedModeBanner <span class="docs-badge docs-badge-tip">final</span> {#prop-debugshowcheckedmodebanner}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">debugShowCheckedModeBanner</span></div></div>

:::details Implementation
```dart
final bool debugShowCheckedModeBanner;
```
:::

### enableAutoRepositionTicker <span class="docs-badge docs-badge-tip">final</span> {#prop-enableautorepositionticker}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">enableAutoRepositionTicker</span></div></div>

When enabled, AnchoredOverlayEngineHost will request reposition every frame while overlays
are active.

:::details Implementation
```dart
final bool enableAutoRepositionTicker;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/headless_material_app/HeadlessMaterialApp#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/headless_material_app/HeadlessMaterialApp#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/headless_material_app/HeadlessMaterialApp#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/headless_material_app/HeadlessMaterialApp#operator-equals).
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

If a subclass overrides [hashCode](/api/headless_material_app/HeadlessMaterialApp#prop-hashcode), it should override the
[operator ==](/api/headless_material_app/HeadlessMaterialApp#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### headlessTheme <span class="docs-badge docs-badge-tip">final</span> {#prop-headlesstheme}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">headlessTheme</span></div></div>

Headless theme used by components (capability provider).

Defaults to [MaterialHeadlessTheme](/api/src_material_headless_theme/MaterialHeadlessTheme).

:::details Implementation
```dart
final HeadlessTheme? headlessTheme;
```
:::

### home <span class="docs-badge docs-badge-tip">final</span> {#prop-home}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">home</span></div></div>

:::details Implementation
```dart
final Widget? home;
```
:::

### initialRoute <span class="docs-badge docs-badge-tip">final</span> {#prop-initialroute}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span>? <span class="fn">initialRoute</span></div></div>

:::details Implementation
```dart
final String? initialRoute;
```
:::

### locale <span class="docs-badge docs-badge-tip">final</span> {#prop-locale}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">locale</span></div></div>

:::details Implementation
```dart
final Locale? locale;
```
:::

### localeResolutionCallback <span class="docs-badge docs-badge-tip">final</span> {#prop-localeresolutioncallback}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">localeResolutionCallback</span></div></div>

:::details Implementation
```dart
final LocaleResolutionCallback? localeResolutionCallback;
```
:::

### localizationsDelegates <span class="docs-badge docs-badge-tip">final</span> {#prop-localizationsdelegates}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">Iterable</span>&lt;<span class="type">dynamic</span>&gt;? <span class="fn">localizationsDelegates</span></div></div>

:::details Implementation
```dart
final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
```
:::

### navigatorKey <span class="docs-badge docs-badge-tip">final</span> {#prop-navigatorkey}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">navigatorKey</span></div></div>

:::details Implementation
```dart
final GlobalKey<NavigatorState>? navigatorKey;
```
:::

### onGenerateRoute <span class="docs-badge docs-badge-tip">final</span> {#prop-ongenerateroute}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">onGenerateRoute</span></div></div>

:::details Implementation
```dart
final RouteFactory? onGenerateRoute;
```
:::

### onUnknownRoute <span class="docs-badge docs-badge-tip">final</span> {#prop-onunknownroute}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">onUnknownRoute</span></div></div>

:::details Implementation
```dart
final RouteFactory? onUnknownRoute;
```
:::

### overlayController <span class="docs-badge docs-badge-tip">final</span> {#prop-overlaycontroller}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">overlayController</span></div></div>

Optional external overlay controller.

If provided, it will NOT be disposed by this widget.

:::details Implementation
```dart
final OverlayController? overlayController;
```
:::

### requireResolvedTokens <span class="docs-badge docs-badge-tip">final</span> {#prop-requireresolvedtokens}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">requireResolvedTokens</span></div></div>

When true, preset renderers require non-null resolvedTokens.

Defaults to true because the Material preset always provides token resolvers.
If you provide a custom [headlessTheme](/api/headless_material_app/HeadlessMaterialApp#prop-headlesstheme) that intentionally omits token resolvers,
you can disable this.

:::details Implementation
```dart
final bool requireResolvedTokens;
```
:::

### routes <span class="docs-badge docs-badge-tip">final</span> {#prop-routes}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">Map</span>&lt;<span class="type">String</span>, <span class="type">dynamic</span>&gt; <span class="fn">routes</span></div></div>

:::details Implementation
```dart
final Map<String, WidgetBuilder> routes;
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

### scaffoldMessengerKey <span class="docs-badge docs-badge-tip">final</span> {#prop-scaffoldmessengerkey}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">scaffoldMessengerKey</span></div></div>

:::details Implementation
```dart
final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
```
:::

### supportedLocales <span class="docs-badge docs-badge-tip">final</span> {#prop-supportedlocales}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">Iterable</span>&lt;<span class="type">dynamic</span>&gt; <span class="fn">supportedLocales</span></div></div>

:::details Implementation
```dart
final Iterable<Locale> supportedLocales;
```
:::

### theme <span class="docs-badge docs-badge-tip">final</span> {#prop-theme}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">theme</span></div></div>

:::details Implementation
```dart
final ThemeData? theme;
```
:::

### themeMode <span class="docs-badge docs-badge-tip">final</span> {#prop-thememode}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">themeMode</span></div></div>

:::details Implementation
```dart
final ThemeMode? themeMode;
```
:::

### title <span class="docs-badge docs-badge-tip">final</span> {#prop-title}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span> <span class="fn">title</span></div></div>

:::details Implementation
```dart
final String title;
```
:::

## Methods {#section-methods}

### createState() {#createstate}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="fn">createState</span>()</div></div>

:::details Implementation
```dart
@override
State<HeadlessMaterialApp> createState() => _HeadlessMaterialAppState();
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

