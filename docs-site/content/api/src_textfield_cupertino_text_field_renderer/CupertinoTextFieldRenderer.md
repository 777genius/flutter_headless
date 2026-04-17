---
title: "CupertinoTextFieldRenderer"
description: "API documentation for CupertinoTextFieldRenderer class from cupertino_text_field_renderer"
category: "Classes"
library: "cupertino_text_field_renderer"
outline: [2, 3]
---

# CupertinoTextFieldRenderer

<div class="member-signature"><div class="member-signature-code"><span class="kw">class</span> <span class="fn">CupertinoTextFieldRenderer</span></div></div>

Cupertino renderer for TextField components.

Implements [RTextFieldRenderer](/api/src_renderers_textfield_r_text_field_renderer/RTextFieldRenderer) with iOS styling.

Layout structure:

```dart
CupertinoTextFieldSurface
  └─ Row
       ├─ leading (outside)
       ├─ CupertinoTextFieldAffix(prefix)
       ├─ Expanded
       │    └─ Stack
       │         ├─ placeholder (if !hasText)
       │         └─ request.input
       ├─ CupertinoTextFieldAffix(suffix)
       ├─ trailing (outside)
       └─ CupertinoTextFieldClearButton
```

## Constructors {#section-constructors}

### CupertinoTextFieldRenderer() <span class="docs-badge docs-badge-tip">const</span> {#ctor-cupertinotextfieldrenderer}

<div class="member-signature"><div class="member-signature-code"><span class="kw">const</span> <span class="fn">CupertinoTextFieldRenderer</span>()</div></div>

:::details Implementation
```dart
const CupertinoTextFieldRenderer();
```
:::

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_textfield_cupertino_text_field_renderer/CupertinoTextFieldRenderer#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_textfield_cupertino_text_field_renderer/CupertinoTextFieldRenderer#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_textfield_cupertino_text_field_renderer/CupertinoTextFieldRenderer#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_textfield_cupertino_text_field_renderer/CupertinoTextFieldRenderer#operator-equals).
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

If a subclass overrides [hashCode](/api/src_textfield_cupertino_text_field_renderer/CupertinoTextFieldRenderer#prop-hashcode), it should override the
[operator ==](/api/src_textfield_cupertino_text_field_renderer/CupertinoTextFieldRenderer#operator-equals) operator as well to maintain consistency.

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

### render() {#render}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="fn">render</span>(<span class="type">dynamic</span> <span class="param">request</span>)</div></div>

:::details Implementation
```dart
@override
Widget render(RTextFieldRenderRequest request) {
  final tokens = request.resolvedTokens;
  final state = request.state;
  final spec = request.spec;
  final slots = request.slots;

  &#47;&#47; Get effective values from tokens or use defaults
  final backgroundColor =
      tokens?.containerBackgroundColor ?? CupertinoColors.white;
  final borderColor = tokens?.containerBorderColor ?? const Color(0xFFC6C6C8);
  final borderRadius = tokens?.containerBorderRadius ??
      const BorderRadius.all(Radius.circular(5));
  final borderWidth = tokens?.containerBorderWidth ?? 0.5;
  final padding = tokens?.containerPadding ?? const EdgeInsets.all(7);
  final animationDuration =
      tokens?.containerAnimationDuration ?? const Duration(milliseconds: 200);
  final placeholderStyle = tokens?.placeholderStyle ?? const TextStyle();
  final placeholderColor =
      tokens?.placeholderColor ?? CupertinoColors.placeholderText;
  final iconColor = tokens?.iconColor ?? CupertinoColors.placeholderText;
  final disabledOpacity = tokens?.disabledOpacity ?? 0.38;

  &#47;&#47; Build placeholder
  Widget? placeholder;
  if (spec.placeholder != null && !state.hasText) {
    placeholder = Text(
      spec.placeholder!,
      style: placeholderStyle.copyWith(color: placeholderColor),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  &#47;&#47; Build input area with placeholder
  Widget inputArea = Stack(
    alignment: Alignment.centerLeft,
    children: [
      if (placeholder != null)
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerLeft,
            child: placeholder,
          ),
        ),
      request.input,
    ],
  );

  &#47;&#47; Build row with leading, prefix, input, suffix, trailing, clear button
  final rowChildren = <Widget>[];

  &#47;&#47; Leading (outside, before field)
  if (slots?.leading != null) {
    rowChildren.add(
      Padding(
        padding: const EdgeInsets.only(right: 8),
        child: IconTheme(
          data: IconThemeData(color: iconColor, size: 18),
          child: slots!.leading!,
        ),
      ),
    );
  }

  &#47;&#47; Prefix
  if (slots?.prefix != null) {
    rowChildren.add(
      CupertinoTextFieldAffix(
        mode: spec.prefixMode,
        isFocused: state.isFocused,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconTheme(
            data: IconThemeData(color: iconColor, size: 18),
            child: slots!.prefix!,
          ),
        ),
      ),
    );
  }

  &#47;&#47; Input area (expanded)
  rowChildren.add(Expanded(child: inputArea));

  &#47;&#47; Suffix
  if (slots?.suffix != null) {
    rowChildren.add(
      CupertinoTextFieldAffix(
        mode: spec.suffixMode,
        isFocused: state.isFocused,
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconTheme(
            data: IconThemeData(color: iconColor, size: 18),
            child: slots!.suffix!,
          ),
        ),
      ),
    );
  }

  &#47;&#47; Trailing (outside, after field)
  if (slots?.trailing != null) {
    rowChildren.add(
      Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconTheme(
          data: IconThemeData(color: iconColor, size: 18),
          child: slots!.trailing!,
        ),
      ),
    );
  }

  &#47;&#47; Clear button
  if (spec.clearButtonMode != RTextFieldOverlayVisibilityMode.never) {
    rowChildren.add(
      CupertinoTextFieldClearButton(
        mode: spec.clearButtonMode,
        hasText: state.hasText,
        isFocused: state.isFocused,
        isDisabled: state.isDisabled,
        isReadOnly: state.isReadOnly,
        onClear: request.commands?.clearText,
        iconColor: iconColor,
      ),
    );
  }

  Widget row = Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: rowChildren,
  );

  &#47;&#47; Wrap in surface
  Widget field = CupertinoTextFieldSurface(
    backgroundColor: backgroundColor,
    borderColor: borderColor,
    borderRadius: borderRadius,
    borderWidth: borderWidth,
    padding: padding,
    animationDuration: animationDuration,
    onTap: request.commands?.tapContainer,
    child: row,
  );

  &#47;&#47; Apply disabled opacity
  if (state.isDisabled) {
    field = Opacity(
      opacity: disabledOpacity,
      child: field,
    );
  }

  return field;
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

