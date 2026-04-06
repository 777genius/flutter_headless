---
title: "MaterialSwitchTokenResolver"
description: "API documentation for MaterialSwitchTokenResolver class from material_switch_token_resolver"
category: "Classes"
library: "material_switch_token_resolver"
outline: [2, 3]
---

# MaterialSwitchTokenResolver

<div class="member-signature"><div class="member-signature-code"><span class="kw">class</span> <span class="fn">MaterialSwitchTokenResolver</span></div></div>

Material 3 token resolver for Switch components.

Implements [RSwitchTokenResolver](/api/src_renderers_switch_r_switch_token_resolver/RSwitchTokenResolver) with Material Design 3 styling.

Token resolution priority (v1):

1. Contract overrides: `overrides.get<RSwitchOverrides>()`
2. Theme defaults / preset defaults

## Constructors {#section-constructors}

### MaterialSwitchTokenResolver() <span class="docs-badge docs-badge-tip">const</span> {#ctor-materialswitchtokenresolver}

<div class="member-signature"><div class="member-signature-code"><span class="kw">const</span> <span class="fn">MaterialSwitchTokenResolver</span>({<span class="type">dynamic</span> <span class="param">colorScheme</span>})</div></div>

:::details Implementation
```dart
const MaterialSwitchTokenResolver({
  this.colorScheme,
});
```
:::

## Properties {#section-properties}

### colorScheme <span class="docs-badge docs-badge-tip">final</span> {#prop-colorscheme}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">colorScheme</span></div></div>

