---
title: "RTextFieldViewModel"
description: "API documentation for RTextFieldViewModel class from r_text_field_view_model"
category: "Classes"
library: "r_text_field_view_model"
outline: [2, 3]
---

# RTextFieldViewModel <span class="docs-badge docs-badge-info">final</span>

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RTextFieldViewModel</span></div></div>

## Constructors {#section-constructors}

### RTextFieldViewModel() <span class="docs-badge docs-badge-tip">const</span> {#ctor-rtextfieldviewmodel}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">const</span> <span class="fn">RTextFieldViewModel</span>({</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">String</span>? <span class="param">placeholder</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">String</span>? <span class="param">label</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">String</span>? <span class="param">helperText</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">String</span>? <span class="param">errorText</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">variant</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">obscureText</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">enabled</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">readOnly</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">autofocus</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">keyboardType</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">textInputAction</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">textCapitalization</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">autocorrect</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span> <span class="param">enableSuggestions</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">smartDashesType</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">smartQuotesType</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">int</span>? <span class="param">maxLines</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">int</span>? <span class="param">minLines</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">int</span>? <span class="param">maxLength</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">maxLengthEnforcement</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span>? <span class="param">showCursor</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">keyboardAppearance</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">scrollPadding</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">dragStartBehavior</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">bool</span>? <span class="param">enableInteractiveSelection</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">List</span>&lt;<span class="type">dynamic</span>&gt;? <span class="param">inputFormatters</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">clearButtonMode</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">prefixMode</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">suffixMode</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <a href="/api/src_presentation_r_text_field_style/RTextFieldStyle" class="type-link">RTextFieldStyle</a>? <span class="param">style</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">slots</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">overrides</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">onEditingComplete</span>,</span><span class="member-signature-line">  <span class="kw">required</span> <span class="type">dynamic</span> <span class="param">onTapOutside</span>,</span><span class="member-signature-line">})</span></div></div>

:::details Implementation
```dart
const RTextFieldViewModel({
  required this.placeholder,
  required this.label,
  required this.helperText,
  required this.errorText,
  required this.variant,
  required this.obscureText,
  required this.enabled,
  required this.readOnly,
  required this.autofocus,
  required this.keyboardType,
  required this.textInputAction,
  required this.textCapitalization,
  required this.autocorrect,
  required this.enableSuggestions,
  required this.smartDashesType,
  required this.smartQuotesType,
  required this.maxLines,
  required this.minLines,
  required this.maxLength,
  required this.maxLengthEnforcement,
  required this.showCursor,
  required this.keyboardAppearance,
  required this.scrollPadding,
  required this.dragStartBehavior,
  required this.enableInteractiveSelection,
  required this.inputFormatters,
  required this.clearButtonMode,
  required this.prefixMode,
  required this.suffixMode,
  required this.style,
  required this.slots,
  required this.overrides,
  required this.onEditingComplete,
  required this.onTapOutside,
});
```
:::

### RTextFieldViewModel.fromWidget() <span class="docs-badge docs-badge-tip">factory</span> {#fromwidget}

<div class="member-signature"><div class="member-signature-code"><span class="kw">factory</span> <span class="fn">RTextFieldViewModel.fromWidget</span>(<a href="/api/src_presentation_r_text_field/RTextField" class="type-link">RTextField</a> <span class="param">widget</span>)</div></div>

:::details Implementation
```dart
factory RTextFieldViewModel.fromWidget(RTextField widget) {
  return RTextFieldViewModel(
    placeholder: widget.placeholder,
    label: widget.label,
    helperText: widget.helperText,
    errorText: widget.errorText,
    variant: widget.variant,
    obscureText: widget.obscureText,
    enabled: widget.enabled,
    readOnly: widget.readOnly,
    autofocus: widget.autofocus,
    keyboardType: widget.keyboardType,
    textInputAction: widget.textInputAction,
    textCapitalization: widget.textCapitalization,
    autocorrect: widget.autocorrect,
    enableSuggestions: widget.enableSuggestions,
    smartDashesType: widget.smartDashesType,
    smartQuotesType: widget.smartQuotesType,
    maxLines: widget.maxLines,
    minLines: widget.minLines,
    maxLength: widget.maxLength,
    maxLengthEnforcement: widget.maxLengthEnforcement,
    showCursor: widget.showCursor,
    keyboardAppearance: widget.keyboardAppearance,
    scrollPadding: widget.scrollPadding,
    dragStartBehavior: widget.dragStartBehavior,
    enableInteractiveSelection: widget.enableInteractiveSelection,
    inputFormatters: widget.inputFormatters,
    clearButtonMode: widget.clearButtonMode,
    prefixMode: widget.prefixMode,
    suffixMode: widget.suffixMode,
    style: widget.style,
    slots: widget.slots,
    overrides: widget.overrides,
    onEditingComplete: widget.onEditingComplete,
    onTapOutside: widget.onTapOutside,
  );
}
```
:::

