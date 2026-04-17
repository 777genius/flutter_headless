---
title: "AutocompleteSingleSelectionController<T>"
description: "API documentation for AutocompleteSingleSelectionController<T> class from autocomplete_selection_controller"
category: "Classes"
library: "autocomplete_selection_controller"
outline: [2, 3]
---

# AutocompleteSingleSelectionController\<T\> <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">AutocompleteSingleSelectionController</span>&lt;T&gt; <span class="kw">implements</span> <a href="/api/src_logic_autocomplete_selection_controller/AutocompleteSelectionController" class="type-link">AutocompleteSelectionController</a>&lt;<span class="type">T</span>&gt;</div></div>

:::info Implemented types
- [AutocompleteSelectionController\<T\>](/api/src_logic_autocomplete_selection_controller/AutocompleteSelectionController)
:::

## Constructors {#section-constructors}

### AutocompleteSingleSelectionController() {#ctor-autocompletesingleselectioncontroller}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="fn">AutocompleteSingleSelectionController</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">controller</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">itemAdapter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">onSelected</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">clearQueryOnSelection</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">notifyStateChanged</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
AutocompleteSingleSelectionController({
  required TextEditingController controller,
  required HeadlessItemAdapter<T> itemAdapter,
  required ValueChanged<T>? onSelected,
  required bool clearQueryOnSelection,
  required VoidCallback notifyStateChanged,
})  : _controller = controller,
      _itemAdapter = itemAdapter,
      _onSelected = onSelected,
      _clearQueryOnSelection = clearQueryOnSelection,
      _notifyStateChanged = notifyStateChanged;
```
:::

## Properties {#section-properties}

### committedText <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-committedtext}

<div class="member-signature"><div class="member-signature-code"><span class="type">String</span>? <span class="kw">get</span> <span class="fn">committedText</span></div></div>

:::details Implementation
```dart
@override
String? get committedText => _lastSelectedText;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_logic_autocomplete_selection_controller/AutocompleteSingleSelectionController#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_logic_autocomplete_selection_controller/AutocompleteSingleSelectionController#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_logic_autocomplete_selection_controller/AutocompleteSingleSelectionController#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_logic_autocomplete_selection_controller/AutocompleteSingleSelectionController#operator-equals).
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

