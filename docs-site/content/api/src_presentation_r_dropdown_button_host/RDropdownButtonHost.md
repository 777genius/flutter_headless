---
title: "RDropdownButtonHost<T>"
description: "API documentation for RDropdownButtonHost<T> class from r_dropdown_button_host"
category: "Classes"
library: "r_dropdown_button_host"
outline: [2, 3]
---

# RDropdownButtonHost\<T\> <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RDropdownButtonHost</span>&lt;T&gt; <span class="kw">implements</span> <a href="/api/src_presentation_dropdown_overlay_controller/DropdownOverlayHost" class="type-link">DropdownOverlayHost</a>, <a href="/api/src_presentation_dropdown_selection_controller/DropdownSelectionHost" class="type-link">DropdownSelectionHost</a>&lt;<span class="type">T</span>&gt;, <a href="/api/src_logic_dropdown_menu_keyboard_controller/DropdownMenuKeyboardHost" class="type-link">DropdownMenuKeyboardHost</a></div></div>

:::info Implemented types
- [DropdownOverlayHost](/api/src_presentation_dropdown_overlay_controller/DropdownOverlayHost)
- [DropdownSelectionHost\<T\>](/api/src_presentation_dropdown_selection_controller/DropdownSelectionHost)
- [DropdownMenuKeyboardHost](/api/src_logic_dropdown_menu_keyboard_controller/DropdownMenuKeyboardHost)
:::

## Constructors {#section-constructors}

### RDropdownButtonHost() {#ctor-rdropdownbuttonhost}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="fn">RDropdownButtonHost</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">contextGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">triggerContextGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">triggerFocusNodeGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">anchorRectGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="type">Function</span>() <span class="param">isDisposedGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<a href="/api/src_presentation_r_dropdown_option/RDropdownOption" class="type-link">RDropdownOption</a>&lt;<span class="type">T</span>&gt;&gt; <span class="type">Function</span>() <span class="param">optionsGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>() <span class="param">selectedIdGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">T</span>? <span class="type">Function</span>() <span class="param">selectedValueGetter</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">onChanged</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>(<span class="type">dynamic</span>) <span class="param">menuRequestBuilder</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="type">Function</span>(<span class="type">dynamic</span>, <span class="type">dynamic</span>) <span class="param">menuKeyHandler</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">void</span> <span class="type">Function</span>(<span class="type">dynamic</span> <span class="param">event</span>)? <span class="param">menuPointerSignalHandler</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">notifyStateChanged</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
RDropdownButtonHost({
  required BuildContext Function() contextGetter,
  required BuildContext? Function() triggerContextGetter,
  required FocusNode Function() triggerFocusNodeGetter,
  required Rect Function() anchorRectGetter,
  required bool Function() isDisposedGetter,
  required List<RDropdownOption<T>> Function() optionsGetter,
  required ListboxItemId? Function() selectedIdGetter,
  required T? Function() selectedValueGetter,
  required ValueChanged<T>? onChanged,
  required RDropdownMenuRenderRequest Function(BuildContext)
      menuRequestBuilder,
  required KeyEventResult Function(FocusNode, KeyEvent) menuKeyHandler,
  required void Function(PointerSignalEvent event)? menuPointerSignalHandler,
  required VoidCallback notifyStateChanged,
})  : _contextGetter = contextGetter,
      _triggerContextGetter = triggerContextGetter,
      _triggerFocusNodeGetter = triggerFocusNodeGetter,
      _anchorRectGetter = anchorRectGetter,
      _isDisposedGetter = isDisposedGetter,
      _optionsGetter = optionsGetter,
      _selectedIdGetter = selectedIdGetter,
      _selectedValueGetter = selectedValueGetter,
      _onChanged = onChanged,
      _menuRequestBuilder = menuRequestBuilder,
      _menuKeyHandler = menuKeyHandler,
      _menuPointerSignalHandler = menuPointerSignalHandler,
      _notifyStateChanged = notifyStateChanged;