## Properties {#section-properties}

### autocorrect <span class="docs-badge docs-badge-tip">final</span> {#prop-autocorrect}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">autocorrect</span></div></div>

:::details Implementation
```dart
final bool autocorrect;
```
:::

### autofocus <span class="docs-badge docs-badge-tip">final</span> {#prop-autofocus}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">autofocus</span></div></div>

:::details Implementation
```dart
final bool autofocus;
```
:::

### clearButtonMode <span class="docs-badge docs-badge-tip">final</span> {#prop-clearbuttonmode}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">clearButtonMode</span></div></div>

:::details Implementation
```dart
final RTextFieldOverlayVisibilityMode clearButtonMode;
```
:::

### dragStartBehavior <span class="docs-badge docs-badge-tip">final</span> {#prop-dragstartbehavior}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">dragStartBehavior</span></div></div>

:::details Implementation
```dart
final DragStartBehavior dragStartBehavior;
```
:::

### enabled <span class="docs-badge docs-badge-tip">final</span> {#prop-enabled}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">enabled</span></div></div>

:::details Implementation
```dart
final bool enabled;
```
:::

### enableInteractiveSelection <span class="docs-badge docs-badge-tip">final</span> {#prop-enableinteractiveselection}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span>? <span class="fn">enableInteractiveSelection</span></div></div>

:::details Implementation
```dart
final bool? enableInteractiveSelection;
```
:::

### enableSuggestions <span class="docs-badge docs-badge-tip">final</span> {#prop-enablesuggestions}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">enableSuggestions</span></div></div>

:::details Implementation
```dart
final bool enableSuggestions;
```
:::

### errorText <span class="docs-badge docs-badge-tip">final</span> {#prop-errortext}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span>? <span class="fn">errorText</span></div></div>

:::details Implementation
```dart
final String? errorText;
```
:::

### hasError <span class="docs-badge docs-badge-tip">no setter</span> {#prop-haserror}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">hasError</span></div></div>

:::details Implementation
```dart
bool get hasError => errorText != null;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_presentation_r_text_field_view_model/RTextFieldViewModel#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_presentation_r_text_field_view_model/RTextFieldViewModel#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_presentation_r_text_field_view_model/RTextFieldViewModel#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_presentation_r_text_field_view_model/RTextFieldViewModel#operator-equals).
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

If a subclass overrides [hashCode](/api/src_presentation_r_text_field_view_model/RTextFieldViewModel#prop-hashcode), it should override the
[operator ==](/api/src_presentation_r_text_field_view_model/RTextFieldViewModel#operator-equals) operator as well to maintain consistency.

*Inherited from Object.*

:::details Implementation
```dart
external int get hashCode;
```
:::

### helperText <span class="docs-badge docs-badge-tip">final</span> {#prop-helpertext}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span>? <span class="fn">helperText</span></div></div>

:::details Implementation
```dart
final String? helperText;
```
:::

### inputFormatters <span class="docs-badge docs-badge-tip">final</span> {#prop-inputformatters}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">List</span>&lt;<span class="type">dynamic</span>&gt;? <span class="fn">inputFormatters</span></div></div>

:::details Implementation
```dart
final List<TextInputFormatter>? inputFormatters;
```
:::

### isMultiline <span class="docs-badge docs-badge-tip">no setter</span> {#prop-ismultiline}

<div class="member-signature"><div class="member-signature-code"><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isMultiline</span></div></div>

:::details Implementation
```dart
bool get isMultiline => maxLines == null || maxLines! > 1;
```
:::

### keyboardAppearance <span class="docs-badge docs-badge-tip">final</span> {#prop-keyboardappearance}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">keyboardAppearance</span></div></div>

:::details Implementation
```dart
final Brightness? keyboardAppearance;
```
:::

### keyboardType <span class="docs-badge docs-badge-tip">final</span> {#prop-keyboardtype}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">keyboardType</span></div></div>

:::details Implementation
```dart
final TextInputType? keyboardType;
```
:::

### label <span class="docs-badge docs-badge-tip">final</span> {#prop-label}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span>? <span class="fn">label</span></div></div>

:::details Implementation
```dart
final String? label;
```
:::

### maxLength <span class="docs-badge docs-badge-tip">final</span> {#prop-maxlength}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">int</span>? <span class="fn">maxLength</span></div></div>

:::details Implementation
```dart
final int? maxLength;
```
:::

### maxLengthEnforcement <span class="docs-badge docs-badge-tip">final</span> {#prop-maxlengthenforcement}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">maxLengthEnforcement</span></div></div>

:::details Implementation
```dart
final MaxLengthEnforcement? maxLengthEnforcement;
```
:::

### maxLines <span class="docs-badge docs-badge-tip">final</span> {#prop-maxlines}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">int</span>? <span class="fn">maxLines</span></div></div>

:::details Implementation
```dart
final int? maxLines;
```
:::

### minLines <span class="docs-badge docs-badge-tip">final</span> {#prop-minlines}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">int</span>? <span class="fn">minLines</span></div></div>

:::details Implementation
```dart
final int? minLines;
```
:::

### obscureText <span class="docs-badge docs-badge-tip">final</span> {#prop-obscuretext}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">obscureText</span></div></div>

:::details Implementation
```dart
final bool obscureText;
```
:::

### onEditingComplete <span class="docs-badge docs-badge-tip">final</span> {#prop-oneditingcomplete}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">onEditingComplete</span></div></div>

:::details Implementation
```dart
final VoidCallback? onEditingComplete;
```
:::

### onTapOutside <span class="docs-badge docs-badge-tip">final</span> {#prop-ontapoutside}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">onTapOutside</span></div></div>

:::details Implementation
```dart
final TapRegionCallback? onTapOutside;
```
:::

### overrides <span class="docs-badge docs-badge-tip">final</span> {#prop-overrides}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">overrides</span></div></div>

:::details Implementation
```dart
final RenderOverrides? overrides;
```
:::

### placeholder <span class="docs-badge docs-badge-tip">final</span> {#prop-placeholder}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span>? <span class="fn">placeholder</span></div></div>

:::details Implementation
```dart
final String? placeholder;
```
:::

### prefixMode <span class="docs-badge docs-badge-tip">final</span> {#prop-prefixmode}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">prefixMode</span></div></div>

:::details Implementation
```dart
final RTextFieldOverlayVisibilityMode prefixMode;
```
:::

### readOnly <span class="docs-badge docs-badge-tip">final</span> {#prop-readonly}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">readOnly</span></div></div>

:::details Implementation
```dart
final bool readOnly;
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

