---
title: "RDropdownButtonSlots"
description: "API documentation for RDropdownButtonSlots class from r_dropdown_slots"
category: "Classes"
library: "r_dropdown_slots"
outline: [2, 3]
---

# RDropdownButtonSlots <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RDropdownButtonSlots</span></div></div>

Dropdown slots for partial customization (Replace/Decorate pattern).

Allows overriding specific visual parts without reimplementing
the entire renderer.

Slot policy (v1):

- Prefer [Decorate](/api/src_slots_slot_override/Decorate)/[Enhance](/api/src_slots_slot_override/Enhance) to preserve default structure/semantics.
- [Replace](/api/src_slots_slot_override/Replace) is a full takeover and must preserve essential behavior
(e.g. item tap should still call commands, menu close contract must still
be respected by the renderer).

See `docs/V1_DECISIONS.md` → "4) Renderer contracts + Slots override".

## Constructors {#section-constructors}

### RDropdownButtonSlots() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rdropdownbuttonslots}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RDropdownButtonSlots</span>({</span><span class="member-signature-line">  <a href="/api/src_slots_slot_override/SlotOverride" class="type-link">SlotOverride</a>&lt;<a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownAnchorContext" class="type-link">RDropdownAnchorContext</a>&gt;? <span class="param">anchor</span>,</span><span class="member-signature-line">  <a href="/api/src_slots_slot_override/SlotOverride" class="type-link">SlotOverride</a>&lt;<a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownChevronContext" class="type-link">RDropdownChevronContext</a>&gt;? <span class="param">chevron</span>,</span><span class="member-signature-line">  <a href="/api/src_slots_slot_override/SlotOverride" class="type-link">SlotOverride</a>&lt;<a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownMenuContext" class="type-link">RDropdownMenuContext</a>&gt;? <span class="param">menu</span>,</span><span class="member-signature-line">  <a href="/api/src_slots_slot_override/SlotOverride" class="type-link">SlotOverride</a>&lt;<a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownItemContext" class="type-link">RDropdownItemContext</a>&gt;? <span class="param">item</span>,</span><span class="member-signature-line">  <a href="/api/src_slots_slot_override/SlotOverride" class="type-link">SlotOverride</a>&lt;<a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownItemContentContext" class="type-link">RDropdownItemContentContext</a>&gt;? <span class="param">itemContent</span>,</span><span class="member-signature-line">  <a href="/api/src_slots_slot_override/SlotOverride" class="type-link">SlotOverride</a>&lt;<a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownMenuSurfaceContext" class="type-link">RDropdownMenuSurfaceContext</a>&gt;? <span class="param">menuSurface</span>,</span><span class="member-signature-line">  <a href="/api/src_slots_slot_override/SlotOverride" class="type-link">SlotOverride</a>&lt;<a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownMenuContext" class="type-link">RDropdownMenuContext</a>&gt;? <span class="param">emptyState</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const RDropdownButtonSlots({
  this.anchor,
  this.chevron,
  this.menu,
  this.item,
  this.itemContent,
  this.menuSurface,
  this.emptyState,
});
```
:::

## Properties {#section-properties}

### anchor <span class="docs-badge docs-badge-tip">final</span> {#prop-anchor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_slots_slot_override/SlotOverride" class="type-link">SlotOverride</a>&lt;<a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownAnchorContext" class="type-link">RDropdownAnchorContext</a>&gt;? <span class="fn">anchor</span></div></div>

Override for the trigger button.

:::details Implementation
```dart
final SlotOverride<RDropdownAnchorContext>? anchor;
```
:::

### chevron <span class="docs-badge docs-badge-tip">final</span> {#prop-chevron}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_slots_slot_override/SlotOverride" class="type-link">SlotOverride</a>&lt;<a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownChevronContext" class="type-link">RDropdownChevronContext</a>&gt;? <span class="fn">chevron</span></div></div>

Override for the chevron icon inside the trigger.

:::details Implementation
```dart
final SlotOverride<RDropdownChevronContext>? chevron;
```
:::

### emptyState <span class="docs-badge docs-badge-tip">final</span> {#prop-emptystate}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_slots_slot_override/SlotOverride" class="type-link">SlotOverride</a>&lt;<a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownMenuContext" class="type-link">RDropdownMenuContext</a>&gt;? <span class="fn">emptyState</span></div></div>

Override for empty state when the item list is empty.

:::details Implementation
```dart
final SlotOverride<RDropdownMenuContext>? emptyState;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_renderers_dropdown_r_dropdown_slots/RDropdownButtonSlots#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_renderers_dropdown_r_dropdown_slots/RDropdownButtonSlots#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_renderers_dropdown_r_dropdown_slots/RDropdownButtonSlots#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_renderers_dropdown_r_dropdown_slots/RDropdownButtonSlots#operator-equals).
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

If a subclass overrides [hashCode](/api/src_renderers_dropdown_r_dropdown_slots/RDropdownButtonSlots#prop-hashcode), it should override the
[operator ==](/api/src_renderers_dropdown_r_dropdown_slots/RDropdownButtonSlots#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### item <span class="docs-badge docs-badge-tip">final</span> {#prop-item}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_slots_slot_override/SlotOverride" class="type-link">SlotOverride</a>&lt;<a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownItemContext" class="type-link">RDropdownItemContext</a>&gt;? <span class="fn">item</span></div></div>

Override for individual items.

:::details Implementation
```dart
final SlotOverride<RDropdownItemContext>? item;
```
:::

### itemContent <span class="docs-badge docs-badge-tip">final</span> {#prop-itemcontent}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_slots_slot_override/SlotOverride" class="type-link">SlotOverride</a>&lt;<a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownItemContentContext" class="type-link">RDropdownItemContentContext</a>&gt;? <span class="fn">itemContent</span></div></div>

Override for item content inside the menu item.

:::details Implementation
```dart
final SlotOverride<RDropdownItemContentContext>? itemContent;
```
:::

### menu <span class="docs-badge docs-badge-tip">final</span> {#prop-menu}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_slots_slot_override/SlotOverride" class="type-link">SlotOverride</a>&lt;<a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownMenuContext" class="type-link">RDropdownMenuContext</a>&gt;? <span class="fn">menu</span></div></div>

Override for the menu (list of items).

:::details Implementation
```dart
final SlotOverride<RDropdownMenuContext>? menu;
```
:::

### menuSurface <span class="docs-badge docs-badge-tip">final</span> {#prop-menusurface}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_slots_slot_override/SlotOverride" class="type-link">SlotOverride</a>&lt;<a href="/api/src_renderers_dropdown_r_dropdown_slots/RDropdownMenuSurfaceContext" class="type-link">RDropdownMenuSurfaceContext</a>&gt;? <span class="fn">menuSurface</span></div></div>

Override for the menu surface (background/container).

:::details Implementation
```dart
final SlotOverride<RDropdownMenuSurfaceContext>? menuSurface;
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

