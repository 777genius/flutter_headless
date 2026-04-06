---
title: "AutocompleteCombiner<T>"
description: "API documentation for AutocompleteCombiner<T> class from autocomplete_combiner"
category: "Classes"
library: "autocomplete_combiner"
outline: [2, 3]
---

# AutocompleteCombiner\<T\> <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">AutocompleteCombiner</span>&lt;T&gt;</div></div>

Combines local and remote autocomplete results with deduplication.

Features:

- Deduplication by item ID (configurable preference for local or remote).
- Section markers for visual separation.
- Option to show remote only when local is empty.

## Constructors {#section-constructors}

### AutocompleteCombiner() <span class="docs-badge docs-badge-tip">const</span> {#ctor-autocompletecombiner}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">AutocompleteCombiner</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">itemAdapter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_sources_r_autocomplete_policies/RAutocompleteCombinePolicy" class="type-link">RAutocompleteCombinePolicy</a> <span class="param">policy</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const AutocompleteCombiner({
  required HeadlessItemAdapter<T> itemAdapter,
  required RAutocompleteCombinePolicy policy,
})  : _itemAdapter = itemAdapter,
      _policy = policy;
```
:::

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_logic_autocomplete_combiner/AutocompleteCombiner#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_logic_autocomplete_combiner/AutocompleteCombiner#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_logic_autocomplete_combiner/AutocompleteCombiner#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_logic_autocomplete_combiner/AutocompleteCombiner#operator-equals).
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

If a subclass overrides [hashCode](/api/src_logic_autocomplete_combiner/AutocompleteCombiner#prop-hashcode), it should override the
[operator ==](/api/src_logic_autocomplete_combiner/AutocompleteCombiner#operator-equals) operator as well to maintain consistency.

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

### combine() {#combine}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><a href="/api/src_logic_autocomplete_combiner/AutocompleteCombineResult" class="type-link">AutocompleteCombineResult</a>&lt;<span class="type">T</span>&gt; <span class="fn">combine</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<span class="type">T</span>&gt; <span class="param">local</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<span class="type">T</span>&gt; <span class="param">remote</span>,</span><span class="member-signature-line">});</span></div></div>

Combines local and remote results according to the policy.

Returns a [AutocompleteCombineResult](/api/src_logic_autocomplete_combiner/AutocompleteCombineResult) with combined items and counts.

:::details Implementation
```dart
AutocompleteCombineResult<T> combine({
  required List<T> local,
  required List<T> remote,
}) {
  return combineWithFeatures(local: local, remote: remote);
}
```
:::

### combineWithFeatures() {#combinewithfeatures}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><a href="/api/src_logic_autocomplete_combiner/AutocompleteCombineResult" class="type-link">AutocompleteCombineResult</a>&lt;<span class="type">T</span>&gt; <span class="fn">combineWithFeatures</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<span class="type">T</span>&gt; <span class="param">local</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<span class="type">T</span>&gt; <span class="param">remote</span>,</span><span class="member-signature-line">});</span></div></div>

Combines local and remote results and also returns aligned per-item features.

:::details Implementation
```dart
AutocompleteCombineResult<T> combineWithFeatures({
  required List<T> local,
  required List<T> remote,
}) {
  final showSections = _policy.showSections;
  final localSection = showSections ? RAutocompleteSectionId.local : null;
  final remoteSection = showSections ? RAutocompleteSectionId.remote : null;

  HeadlessItemFeatures localFeatures() => createItemFeatures(
      source: RAutocompleteItemSource.local, sectionId: localSection);
  HeadlessItemFeatures remoteFeatures() => createItemFeatures(
      source: RAutocompleteItemSource.remote, sectionId: remoteSection);

  if (_policy.remoteOnlyWhenLocalEmpty && local.isNotEmpty) {
    final lf = localFeatures();
    final withFeatures = local.map((v) => (v, lf)).toList();
    return AutocompleteCombineResult(
      combined: local,
      withFeatures: withFeatures,
      localCount: local.length,
      remoteCount: 0,
    );
  }

  if (!_policy.dedupeById) {
    final lf = localFeatures();
    final rf = remoteFeatures();
    final withFeatures = <(T, HeadlessItemFeatures)>[
      ...local.map((v) => (v, lf)),
      ...remote.map((v) => (v, rf)),
    ];
    return AutocompleteCombineResult(
      combined: [...local, ...remote],
      withFeatures: withFeatures,
      localCount: local.length,
      remoteCount: remote.length,
    );
  }

  final seenIds = <ListboxItemId>{};
  final withFeatures = <(T, HeadlessItemFeatures)>[];

  final preferLocal =
      _policy.dedupePreference == RAutocompleteDedupePreference.preferLocal;
  final first = preferLocal ? local : remote;
  final second = preferLocal ? remote : local;
  final firstFeatures = preferLocal ? localFeatures() : remoteFeatures();
  final secondFeatures = preferLocal ? remoteFeatures() : localFeatures();

  var firstCount = 0;
  for (final item in first) {
    final id = _itemAdapter.id(item);
    if (seenIds.add(id)) {
      withFeatures.add((item, firstFeatures));
      firstCount++;
    }
  }

  var secondCount = 0;
  for (final item in second) {
    final id = _itemAdapter.id(item);
    if (seenIds.add(id)) {
      withFeatures.add((item, secondFeatures));
      secondCount++;
    }
  }

  final (localCount, remoteCount) =
      preferLocal ? (firstCount, secondCount) : (secondCount, firstCount);

  return AutocompleteCombineResult(
    combined: withFeatures.map((r) => r.$1).toList(),
    withFeatures: withFeatures,
    localCount: localCount,
    remoteCount: remoteCount,
  );
}
```
:::

### createItemFeatures() {#createitemfeatures}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">dynamic</span> <span class="fn">createItemFeatures</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_sources_r_autocomplete_item_features/RAutocompleteItemSource" class="type-link">RAutocompleteItemSource</a> <span class="param">source</span>,</span><span class="member-signature-line">  <a href="/api/src_sources_r_autocomplete_item_features/RAutocompleteSectionId" class="type-link">RAutocompleteSectionId</a>? <span class="param">sectionId</span>,</span><span class="member-signature-line">});</span></div></div>

Creates item features for marking the source of an item.

Returns features with [RAutocompleteItemSource](/api/src_sources_r_autocomplete_item_features/RAutocompleteItemSource) and optionally section ID.

:::details Implementation
```dart
HeadlessItemFeatures createItemFeatures({
  required RAutocompleteItemSource source,
  RAutocompleteSectionId? sectionId,
}) {
  return HeadlessItemFeatures.build((b) {
    b.set(rAutocompleteItemSourceKey, source);
    if (sectionId != null) {
      b.set(rAutocompleteSectionIdKey, sectionId);
    }
  });
}
```
:::

### markWithSource() {#markwithsource}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">List</span>&lt;<span class="type">Record</span>&gt; <span class="fn">markWithSource</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<span class="type">T</span>&gt; <span class="param">items</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_sources_r_autocomplete_item_features/RAutocompleteItemSource" class="type-link">RAutocompleteItemSource</a> <span class="param">source</span>,</span><span class="member-signature-line">  <a href="/api/src_sources_r_autocomplete_item_features/RAutocompleteSectionId" class="type-link">RAutocompleteSectionId</a>? <span class="param">sectionId</span>,</span><span class="member-signature-line">});</span></div></div>

Marks a list of items with source features.

Returns a list of (item, features) pairs.

:::details Implementation
```dart
List<(T, HeadlessItemFeatures)> markWithSource({
  required List<T> items,
  required RAutocompleteItemSource source,
  RAutocompleteSectionId? sectionId,
}) {
  final features = createItemFeatures(source: source, sectionId: sectionId);
  return items.map((item) => (item, features)).toList();
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

