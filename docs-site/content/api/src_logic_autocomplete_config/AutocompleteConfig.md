---
title: "AutocompleteConfig<T>"
description: "API documentation for AutocompleteConfig<T> class from autocomplete_config"
category: "Classes"
library: "autocomplete_config"
outline: [2, 3]
---

# AutocompleteConfig\<T\> <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">AutocompleteConfig</span>&lt;T&gt;</div></div>

## Constructors {#section-constructors}

### AutocompleteConfig() <span class="docs-badge docs-badge-tip">const</span> {#ctor-autocompleteconfig}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">AutocompleteConfig</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">Iterable</span>&lt;<span class="type">T</span>&gt; <span class="type">Function</span>(<span class="type">dynamic</span> <span class="param">textEditingValue</span>) <span class="param">optionsBuilder</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">localCacheEnabled</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">itemAdapter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">disabled</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_logic_autocomplete_selection_mode/AutocompleteSelectionMode" class="type-link">AutocompleteSelectionMode</a>&lt;<span class="type">T</span>&gt; <span class="param">selectionMode</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">openOnFocus</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">openOnInput</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">openOnTap</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">closeOnSelected</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">int</span>? <span class="param">maxOptions</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">String</span>? <span class="param">placeholder</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">String</span>? <span class="param">semanticLabel</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">menuSlots</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">menuOverrides</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">clearQueryOnSelection</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">hideSelectedOptions</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">pinSelectedOptions</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_sources_r_autocomplete_source/RAutocompleteSource" class="type-link">RAutocompleteSource</a>&lt;<span class="type">T</span>&gt; <span class="param">source</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const AutocompleteConfig({
  required this.optionsBuilder,
  required this.localCacheEnabled,
  required this.itemAdapter,
  required this.disabled,
  required this.selectionMode,
  required this.openOnFocus,
  required this.openOnInput,
  required this.openOnTap,
  required this.closeOnSelected,
  required this.maxOptions,
  required this.placeholder,
  required this.semanticLabel,
  required this.menuSlots,
  required this.menuOverrides,
  required this.clearQueryOnSelection,
  required this.hideSelectedOptions,
  required this.pinSelectedOptions,
  required this.source,
});
```
:::

## Properties {#section-properties}

### clearQueryOnSelection <span class="docs-badge docs-badge-tip">final</span> {#prop-clearqueryonselection}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">clearQueryOnSelection</span></div></div>

Clears the query text after a successful selection.

For multiple mode this is typically true.

:::details Implementation
```dart
final bool clearQueryOnSelection;
```
:::

### closeOnSelected <span class="docs-badge docs-badge-tip">final</span> {#prop-closeonselected}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">closeOnSelected</span></div></div>

:::details Implementation
```dart
final bool closeOnSelected;
```
:::

### disabled <span class="docs-badge docs-badge-tip">final</span> {#prop-disabled}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">disabled</span></div></div>

:::details Implementation
```dart
final bool disabled;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_logic_autocomplete_config/AutocompleteConfig#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_logic_autocomplete_config/AutocompleteConfig#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_logic_autocomplete_config/AutocompleteConfig#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_logic_autocomplete_config/AutocompleteConfig#operator-equals).
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

