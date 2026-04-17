---
title: "DropdownSelectionController<T>"
description: "API documentation for DropdownSelectionController<T> class from dropdown_selection_controller"
category: "Classes"
library: "dropdown_selection_controller"
outline: [2, 3]
---

# DropdownSelectionController\<T\> <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">DropdownSelectionController</span>&lt;T&gt;</div></div>

Controls dropdown selection, navigation, and typeahead.

Manages item highlighting, keyboard navigation with wrap-around,
and typeahead search functionality.

## Constructors {#section-constructors}

### DropdownSelectionController() {#ctor-dropdownselectioncontroller}

<div class="member-signature"><div class="member-signature-code"><span class="fn">DropdownSelectionController</span>(<a href="/api/src_presentation_dropdown_selection_controller/DropdownSelectionHost" class="type-link">DropdownSelectionHost</a>&lt;<span class="type">T</span>&gt; <span class="param">_host</span>)</div></div>

:::details Implementation
```dart
DropdownSelectionController(this._host);
```
:::

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_presentation_dropdown_selection_controller/DropdownSelectionController#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_presentation_dropdown_selection_controller/DropdownSelectionController#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_presentation_dropdown_selection_controller/DropdownSelectionController#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_presentation_dropdown_selection_controller/DropdownSelectionController#operator-equals).
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

If a subclass overrides [hashCode](/api/src_presentation_dropdown_selection_controller/DropdownSelectionController#prop-hashcode), it should override the
[operator ==](/api/src_presentation_dropdown_selection_controller/DropdownSelectionController#operator-equals) operator as well to maintain consistency.

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

### dispose() {#dispose}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">dispose</span>()</div></div>

Disposes controller resources.

:::details Implementation
```dart
void dispose() {
  _listbox.dispose();
}
```
:::

### findFirstEnabledIndex() {#findfirstenabledindex}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span>? <span class="fn">findFirstEnabledIndex</span>()</div></div>

Finds first enabled item index.

:::details Implementation
```dart
int? findFirstEnabledIndex() {
  final options = _host.options;
  for (var i = 0; i < options.length; i++) {
    if (!options[i].item.isDisabled) return i;
  }
  return null;
}
```
:::

### findLastEnabledIndex() {#findlastenabledindex}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span>? <span class="fn">findLastEnabledIndex</span>()</div></div>

Finds last enabled item index.

:::details Implementation
```dart
int? findLastEnabledIndex() {
  final options = _host.options;
  for (var i = options.length - 1; i >= 0; i--) {
    if (!options[i].item.isDisabled) return i;
  }
  return null;
}
```
:::

### findSelectedIndex() {#findselectedindex}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span>? <span class="fn">findSelectedIndex</span>()</div></div>

Finds index of currently selected value.

:::details Implementation
```dart
int? findSelectedIndex() {
  _syncItems();
  final id = _host.selectedId;
  if (id == null) return null;
  return _indexById[id];
}
```
:::

### handleTypeahead() {#handletypeahead}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">handleTypeahead</span>(<span class="type">String</span> <span class="param">char</span>)</div></div>

Handles typeahead character input.

:::details Implementation
```dart
void handleTypeahead(String char) {
  _syncItems();
  final currentIndex = _host.highlightedIndex;
  if (currentIndex != null) {
    final options = _host.options;
    if (currentIndex >= 0 && currentIndex < options.length) {
      _listbox.setHighlightedId(options[currentIndex].item.id);
    }
  }
  _listbox.handleTypeahead(char);
  _applyHighlightFromListbox();
}
```
:::

### highlightIndex() {#highlightindex}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">highlightIndex</span>(<span class="type">int</span> <span class="param">index</span>)</div></div>

Highlights item by index.

:::details Implementation
```dart
void highlightIndex(int index) {
  final options = _host.options;
  if (index < 0 || index >= options.length) return;
  final option = options[index];
  if (option.item.isDisabled) return;

  _host.updateHighlight(index);
  _syncItems();
  _listbox.setHighlightedId(option.item.id);
}
```
:::

### navigateDown() {#navigatedown}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">navigateDown</span>()</div></div>

Navigates to next enabled item (with wrap-around).

:::details Implementation
```dart
void navigateDown() {
  _syncItems();
  final currentIndex = _host.highlightedIndex;
  if (currentIndex != null) {
    final options = _host.options;
    if (currentIndex >= 0 && currentIndex < options.length) {
      _listbox.setHighlightedId(options[currentIndex].item.id);
    }
  }
  _listbox.highlightNext();
  _applyHighlightFromListbox();
}
```
:::

### navigateToFirst() {#navigatetofirst}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">navigateToFirst</span>()</div></div>

Navigates to first enabled item.

:::details Implementation
```dart
void navigateToFirst() {
  _syncItems();
  _listbox.highlightFirst();
  _applyHighlightFromListbox();
}
```
:::

### navigateToLast() {#navigatetolast}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">navigateToLast</span>()</div></div>

Navigates to last enabled item.

:::details Implementation
```dart
void navigateToLast() {
  _syncItems();
  _listbox.highlightLast();
  _applyHighlightFromListbox();
}
```
:::

### navigateUp() {#navigateup}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">navigateUp</span>()</div></div>

Navigates to previous enabled item (with wrap-around).

:::details Implementation
```dart
void navigateUp() {
  _syncItems();
  final currentIndex = _host.highlightedIndex;
  if (currentIndex != null) {
    final options = _host.options;
    if (currentIndex >= 0 && currentIndex < options.length) {
      _listbox.setHighlightedId(options[currentIndex].item.id);
    }
  }
  _listbox.highlightPrevious();
  _applyHighlightFromListbox();
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

### resetTypeahead() {#resettypeahead}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">resetTypeahead</span>()</div></div>

Resets typeahead state.

:::details Implementation
```dart
void resetTypeahead() {
  _listbox.resetTypeahead();
}
```
:::

### selectByIndex() {#selectbyindex}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">selectByIndex</span>(<span class="type">int</span> <span class="param">index</span>)</div></div>

Selects item by index and closes menu.

:::details Implementation
```dart
void selectByIndex(int index) {
  final options = _host.options;
  if (index < 0 || index >= options.length) return;
  final option = options[index];
  if (option.item.isDisabled) return;

  _host.onValueSelected(option.value);
  _host.closeMenu();
}
```
:::

### selectHighlighted() {#selecthighlighted}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">selectHighlighted</span>()</div></div>

Selects currently highlighted item.

:::details Implementation
```dart
void selectHighlighted() {
  final index = _host.highlightedIndex;
  if (index != null) {
    selectByIndex(index);
  }
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

