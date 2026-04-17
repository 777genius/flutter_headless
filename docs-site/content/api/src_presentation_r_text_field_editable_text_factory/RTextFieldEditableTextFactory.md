---
title: "RTextFieldEditableTextFactory"
description: "API documentation for RTextFieldEditableTextFactory class from r_text_field_editable_text_factory"
category: "Classes"
library: "r_text_field_editable_text_factory"
outline: [2, 3]
---

# RTextFieldEditableTextFactory <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RTextFieldEditableTextFactory</span></div></div>

## Constructors {#section-constructors}

### RTextFieldEditableTextFactory() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rtextfieldeditabletextfactory}

<div class="member-signature"><div class="member-signature-code"><span class="kw">const</span> <span class="fn">RTextFieldEditableTextFactory</span>()</div></div>

:::details Implementation
```dart
const RTextFieldEditableTextFactory();
```
:::

## Properties {#section-properties}

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_presentation_r_text_field_editable_text_factory/RTextFieldEditableTextFactory#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_presentation_r_text_field_editable_text_factory/RTextFieldEditableTextFactory#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_presentation_r_text_field_editable_text_factory/RTextFieldEditableTextFactory#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_presentation_r_text_field_editable_text_factory/RTextFieldEditableTextFactory#operator-equals).
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

If a subclass overrides [hashCode](/api/src_presentation_r_text_field_editable_text_factory/RTextFieldEditableTextFactory#prop-hashcode), it should override the
[operator ==](/api/src_presentation_r_text_field_editable_text_factory/RTextFieldEditableTextFactory#operator-equals) operator as well to maintain consistency.

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

### create() {#create}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="type">dynamic</span> <span class="fn">create</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">context</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">editableTextKey</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">controller</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">focusNode</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">autofocus</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">obscureText</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">readOnly</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">enabled</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">isMultiline</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">keyboardType</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">textInputAction</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">textCapitalization</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">autocorrect</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">enableSuggestions</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">smartDashesType</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">smartQuotesType</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">int</span>? <span class="param">maxLines</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">int</span>? <span class="param">minLines</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span>? <span class="param">showCursor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">keyboardAppearance</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">scrollPadding</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">dragStartBehavior</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span>? <span class="param">enableInteractiveSelection</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<span class="type">dynamic</span>&gt;? <span class="param">inputFormatters</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">onChanged</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">onSubmitted</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">onEditingComplete</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">onTapOutside</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">resolvedTokens</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
Widget create({
  required BuildContext context,
  GlobalKey<EditableTextState>? editableTextKey,
  required TextEditingController controller,
  required FocusNode focusNode,
  required bool autofocus,
  required bool obscureText,
  required bool readOnly,
  required bool enabled,
  required bool isMultiline,
  required TextInputType? keyboardType,
  required TextInputAction? textInputAction,
  required TextCapitalization textCapitalization,
  required bool autocorrect,
  required bool enableSuggestions,
  required SmartDashesType? smartDashesType,
  required SmartQuotesType? smartQuotesType,
  required int? maxLines,
  required int? minLines,
  required bool? showCursor,
  required Brightness? keyboardAppearance,
  required EdgeInsets scrollPadding,
  required DragStartBehavior dragStartBehavior,
  required bool? enableInteractiveSelection,
  required List<TextInputFormatter>? inputFormatters,
  required ValueChanged<String> onChanged,
  required ValueChanged<String> onSubmitted,
  required VoidCallback? onEditingComplete,
  required TapRegionCallback? onTapOutside,
  RTextFieldResolvedTokens? resolvedTokens,
}) {
  final selectionStyle = DefaultSelectionStyle.of(context);
  final textStyle =
      resolvedTokens?.textStyle ?? DefaultTextStyle.of(context).style;
  final textColor = resolvedTokens?.textColor;
  final cursorColor = resolvedTokens?.cursorColor ??
      selectionStyle.cursorColor ??
      DefaultTextStyle.of(context).style.color ??
      const Color(0xFF000000);
  final selectionColor =
      resolvedTokens?.selectionColor ?? selectionStyle.selectionColor;

  final effectiveStyle = textStyle.copyWith(color: textColor);

  return EditableText(
    key: editableTextKey,
    controller: controller,
    focusNode: focusNode,
    style: effectiveStyle,
    cursorColor: cursorColor,
    backgroundCursorColor: cursorColor.withValues(alpha: 0.2),
    selectionColor: selectionColor,
    keyboardType: keyboardType ?? _inferKeyboardType(isMultiline),
    textInputAction: textInputAction ?? _inferTextInputAction(isMultiline),
    textCapitalization: textCapitalization,
    autocorrect: autocorrect,
    enableSuggestions: enableSuggestions,
    smartDashesType: smartDashesType,
    smartQuotesType: smartQuotesType,
    autofocus: autofocus,
    obscureText: obscureText,
    readOnly: readOnly || !enabled,
    showCursor: showCursor,
    maxLines: maxLines,
    minLines: minLines,
    keyboardAppearance:
        keyboardAppearance ?? MediaQuery.platformBrightnessOf(context),
    scrollPadding: scrollPadding,
    dragStartBehavior: dragStartBehavior,
    enableInteractiveSelection: enableInteractiveSelection ?? !obscureText,
    inputFormatters: inputFormatters,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    onEditingComplete: onEditingComplete,
    onTapOutside: onTapOutside,
    &#47;&#47; Match Flutter TextField: gesture handling is external.
    rendererIgnoresPointer: true,
    mouseCursor: MouseCursor.defer,
  );
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