If a subclass overrides [hashCode](/api/src_logic_autocomplete_selection_controller/AutocompleteSingleSelectionController#prop-hashcode), it should override the
[operator ==](/api/src_logic_autocomplete_selection_controller/AutocompleteSingleSelectionController#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### highlightedIndex <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-highlightedindex}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span>? <span class="kw">get</span> <span class="fn">highlightedIndex</span></div></div>

:::details Implementation
```dart
@override
int? get highlightedIndex => _indexById[_listbox.highlightedId];
```
:::

### isApplyingSelectionText <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-isapplyingselectiontext}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isApplyingSelectionText</span></div></div>

:::details Implementation
```dart
@override
bool get isApplyingSelectionText => _isApplyingSelectionText;
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

### selectedId <span class="docs-badge docs-badge-tip">no setter</span> {#prop-selectedid}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="kw">get</span> <span class="fn">selectedId</span></div></div>

:::details Implementation
```dart
ListboxItemId? get selectedId => _selectedId;
```
:::

### selectedIds <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-selectedids}

<div class="member-signature"><div class="member-signature-code"><span class="type">Iterable</span>&lt;<span class="type">dynamic</span>&gt; <span class="kw">get</span> <span class="fn">selectedIds</span></div></div>

:::details Implementation
```dart
@override
Iterable<ListboxItemId> get selectedIds => _selectedId == null
    ? const <ListboxItemId>[]
    : <ListboxItemId>[_selectedId!];
```
:::

### selectedIndex <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-selectedindex}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span>? <span class="kw">get</span> <span class="fn">selectedIndex</span></div></div>

:::details Implementation
```dart
@override
int? get selectedIndex => _indexById[_selectedId];
```
:::

### selectedItemsIndices <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-selecteditemsindices}

<div class="member-signature"><div class="member-signature-code"><span class="type">Set</span>&lt;<span class="type">int</span>&gt;? <span class="kw">get</span> <span class="fn">selectedItemsIndices</span></div></div>

:::details Implementation
```dart
@override
Set<int>? get selectedItemsIndices => null;
```
:::

## Methods {#section-methods}

### dispose() <span class="docs-badge docs-badge-info">override</span> {#dispose}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">dispose</span>()</div></div>

:::details Implementation
```dart
@override
void dispose() {
  _listbox.dispose();
}
```
:::

### handleTextChanged() <span class="docs-badge docs-badge-info">override</span> {#handletextchanged}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="fn">handleTextChanged</span>(<span class="type">dynamic</span> <span class="param">value</span>)</div></div>

:::details Implementation
```dart
@override
bool handleTextChanged(TextEditingValue value) {
  final text = value.text;
  if (text == _lastText) return false;

  _lastText = text;
  if (_isApplyingSelectionText) {
    return false;
  }
  final committed = _lastSelectedText;
  if (_selectedId != null && committed != null) {
    if (text.isEmpty) {
      _selectedId = null;
      _lastSelectedText = null;
      _listbox.setSelectedId(null);
    } else {
      final keepSelected =
          committed.toLowerCase().startsWith(text.toLowerCase());
      if (!keepSelected) {
        _selectedId = null;
        _lastSelectedText = null;
        _listbox.setSelectedId(null);
      }
    }
  }
  return true;
}
```
:::

### highlightIndex() <span class="docs-badge docs-badge-info">override</span> {#highlightindex}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">highlightIndex</span>(<span class="type">int</span> <span class="param">index</span>)</div></div>

:::details Implementation
```dart
@override
void highlightIndex(int index) {
  if (index < 0 || index >= _items.length) return;
  final item = _items[index];
  if (item.isDisabled) return;
  _listbox.setHighlightedId(item.id);
}
```
:::

### navigateDown() <span class="docs-badge docs-badge-info">override</span> {#navigatedown}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">navigateDown</span>()</div></div>

:::details Implementation
```dart
@override
void navigateDown() {
  syncAutocompleteHighlightedId(
    listbox: _listbox,
    highlightedIndex: highlightedIndex,
    indexById: _indexById,
    items: _items,
    preferredId: _selectedId,
  );
  _listbox.highlightNext();
}
```
:::

### navigateToFirst() <span class="docs-badge docs-badge-info">override</span> {#navigatetofirst}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">navigateToFirst</span>()</div></div>

:::details Implementation
```dart
@override
void navigateToFirst() {
  _listbox.highlightFirst();
}
```
:::

### navigateToLast() <span class="docs-badge docs-badge-info">override</span> {#navigatetolast}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">navigateToLast</span>()</div></div>

:::details Implementation
```dart
@override
void navigateToLast() {
  _listbox.highlightLast();
}
```
:::

### navigateUp() <span class="docs-badge docs-badge-info">override</span> {#navigateup}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">navigateUp</span>()</div></div>

:::details Implementation
```dart
@override
void navigateUp() {
  syncAutocompleteHighlightedId(
    listbox: _listbox,
    highlightedIndex: highlightedIndex,
    indexById: _indexById,
    items: _items,
    preferredId: _selectedId,
  );
  _listbox.highlightPrevious();
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

### removeLastSelected() <span class="docs-badge docs-badge-info">override</span> {#removelastselected}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="fn">removeLastSelected</span>()</div></div>

:::details Implementation
```dart
@override
bool removeLastSelected() => false;
```
:::

### resetTypeahead() <span class="docs-badge docs-badge-info">override</span> {#resettypeahead}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">resetTypeahead</span>()</div></div>

:::details Implementation
```dart
@override
void resetTypeahead() {
  _listbox.resetTypeahead();
}
```
:::

### selectByIndex() <span class="docs-badge docs-badge-info">override</span> {#selectbyindex}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">void</span> <span class="fn">selectByIndex</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">int</span> <span class="param">index</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">closeOnSelected</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">closeMenu</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
@override
void selectByIndex({
  required int index,
  required bool closeOnSelected,
  required VoidCallback closeMenu,
}) {
  if (index < 0 || index >= _options.length) return;
  final item = _items[index];
  if (item.isDisabled) return;

  _selectedId = item.id;
  _listbox.setSelectedId(item.id);
  if (_clearQueryOnSelection) {
    _applyQueryText('');
  } else {
    _applyQueryText(item.primaryText);
    _lastSelectedText = item.primaryText;
  }
  _onSelected?.call(_options[index]);
  if (closeOnSelected) closeMenu();
  _notifyStateChanged();
}
```
:::

### setSelectedIdsOptimistic() <span class="docs-badge docs-badge-info">override</span> {#setselectedidsoptimistic}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">setSelectedIdsOptimistic</span>(<span class="type">Set</span>&lt;<span class="type">dynamic</span>&gt; <span class="param">ids</span>)</div></div>

:::details Implementation
```dart
@override
void setSelectedIdsOptimistic(Set<ListboxItemId> ids) {}
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

### updateClearQueryOnSelection() {#updateclearqueryonselection}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">updateClearQueryOnSelection</span>(<span class="type">bool</span> <span class="param">clear</span>)</div></div>

:::details Implementation
```dart
void updateClearQueryOnSelection(bool clear) {
  _clearQueryOnSelection = clear;
}
```
:::

### updateController() <span class="docs-badge docs-badge-info">override</span> {#updatecontroller}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">updateController</span>(<span class="type">dynamic</span> <span class="param">controller</span>)</div></div>

:::details Implementation
```dart
@override
void updateController(TextEditingController controller) {
  _controller = controller;
  _lastText = controller.text;
}
```
:::

### updateItemAdapter() <span class="docs-badge docs-badge-info">override</span> {#updateitemadapter}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">updateItemAdapter</span>(<span class="type">dynamic</span> <span class="param">adapter</span>)</div></div>

:::details Implementation
```dart
@override
void updateItemAdapter(HeadlessItemAdapter<T> adapter) {
  if (identical(_itemAdapter, adapter)) return;
  _itemAdapter = adapter;
}
```
:::

### updateOnSelected() {#updateonselected}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">updateOnSelected</span>(<span class="type">dynamic</span> <span class="param">onSelected</span>)</div></div>

:::details Implementation
```dart
void updateOnSelected(ValueChanged<T>? onSelected) {
  _onSelected = onSelected;
}
```
:::

### updateOptions() <span class="docs-badge docs-badge-info">override</span> {#updateoptions}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">bool</span> <span class="fn">updateOptions</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<span class="type">T</span>&gt; <span class="param">options</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<span class="type">dynamic</span>&gt; <span class="param">items</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
@override
bool updateOptions({
  required List<T> options,
  required List<HeadlessListItemModel> items,
}) {
  _options = options;
  final signature = Object.hashAll(items);
  final itemsChanged =
      signature != _itemsSignature || !identical(items, _items);
  if (!itemsChanged) return false;

  _itemsSignature = signature;
  _items = items;
  _indexById
    ..clear()
    ..addEntries(
      items.asMap().entries.map(
            (entry) => MapEntry(entry.value.id, entry.key),
          ),
    );

  setAutocompleteListboxMetas(_listbox, items);
  _listbox.setSelectedId(
    resolveAutocompleteSelectableId(
      id: _selectedId,
      indexById: _indexById,
      items: _items,
    ),
  );
  _listbox.setHighlightedId(
    resolveAutocompleteHighlightId(
      listbox: _listbox,
      indexById: _indexById,
      items: _items,
      preferredId: _selectedId,
    ),
  );
  return true;
}
```
:::

### updateSelectionMode() <span class="docs-badge docs-badge-info">override</span> {#updateselectionmode}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">void</span> <span class="fn">updateSelectionMode</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_logic_autocomplete_selection_mode/AutocompleteSelectionMode" class="type-link">AutocompleteSelectionMode</a>&lt;<span class="type">T</span>&gt; <span class="param">mode</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">clearQueryOnSelection</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
@override
void updateSelectionMode({
  required AutocompleteSelectionMode<T> mode,
  required bool clearQueryOnSelection,
}) {
  if (mode is! AutocompleteSingleSelectionMode<T>) {
    throw StateError('Expected single selection mode.');
  }
  _onSelected = mode.onSelected;
  _clearQueryOnSelection = clearQueryOnSelection;
}
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

