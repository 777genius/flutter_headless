---
title: "DropdownOverlayController"
description: "API documentation for DropdownOverlayController class from dropdown_overlay_controller"
category: "Classes"
library: "dropdown_overlay_controller"
outline: [2, 3]
---

# DropdownOverlayController <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">DropdownOverlayController</span></div></div>

Controls dropdown overlay lifecycle.

Manages opening, closing, and phase transitions of the menu overlay.
Extracted from State to reduce class size and improve testability.

## Constructors {#section-constructors}

### DropdownOverlayController() {#ctor-dropdownoverlaycontroller}

<div class="member-signature"><div class="member-signature-code"><span class="fn">DropdownOverlayController</span>(<a href="/api/src_presentation_dropdown_overlay_controller/DropdownOverlayHost" class="type-link">DropdownOverlayHost</a> <span class="param">_host</span>)</div></div>

:::details Implementation
```dart
DropdownOverlayController(this._host)
    : _menuOverlay = HeadlessMenuOverlayController(
        contextGetter: () => _host.context,
        isDisposedGetter: () => _host.isDisposed,
      ) {
  _menuOverlay.phase.addListener(_onPhaseChanged);
}
```
:::

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_presentation_dropdown_overlay_controller/DropdownOverlayController#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_presentation_dropdown_overlay_controller/DropdownOverlayController#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_presentation_dropdown_overlay_controller/DropdownOverlayController#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_presentation_dropdown_overlay_controller/DropdownOverlayController#operator-equals).
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

If a subclass overrides [hashCode](/api/src_presentation_dropdown_overlay_controller/DropdownOverlayController#prop-hashcode), it should override the
[operator ==](/api/src_presentation_dropdown_overlay_controller/DropdownOverlayController#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### highlightedIndex <span class="docs-badge docs-badge-tip">no setter</span> {#prop-highlightedindex}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span>? <span class="kw">get</span> <span class="fn">highlightedIndex</span></div></div>

Current highlighted index in menu.

:::details Implementation
```dart
int? get highlightedIndex => _menuStateNotifier?.value.highlightedIndex;
```
:::

### isMenuOpen <span class="docs-badge docs-badge-tip">no setter</span> {#prop-ismenuopen}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isMenuOpen</span></div></div>

Whether menu is open (opening or open phase).

:::details Implementation
```dart
bool get isMenuOpen => _menuOverlay.isOpen;
```
:::

### overlayPhase <span class="docs-badge docs-badge-tip">no setter</span> {#prop-overlayphase}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="kw">get</span> <span class="fn">overlayPhase</span></div></div>

Current overlay phase.

:::details Implementation
```dart
ROverlayPhase get overlayPhase => _mapOverlayPhase(_menuOverlay.phase.value);
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

### closeMenu() {#closemenu}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">closeMenu</span>()</div></div>

Starts closing animation.

:::details Implementation
```dart
void closeMenu() {
  _menuOverlay.close();
}
```
:::

### completeClose() {#completeclose}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">completeClose</span>()</div></div>

Completes closing and removes overlay.

:::details Implementation
```dart
void completeClose() {
  _menuOverlay.completeClose();
}
```
:::

### dispose() {#dispose}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">dispose</span>()</div></div>

Disposes controller resources.

Should be called from State.dispose().

:::details Implementation
```dart
void dispose() {
  final notifier = _menuStateNotifier;
  final menuFocus = _menuFocusNode;

  _menuStateNotifier = null;
  _menuFocusNode = null;

  _menuOverlay.phase.removeListener(_onPhaseChanged);
  _menuOverlay.dispose();

  if (notifier != null || menuFocus != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier?.dispose();
      menuFocus?.dispose();
    });
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

### openMenu() {#openmenu}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">openMenu</span>()</div></div>

Opens the dropdown menu overlay.

:::details Implementation
```dart
void openMenu() {
  if (_menuOverlay.hasOverlay) return;

  &#47;&#47; Initialize highlight to selected item or first enabled
  final selectedIndex = _host.findSelectedIndex();
  final initialHighlight =
      (selectedIndex != null && !_host.isItemDisabled(selectedIndex))
          ? selectedIndex
          : _host.findFirstEnabledIndex();

  _menuStateNotifier = ValueNotifier(
    RDropdownMenuState(
      highlightedIndex: initialHighlight,
      overlayPhase: ROverlayPhase.opening,
    ),
  );

  _menuFocusNode = FocusNode(debugLabel: 'DropdownMenu');

  final anchor = HeadlessMenuAnchor(
    anchorRectGetter: _host.anchorRectGetter,
    restoreFocus: _host.triggerFocusNode,
  );

  _menuOverlay.open(
    builder: (overlayContext) {
      return RDropdownMenu(
        stateNotifier: _menuStateNotifier!,
        focusNode: _menuFocusNode!,
        createMenuRequest: _host.menuRequestBuilder,
        onKeyEvent: _host.menuKeyHandler,
        onPointerSignal: _host.menuPointerSignalHandler,
      );
    },
    anchor: anchor,
    &#47;&#47; When we explicitly transfer focus into the menu, "focus loss" is not a
    &#47;&#47; reliable dismissal signal (focus can transiently bounce during open).
    &#47;&#47; We still want outsideTap + escape behavior.
    dismissPolicy: DismissPolicy.nonModal.copyWith(dismissOnFocusLoss: false),
    focusPolicy: const NonModalFocusPolicy(),
    focusTransfer: HeadlessMenuFocusTransferPolicy.transferToMenu,
    menuFocusNode: _menuFocusNode,
  );
}
```
:::

### toggleMenu() {#togglemenu}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">toggleMenu</span>()</div></div>

Toggles menu open/closed.

:::details Implementation
```dart
void toggleMenu() {
  if (isMenuOpen) {
    closeMenu();
  } else {
    openMenu();
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

### updateHighlight() {#updatehighlight}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">updateHighlight</span>(<span class="type">int</span>? <span class="param">index</span>)</div></div>

Updates highlight index in menu state.

:::details Implementation
```dart
void updateHighlight(int? index) {
  if (_host.isDisposed || _menuStateNotifier == null) return;

  _menuStateNotifier!.value = RDropdownMenuState(
    highlightedIndex: index,
    overlayPhase: overlayPhase,
  );
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