```
:::

## Properties {#section-properties}

### anchorRectGetter <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-anchorrectgetter}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="type">Function</span>() <span class="kw">get</span> <span class="fn">anchorRectGetter</span></div></div>

:::details Implementation
```dart
@override
Rect Function() get anchorRectGetter => _anchorRectGetter;
```
:::

### context <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-context}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="kw">get</span> <span class="fn">context</span></div></div>

:::details Implementation
```dart
@override
BuildContext get context => _contextGetter();
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_presentation_r_dropdown_button_host/RDropdownButtonHost#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_presentation_r_dropdown_button_host/RDropdownButtonHost#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_presentation_r_dropdown_button_host/RDropdownButtonHost#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_presentation_r_dropdown_button_host/RDropdownButtonHost#operator-equals).
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

If a subclass overrides [hashCode](/api/src_presentation_r_dropdown_button_host/RDropdownButtonHost#prop-hashcode), it should override the
[operator ==](/api/src_presentation_r_dropdown_button_host/RDropdownButtonHost#operator-equals) operator as well to maintain consistency.

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
int? get highlightedIndex => _overlay.highlightedIndex;
```
:::

### isDisposed <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-isdisposed}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isDisposed</span></div></div>

:::details Implementation
```dart
@override
bool get isDisposed => _isDisposedGetter();
```
:::

### menuKeyHandler <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-menukeyhandler}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="type">Function</span>(<span class="type">dynamic</span>, <span class="type">dynamic</span>) <span class="kw">get</span> <span class="fn">menuKeyHandler</span></div></div>

:::details Implementation
```dart
@override
KeyEventResult Function(FocusNode, KeyEvent) get menuKeyHandler =>
    _menuKeyHandler;
```
:::

### menuPointerSignalHandler <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-menupointersignalhandler}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="type">Function</span>(<span class="type">dynamic</span> <span class="param">event</span>)? <span class="kw">get</span> <span class="fn">menuPointerSignalHandler</span></div></div>

:::details Implementation
```dart
@override
void Function(PointerSignalEvent event)? get menuPointerSignalHandler =>
    _menuPointerSignalHandler;
```
:::

### menuRequestBuilder <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-menurequestbuilder}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="type">Function</span>(<span class="type">dynamic</span>) <span class="kw">get</span> <span class="fn">menuRequestBuilder</span></div></div>

:::details Implementation
```dart
@override
RDropdownMenuRenderRequest Function(BuildContext) get menuRequestBuilder =>
    _menuRequestBuilder;
```
:::

### options <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-options}

<div class="member-signature"><div class="member-signature-code"><span class="type">List</span>&lt;<a href="/api/src_presentation_r_dropdown_option/RDropdownOption" class="type-link">RDropdownOption</a>&lt;<span class="type">T</span>&gt;&gt; <span class="kw">get</span> <span class="fn">options</span></div></div>

:::details Implementation
```dart
@override
List<RDropdownOption<T>> get options => _optionsGetter();
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

### selectedId <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-selectedid}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="kw">get</span> <span class="fn">selectedId</span></div></div>

:::details Implementation
```dart
@override
ListboxItemId? get selectedId => _selectedIdGetter();
```
:::

### selectedValue <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-selectedvalue}

<div class="member-signature"><div class="member-signature-code"><span class="type">T</span>? <span class="kw">get</span> <span class="fn">selectedValue</span></div></div>

:::details Implementation
```dart
@override
T? get selectedValue => _selectedValueGetter();
```
:::

### triggerContext <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-triggercontext}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="kw">get</span> <span class="fn">triggerContext</span></div></div>

:::details Implementation
```dart
@override
BuildContext? get triggerContext => _triggerContextGetter();
```
:::

### triggerFocusNode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">override</span> {#prop-triggerfocusnode}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="kw">get</span> <span class="fn">triggerFocusNode</span></div></div>

:::details Implementation
```dart
@override
FocusNode get triggerFocusNode => _triggerFocusNodeGetter();
```
:::

## Methods {#section-methods}

### bind() {#bind}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">void</span> <span class="fn">bind</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_presentation_dropdown_overlay_controller/DropdownOverlayController" class="type-link">DropdownOverlayController</a> <span class="param">overlay</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_presentation_dropdown_selection_controller/DropdownSelectionController" class="type-link">DropdownSelectionController</a>&lt;<span class="type">T</span>&gt; <span class="param">selection</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
void bind({
  required DropdownOverlayController overlay,
  required DropdownSelectionController<T> selection,
}) {
  _overlay = overlay;
  _selection = selection;
}
```
:::

### closeMenu() <span class="docs-badge docs-badge-info">override</span> {#closemenu}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">closeMenu</span>()</div></div>

:::details Implementation
```dart
@override
void closeMenu() {
  _selection.resetTypeahead();
  _overlay.closeMenu();
}
```
:::

### findFirstEnabledIndex() <span class="docs-badge docs-badge-info">override</span> {#findfirstenabledindex}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span>? <span class="fn">findFirstEnabledIndex</span>()</div></div>

:::details Implementation
```dart
@override
int? findFirstEnabledIndex() {
  final options = _optionsGetter();
  for (var i = 0; i < options.length; i++) {
    if (!options[i].item.isDisabled) return i;
  }
  return null;
}
```
:::

### findSelectedIndex() <span class="docs-badge docs-badge-info">override</span> {#findselectedindex}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span>? <span class="fn">findSelectedIndex</span>()</div></div>

:::details Implementation
```dart
@override
int? findSelectedIndex() {
  final selectedId = this.selectedId;
  if (selectedId == null) return null;
  final options = _optionsGetter();
  for (var i = 0; i < options.length; i++) {
    if (options[i].item.id == selectedId) return i;
  }
  return null;
}
```
:::

### handleTypeahead() <span class="docs-badge docs-badge-info">override</span> {#handletypeahead}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">handleTypeahead</span>(<span class="type">String</span> <span class="param">char</span>)</div></div>

:::details Implementation
```dart
@override
void handleTypeahead(String char) => _selection.handleTypeahead(char);
```
:::

### isItemDisabled() <span class="docs-badge docs-badge-info">override</span> {#isitemdisabled}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="fn">isItemDisabled</span>(<span class="type">int</span> <span class="param">index</span>)</div></div>

:::details Implementation
```dart
@override
bool isItemDisabled(int index) => _optionsGetter()[index].item.isDisabled;
```
:::

### navigateDown() <span class="docs-badge docs-badge-info">override</span> {#navigatedown}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">navigateDown</span>()</div></div>

:::details Implementation
```dart
@override
void navigateDown() => _selection.navigateDown();
```
:::

### navigateToFirst() <span class="docs-badge docs-badge-info">override</span> {#navigatetofirst}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">navigateToFirst</span>()</div></div>

:::details Implementation
```dart
@override
void navigateToFirst() => _selection.navigateToFirst();
```
:::

### navigateToLast() <span class="docs-badge docs-badge-info">override</span> {#navigatetolast}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">navigateToLast</span>()</div></div>

:::details Implementation
```dart
@override
void navigateToLast() => _selection.navigateToLast();
```
:::

### navigateUp() <span class="docs-badge docs-badge-info">override</span> {#navigateup}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">navigateUp</span>()</div></div>

:::details Implementation
```dart
@override
void navigateUp() => _selection.navigateUp();
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

### notifyStateChanged() <span class="docs-badge docs-badge-info">override</span> {#notifystatechanged}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">notifyStateChanged</span>()</div></div>

:::details Implementation
```dart
@override
void notifyStateChanged() => _notifyStateChanged();
```
:::

### onValueSelected() <span class="docs-badge docs-badge-info">override</span> {#onvalueselected}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">onValueSelected</span>(<span class="type">T</span> <span class="param">value</span>)</div></div>

:::details Implementation
```dart
@override
void onValueSelected(T value) => _onChanged?.call(value);
```
:::

### selectHighlighted() <span class="docs-badge docs-badge-info">override</span> {#selecthighlighted}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">selectHighlighted</span>()</div></div>

:::details Implementation
```dart
@override
void selectHighlighted() => _selection.selectHighlighted();
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

### updateHighlight() <span class="docs-badge docs-badge-info">override</span> {#updatehighlight}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">updateHighlight</span>(<span class="type">int</span>? <span class="param">index</span>)</div></div>

:::details Implementation
```dart
@override
void updateHighlight(int? index) => _overlay.updateHighlight(index);
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

