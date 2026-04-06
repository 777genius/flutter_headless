---
title: "AutocompleteCoordinator<T>"
description: "API documentation for AutocompleteCoordinator<T> class from autocomplete_coordinator"
category: "Classes"
library: "autocomplete_coordinator"
outline: [2, 3]
---

# AutocompleteCoordinator\<T\> <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">AutocompleteCoordinator</span>&lt;T&gt;</div></div>

## Constructors {#section-constructors}

### AutocompleteCoordinator() {#ctor-autocompletecoordinator}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="fn">AutocompleteCoordinator</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">contextGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">notifyStateChanged</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">anchorRectGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">controller</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">focusNode</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">initialValue</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_logic_autocomplete_config/AutocompleteConfig" class="type-link">AutocompleteConfig</a>&lt;<span class="type">T</span>&gt; <span class="param">config</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
AutocompleteCoordinator({
  required BuildContext Function() contextGetter,
  required VoidCallback notifyStateChanged,
  required Rect Function() anchorRectGetter,
  required TextEditingController? controller,
  required FocusNode? focusNode,
  required TextEditingValue? initialValue,
  required AutocompleteConfig<T> config,
})  : _contextGetter = contextGetter,
      _notifyWidgetStateChanged = notifyStateChanged,
      _anchorRectGetter = anchorRectGetter,
      _config = config {
  _isDisposed = false;
  _inputOwner = _createInputOwner(
    controller: controller,
    focusNode: focusNode,
    initialValue: initialValue,
  );
  _optionsController = _createOptionsController();
  _selection = _createSelectionController();
  _menuCoordinator = _createMenuCoordinator();
  _keyboardHandler = _createKeyboardHandler();
  _attachInputListeners();
  _initializeSourceController();
  _syncOptions();
}
```
:::

## Properties {#section-properties}

### activeDescendantSemanticsLabel <span class="docs-badge docs-badge-tip">no setter</span> {#prop-activedescendantsemanticslabel}

<div class="member-signature"><div class="member-signature-code"><span class="type">String</span>? <span class="kw">get</span> <span class="fn">activeDescendantSemanticsLabel</span></div></div>

A11y: label of the currently highlighted option (active descendant).

Used to announce highlighted option changes while keeping input focus on the
text field (combobox/listbox semantics).

:::details Implementation
```dart
String? get activeDescendantSemanticsLabel {
  final index = _selection.highlightedIndex;
  if (index == null) return null;
  if (index < 0 || index >= _items.length) return null;
  final item = _items[index];
  return item.semanticsLabel ?? item.primaryText;
}
```
:::

### controller <span class="docs-badge docs-badge-tip">no setter</span> {#prop-controller}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="kw">get</span> <span class="fn">controller</span></div></div>

:::details Implementation
```dart
TextEditingController get controller => _inputOwner.controller;
```
:::

### focusHover <span class="docs-badge docs-badge-tip">no setter</span> {#prop-focushover}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="kw">get</span> <span class="fn">focusHover</span></div></div>

:::details Implementation
```dart
HeadlessFocusHoverController get focusHover => _inputOwner.focusHover;
```
:::

### focusNode <span class="docs-badge docs-badge-tip">no setter</span> {#prop-focusnode}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="kw">get</span> <span class="fn">focusNode</span></div></div>

:::details Implementation
```dart
FocusNode get focusNode => _inputOwner.focusNode;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_logic_autocomplete_coordinator/AutocompleteCoordinator#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_logic_autocomplete_coordinator/AutocompleteCoordinator#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_logic_autocomplete_coordinator/AutocompleteCoordinator#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_logic_autocomplete_coordinator/AutocompleteCoordinator#operator-equals).
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

