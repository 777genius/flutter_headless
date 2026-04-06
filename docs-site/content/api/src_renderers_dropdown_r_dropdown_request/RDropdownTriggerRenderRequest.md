---
title: "RDropdownTriggerRenderRequest"
description: "API documentation for RDropdownTriggerRenderRequest class from r_dropdown_request"
category: "Classes"
library: "r_dropdown_request"
outline: [2, 3]
---

# RDropdownTriggerRenderRequest <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RDropdownTriggerRenderRequest</span> <span class="kw">extends</span> <a href="/api/src_renderers_dropdown_r_dropdown_request/RDropdownRenderRequest" class="type-link">RDropdownRenderRequest</a></div></div>

Render request for the dropdown trigger (anchor).

:::info Inheritance
Object → [RDropdownRenderRequest](/api/src_renderers_dropdown_r_dropdown_request/RDropdownRenderRequest) → **RDropdownTriggerRenderRequest**
:::

## Constructors {#section-constructors}

### RDropdownTriggerRenderRequest() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rdropdowntriggerrenderrequest}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RDropdownTriggerRenderRequest</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">context</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_renderers_dropdown_r_dropdown_spec/RDropdownButtonSpec" class="type-link">RDropdownButtonSpec</a> <span class="param">spec</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_renderers_dropdown_r_dropdown_state/RDropdownButtonState" class="type-link">RDropdownButtonState</a> <span class="param">state</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<span class="type">dynamic</span>&gt; <span class="param">items</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_renderers_dropdown_r_dropdown_commands/RDropdownCommands" class="type-link">RDropdownCommands</a> <span class="param">commands</span>,</span><span class="member-signature-line">  <a href="/api/src_renderers_dropdown_r_dropdown_semantics/RDropdownSemantics" class="type-link">RDropdownSemantics</a>? <span class="param">semantics</span>,</span><span class="member-signature-line">  <a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownButtonSlots" class="type-link">RDropdownButtonSlots</a>? <span class="param">slots</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">visualEffects</span>,</span><span class="member-signature-line">  <a href="/api/src_renderers_dropdown_r_dropdown_resolved_tokens/RDropdownResolvedTokens" class="type-link">RDropdownResolvedTokens</a>? <span class="param">resolvedTokens</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">constraints</span>,</span><span class="member-signature-line">  <a href="/api/src_renderers_render_overrides/RenderOverrides" class="type-link">RenderOverrides</a>? <span class="param">overrides</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">features</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const RDropdownTriggerRenderRequest({
  required super.context,
  required super.spec,
  required super.state,
  required super.items,
  required super.commands,
  super.semantics,
  super.slots,
  super.visualEffects,
  super.resolvedTokens,
  super.constraints,
  super.overrides,
  super.features,
});
```
:::

## Properties {#section-properties}

### commands <span class="docs-badge docs-badge-tip">final</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-commands}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_dropdown_r_dropdown_commands/RDropdownCommands" class="type-link">RDropdownCommands</a> <span class="fn">commands</span></div></div>

Internal component commands.

Renderer must not call application-level user callbacks directly.

*Inherited from RDropdownRenderRequest.*

:::details Implementation
```dart
final RDropdownCommands commands;
```
:::

### constraints <span class="docs-badge docs-badge-tip">final</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-constraints}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">constraints</span></div></div>

Layout constraints (e.g., minimum hit target, max menu height).

*Inherited from RDropdownRenderRequest.*

:::details Implementation
```dart
final BoxConstraints? constraints;
```
:::

### context <span class="docs-badge docs-badge-tip">final</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-context}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">context</span></div></div>

Build context for theme/media query access.

*Inherited from RDropdownRenderRequest.*

:::details Implementation
```dart
final BuildContext context;
```
:::

### features <span class="docs-badge docs-badge-tip">final</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-features}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">features</span></div></div>

Typed features for the request (e.g., remote loading state, error info).

Provides data that presets/slots can read to customize UI behavior.
Unlike [overrides](/api/src_renderers_dropdown_r_dropdown_request/RDropdownRenderRequest#prop-overrides), features carry data/state, not visual customization.

Example: autocomplete remote loading state is passed here so that
empty state slot can show "loading..." or "error + retry" UI.

*Inherited from RDropdownRenderRequest.*

:::details Implementation
```dart
final HeadlessRequestFeatures features;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_renderers_dropdown_r_dropdown_request/RDropdownTriggerRenderRequest#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_renderers_dropdown_r_dropdown_request/RDropdownTriggerRenderRequest#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_renderers_dropdown_r_dropdown_request/RDropdownTriggerRenderRequest#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_renderers_dropdown_r_dropdown_request/RDropdownTriggerRenderRequest#operator-equals).
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

