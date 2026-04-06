---
title: "OverlayController"
description: "API documentation for OverlayController class from overlay_controller"
category: "Classes"
library: "overlay_controller"
outline: [2, 3]
---

# OverlayController

<div class="member-signature"><div class="member-signature-code"><span class="kw">class</span> <span class="fn">OverlayController</span></div></div>

Controller for managing overlay layers.

Provides [show](/api/src_controller_overlay_controller/OverlayController#show) to create new overlays and manages stacking (LIFO).
Each [show](/api/src_controller_overlay_controller/OverlayController#show) call returns a new [OverlayHandle](/api/src_lifecycle_overlay_handle/OverlayHandle) - handles are never reused.

## Constructors {#section-constructors}

### OverlayController() {#ctor-overlaycontroller}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="fn">OverlayController</span>({</span><span class="member-signature-line">  <span class="type">Duration</span> <span class="param">failSafeTimeout</span> = kOverlayFailSafeTimeout,</span><span class="member-signature-line">  <span class="type">void</span> <span class="type">Function</span>(<a href="/api/src_lifecycle_overlay_handle/OverlayHandle" class="type-link">OverlayHandle</a> <span class="param">handle</span>)? <span class="param">onFailSafeTimeout</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
OverlayController({
  Duration failSafeTimeout = kOverlayFailSafeTimeout,
  OverlayTimeoutCallback? onFailSafeTimeout,
})  : _failSafeTimeout = failSafeTimeout,
      _onFailSafeTimeout = onFailSafeTimeout ?? _defaultFailSafeHandler;
```
:::

## Properties {#section-properties}

### entries <span class="docs-badge docs-badge-tip">no setter</span> {#prop-entries}

<div class="member-signature"><div class="member-signature-code"><span class="type">List</span>&lt;<a href="/api/src_controller_overlay_entry_data/OverlayEntryData" class="type-link">OverlayEntryData</a>&gt; <span class="kw">get</span> <span class="fn">entries</span></div></div>

Current overlay entries (LIFO order: last = topmost).

:::details Implementation
```dart
List<OverlayEntryData> get entries => List.unmodifiable(_entries);
```
:::

### hasActiveOverlays <span class="docs-badge docs-badge-tip">no setter</span> {#prop-hasactiveoverlays}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">hasActiveOverlays</span></div></div>

Whether there are any active overlays.

:::details Implementation
```dart
bool get hasActiveOverlays => _entries.isNotEmpty;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_controller_overlay_controller/OverlayController#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_controller_overlay_controller/OverlayController#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_controller_overlay_controller/OverlayController#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_controller_overlay_controller/OverlayController#operator-equals).
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

If a subclass overrides [hashCode](/api/src_controller_overlay_controller/OverlayController#prop-hashcode), it should override the
[operator ==](/api/src_controller_overlay_controller/OverlayController#operator-equals) operator as well to maintain consistency.

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

### closeAll() {#closeall}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">closeAll</span>()</div></div>

Close all active overlays.

:::details Implementation
```dart
void closeAll() {
  &#47;&#47; Close in reverse order (topmost first)
  for (final entry in _entries.reversed.toList()) {
    entry.handle.close();
  }
}
```
:::

### closeTop() {#closetop}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">closeTop</span>()</div></div>

Close the topmost overlay.

:::details Implementation
```dart
void closeTop() {
  if (_entries.isNotEmpty) {
    _entries.last.handle.close();
  }
}
```
:::

### dismissTopByEscape() {#dismisstopbyescape}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">dismissTopByEscape</span>()</div></div>

Dismiss the topmost overlay using its [DismissPolicy](/api/src_policies_overlay_dismiss_policy/DismissPolicy).

Intended for user-driven dismissal (e.g. Escape key). If the topmost
overlay does not allow dismissal via Escape, this is a no-op.

:::details Implementation
```dart
void dismissTopByEscape() {
  if (_entries.isEmpty) return;
  final top = _entries.last;
  if (!top.dismissPolicy.dismissOnEscape) return;
  top.handle.close();
}
```
:::

### dispose() {#dispose}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">dispose</span>()</div></div>

:::details Implementation
```dart
@override
void dispose() {
  _isDisposed = true;
  &#47;&#47; Remove all phase listeners first to avoid memory leaks
  for (final entry in _phaseListeners.entries) {
    entry.key.phase.removeListener(entry.value);
  }
  _phaseListeners.clear();

  &#47;&#47; Dispose all handles
  for (final entry in _entries) {
    try {
      entry.focusScopeNode.dispose();
    } catch (_) {}
    entry.handle.dispose();
  }
  _entries.clear();
  super.dispose();
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

### requestReposition() {#requestreposition}

<div class="member-signature"><div class="member-signature-code"><span class="type">void</span> <span class="fn">requestReposition</span>({<span class="type">bool</span> <span class="param">ensureFrame</span> = <span class="kw">true</span>})</div></div>

Request overlay reposition for anchored overlays.

Coalesces multiple requests to at most 1 notify per frame.

:::details Implementation
```dart
void requestReposition({bool ensureFrame = true}) {
  if (_repositionScheduled) return;
  if (_entries.isEmpty) return;
  if (!_entries.any((entry) => entry.needsReposition)) return;
  _repositionScheduled = true;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _repositionScheduled = false;
    if (_entries.isEmpty) return;
    if (!_isDisposed) notifyListeners();
  });

  if (ensureFrame) {
    &#47;&#47; Ensure a frame will be produced even if reposition is requested while
    &#47;&#47; the scheduler is idle (e.g. manual calls from application code).
    WidgetsBinding.instance.scheduleFrame();
  }
}
```
:::

### show() {#show}

<div class="member-signature"><div class="member-signature-code"><a href="/api/src_lifecycle_overlay_handle/OverlayHandle" class="type-link">OverlayHandle</a> <span class="fn">show</span>(<a href="/api/src_model_overlay_request/OverlayRequest" class="type-link">OverlayRequest</a> <span class="param">request</span>)</div></div>

Show a new overlay with the given request.

Returns a new [OverlayHandle](/api/src_lifecycle_overlay_handle/OverlayHandle) to control the overlay lifecycle.

:::details Implementation
```dart
OverlayHandle show(OverlayRequest request) {
  final handle = OverlayHandleImpl(
    failSafeTimeout: _failSafeTimeout,
    onFailSafeTimeout: _onFailSafeTimeout,
  );

  final focusScopeNode = FocusScopeNode(debugLabel: 'OverlayScope');

  late final OverlayEntryData entry;
  VoidCallback? restoreFocusListener;

  void removeEntry() {
    final index = _entries.indexOf(entry);
    if (index != -1) {
      _entries.removeAt(index);

      &#47;&#47; Restore focus if specified
      final shouldRestoreFocus = switch (request.focus) {
        ModalFocusPolicy(:final restoreOnClose) => restoreOnClose,
        NonModalFocusPolicy(:final restoreOnClose) => restoreOnClose,
      };

      final restoreFocus = request.restoreFocus;
      if (shouldRestoreFocus &&
          restoreFocus != null &&
          restoreFocus.canRequestFocus) {
        restoreFocus.requestFocus();
      }

      if (!_isDisposed) notifyListeners();
    }
  }

  &#47;&#47; Listen for closed phase to remove entry
  void onPhaseChange() {
    if (handle.phase.value == OverlayPhase.closed) {
      handle.phase.removeListener(onPhaseChange);
      _phaseListeners.remove(handle);
      final restoreFocus = request.restoreFocus;
      if (restoreFocusListener != null && restoreFocus != null) {
        try {
          restoreFocus.removeListener(restoreFocusListener);
        } catch (_) {}
      }
      removeEntry();
      &#47;&#47; Defer dispose to avoid calling during notifyListeners
      Future.microtask(() {
        try {
          focusScopeNode.dispose();
        } catch (_) {}
        handle.dispose();
      });
    }
  }

  handle.phase.addListener(onPhaseChange);
  _phaseListeners[handle] = onPhaseChange;

  final barrierPolicy = request.barrier ??
      OverlayBarrierPolicy.fromDismissPolicy(request.dismiss);

  entry = OverlayEntryData(
    handle: handle,
    overlayBuilder: request.overlayBuilder,
    dismissPolicy: request.dismiss,
    barrierPolicy: barrierPolicy,
    focusPolicy: request.focus,
    repositionPolicy: request.reposition,
    stackPolicy: request.stack,
    focusScopeNode: focusScopeNode,
    onRemove: removeEntry,
    anchor: request.anchor,
    restoreFocus: request.restoreFocus,
  );

  _entries.add(entry);
  if (!_isDisposed) notifyListeners();

  &#47;&#47; Mark as open on next frame (after build)
  WidgetsBinding.instance.addPostFrameCallback((_) {
    handle.markOpen();
  });

  &#47;&#47; Apply initial focus for modal overlays after mount.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!handle.isOpen) return;
    final policy = request.focus;
    if (policy is ModalFocusPolicy && policy.initialFocus != null) {
      &#47;&#47; Wait one more frame so the focus node is guaranteed to be attached
      &#47;&#47; to the focus tree under the overlay scope.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!handle.isOpen) return;
        final node = policy.initialFocus!;
        if (node.canRequestFocus) {
          node.requestFocus();
        }
      });
    } else if (policy is ModalFocusPolicy) {
      &#47;&#47; For modal overlays we want the overlay scope to participate in focus.
      try {
        focusScopeNode.requestFocus();
      } catch (_) {}
    }
  });

  &#47;&#47; Non-modal dismiss-on-focus-loss: close when the anchor&#47;trigger loses focus.
  &#47;&#47;
  &#47;&#47; This avoids forcing overlay scope focus (which would steal focus from
  &#47;&#47; non-modal triggers like autocomplete text fields).
  final restoreFocus = request.restoreFocus;
  if (request.dismiss.dismissOnFocusLoss && restoreFocus != null) {
    restoreFocusListener = () {
      if (!handle.isOpen) return;
      if (!restoreFocus.hasFocus) {
        handle.close();
      }
    };
    restoreFocus.addListener(restoreFocusListener);
  }

  return handle;
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

