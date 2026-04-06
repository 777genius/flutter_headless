---
title: "AutocompleteSourceController<T>"
description: "API documentation for AutocompleteSourceController<T> class from autocomplete_source_controller"
category: "Classes"
library: "autocomplete_source_controller"
outline: [2, 3]
---

# AutocompleteSourceController\<T\> <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">AutocompleteSourceController</span>&lt;T&gt; <span class="kw">implements</span> <a href="/api/src_sources_r_autocomplete_remote_commands/RAutocompleteRemoteCommands" class="type-link">RAutocompleteRemoteCommands</a></div></div>

Unified controller for local, remote, and hybrid autocomplete sources.

Provides a consistent interface regardless of source type:

- Local: Synchronous filtering.
- Remote: Async with state machine.
- Hybrid: Combines local and remote results.

:::info Implemented types
- [RAutocompleteRemoteCommands](/api/src_sources_r_autocomplete_remote_commands/RAutocompleteRemoteCommands)
:::

## Constructors {#section-constructors}

### AutocompleteSourceController() {#ctor-autocompletesourcecontroller}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="fn">AutocompleteSourceController</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_sources_r_autocomplete_source/RAutocompleteSource" class="type-link">RAutocompleteSource</a>&lt;<span class="type">T</span>&gt; <span class="param">source</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">itemAdapter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">onStateChanged</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
AutocompleteSourceController({
  required RAutocompleteSource<T> source,
  required HeadlessItemAdapter<T> itemAdapter,
  required VoidCallback onStateChanged,
})  : _source = source,
      _itemAdapter = itemAdapter,
      _onStateChanged = onStateChanged {
  _initializeStateMachine();
}
```
:::

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_logic_autocomplete_source_controller/AutocompleteSourceController#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_logic_autocomplete_source_controller/AutocompleteSourceController#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_logic_autocomplete_source_controller/AutocompleteSourceController#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_logic_autocomplete_source_controller/AutocompleteSourceController#operator-equals).
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

If a subclass overrides [hashCode](/api/src_logic_autocomplete_source_controller/AutocompleteSourceController#prop-hashcode), it should override the
[operator ==](/api/src_logic_autocomplete_source_controller/AutocompleteSourceController#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### isLoading <span class="docs-badge docs-badge-tip">no setter</span> {#prop-isloading}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isLoading</span></div></div>

Whether currently loading remote data.

:::details Implementation
```dart
bool get isLoading {
  final machine = _remoteStateMachine;
  return machine != null &&
      machine.state.status == RAutocompleteRemoteStatus.loading;
}
```
:::

### remoteState <span class="docs-badge docs-badge-tip">no setter</span> {#prop-remotestate}

<div class="member-signature"><div class="member-signature-code"><a href="/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteState" class="type-link">RAutocompleteRemoteState</a>? <span class="kw">get</span> <span class="fn">remoteState</span></div></div>

Remote state for UI indicators.

Returns null for pure local sources.

:::details Implementation
```dart
RAutocompleteRemoteState? get remoteState => _remoteStateMachine?.state;
```
:::

### requestFeatures <span class="docs-badge docs-badge-tip">no setter</span> {#prop-requestfeatures}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="kw">get</span> <span class="fn">requestFeatures</span></div></div>

Request features containing remote state.

Used to pass state to renderers through the request pipeline.

:::details Implementation
```dart
HeadlessRequestFeatures get requestFeatures {
  final state = remoteState;
  if (state == null) return HeadlessRequestFeatures.empty;

  return HeadlessRequestFeatures.build((b) {
    b.set(rAutocompleteRemoteStateKey, state);
    b.set(rAutocompleteRemoteCommandsKey, this);
  });
}
```
:::

### results <span class="docs-badge docs-badge-tip">no setter</span> {#prop-results}

<div class="member-signature"><div class="member-signature-code"><span class="type">List</span>&lt;<span class="type">T</span>&gt; <span class="kw">get</span> <span class="fn">results</span></div></div>

Current results from all sources.

:::details Implementation
```dart
List<T> get results => _combinedResults;
```
:::

### resultsWithFeatures <span class="docs-badge docs-badge-tip">no setter</span> {#prop-resultswithfeatures}

<div class="member-signature"><div class="member-signature-code"><span class="type">List</span>&lt;<span class="type">Record</span>&gt; <span class="kw">get</span> <span class="fn">resultsWithFeatures</span></div></div>

Current results with source features (local/remote marking).

Each tuple contains (item, features) where features includes
[rAutocompleteItemSourceKey](/api/headless_autocomplete/rAutocompleteItemSourceKey) to identify the item's origin.

:::details Implementation
```dart
List<(T, HeadlessItemFeatures?)> get resultsWithFeatures =>
    _resultsWithFeatures;
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

### cancel() {#cancel}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">cancel</span>()</div></div>

Cancels any pending remote requests.

:::details Implementation
```dart
void cancel() {
  _remoteStateMachine?.cancel();
}
```
:::

### clearError() <span class="docs-badge docs-badge-info">override</span> {#clearerror}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">clearError</span>()</div></div>

Clear the current error state.

Moves remote state from error back to idle.

:::details Implementation
```dart
@override
void clearError() {
  _remoteStateMachine?.clearError();
}
```
:::

### dispose() {#dispose}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">dispose</span>()</div></div>

:::details Implementation
```dart
void dispose() {
  _remoteStateMachine?.dispose();
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

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">void</span> <span class="fn">resolve</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">text</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_sources_r_autocomplete_remote_query/RAutocompleteRemoteTrigger" class="type-link">RAutocompleteRemoteTrigger</a> <span class="param">trigger</span>,</span><span class="member-signature-line">});</span></div></div>

Resolves options for the given text.

For local sources, returns synchronously filtered results.
For remote/hybrid sources, triggers async loading.

:::details Implementation
```dart
void resolve({
  required TextEditingValue text,
  required RAutocompleteRemoteTrigger trigger,
}) {
  switch (_source) {
    case RAutocompleteLocalSource<T>(:final options, :final policy):
      final normalized = _normalizeLocalQuery(text, policy);
      _localResults = _resolveLocal(
        policy: policy,
        normalized: normalized,
        options: options,
      );
      _combinedResults = _localResults;
      _resultsWithFeatures =
          _markItems(_localResults, RAutocompleteItemSource.local);
      _onStateChanged();

    case RAutocompleteRemoteSource<T>():
      _triggerRemoteLoad(text: text, trigger: trigger);

    case RAutocompleteHybridSource<T>(:final local):
      &#47;&#47; Local is synchronous
      final normalized = _normalizeLocalQuery(text, local.policy);
      _localResults = _resolveLocal(
        policy: local.policy,
        normalized: normalized,
        options: local.options,
      );
      _combinedResults = _localResults;
      _resultsWithFeatures =
          _markItems(_localResults, RAutocompleteItemSource.local);
      _onStateChanged();

      &#47;&#47; Remote is async
      _triggerRemoteLoad(text: text, trigger: trigger);
  }
}
```
:::

### retry() <span class="docs-badge docs-badge-info">override</span> {#retry}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">retry</span>()</div></div>

Retry the last failed remote load.

Only meaningful when remote state is in error status.

:::details Implementation
```dart
@override
void retry() {
  _remoteStateMachine?.retry();
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

