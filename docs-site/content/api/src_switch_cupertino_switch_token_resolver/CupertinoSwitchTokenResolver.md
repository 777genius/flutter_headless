---
title: "CupertinoSwitchTokenResolver"
description: "API documentation for CupertinoSwitchTokenResolver class from cupertino_switch_token_resolver"
category: "Classes"
library: "cupertino_switch_token_resolver"
outline: [2, 3]
---

# CupertinoSwitchTokenResolver

<div class="member-signature"><div class="member-signature-code"><span class="kw">class</span> <span class="fn">CupertinoSwitchTokenResolver</span></div></div>

Cupertino token resolver for Switch components.

Implements [RSwitchTokenResolver](/api/src_renderers_switch_r_switch_token_resolver/RSwitchTokenResolver) with iOS styling.

## Constructors {#section-constructors}

### CupertinoSwitchTokenResolver() <span class="docs-badge docs-badge-tip">const</span> {#ctor-cupertinoswitchtokenresolver}

<div class="member-signature"><div class="member-signature-code"><span class="kw">const</span> <span class="fn">CupertinoSwitchTokenResolver</span>({<span class="type">dynamic</span> <span class="param">brightness</span>})</div></div>

:::details Implementation
```dart
const CupertinoSwitchTokenResolver({
  this.brightness,
});
```
:::

## Properties {#section-properties}

### brightness <span class="docs-badge docs-badge-tip">final</span> {#prop-brightness}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">brightness</span></div></div>