:::details Implementation
```dart
final ColorScheme? colorScheme;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_switch_material_switch_token_resolver/MaterialSwitchTokenResolver#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_switch_material_switch_token_resolver/MaterialSwitchTokenResolver#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_switch_material_switch_token_resolver/MaterialSwitchTokenResolver#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_switch_material_switch_token_resolver/MaterialSwitchTokenResolver#operator-equals).
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

If a subclass overrides [hashCode](/api/src_switch_material_switch_token_resolver/MaterialSwitchTokenResolver#prop-hashcode), it should override the
[operator ==](/api/src_switch_material_switch_token_resolver/MaterialSwitchTokenResolver#operator-equals) operator as well to maintain consistency.

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
          HeadlessMotionTheme.material;

  final scheme = colorScheme ?? Theme.of(context).colorScheme;
  final q = HeadlessWidgetStateQuery(states);

  final contractOverrides = overrides?.get<RSwitchOverrides>();

  &#47;&#47; Material 3 Switch baseline values.
  const defaultTrackSize = Size(52, 32);
  const defaultTrackBorderRadius = BorderRadius.all(Radius.circular(16));
  const defaultTrackOutlineWidth = 2.0;
  const defaultThumbPadding = 4.0;

  &#47;&#47; Material 3 thumb sizes (from Flutter switch.dart _SwitchConfigM3)
  const defaultThumbSizeUnselected = Size(16, 16);
  const defaultThumbSizeSelected = Size(24, 24);
  const defaultThumbSizePressed = Size(28, 28);
  const defaultThumbSizeTransition = Size(34, 22);

  &#47;&#47; Material 3 state layer radius (splashRadius = 40.0 &#47; 2 = 20.0)
  const defaultStateLayerRadius = 20.0;

  &#47;&#47; Material thumb toggle duration.
  &#47;&#47; Ускорили дефолт в демо&#47;проекте в 2 раза относительно Flutter (300ms → 150ms).
  const defaultThumbToggleDuration = Duration(milliseconds: 150);

  final isSelected = spec.value || q.isSelected;

  Color activeTrackColor;
  Color inactiveTrackColor;
  Color activeThumbColor;
  Color inactiveThumbColor;
  Color trackOutlineColor;

  final isInteraction = q.isPressed || q.isHovered || q.isFocused;

  if (q.isDisabled) {
    &#47;&#47; Matches Flutter _SwitchDefaultsM3:
    &#47;&#47; - track: selected -> onSurface 0.12, unselected -> surfaceContainerHighest 0.12
    &#47;&#47; - thumb: selected -> surface (opacity 1.0), unselected -> onSurface 0.38
    &#47;&#47; - outline: disabled -> onSurface 0.12
    activeTrackColor = scheme.onSurface.withValues(alpha: 0.12);
    inactiveTrackColor =
        scheme.surfaceContainerHighest.withValues(alpha: 0.12);
    activeThumbColor = scheme.surface;
    inactiveThumbColor = scheme.onSurface.withValues(alpha: 0.38);
    trackOutlineColor = scheme.onSurface.withValues(alpha: 0.12);
  } else {
    &#47;&#47; Matches Flutter _SwitchDefaultsM3:
    &#47;&#47; - track: selected -> primary, unselected -> surfaceContainerHighest
    &#47;&#47; - thumb (selected): onPrimary (normal), primaryContainer (pressed&#47;hovered&#47;focused)
    &#47;&#47; - thumb (unselected): outline (normal), onSurfaceVariant (pressed&#47;hovered&#47;focused)
    &#47;&#47; - outline: outline (unselected), transparent (selected) handled in renderer
    activeTrackColor = scheme.primary;
    inactiveTrackColor = scheme.surfaceContainerHighest;
    activeThumbColor =
        isInteraction ? scheme.primaryContainer : scheme.onPrimary;
    inactiveThumbColor =
        isInteraction ? scheme.onSurfaceVariant : scheme.outline;
    trackOutlineColor = scheme.outline;
  }

  final pressOverlayColor = isSelected
      ? scheme.primary.withValues(alpha: 0.12)
      : scheme.onSurface.withValues(alpha: 0.12);

  &#47;&#47; State layer color as WidgetStateProperty.
  &#47;&#47; Material 3 overlay opacities:
  &#47;&#47; - Pressed: 0.1 (10%)
  &#47;&#47; - Focused: 0.1 (10%)
  &#47;&#47; - Hovered: 0.08 (8%)
  final stateLayerColor = contractOverrides?.stateLayerColor ??
      WidgetStateProperty.resolveWith((states) {
        final baseColor = isSelected ? scheme.primary : scheme.onSurface;
        if (states.contains(WidgetState.pressed)) {
          return baseColor.withValues(alpha: 0.1);
        }
        if (states.contains(WidgetState.focused)) {
          return baseColor.withValues(alpha: 0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return baseColor.withValues(alpha: 0.08);
        }
        return Colors.transparent;
      });

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
    trackOutlineWidth:
        contractOverrides?.trackOutlineWidth ?? defaultTrackOutlineWidth,
    activeTrackColor: contractOverrides?.activeTrackColor ?? activeTrackColor,
    inactiveTrackColor:
        contractOverrides?.inactiveTrackColor ?? inactiveTrackColor,
    thumbSizeUnselected:
        contractOverrides?.thumbSizeUnselected ?? defaultThumbSizeUnselected,
    thumbSizeSelected:
        contractOverrides?.thumbSizeSelected ?? defaultThumbSizeSelected,
    thumbSizePressed:
        contractOverrides?.thumbSizePressed ?? defaultThumbSizePressed,
    thumbSizeTransition:
        contractOverrides?.thumbSizeTransition ?? defaultThumbSizeTransition,
    activeThumbColor: contractOverrides?.activeThumbColor ?? activeThumbColor,
    inactiveThumbColor:
        contractOverrides?.inactiveThumbColor ?? inactiveThumbColor,
    thumbPadding: contractOverrides?.thumbPadding ?? defaultThumbPadding,
    disabledOpacity: contractOverrides?.disabledOpacity ?? 1.0,
    pressOverlayColor:
        contractOverrides?.pressOverlayColor ?? pressOverlayColor,
    pressOpacity: contractOverrides?.pressOpacity ?? 1.0,
    minTapTargetSize: minTapTargetSize,
    stateLayerRadius:
        contractOverrides?.stateLayerRadius ?? defaultStateLayerRadius,
    stateLayerColor: stateLayerColor,
    thumbIcon: contractOverrides?.thumbIcon,
    motion: contractOverrides?.motion ??
        RSwitchMotionTokens(
          stateChangeDuration: motionTheme.button.stateChangeDuration,
          thumbSlideDuration: const Duration(milliseconds: 150),
          thumbToggleDuration: defaultThumbToggleDuration,
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