### scrollPadding <span class="docs-badge docs-badge-tip">final</span> {#prop-scrollpadding}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">scrollPadding</span></div></div>

:::details Implementation
```dart
final EdgeInsets scrollPadding;
```
:::

### showCursor <span class="docs-badge docs-badge-tip">final</span> {#prop-showcursor}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span>? <span class="fn">showCursor</span></div></div>

:::details Implementation
```dart
final bool? showCursor;
```
:::

### slots <span class="docs-badge docs-badge-tip">final</span> {#prop-slots}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">slots</span></div></div>

:::details Implementation
```dart
final RTextFieldSlots? slots;
```
:::

### smartDashesType <span class="docs-badge docs-badge-tip">final</span> {#prop-smartdashestype}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">smartDashesType</span></div></div>

:::details Implementation
```dart
final SmartDashesType? smartDashesType;
```
:::

### smartQuotesType <span class="docs-badge docs-badge-tip">final</span> {#prop-smartquotestype}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">smartQuotesType</span></div></div>

:::details Implementation
```dart
final SmartQuotesType? smartQuotesType;
```
:::

### style <span class="docs-badge docs-badge-tip">final</span> {#prop-style}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <a href="/api/src_presentation_r_text_field_style/RTextFieldStyle" class="type-link">RTextFieldStyle</a>? <span class="fn">style</span></div></div>

:::details Implementation
```dart
final RTextFieldStyle? style;
```
:::

### suffixMode <span class="docs-badge docs-badge-tip">final</span> {#prop-suffixmode}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">suffixMode</span></div></div>

:::details Implementation
```dart
final RTextFieldOverlayVisibilityMode suffixMode;
```
:::

### textCapitalization <span class="docs-badge docs-badge-tip">final</span> {#prop-textcapitalization}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">textCapitalization</span></div></div>

:::details Implementation
```dart
final TextCapitalization textCapitalization;
```
:::

### textInputAction <span class="docs-badge docs-badge-tip">final</span> {#prop-textinputaction}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">textInputAction</span></div></div>

:::details Implementation
```dart
final TextInputAction? textInputAction;
```
:::

### variant <span class="docs-badge docs-badge-tip">final</span> {#prop-variant}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">variant</span></div></div>

:::details Implementation
```dart
final RTextFieldVariant variant;
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

