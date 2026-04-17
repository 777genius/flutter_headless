---
title: "MaterialTextFieldTokenResolver"
description: "API documentation for MaterialTextFieldTokenResolver class from material_text_field_token_resolver"
category: "Classes"
library: "material_text_field_token_resolver"
outline: [2, 3]
---

# MaterialTextFieldTokenResolver

<div class="member-signature"><div class="member-signature-code"><span class="kw">class</span> <span class="fn">MaterialTextFieldTokenResolver</span></div></div>

Material 3 token resolver for TextField components.

Provides resolved visual tokens consumed by the **component** (RTextField)
for `EditableText` configuration (textStyle, cursorColor, selectionColor).

NOTE: In Material parity mode, the **renderer** does NOT read these tokens.
Container, label, helper, and icon tokens are resolved but ignored by
`MaterialTextFieldRenderer` — `InputDecorator` provides M3 defaults directly.
These tokens remain for non-parity renderers and per-instance overrides.

Token resolution priority (v1):

1. Per-instance contract overrides: `overrides.get<RTextFieldOverrides>()`
2. Theme defaults / preset defaults

Deterministic: same inputs always produce same outputs.

## Constructors {#section-constructors}

### MaterialTextFieldTokenResolver() <span class="docs-badge docs-badge-tip">const</span> {#ctor-materialtextfieldtokenresolver}

<div class="member-signature"><div class="member-signature-code"><span class="kw">const</span> <span class="fn">MaterialTextFieldTokenResolver</span>({<span class="type">dynamic</span> <span class="param">colorScheme</span>, <span class="type">dynamic</span> <span class="param">textTheme</span>})</div></div>

Creates a Material text field token resolver.

`colorScheme` - Optional color scheme override.
`textTheme` - Optional text theme override.

:::details Implementation
```dart
const MaterialTextFieldTokenResolver({
  this.colorScheme,
  this.textTheme,
});
```
:::

## Properties {#section-properties}

### colorScheme <span class="docs-badge docs-badge-tip">final</span> {#prop-colorscheme}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">colorScheme</span></div></div>

Optional color scheme override.

:::details Implementation
```dart
final ColorScheme? colorScheme;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_textfield_material_text_field_token_resolver/MaterialTextFieldTokenResolver#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_textfield_material_text_field_token_resolver/MaterialTextFieldTokenResolver#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_textfield_material_text_field_token_resolver/MaterialTextFieldTokenResolver#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_textfield_material_text_field_token_resolver/MaterialTextFieldTokenResolver#operator-equals).
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

If a subclass overrides [hashCode](/api/src_textfield_material_text_field_token_resolver/MaterialTextFieldTokenResolver#prop-hashcode), it should override the
[operator ==](/api/src_textfield_material_text_field_token_resolver/MaterialTextFieldTokenResolver#operator-equals) operator as well to maintain consistency.

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

### textTheme <span class="docs-badge docs-badge-tip">final</span> {#prop-texttheme}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">textTheme</span></div></div>

Optional text theme override.

:::details Implementation
```dart
final TextTheme? textTheme;
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
RTextFieldResolvedTokens resolve({
  required BuildContext context,
  required RTextFieldSpec spec,
  required Set<WidgetState> states,
  BoxConstraints? constraints,
  RenderOverrides? overrides,
}) {
  &#47;&#47; Get theme from context or use overrides
  final scheme = colorScheme ?? Theme.of(context).colorScheme;
  final text = textTheme ?? Theme.of(context).textTheme;

  &#47;&#47; Get per-instance overrides (priority 1)
  final fieldOverrides = overrides?.get<RTextFieldOverrides>();

  &#47;&#47; Resolve state-dependent colors
  final q = HeadlessWidgetStateQuery(states);
  final isDisabled = q.isDisabled;
  final isFocused = q.isFocused;
  final isError = q.isError;

  final variant = spec.variant;

  &#47;&#47; Container colors
  final containerBackgroundColor = fieldOverrides?.containerBackgroundColor ??
      _resolveBackgroundColor(
        variant: variant,
        scheme: scheme,
      );
  final containerBorderColor = _resolveBorderColor(
    isError: isError,
    isFocused: isFocused,
    isDisabled: isDisabled,
    scheme: scheme,
    override: fieldOverrides?.containerBorderColor,
  );

  &#47;&#47; Text colors
  final textColor = fieldOverrides?.textColor ??
      (isDisabled
          ? scheme.onSurface.withValues(alpha: 0.38)
          : scheme.onSurface);
  final placeholderColor = fieldOverrides?.placeholderColor ??
      scheme.onSurfaceVariant.withValues(alpha: 0.6);

  &#47;&#47; Label colors
  final labelColor = fieldOverrides?.labelColor ??
      (isError
          ? scheme.error
          : isFocused
              ? scheme.primary
              : scheme.onSurfaceVariant);

  &#47;&#47; Helper&#47;error colors
  final helperColor = fieldOverrides?.helperColor ?? scheme.onSurfaceVariant;
  final errorColor = fieldOverrides?.errorColor ?? scheme.error;

  &#47;&#47; Cursor&#47;selection
  final cursorColor = fieldOverrides?.cursorColor ??
      (isError ? scheme.error : scheme.primary);
  final selectionColor =
      fieldOverrides?.selectionColor ?? scheme.primary.withValues(alpha: 0.4);

  &#47;&#47; Icon color
  final iconColor = fieldOverrides?.iconColor ??
      (isDisabled
          ? scheme.onSurface.withValues(alpha: 0.38)
          : scheme.onSurfaceVariant);

  &#47;&#47; Text styles
  final bodyStyle = text.bodyLarge ?? const TextStyle(fontSize: 16);
  final labelStyle = text.bodySmall ?? const TextStyle(fontSize: 12);
  final helperStyle = text.bodySmall ?? const TextStyle(fontSize: 12);

  return RTextFieldResolvedTokens(
    &#47;&#47; Container
    containerPadding: fieldOverrides?.containerPadding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    containerBackgroundColor: containerBackgroundColor,
    containerBorderColor: containerBorderColor,
    containerBorderRadius: fieldOverrides?.containerBorderRadius ??
        _resolveBorderRadius(variant: variant),
    containerBorderWidth: fieldOverrides?.containerBorderWidth ?? 1.0,
    containerElevation: fieldOverrides?.containerElevation ?? 0.0,
    containerAnimationDuration: fieldOverrides?.containerAnimationDuration ??
        const Duration(milliseconds: 200),
    &#47;&#47; Label &#47; Helper &#47; Error
    labelStyle: fieldOverrides?.labelStyle ?? labelStyle,
    labelColor: labelColor,
    helperStyle: fieldOverrides?.helperStyle ?? helperStyle,
    helperColor: helperColor,
    errorStyle: fieldOverrides?.errorStyle ?? helperStyle,
    errorColor: errorColor,
    messageSpacing: fieldOverrides?.messageSpacing ?? 4.0,
    &#47;&#47; Input
    textStyle: fieldOverrides?.textStyle ?? bodyStyle,
    textColor: textColor,
    placeholderStyle: fieldOverrides?.placeholderStyle ?? bodyStyle,
    placeholderColor: placeholderColor,
    cursorColor: cursorColor,
    selectionColor: selectionColor,
    disabledOpacity: 0.38,
    &#47;&#47; Icons &#47; Slots
    iconColor: iconColor,
    iconSpacing: fieldOverrides?.iconSpacing ?? 12.0,
    &#47;&#47; Sizing
    minSize: fieldOverrides?.minSize ?? Size.zero,
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

