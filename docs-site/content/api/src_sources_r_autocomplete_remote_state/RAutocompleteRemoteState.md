---
title: "RAutocompleteRemoteState"
description: "API documentation for RAutocompleteRemoteState class from r_autocomplete_remote_state"
category: "Classes"
library: "r_autocomplete_remote_state"
outline: [2, 3]
---

# RAutocompleteRemoteState <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RAutocompleteRemoteState</span></div></div>

Current state of the remote source.

Passed to renderer via request features so slots can display
appropriate UI (loading indicator, error message, retry button, etc.).

Example usage in a slot:

```dart
final remoteState = ctx.features.get(rAutocompleteRemoteStateKey);
if (remoteState?.isLoading == true) {
  return CircularProgressIndicator();
}
if (remoteState?.isError == true) {
  return Column(
    children: [
      Text(remoteState.error?.message ?? 'Error'),
      TextButton(onPressed: onRetry, child: Text('Retry')),
    ],
  );
}
```

## Constructors {#section-constructors}

### RAutocompleteRemoteState() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rautocompleteremotestate}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RAutocompleteRemoteState</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteStatus" class="type-link">RAutocompleteRemoteStatus</a> <span class="param">status</span>,</span><span class="member-signature-line">  <span class="type">String</span> <span class="param">queryText</span> = <span class="str-lit">''</span>,</span><span class="member-signature-line">  <a href="/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteError" class="type-link">RAutocompleteRemoteError</a>? <span class="param">error</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">isStale</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">canRetry</span> = <span class="kw">false</span>,</span><span class="member-signature-line">})</span></div></div>

Creates a remote state with the given parameters.

:::details Implementation
```dart
const RAutocompleteRemoteState({
  required this.status,
  this.queryText = '',
  this.error,
  this.isStale = false,
  this.canRetry = false,
});
```
:::

## Properties {#section-properties}

### canRetry <span class="docs-badge docs-badge-tip">final</span> {#prop-canretry}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">canRetry</span></div></div>

Whether retry is available (only meaningful when [status](/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteState#prop-status) is error).

:::details Implementation
```dart
final bool canRetry;
```
:::

### error <span class="docs-badge docs-badge-tip">final</span> {#prop-error}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteError" class="type-link">RAutocompleteRemoteError</a>? <span class="fn">error</span></div></div>

Error information if [status](/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteState#prop-status) is [RAutocompleteRemoteStatus.error](/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteStatus#value-error).

:::details Implementation
```dart
final RAutocompleteRemoteError? error;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteState#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteState#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteState#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteState#operator-equals).
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

If a subclass overrides [hashCode](/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteState#prop-hashcode), it should override the
[operator ==](/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteState#operator-equals) operator as well to maintain consistency.

:::details Implementation
```dart
@override
int get hashCode => Object.hash(status, queryText, error, isStale, canRetry);
```
:::

### isError <span class="docs-badge docs-badge-tip">no setter</span> {#prop-iserror}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isError</span></div></div>

Whether the remote source has an error.

:::details Implementation
```dart
bool get isError => status == RAutocompleteRemoteStatus.error;
```
:::

### isIdle <span class="docs-badge docs-badge-tip">no setter</span> {#prop-isidle}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isIdle</span></div></div>

Whether the remote source is idle (not started or below minQueryLength).

:::details Implementation
```dart
bool get isIdle => status == RAutocompleteRemoteStatus.idle;
```
:::

### isLoading <span class="docs-badge docs-badge-tip">no setter</span> {#prop-isloading}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isLoading</span></div></div>

Whether the remote source is currently loading.

:::details Implementation
```dart
bool get isLoading => status == RAutocompleteRemoteStatus.loading;
```
:::

### isReady <span class="docs-badge docs-badge-tip">no setter</span> {#prop-isready}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isReady</span></div></div>

Whether the remote source has successfully loaded results.

:::details Implementation
```dart
bool get isReady => status == RAutocompleteRemoteStatus.ready;
```
:::

### isStale <span class="docs-badge docs-badge-tip">final</span> {#prop-isstale}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">isStale</span></div></div>

Whether the current results are stale (from a previous query).

True when showing cached results while a new load is in progress.

:::details Implementation
```dart
final bool isStale;
```
:::

### queryText <span class="docs-badge docs-badge-tip">final</span> {#prop-querytext}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span> <span class="fn">queryText</span></div></div>

The query text that was used for the current/last load.

:::details Implementation
```dart
final String queryText;
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

### status <span class="docs-badge docs-badge-tip">final</span> {#prop-status}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteStatus" class="type-link">RAutocompleteRemoteStatus</a> <span class="fn">status</span></div></div>

Current status of the remote source.

:::details Implementation
```dart
final RAutocompleteRemoteStatus status;
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

### toString() <span class="docs-badge docs-badge-info">override</span> {#tostring}

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

:::details Implementation
```dart
@override
String toString() => 'RAutocompleteRemoteState('
    'status: $status'
    '${queryText.isNotEmpty ? ', query: "$queryText"' : ''}'
    '${error != null ? ', error: $error' : ''}'
    '${isStale ? ', stale' : ''}'
    '${canRetry ? ', canRetry' : ''}'
    ')';
```
:::

## Operators {#section-operators}

### operator ==() <span class="docs-badge docs-badge-info">override</span> {#operator-equals}

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
the [hashCode](/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteState#prop-hashcode) method as well to maintain consistency.

:::details Implementation
```dart
@override
bool operator ==(Object other) {
  if (identical(this, other)) return true;
  return other is RAutocompleteRemoteState &&
      other.status == status &&
      other.queryText == queryText &&
      other.error == error &&
      other.isStale == isStale &&
      other.canRetry == canRetry;
}
```
:::

## Constants {#section-constants}

### idle {#prop-idle}

<div class="member-signature"><div class="member-signature-code"><span class="kw">const</span> <a href="/api/src_sources_r_autocomplete_remote_state/RAutocompleteRemoteState" class="type-link">RAutocompleteRemoteState</a> <span class="fn">idle</span></div></div>

Idle state constant (no remote load yet).

:::details Implementation
```dart
static const idle = RAutocompleteRemoteState(
  status: RAutocompleteRemoteStatus.idle,
);
```
:::

