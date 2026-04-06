---
title: "RButtonRenderRequest"
description: "API documentation for RButtonRenderRequest class from r_button_renderer"
category: "Classes"
library: "r_button_renderer"
outline: [2, 3]
---

# RButtonRenderRequest <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RButtonRenderRequest</span></div></div>

Render request containing everything a button renderer needs.

Follows the pattern: context + spec + state + semantics + slots + tokens + constraints.
Only includes what the renderer actually needs (perf + API stability).

See `docs/V1_DECISIONS.md` → "0.1 Renderer contracts".

## Constructors {#section-constructors}

### RButtonRenderRequest() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rbuttonrenderrequest}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RButtonRenderRequest</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">context</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_renderers_button_r_button_renderer/RButtonSpec" class="type-link">RButtonSpec</a> <span class="param">spec</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_renderers_button_r_button_renderer/RButtonState" class="type-link">RButtonState</a> <span class="param">state</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">content</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">leadingIcon</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">trailingIcon</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">spinner</span>,</span><span class="member-signature-line">  <a href="/api/src_renderers_button_r_button_semantics/RButtonSemantics" class="type-link">RButtonSemantics</a>? <span class="param">semantics</span>,</span><span class="member-signature-line">  <a href="/api/src_renderers_button_r_button_slots/RButtonSlots" class="type-link">RButtonSlots</a>? <span class="param">slots</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">visualEffects</span>,</span><span class="member-signature-line">  <a href="/api/src_renderers_button_r_button_resolved_tokens/RButtonResolvedTokens" class="type-link">RButtonResolvedTokens</a>? <span class="param">resolvedTokens</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">constraints</span>,</span><span class="member-signature-line">  <a href="/api/src_renderers_render_overrides/RenderOverrides" class="type-link">RenderOverrides</a>? <span class="param">overrides</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const RButtonRenderRequest({
  required this.context,
  required this.spec,
  required this.state,
  required this.content,
  this.leadingIcon,
  this.trailingIcon,
  this.spinner,
  this.semantics,
  this.slots,
  this.visualEffects,
  this.resolvedTokens,
  this.constraints,
  this.overrides,
});
```
:::

## Properties {#section-properties}

### constraints <span class="docs-badge docs-badge-tip">final</span> {#prop-constraints}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">constraints</span></div></div>

Visual layout constraints for the rendered button.

These are visual constraints only. Tap target sizing is handled
separately by [HeadlessTapTargetPolicy](/api/src_accessibility_headless_tap_target_policy/HeadlessTapTargetPolicy) at the component level.

:::details Implementation
```dart
final BoxConstraints? constraints;
```
:::

### content <span class="docs-badge docs-badge-tip">final</span> {#prop-content}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">content</span></div></div>

Default content widget provided by the component.

:::details Implementation
```dart
final Widget content;
```
:::

### context <span class="docs-badge docs-badge-tip">final</span> {#prop-context}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">context</span></div></div>

Build context for theme/media query access.

:::details Implementation
```dart
final BuildContext context;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_renderers_button_r_button_renderer/RButtonRenderRequest#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_renderers_button_r_button_renderer/RButtonRenderRequest#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_renderers_button_r_button_renderer/RButtonRenderRequest#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_renderers_button_r_button_renderer/RButtonRenderRequest#operator-equals).
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

If a subclass overrides [hashCode](/api/src_renderers_button_r_button_renderer/RButtonRenderRequest#prop-hashcode), it should override the
[operator ==](/api/src_renderers_button_r_button_renderer/RButtonRenderRequest#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### leadingIcon <span class="docs-badge docs-badge-tip">final</span> {#prop-leadingicon}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">leadingIcon</span></div></div>

Optional leading icon widget provided by the component.

:::details Implementation
```dart
final Widget? leadingIcon;
```
:::

### overrides <span class="docs-badge docs-badge-tip">final</span> {#prop-overrides}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_render_overrides/RenderOverrides" class="type-link">RenderOverrides</a>? <span class="fn">overrides</span></div></div>

Per-instance override bag for preset customization.

Allows "style on this specific button" without API pollution.
See `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`.

:::details Implementation
```dart
final RenderOverrides? overrides;
```
:::

### resolvedTokens <span class="docs-badge docs-badge-tip">final</span> {#prop-resolvedtokens}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_button_r_button_resolved_tokens/RButtonResolvedTokens" class="type-link">RButtonResolvedTokens</a>? <span class="fn">resolvedTokens</span></div></div>

Pre-resolved visual tokens.

If provided, renderer should use these directly.
If null, renderer may use default theme values.

:::details Implementation
```dart
final RButtonResolvedTokens? resolvedTokens;
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

### semantics <span class="docs-badge docs-badge-tip">final</span> {#prop-semantics}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_button_r_button_semantics/RButtonSemantics" class="type-link">RButtonSemantics</a>? <span class="fn">semantics</span></div></div>

Semantic information for accessibility.

Allows renderer to provide tooltip/aria hints if needed.

:::details Implementation
```dart
final RButtonSemantics? semantics;
```
:::

### slots <span class="docs-badge docs-badge-tip">final</span> {#prop-slots}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_button_r_button_slots/RButtonSlots" class="type-link">RButtonSlots</a>? <span class="fn">slots</span></div></div>

Optional slots for partial override (Replace/Decorate/Enhance).

:::details Implementation
```dart
final RButtonSlots? slots;
```
:::

### spec <span class="docs-badge docs-badge-tip">final</span> {#prop-spec}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_button_r_button_renderer/RButtonSpec" class="type-link">RButtonSpec</a> <span class="fn">spec</span></div></div>

Static specification (variant, size, semantics).

:::details Implementation
```dart
final RButtonSpec spec;
```
:::

### spinner <span class="docs-badge docs-badge-tip">final</span> {#prop-spinner}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">spinner</span></div></div>

Optional spinner widget provided by the component.

:::details Implementation
```dart
final Widget? spinner;
```
:::

### state <span class="docs-badge docs-badge-tip">final</span> {#prop-state}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_button_r_button_renderer/RButtonState" class="type-link">RButtonState</a> <span class="fn">state</span></div></div>

Current interaction state.

:::details Implementation
```dart
final RButtonState state;
```
:::

### trailingIcon <span class="docs-badge docs-badge-tip">final</span> {#prop-trailingicon}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">trailingIcon</span></div></div>

Optional trailing icon widget provided by the component.

:::details Implementation
```dart
final Widget? trailingIcon;
```
:::

### visualEffects <span class="docs-badge docs-badge-tip">final</span> {#prop-visualeffects}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">visualEffects</span></div></div>

Optional visual-only effects controller (pointer/hover/focus events).

Renderers may use this to drive ripple/highlight animations without
owning activation logic.

:::details Implementation
```dart
final HeadlessPressableVisualEffectsController? visualEffects;
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