:::details Implementation
```dart
final Brightness? brightness;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_switch_cupertino_switch_token_resolver/CupertinoSwitchTokenResolver#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_switch_cupertino_switch_token_resolver/CupertinoSwitchTokenResolver#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_switch_cupertino_switch_token_resolver/CupertinoSwitchTokenResolver#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_switch_cupertino_switch_token_resolver/CupertinoSwitchTokenResolver#operator-equals).
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

If a subclass overrides [hashCode](/api/src_switch_cupertino_switch_token_resolver/CupertinoSwitchTokenResolver#prop-hashcode), it should override the
[operator ==](/api/src_switch_cupertino_switch_token_resolver/CupertinoSwitchTokenResolver#operator-equals) operator as well to maintain consistency.

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

### resolve() {#resolve}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">dynamic</span> <span class="fn">resolve</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">context</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">spec</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">Set</span>&lt;<span class="type">dynamic</span>&gt; <span class="param">states</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">constraints</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">overrides</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
@override
RSwitchResolvedTokens resolve({
  required BuildContext context,
  required RSwitchSpec spec,
  required Set<WidgetState> states,
  BoxConstraints? constraints,
  RenderOverrides? overrides,
}) {
  final motionTheme =
      HeadlessThemeProvider.of(context)?.capability<HeadlessMotionTheme>() ??
          HeadlessMotionTheme.cupertino;

  final q = HeadlessWidgetStateQuery(states);
  final contractOverrides = overrides?.get<RSwitchOverrides>();

  &#47;&#47; Use provided brightness or fallback to platform brightness
  final effectiveBrightness =
      brightness ?? MediaQuery.platformBrightnessOf(context);
  final isDark = effectiveBrightness == Brightness.dark;

  &#47;&#47; Cupertino Switch baseline values (iOS style).
  &#47;&#47; Cupertino switches have a fixed thumb size (no dynamic sizing like Material 3)
  const defaultTrackSize = Size(51, 31);
  &#47;&#47; Flutter: _kThumbRadius = 14.0 -> diameter 28.0
  const defaultThumbSize = Size(28, 28);
  const defaultTrackBorderRadius = BorderRadius.all(Radius.circular(16));
  const defaultThumbPadding = 2.0;

  final isSelected = spec.value || q.isSelected;

  Color activeTrackColor;
  Color inactiveTrackColor;
  Color activeThumbColor;
  Color inactiveThumbColor;
  Color trackOutlineColor;

  if (q.isDisabled) {
    activeTrackColor = CupertinoColors.systemGreen.withValues(alpha: 0.5);
    inactiveTrackColor = isDark
        ? CupertinoColors.systemGrey.withValues(alpha: 0.5)
        : CupertinoColors.systemGrey4.withValues(alpha: 0.5);
    activeThumbColor = CupertinoColors.white.withValues(alpha: 0.8);
    inactiveThumbColor = CupertinoColors.white.withValues(alpha: 0.8);
    trackOutlineColor = isDark
        ? CupertinoColors.systemGrey.withValues(alpha: 0.5)
        : CupertinoColors.systemGrey4.withValues(alpha: 0.5);
  } else {
    activeTrackColor = CupertinoColors.systemGreen;
    inactiveTrackColor =
        isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey4;
    activeThumbColor = CupertinoColors.white;
    inactiveThumbColor = CupertinoColors.white;
    trackOutlineColor =
        isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey4;
  }

  final pressOverlayColor = isSelected
      ? CupertinoColors.systemGreen.withValues(alpha: 0.12)
      : CupertinoColors.systemGrey.withValues(alpha: 0.12);

  &#47;&#47; Cupertino doesn't use state layer, but we provide transparent fallback
  final stateLayerColor =
      WidgetStateProperty.all<Color?>(const Color(0x00000000));

  final minTapTargetSize = _resolveMinTapTargetSize(
    constraints: constraints,
    override: contractOverrides?.minTapTargetSize,
  );

  return RSwitchResolvedTokens(
    trackSize: contractOverrides?.trackSize ?? defaultTrackSize,
    trackBorderRadius:
        contractOverrides?.trackBorderRadius ?? defaultTrackBorderRadius,
    trackOutlineColor:
        contractOverrides?.trackOutlineColor ?? trackOutlineColor,
    trackOutlineWidth: contractOverrides?.trackOutlineWidth ?? 0.0,
    activeTrackColor: contractOverrides?.activeTrackColor ?? activeTrackColor,
    inactiveTrackColor:
        contractOverrides?.inactiveTrackColor ?? inactiveTrackColor,
    &#47;&#47; Cupertino: thumb size is fixed (no unselected&#47;selected&#47;pressed differentiation)
    thumbSizeUnselected:
        contractOverrides?.thumbSizeUnselected ?? defaultThumbSize,
    thumbSizeSelected:
        contractOverrides?.thumbSizeSelected ?? defaultThumbSize,
    thumbSizePressed: contractOverrides?.thumbSizePressed ?? defaultThumbSize,
    thumbSizeTransition:
        contractOverrides?.thumbSizeTransition ?? defaultThumbSize,
    activeThumbColor: contractOverrides?.activeThumbColor ?? activeThumbColor,
    inactiveThumbColor:
        contractOverrides?.inactiveThumbColor ?? inactiveThumbColor,
    thumbPadding: contractOverrides?.thumbPadding ?? defaultThumbPadding,
    &#47;&#47; Flutter: _kDisabledOpacity = 0.5
    disabledOpacity: contractOverrides?.disabledOpacity ?? 0.5,
    pressOverlayColor:
        contractOverrides?.pressOverlayColor ?? pressOverlayColor,
    &#47;&#47; Native CupertinoSwitch does not dim the whole control on press.
    pressOpacity: contractOverrides?.pressOpacity ?? 1.0,
    &#47;&#47; Flutter: _kSwitchSize = 59×39 (track 51×31 centered inside).
    minTapTargetSize: minTapTargetSize,
    &#47;&#47; Cupertino doesn't use state layer
    stateLayerRadius: contractOverrides?.stateLayerRadius ?? 0.0,
    stateLayerColor: contractOverrides?.stateLayerColor ?? stateLayerColor,
    thumbIcon: contractOverrides?.thumbIcon,
    motion: contractOverrides?.motion ??
        RSwitchMotionTokens(
          stateChangeDuration: motionTheme.button.stateChangeDuration,
          thumbSlideDuration: const Duration(milliseconds: 200),
        ),
  );
}
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

