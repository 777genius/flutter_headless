---
title: "ListboxController"
description: "API documentation for ListboxController class from listbox_controller"
category: "Classes"
library: "listbox_controller"
outline: [2, 3]
---

# ListboxController <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">ListboxController</span></div></div>

Foundation listbox controller (keyboard navigation + typeahead).

- Ядро использует [ItemRegistry](/api/src_listbox_item_registry/ItemRegistry) и не зависит от UI.
- Для простых кейсов допускается convenience API [setItems](/api/src_listbox_listbox_controller/ListboxController#setitems).

## Constructors {#section-constructors}

### ListboxController() {#ctor-listboxcontroller}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="fn">ListboxController</span>({</span><span class="member-signature-line">  <a href="/api/src_listbox_item_registry/ItemRegistry" class="type-link">ItemRegistry</a>? <span class="param">registry</span>,</span><span class="member-signature-line">  <a href="/api/src_listbox_listbox_navigation_policy/ListboxNavigationPolicy" class="type-link">ListboxNavigationPolicy</a> <span class="param">navigationPolicy</span> = <span class="kw">const</span> ListboxNavigationPolicy(),</span><span class="member-signature-line">  <a href="/api/src_listbox_listbox_typeahead/ListboxTypeaheadConfig" class="type-link">ListboxTypeaheadConfig</a> <span class="param">typeaheadConfig</span> = <span class="kw">const</span> ListboxTypeaheadConfig(),</span><span class="member-signature-line">  <span class="type">DateTime</span> <span class="type">Function</span>()? <span class="param">now</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
ListboxController({
  ItemRegistry? registry,
  this.navigationPolicy = const ListboxNavigationPolicy(),
  ListboxTypeaheadConfig typeaheadConfig = const ListboxTypeaheadConfig(),
  DateTime Function()? now,
})  : _registry = registry ?? ItemRegistry(),
      _typeahead = ListboxTypeaheadBuffer(config: typeaheadConfig, now: now);
```
:::

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_listbox_listbox_controller/ListboxController#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_listbox_listbox_controller/ListboxController#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_listbox_listbox_controller/ListboxController#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_listbox_listbox_controller/ListboxController#operator-equals).
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

If a subclass overrides [hashCode](/api/src_listbox_listbox_controller/ListboxController#prop-hashcode), it should override the
[operator ==](/api/src_listbox_listbox_controller/ListboxController#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### highlightedId <span class="docs-badge docs-badge-tip">no setter</span> {#prop-highlightedid}

<div class="member-signature"><div class="member-signature-code"><a href="/api/src_listbox_listbox_item_id/ListboxItemId" class="type-link">ListboxItemId</a>? <span class="kw">get</span> <span class="fn">highlightedId</span></div></div>

:::details Implementation
```dart
ListboxItemId? get highlightedId => _highlightedId;
```
:::

### navigationPolicy <span class="docs-badge docs-badge-tip">final</span> {#prop-navigationpolicy}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_listbox_listbox_navigation_policy/ListboxNavigationPolicy" class="type-link">ListboxNavigationPolicy</a> <span class="fn">navigationPolicy</span></div></div>

:::details Implementation
```dart
final ListboxNavigationPolicy navigationPolicy;
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

<div class="member-signature"><div class="member-signature-code"><a href="/api/src_listbox_listbox_item_id/ListboxItemId" class="type-link">ListboxItemId</a>? <span class="kw">get</span> <span class="fn">selectedId</span></div></div>

:::details Implementation
```dart
ListboxItemId? get selectedId => _selectedId;
```
:::

### state <span class="docs-badge docs-badge-tip">no setter</span> {#prop-state}

<div class="member-signature"><div class="member-signature-code"><a href="/api/src_listbox_listbox_state/ListboxState" class="type-link">ListboxState</a> <span class="kw">get</span> <span class="fn">state</span></div></div>

:::details Implementation
```dart
ListboxState get state => ListboxState(
      highlightedId: _highlightedId,
      selectedId: _selectedId,
    );
```
:::

## Methods {#section-methods}

### handleTypeahead() {#handletypeahead}

<div class="member-signature"><div class="member-signature-code"><a href="/api/src_listbox_listbox_item_id/ListboxItemId" class="type-link">ListboxItemId</a>? <span class="fn">handleTypeahead</span>(<span class="type">String</span> <span class="param">char</span>)</div></div>

:::details Implementation
```dart
ListboxItemId? handleTypeahead(String char) {
  final enabled = _registry.orderedEnabledIds;
  if (enabled.isEmpty) return null;

  final query = HeadlessTypeaheadLabel.normalize(_typeahead.push(char));
  if (query.isEmpty) return null;
  final from = _highlightedId == null ? -1 : enabled.indexOf(_highlightedId!);
  final startIndex = (from < 0 ? -1 : from) + 1;

  for (var step = 0; step < enabled.length; step++) {
    final idx = (startIndex + step) % enabled.length;
    final id = enabled[idx];
    final meta = _registry.getMeta(id);
    if (meta == null) continue;
    if (meta.typeaheadLabel.startsWith(query)) {
      setHighlightedId(id);
      return id;
    }
  }

  return null;
}
```
:::

### highlightFirst() {#highlightfirst}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">highlightFirst</span>()</div></div>

:::details Implementation
```dart
void highlightFirst() {
  final enabled = _registry.orderedEnabledIds;
  if (enabled.isEmpty) return;
  setHighlightedId(enabled.first);
}
```
:::

### highlightLast() {#highlightlast}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">highlightLast</span>()</div></div>

:::details Implementation
```dart
void highlightLast() {
  final enabled = _registry.orderedEnabledIds;
  if (enabled.isEmpty) return;
  setHighlightedId(enabled.last);
}
```
:::

### highlightNext() {#highlightnext}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">highlightNext</span>()</div></div>

:::details Implementation
```dart
void highlightNext() {
  final enabled = _registry.orderedEnabledIds;
  if (enabled.isEmpty) return;

  final fromId = _highlightedId ?? _selectedId;
  final fromIndex = fromId == null ? -1 : enabled.indexOf(fromId);
  final start = fromIndex < 0 ? -1 : fromIndex;

  final nextIndex =
      _nextIndex(enabledLength: enabled.length, fromIndex: start);
  if (nextIndex == null) return;
  setHighlightedId(enabled[nextIndex]);
}
```
:::

### highlightPrevious() {#highlightprevious}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">highlightPrevious</span>()</div></div>

:::details Implementation
```dart
void highlightPrevious() {
  final enabled = _registry.orderedEnabledIds;
  if (enabled.isEmpty) return;

  final fromId = _highlightedId ?? _selectedId;
  final fromIndex = fromId == null ? enabled.length : enabled.indexOf(fromId);
  final start = fromIndex < 0 ? enabled.length : fromIndex;

  final prevIndex =
      _previousIndex(enabledLength: enabled.length, fromIndex: start);
  if (prevIndex == null) return;
  setHighlightedId(enabled[prevIndex]);
}
```
:::

### navigate() {#navigate}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">navigate</span>(<a href="/api/src_listbox_listbox_navigation_command/ListboxNavigation" class="type-link">ListboxNavigation</a> <span class="param">nav</span>)</div></div>

:::details Implementation
```dart
void navigate(ListboxNavigation nav) {
  switch (nav) {
    case MoveHighlight(:final delta):
      if (delta > 0) {
        highlightNext();
      } else if (delta < 0) {
        highlightPrevious();
      }
    case JumpToFirst():
      highlightFirst();
    case JumpToLast():
      highlightLast();
    case TypeaheadChar(:final char):
      handleTypeahead(char);
    case SelectHighlighted():
      selectHighlighted();
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

### register() {#register}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">register</span>(<a href="/api/src_listbox_listbox_item_meta/ListboxItemMeta" class="type-link">ListboxItemMeta</a> <span class="param">meta</span>, {<span class="kw">required</span> <span class="type">int</span> <span class="param">order</span>})</div></div>

:::details Implementation
```dart
void register(ListboxItemMeta meta, {required int order}) {
  _registry.register(meta, order: order);
  notifyListeners();
}
```
:::

### resetTypeahead() {#resettypeahead}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">resetTypeahead</span>()</div></div>

:::details Implementation
```dart
void resetTypeahead() => _typeahead.reset();
```
:::

### selectHighlighted() {#selecthighlighted}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">selectHighlighted</span>()</div></div>

:::details Implementation
```dart
void selectHighlighted() {
  final id = _highlightedId;
  if (id == null) return;
  setSelectedId(id);
}
```
:::

### setHighlightedId() {#sethighlightedid}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">setHighlightedId</span>(<a href="/api/src_listbox_listbox_item_id/ListboxItemId" class="type-link">ListboxItemId</a>? <span class="param">id</span>)</div></div>

:::details Implementation
```dart
void setHighlightedId(ListboxItemId? id) {
  if (id == null) {
    if (_highlightedId == null) return;
    _highlightedId = null;
    notifyListeners();
    return;
  }

  final meta = _registry.getMeta(id);
  if (meta == null || meta.isDisabled) return;
  if (_highlightedId == id) return;
  _highlightedId = id;
  notifyListeners();
}
```
:::

### setItems() {#setitems}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">setItems</span>(<span class="type">List</span>&lt;<a href="/api/src_listbox_listbox_item/ListboxItem" class="type-link">ListboxItem</a>&gt; <span class="param">items</span>)</div></div>

Convenience adapter: регистрирует items списком (подходит для маленьких списков).

:::details Implementation
```dart
void setItems(List<ListboxItem> items) {
  final metas = List<ListboxItemMeta>.generate(
    items.length,
    (index) {
      final item = items[index];
      return ListboxItemMeta(
        id: item.id,
        isDisabled: item.isDisabled,
        typeaheadLabel: HeadlessTypeaheadLabel.normalize(item.label),
      );
    },
  );
  _applyMetas(metas);
}
```
:::

### setMetas() {#setmetas}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">setMetas</span>(<span class="type">List</span>&lt;<a href="/api/src_listbox_listbox_item_meta/ListboxItemMeta" class="type-link">ListboxItemMeta</a>&gt; <span class="param">metas</span>)</div></div>

Convenience adapter: register metas list (already normalized).

:::details Implementation
```dart
void setMetas(List<ListboxItemMeta> metas) {
  _applyMetas(metas);
}
```
:::

### setSelectedId() {#setselectedid}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">setSelectedId</span>(<a href="/api/src_listbox_listbox_item_id/ListboxItemId" class="type-link">ListboxItemId</a>? <span class="param">id</span>)</div></div>

:::details Implementation
```dart
void setSelectedId(ListboxItemId? id) {
  if (id == null) {
    if (_selectedId == null) return;
    _selectedId = null;
    notifyListeners();
    return;
  }

  final meta = _registry.getMeta(id);
  if (meta == null || meta.isDisabled) {
    if (_selectedId == null) return;
    _selectedId = null;
    notifyListeners();
    return;
  }
  if (_selectedId == id) return;
  _selectedId = id;
  notifyListeners();
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

### unregister() {#unregister}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">unregister</span>(<a href="/api/src_listbox_listbox_item_id/ListboxItemId" class="type-link">ListboxItemId</a> <span class="param">id</span>)</div></div>

:::details Implementation
```dart
void unregister(ListboxItemId id) {
  _registry.unregister(id);
  if (_highlightedId == id) _highlightedId = null;
  if (_selectedId == id) _selectedId = null;
  notifyListeners();
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

