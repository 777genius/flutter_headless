---
title: "AutocompleteMenuCoordinator"
description: "API documentation for AutocompleteMenuCoordinator class from autocomplete_menu_coordinator"
category: "Classes"
library: "autocomplete_menu_coordinator"
outline: [2, 3]
---

# AutocompleteMenuCoordinator <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">AutocompleteMenuCoordinator</span></div></div>

## Constructors {#section-constructors}

### AutocompleteMenuCoordinator() {#ctor-autocompletemenucoordinator}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="fn">AutocompleteMenuCoordinator</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">contextGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="type">Function</span>() <span class="param">isDisposedGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">anchorRectGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">anchorFocusNodeGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">int</span>? <span class="type">Function</span>() <span class="param">highlightedIndexGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<span class="type">dynamic</span>&gt; <span class="type">Function</span>() <span class="param">itemsGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">int</span>? <span class="type">Function</span>() <span class="param">selectedIndexGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">Set</span>&lt;<span class="type">int</span>&gt;? <span class="type">Function</span>() <span class="param">selectedItemsIndicesGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">focusHoverGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="type">Function</span>() <span class="param">isDisabledGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">menuSlotsGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">menuOverridesGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">String</span>? <span class="type">Function</span>() <span class="param">placeholderGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">String</span>? <span class="type">Function</span>() <span class="param">semanticLabelGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">featuresGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">notifyStateChanged</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">selectIndex</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">highlightIndex</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
AutocompleteMenuCoordinator({
  required BuildContext Function() contextGetter,
  required bool Function() isDisposedGetter,
  required Rect Function() anchorRectGetter,
  required FocusNode Function() anchorFocusNodeGetter,
  required int? Function() highlightedIndexGetter,
  required List<HeadlessListItemModel> Function() itemsGetter,
  required int? Function() selectedIndexGetter,
  required Set<int>? Function() selectedItemsIndicesGetter,
  required HeadlessFocusHoverController Function() focusHoverGetter,
  required bool Function() isDisabledGetter,
  required RDropdownButtonSlots? Function() menuSlotsGetter,
  required RenderOverrides? Function() menuOverridesGetter,
  required String? Function() placeholderGetter,
  required String? Function() semanticLabelGetter,
  required HeadlessRequestFeatures Function() featuresGetter,
  required VoidCallback notifyStateChanged,
  required ValueChanged<int> selectIndex,
  required ValueChanged<int> highlightIndex,
})  : _itemsGetter = itemsGetter,
      _selectedIndexGetter = selectedIndexGetter,
      _selectedItemsIndicesGetter = selectedItemsIndicesGetter,
      _highlightedIndexGetter = highlightedIndexGetter,
      _focusHoverGetter = focusHoverGetter,
      _isDisabledGetter = isDisabledGetter,
      _menuSlotsGetter = menuSlotsGetter,
      _menuOverridesGetter = menuOverridesGetter,
      _placeholderGetter = placeholderGetter,
      _semanticLabelGetter = semanticLabelGetter,
      _featuresGetter = featuresGetter {
  _menuHost = _createMenuHost(
    contextGetter: contextGetter,
    isDisposedGetter: isDisposedGetter,
    anchorRectGetter: anchorRectGetter,
    anchorFocusNodeGetter: anchorFocusNodeGetter,
    highlightedIndexGetter: highlightedIndexGetter,
    notifyStateChanged: notifyStateChanged,
  );
  _menuController = AutocompleteMenuOverlayController(_menuHost);
  _commandsBuilder = _createCommandsBuilder(
    selectIndex: selectIndex,
    highlightIndex: highlightIndex,
  );
  _menuRequestFactory = _createRequestFactory();
}
```
:::

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_logic_autocomplete_menu_coordinator/AutocompleteMenuCoordinator#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_logic_autocomplete_menu_coordinator/AutocompleteMenuCoordinator#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_logic_autocomplete_menu_coordinator/AutocompleteMenuCoordinator#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_logic_autocomplete_menu_coordinator/AutocompleteMenuCoordinator#operator-equals).
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

If a subclass overrides [hashCode](/api/src_logic_autocomplete_menu_coordinator/AutocompleteMenuCoordinator#prop-hashcode), it should override the
[operator ==](/api/src_logic_autocomplete_menu_coordinator/AutocompleteMenuCoordinator#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### hasOverlay <span class="docs-badge docs-badge-tip">no setter</span> {#prop-hasoverlay}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">hasOverlay</span></div></div>

:::details Implementation
```dart
bool get hasOverlay => _menuController.hasOverlay;
```
:::

### isMenuOpen <span class="docs-badge docs-badge-tip">no setter</span> {#prop-ismenuopen}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isMenuOpen</span></div></div>

:::details Implementation
```dart
bool get isMenuOpen => _menuController.isMenuOpen;
```
:::

### overlayPhase <span class="docs-badge docs-badge-tip">no setter</span> {#prop-overlayphase}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="kw">get</span> <span class="fn">overlayPhase</span></div></div>

:::details Implementation
```dart
ROverlayPhase get overlayPhase => _menuController.overlayPhase;
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

### wasDismissed <span class="docs-badge docs-badge-tip">no setter</span> {#prop-wasdismissed}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">wasDismissed</span></div></div>

:::details Implementation
```dart
bool get wasDismissed => _menuController.wasDismissed;
```
:::

## Methods {#section-methods}

### closeMenu() {#closemenu}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">closeMenu</span>({<span class="kw">required</span> <span class="type">bool</span> <span class="param">programmatic</span>})</div></div>

:::details Implementation
```dart
void closeMenu({required bool programmatic}) {
  _menuController.closeMenu(programmatic: programmatic);
}
```
:::

### dispose() {#dispose}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">dispose</span>()</div></div>

:::details Implementation
```dart
void dispose() => _menuController.dispose();
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

### openMenu() {#openmenu}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">openMenu</span>()</div></div>

:::details Implementation
```dart
void openMenu() => _menuController.openMenu();
```
:::

### refreshMenuState() {#refreshmenustate}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">refreshMenuState</span>()</div></div>

:::details Implementation
```dart
void refreshMenuState() => _menuController.refreshMenuState();
```
:::

### resetDismissed() {#resetdismissed}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">resetDismissed</span>()</div></div>

:::details Implementation
```dart
void resetDismissed() => _menuController.resetDismissed();
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

### updateHighlight() {#updatehighlight}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">updateHighlight</span>(<span class="type">int</span>? <span class="param">index</span>)</div></div>

:::details Implementation
```dart
void updateHighlight(int? index) => _menuController.updateHighlight(index);
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

