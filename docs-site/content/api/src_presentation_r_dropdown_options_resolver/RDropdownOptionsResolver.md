---
title: "RDropdownOptionsResolver<T>"
description: "API documentation for RDropdownOptionsResolver<T> class from r_dropdown_options_resolver"
category: "Classes"
library: "r_dropdown_options_resolver"
outline: [2, 3]
---

# RDropdownOptionsResolver\<T\> <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RDropdownOptionsResolver</span>&lt;T&gt;</div></div>

## Constructors {#section-constructors}

### RDropdownOptionsResolver() {#ctor-rdropdownoptionsresolver}

<div class="member-signature"><div class="member-signature-code"><span class="fn">RDropdownOptionsResolver</span>()</div></div>

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_presentation_r_dropdown_options_resolver/RDropdownOptionsResolver#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_presentation_r_dropdown_options_resolver/RDropdownOptionsResolver#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_presentation_r_dropdown_options_resolver/RDropdownOptionsResolver#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_presentation_r_dropdown_options_resolver/RDropdownOptionsResolver#operator-equals).
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

If a subclass overrides [hashCode](/api/src_presentation_r_dropdown_options_resolver/RDropdownOptionsResolver#prop-hashcode), it should override the
[operator ==](/api/src_presentation_r_dropdown_options_resolver/RDropdownOptionsResolver#operator-equals) operator as well to maintain consistency.

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

### itemsForRender() {#itemsforrender}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">List</span>&lt;<span class="type">dynamic</span>&gt; <span class="fn">itemsForRender</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<span class="type">T</span>&gt;? <span class="param">items</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">itemAdapter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<a href="/api/src_presentation_r_dropdown_option/RDropdownOption" class="type-link">RDropdownOption</a>&lt;<span class="type">T</span>&gt;&gt;? <span class="param">options</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
List<HeadlessListItemModel> itemsForRender({
  required List<T>? items,
  required HeadlessItemAdapter<T>? itemAdapter,
  required List<RDropdownOption<T>>? options,
}) {
  final resolved = resolve(
    items: items,
    itemAdapter: itemAdapter,
    options: options,
  );
  if (identical(resolved, _cachedRenderSource) &&
      _cachedRenderItems != null &&
      _cachedRenderLength == resolved.length) {
    final signature = _signatureForOptions(resolved);
    if (_cachedRenderSignature == signature) {
      return _cachedRenderItems!;
    }
  }

  final signature = _signatureForOptions(resolved);
  final built = List<HeadlessListItemModel>.unmodifiable(
    resolved.map((option) => option.item),
  );
  _cachedRenderSource = resolved;
  _cachedRenderItems = built;
  _cachedRenderLength = resolved.length;
  _cachedRenderSignature = signature;
  return built;
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

### resolve() {#resolve}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">List</span>&lt;<a href="/api/src_presentation_r_dropdown_option/RDropdownOption" class="type-link">RDropdownOption</a>&lt;<span class="type">T</span>&gt;&gt; <span class="fn">resolve</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<span class="type">T</span>&gt;? <span class="param">items</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">itemAdapter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<a href="/api/src_presentation_r_dropdown_option/RDropdownOption" class="type-link">RDropdownOption</a>&lt;<span class="type">T</span>&gt;&gt;? <span class="param">options</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
List<RDropdownOption<T>> resolve({
  required List<T>? items,
  required HeadlessItemAdapter<T>? itemAdapter,
  required List<RDropdownOption<T>>? options,
}) {
  final explicitOptions = options;
  if (explicitOptions != null) {
    final signature = _signatureForOptions(explicitOptions);
    if (identical(_cachedExplicitSource, explicitOptions) &&
        _cachedExplicitLength == explicitOptions.length &&
        _cachedExplicitSignature == signature &&
        _cachedExplicitOptions != null) {
      return _cachedExplicitOptions!;
    }

    final built = List<RDropdownOption<T>>.unmodifiable(explicitOptions);
    _cachedExplicitOptions = built;
    _cachedExplicitSource = explicitOptions;
    _cachedExplicitLength = explicitOptions.length;
    _cachedExplicitSignature = signature;
    _cachedOptions = null;
    _cachedItems = null;
    _cachedAdapter = null;
    _cachedItemsLength = -1;
    _cachedItemsSignature = 0;
    assert(_assertUniqueOptionIds(built));
    return built;
  }

  final values = items!;
  final adapter = itemAdapter!;

  if (identical(_cachedItems, values) &&
      identical(_cachedAdapter, adapter) &&
      _cachedItemsLength == values.length &&
      _cachedOptions != null) {
    final signature = _signatureForItems(values);
    if (_cachedItemsSignature == signature) {
      return _cachedOptions!;
    }
  }

  final signature = _signatureForItems(values);
  final built = List<RDropdownOption<T>>.unmodifiable(
    values.map((value) => RDropdownOption(
          value: value,
          item: adapter.build(value),
        )),
  );

  _cachedItems = values;
  _cachedAdapter = adapter;
  _cachedItemsLength = values.length;
  _cachedItemsSignature = signature;
  _cachedOptions = built;
  assert(_assertUniqueOptionIds(built));
  return built;
}
```
:::

### selectedId() {#selectedid}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">dynamic</span> <span class="fn">selectedId</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">T</span>? <span class="param">value</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<span class="type">T</span>&gt;? <span class="param">items</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">itemAdapter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<a href="/api/src_presentation_r_dropdown_option/RDropdownOption" class="type-link">RDropdownOption</a>&lt;<span class="type">T</span>&gt;&gt;? <span class="param">options</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
ListboxItemId? selectedId({
  required T? value,
  required List<T>? items,
  required HeadlessItemAdapter<T>? itemAdapter,
  required List<RDropdownOption<T>>? options,
}) {
  if (value == null) return null;
  if (options != null) {
    for (final option in resolve(
      items: items,
      itemAdapter: itemAdapter,
      options: options,
    )) {
      if (option.value == value) return option.item.id;
    }
    return null;
  }

  final adapter = itemAdapter;
  if (adapter == null) return null;
  return adapter.id(value);
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