If a subclass overrides [hashCode](/api/src_renderers_dropdown_r_dropdown_request/RDropdownTriggerRenderRequest#prop-hashcode), it should override the
[operator ==](/api/src_renderers_dropdown_r_dropdown_request/RDropdownTriggerRenderRequest#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### items <span class="docs-badge docs-badge-tip">final</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-items}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">List</span>&lt;<span class="type">dynamic</span>&gt; <span class="fn">items</span></div></div>

List of items to display in the menu.

*Inherited from RDropdownRenderRequest.*

:::details Implementation
```dart
final List<HeadlessListItemModel> items;
```
:::

### overrides <span class="docs-badge docs-badge-tip">final</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-overrides}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_render_overrides/RenderOverrides" class="type-link">RenderOverrides</a>? <span class="fn">overrides</span></div></div>

Per-instance override bag for preset customization.

Allows "style on this specific dropdown" without API pollution.
See `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`.

*Inherited from RDropdownRenderRequest.*

:::details Implementation
```dart
final RenderOverrides? overrides;
```
:::

### resolvedTokens <span class="docs-badge docs-badge-tip">final</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-resolvedtokens}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_dropdown_r_dropdown_resolved_tokens/RDropdownResolvedTokens" class="type-link">RDropdownResolvedTokens</a>? <span class="fn">resolvedTokens</span></div></div>

Pre-resolved visual tokens.

If provided, renderer should use these directly.
If null, renderer may use default theme values.

*Inherited from RDropdownRenderRequest.*

:::details Implementation
```dart
final RDropdownResolvedTokens? resolvedTokens;
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

### semantics <span class="docs-badge docs-badge-tip">final</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-semantics}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_dropdown_r_dropdown_semantics/RDropdownSemantics" class="type-link">RDropdownSemantics</a>? <span class="fn">semantics</span></div></div>

Semantic information for accessibility.

*Inherited from RDropdownRenderRequest.*

:::details Implementation
```dart
final RDropdownSemantics? semantics;
```
:::

### slots <span class="docs-badge docs-badge-tip">final</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-slots}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownButtonSlots" class="type-link">RDropdownButtonSlots</a>? <span class="fn">slots</span></div></div>

Optional slots for partial override (Replace/Decorate).

*Inherited from RDropdownRenderRequest.*

:::details Implementation
```dart
final RDropdownButtonSlots? slots;
```
:::

### spec <span class="docs-badge docs-badge-tip">final</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-spec}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_dropdown_r_dropdown_spec/RDropdownButtonSpec" class="type-link">RDropdownButtonSpec</a> <span class="fn">spec</span></div></div>

Static specification (variant, size, semantics).

*Inherited from RDropdownRenderRequest.*

:::details Implementation
```dart
final RDropdownButtonSpec spec;
```
:::

### state <span class="docs-badge docs-badge-tip">final</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-state}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_renderers_dropdown_r_dropdown_state/RDropdownButtonState" class="type-link">RDropdownButtonState</a> <span class="fn">state</span></div></div>

Current dropdown state (open, selection, highlight).

*Inherited from RDropdownRenderRequest.*

:::details Implementation
```dart
final RDropdownButtonState state;
```
:::

### visualEffects <span class="docs-badge docs-badge-tip">final</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-visualeffects}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">visualEffects</span></div></div>

Optional visual-only effects controller (pointer/hover/focus events).

Intended for trigger visuals (e.g., ripple/highlight) without activation.

*Inherited from RDropdownRenderRequest.*

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