If a subclass overrides [hashCode](/api/src_logic_autocomplete_config/AutocompleteConfig#prop-hashcode), it should override the
[operator ==](/api/src_logic_autocomplete_config/AutocompleteConfig#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### hideSelectedOptions <span class="docs-badge docs-badge-tip">final</span> {#prop-hideselectedoptions}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">hideSelectedOptions</span></div></div>

Whether to hide already-selected options from the menu (multiple mode).

:::details Implementation
```dart
final bool hideSelectedOptions;
```
:::

### isDisabled <span class="docs-badge docs-badge-tip">no setter</span> {#prop-isdisabled}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isDisabled</span></div></div>

:::details Implementation
```dart
bool get isDisabled => disabled || selectionMode.isDisabled;
```
:::

### itemAdapter <span class="docs-badge docs-badge-tip">final</span> {#prop-itemadapter}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">itemAdapter</span></div></div>

:::details Implementation
```dart
final HeadlessItemAdapter<T> itemAdapter;
```
:::

### localCacheEnabled <span class="docs-badge docs-badge-tip">final</span> {#prop-localcacheenabled}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">localCacheEnabled</span></div></div>

:::details Implementation
```dart
final bool localCacheEnabled;
```
:::

### maxOptions <span class="docs-badge docs-badge-tip">final</span> {#prop-maxoptions}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">int</span>? <span class="fn">maxOptions</span></div></div>

:::details Implementation
```dart
final int? maxOptions;
```
:::

### menuOverrides <span class="docs-badge docs-badge-tip">final</span> {#prop-menuoverrides}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">menuOverrides</span></div></div>

:::details Implementation
```dart
final RenderOverrides? menuOverrides;
```
:::

### menuSlots <span class="docs-badge docs-badge-tip">final</span> {#prop-menuslots}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">menuSlots</span></div></div>

:::details Implementation
```dart
final RDropdownButtonSlots? menuSlots;
```
:::

### needsSourceController <span class="docs-badge docs-badge-tip">no setter</span> {#prop-needssourcecontroller}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">needsSourceController</span></div></div>

Whether this config requires a source controller for async operations.

:::details Implementation
```dart
bool get needsSourceController {
  final s = source;
  return s is RAutocompleteRemoteSource<T> ||
      s is RAutocompleteHybridSource<T>;
}
```
:::

### openOnFocus <span class="docs-badge docs-badge-tip">final</span> {#prop-openonfocus}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">openOnFocus</span></div></div>

:::details Implementation
```dart
final bool openOnFocus;
```
:::

### openOnInput <span class="docs-badge docs-badge-tip">final</span> {#prop-openoninput}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">openOnInput</span></div></div>

:::details Implementation
```dart
final bool openOnInput;
```
:::

### openOnTap <span class="docs-badge docs-badge-tip">final</span> {#prop-openontap}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">openOnTap</span></div></div>

:::details Implementation
```dart
final bool openOnTap;
```
:::

### optionsBuilder <span class="docs-badge docs-badge-tip">final</span> {#prop-optionsbuilder}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">Iterable</span>&lt;<span class="type">T</span>&gt; <span class="type">Function</span>(<span class="type">dynamic</span> <span class="param">textEditingValue</span>) <span class="fn">optionsBuilder</span></div></div>

:::details Implementation
```dart
final Iterable<T> Function(TextEditingValue textEditingValue) optionsBuilder;
```
:::

### pinSelectedOptions <span class="docs-badge docs-badge-tip">final</span> {#prop-pinselectedoptions}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">pinSelectedOptions</span></div></div>

Whether to pin selected options to the top of the menu (multiple mode).

:::details Implementation
```dart
final bool pinSelectedOptions;
```
:::

### placeholder <span class="docs-badge docs-badge-tip">final</span> {#prop-placeholder}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span>? <span class="fn">placeholder</span></div></div>

:::details Implementation
```dart
final String? placeholder;
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

### selectionMode <span class="docs-badge docs-badge-tip">final</span> {#prop-selectionmode}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_logic_autocomplete_selection_mode/AutocompleteSelectionMode" class="type-link">AutocompleteSelectionMode</a>&lt;<span class="type">T</span>&gt; <span class="fn">selectionMode</span></div></div>

:::details Implementation
```dart
final AutocompleteSelectionMode<T> selectionMode;
```
:::

### semanticLabel <span class="docs-badge docs-badge-tip">final</span> {#prop-semanticlabel}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span>? <span class="fn">semanticLabel</span></div></div>

:::details Implementation
```dart
final String? semanticLabel;
```
:::

### source <span class="docs-badge docs-badge-tip">final</span> {#prop-source}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_sources_r_autocomplete_source/RAutocompleteSource" class="type-link">RAutocompleteSource</a>&lt;<span class="type">T</span>&gt; <span class="fn">source</span></div></div>

Source-first API for autocomplete data.

When provided, enables remote/hybrid modes with full state management.
For local sources, [optionsBuilder](/api/src_logic_autocomplete_config/AutocompleteConfig#prop-optionsbuilder) is still used for filtering.

:::details Implementation
```dart
final RAutocompleteSource<T> source;
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

