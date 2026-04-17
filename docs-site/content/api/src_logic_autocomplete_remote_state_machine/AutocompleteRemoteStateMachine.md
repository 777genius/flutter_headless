---
title: "AutocompleteRemoteStateMachine<T>"
description: "API documentation for AutocompleteRemoteStateMachine<T> class from autocomplete_remote_state_machine"
category: "Classes"
library: "autocomplete_remote_state_machine"
outline: [2, 3]
---

# AutocompleteRemoteStateMachine\<T\> <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">AutocompleteRemoteStateMachine</span>&lt;T&gt;</div></div>

Manages remote source state transitions with debounce, race handling, and caching.

State machine:

- idle: Initial state, no pending requests.
- loading: Request in flight.
- ready: Successful response received.
- error: Request failed.

Features:

- Debounce: Delays requests to avoid excessive API calls during typing.
- Race handling: Ignores stale responses using request IDs.
- Caching: Optionally caches successful results per query.

## Constructors {#section-constructors}

### AutocompleteRemoteStateMachine() {#ctor-autocompleteremotestatemachine}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="fn">AutocompleteRemoteStateMachine</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">Future</span>&lt;<span class="type">Iterable</span>&lt;<span class="type">T</span>&gt;&gt; <span class="type">Function</span>(<a href="/api/src_sources_r_autocomplete_remote_query/RAutocompleteRemoteQuery" class="type-link">RAutocompleteRemoteQuery</a>) <span class="param">load</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_sources_r_autocomplete_policies/RAutocompleteRemotePolicy" class="type-link">RAutocompleteRemotePolicy</a> <span class="param">policy</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">onStateChanged</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
AutocompleteRemoteStateMachine({
  required Future<Iterable<T>> Function(RAutocompleteRemoteQuery) load,
  required RAutocompleteRemotePolicy policy,
  required VoidCallback onStateChanged,
})  : _load = load,
      _policy = policy,
      _onStateChanged = onStateChanged {
  _initializeCache();
}
```
:::

## Properties {#section-properties}

### hasCachedResults <span class="docs-badge docs-badge-tip">no setter</span> {#prop-hascachedresults}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">hasCachedResults</span></div></div>

Whether the state machine has any cached results.

:::details Implementation
```dart
bool get hasCachedResults => _cache?.isNotEmpty ?? false;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_logic_autocomplete_remote_state_machine/AutocompleteRemoteStateMachine#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_logic_autocomplete_remote_state_machine/AutocompleteRemoteStateMachine#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_logic_autocomplete_remote_state_machine/AutocompleteRemoteStateMachine#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_logic_autocomplete_remote_state_machine/AutocompleteRemoteStateMachine#operator-equals).
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

If a subclass overrides [hashCode](/api/src_logic_autocomplete_remote_state_machine/AutocompleteRemoteStateMachine#prop-hashcode), it should override the
[operator ==](/api/src_logic_autocomplete_remote_state_machine/AutocompleteRemoteStateMachine#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### results <span class="docs-badge docs-badge-tip">no setter</span> {#prop-results}

<div class="member-signature"><div class="member-signature-code"><span class="type">List</span>&lt;<span class="type">T</span>&gt; <span class="kw">get</span> <span class="fn">results</span></div></div>

Current results from the remote source.

:::details Implementation
```dart
List<T> get results => _results;
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

### state <span class="docs-badge docs-badge-tip">no setter</span> {#prop-state}

<div class="member-signature"><div class="member-signature-code"><a href="/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteState" class="type-link">RAutocompleteRemoteState</a> <span class="kw">get</span> <span class="fn">state</span></div></div>

Current remote state.

:::details Implementation
```dart
RAutocompleteRemoteState get state => _state;
```
:::

## Methods {#section-methods}

### cancel() {#cancel}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">cancel</span>()</div></div>

Cancels any pending requests and resets to idle.

:::details Implementation
```dart
void cancel() {
  _cancelPending();
  _transitionToIdle();
}
```
:::

### clearError() {#clearerror}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">clearError</span>()</div></div>

Clears the current error state.

Moves state from error back to idle.

:::details Implementation
```dart
void clearError() {
  if (_state.status != RAutocompleteRemoteStatus.error) return;
  _transitionToIdle();
}
```
:::

### dispose() {#dispose}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">dispose</span>()</div></div>

Disposes the state machine, canceling pending requests.

:::details Implementation
```dart
void dispose() {
  _cancelPending();
}
```
:::

### load() {#load}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">void</span> <span class="fn">load</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">String</span> <span class="param">rawText</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_sources_r_autocomplete_remote_query/RAutocompleteRemoteTrigger" class="type-link">RAutocompleteRemoteTrigger</a> <span class="param">trigger</span>,</span><span class="member-signature-line">});</span></div></div>

Triggers a remote load for the given text.

Applies debounce, minQueryLength, and whitespace trimming according to policy.

:::details Implementation
```dart
void load({
  required String rawText,
  required RAutocompleteRemoteTrigger trigger,
}) {
  final queryPolicy = _policy.query;
  final trimmedText = queryPolicy.trimWhitespace ? rawText.trim() : rawText;

  if (trimmedText.length < queryPolicy.minQueryLength) {
    _cancelPending();
    &#47;&#47; Always clear results when below minQueryLength, regardless of
    &#47;&#47; keepPreviousResultsWhileLoading. Stale results for a longer query
    &#47;&#47; should not be shown when the query is too short.
    _results = const [];
    _transitionToIdle();
    return;
  }

  &#47;&#47; Check cache
  final cache = _cache;
  final cached = cache?[trimmedText];
  if (cached != null) {
    &#47;&#47; LRU touch
    cache!.remove(trimmedText);
    cache[trimmedText] = cached;
    _results = cached;
    _state = RAutocompleteRemoteState(
      status: RAutocompleteRemoteStatus.ready,
      queryText: trimmedText,
    );
    _onStateChanged();
    return;
  }

  &#47;&#47; Cancel any pending debounce
  _debounceTimer?.cancel();

  final debounce = _policy.debounce;
  if (debounce != null && debounce > Duration.zero) {
    _debounceTimer = Timer(debounce, () {
      _executeLoad(
          rawText: rawText, trimmedText: trimmedText, trigger: trigger);
    });
  } else {
    _executeLoad(
        rawText: rawText, trimmedText: trimmedText, trigger: trigger);
  }
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

### retry() {#retry}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">retry</span>()</div></div>

Retries the last failed request.

Only meaningful when current state is error.

:::details Implementation
```dart
void retry() {
  if (_state.status != RAutocompleteRemoteStatus.error) return;

  _executeLoad(
    rawText: _state.queryText,
    trimmedText: _state.queryText,
    trigger: RAutocompleteRemoteTrigger.keyboard,
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