If a subclass overrides [hashCode](/api/src_logic_autocomplete_coordinator/AutocompleteCoordinator#prop-hashcode), it should override the
[operator ==](/api/src_logic_autocomplete_coordinator/AutocompleteCoordinator#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### isDisabled <span class="docs-badge docs-badge-tip">no setter</span> {#prop-isdisabled}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isDisabled</span></div></div>

:::details Implementation
```dart
bool get isDisabled => _config.isDisabled;
```
:::

### isMenuOpen <span class="docs-badge docs-badge-tip">no setter</span> {#prop-ismenuopen}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isMenuOpen</span></div></div>

:::details Implementation
```dart
bool get isMenuOpen => _menuCoordinator.isMenuOpen;
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

:::details Implementation
```dart
void dispose() {
  _isDisposed = true;
  _sourceController?.dispose();
  _menuCoordinator.dispose();
  _selection.dispose();
  _inputOwner.focusHover.removeListener(_handleFocusHoverChanged);
  _inputOwner.dispose();
}
```
:::

### handleKeyEvent() {#handlekeyevent}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="fn">handleKeyEvent</span>(<span class="type">dynamic</span> <span class="param">node</span>, <span class="type">dynamic</span> <span class="param">event</span>)</div></div>

:::details Implementation
```dart
KeyEventResult handleKeyEvent(FocusNode node, KeyEvent event) {
  return _keyboardHandler.handle(node, event);
}
```
:::

### handleTapContainer() {#handletapcontainer}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">handleTapContainer</span>()</div></div>

:::details Implementation
```dart
void handleTapContainer() {
  if (_config.isDisabled) return;
  _menuCoordinator.resetDismissed();
  focusNode.requestFocus();
  if (!_config.openOnTap) return;
  _syncOptions(
    trigger: RAutocompleteRemoteTrigger.tap,
    textOverride: _textOverrideForShowAllOnOpenIfNeeded(
      trigger: RAutocompleteRemoteTrigger.tap,
    ),
  );
  _openMenu();
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

### requestFocus() {#requestfocus}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">requestFocus</span>({<span class="kw">required</span> <span class="type">bool</span> <span class="param">suppressOpenOnFocusOnce</span>})</div></div>

:::details Implementation
```dart
void requestFocus({required bool suppressOpenOnFocusOnce}) {
  if (suppressOpenOnFocusOnce) {
    _suppressOpenOnFocusOnce = true;
  }
  focusNode.requestFocus();
}
```
:::

### setSelectedIdsOptimistic() {#setselectedidsoptimistic}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">setSelectedIdsOptimistic</span>(<span class="type">Set</span>&lt;<span class="type">dynamic</span>&gt; <span class="param">ids</span>)</div></div>

:::details Implementation
```dart
void setSelectedIdsOptimistic(Set<ListboxItemId> ids) {
  _selection.setSelectedIdsOptimistic(ids);
  _syncOptions();
  _menuCoordinator.refreshMenuState();
}
```
:::

### suppressOpenOnFocusOnce() {#suppressopenonfocusonce}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">suppressOpenOnFocusOnce</span>()</div></div>

:::details Implementation
```dart
void suppressOpenOnFocusOnce() {
  _suppressOpenOnFocusOnce = true;
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

### updateConfig() {#updateconfig}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">void</span> <span class="fn">updateConfig</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_logic_autocomplete_config/AutocompleteConfig" class="type-link">AutocompleteConfig</a>&lt;<span class="type">T</span>&gt; <span class="param">config</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">controller</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">focusNode</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">initialValue</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
void updateConfig({
  required AutocompleteConfig<T> config,
  required TextEditingController? controller,
  required FocusNode? focusNode,
  required TextEditingValue? initialValue,
}) {
  final prevConfig = _config;
  _config = config;
  _inputOwner.update(
    controller: controller,
    focusNode: focusNode,
    initialValue: initialValue,
    isDisabled: config.isDisabled,
  );
  _selection.updateController(_inputOwner.controller);

  final modeChanged = prevConfig.selectionMode.runtimeType !=
      config.selectionMode.runtimeType;
  if (modeChanged) {
    _selection.dispose();
    _selection = _createSelectionController();
  } else {
    _selection.updateSelectionMode(
      mode: config.selectionMode,
      clearQueryOnSelection: config.clearQueryOnSelection,
    );
  }

  final prevSelectionSig = _selectionSignature(
    mode: prevConfig.selectionMode,
    itemAdapter: prevConfig.itemAdapter,
  );
  final nextSelectionSig = _selectionSignature(
    mode: config.selectionMode,
    itemAdapter: config.itemAdapter,
  );

  if (prevConfig.isDisabled != config.isDisabled) {
    _scheduleCloseMenu(programmatic: true);
  }
  if (!identical(prevConfig.itemAdapter, config.itemAdapter)) {
    _optionsController.updateItemAdapter(config.itemAdapter);
    _selection.updateItemAdapter(config.itemAdapter);
    _scheduleSyncOptions();
  }
  if (!identical(prevConfig.optionsBuilder, config.optionsBuilder) ||
      prevConfig.maxOptions != config.maxOptions) {
    _scheduleSyncOptions();
  }
  if (prevConfig.hideSelectedOptions != config.hideSelectedOptions ||
      prevConfig.pinSelectedOptions != config.pinSelectedOptions) {
    _scheduleSyncOptions();
  }

  &#47;&#47; Critical: selection changes (e.g. chip removal) must refresh options&#47;menu
  &#47;&#47; because hideSelectedOptions&#47;pinSelectedOptions and checked state depend on it.
  &#47;&#47;
  &#47;&#47; Must be scheduled (not immediate) to avoid triggering rebuilds during
  &#47;&#47; didUpdateWidget&#47;build.
  if (prevSelectionSig != nextSelectionSig) {
    _scheduleSyncOptions();
  }
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

