---
title: "RCupertinoTextField"
description: "API documentation for RCupertinoTextField class from r_cupertino_text_field"
category: "Classes"
library: "r_cupertino_text_field"
outline: [2, 3]
---

# RCupertinoTextField

<div class="member-signature"><div class="member-signature-code"><span class="kw">class</span> <span class="fn">RCupertinoTextField</span></div></div>

Cupertino-styled text field with DX-friendly API.

A convenience wrapper around [RTextField](/api/src_presentation_r_text_field/RTextField) that provides Cupertino-specific
defaults and exposes Cupertino-specific properties directly.

Defaults:

- [clearButtonMode](/api/src_textfield_r_cupertino_text_field/RCupertinoTextField#prop-clearbuttonmode) = [RTextFieldOverlayVisibilityMode.whileEditing](/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode#value-whileediting)
- [prefixMode](/api/src_textfield_r_cupertino_text_field/RCupertinoTextField#prop-prefixmode) = [RTextFieldOverlayVisibilityMode.always](/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode#value-always)
- [suffixMode](/api/src_textfield_r_cupertino_text_field/RCupertinoTextField#prop-suffixmode) = [RTextFieldOverlayVisibilityMode.always](/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode#value-always)
- [isBorderless](/api/src_textfield_r_cupertino_text_field/RCupertinoTextField#prop-isborderless) = false

## Constructors {#section-constructors}

### RCupertinoTextField() {#ctor-rcupertinotextfield}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="fn">RCupertinoTextField</span>({</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">key</span>,</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">value</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">controller</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">onChanged</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">onSubmitted</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">onEditingComplete</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">onTapOutside</span>,</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">placeholder</span>,</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">label</span>,</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">helperText</span>,</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">errorText</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">prefix</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">suffix</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">obscureText</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">enabled</span> = <span class="kw">true</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">readOnly</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">autofocus</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">focusNode</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">keyboardType</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">textInputAction</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">textCapitalization</span> = TextCapitalization.none,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">autocorrect</span> = <span class="kw">true</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">enableSuggestions</span> = <span class="kw">true</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">smartDashesType</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">smartQuotesType</span>,</span><span class="member-signature-line">  <span class="type">int</span>? <span class="param">maxLines</span> = <span class="num-lit">1</span>,</span><span class="member-signature-line">  <span class="type">int</span>? <span class="param">minLines</span>,</span><span class="member-signature-line">  <span class="type">int</span>? <span class="param">maxLength</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">maxLengthEnforcement</span>,</span><span class="member-signature-line">  <span class="type">bool</span>? <span class="param">showCursor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">keyboardAppearance</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">scrollPadding</span> = <span class="kw">const</span> EdgeInsets.all(<span class="num-lit">20.0</span>),</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">dragStartBehavior</span> = DragStartBehavior.start,</span><span class="member-signature-line">  <span class="type">bool</span>? <span class="param">enableInteractiveSelection</span>,</span><span class="member-signature-line">  <span class="type">List</span>&lt;<span class="type">dynamic</span>&gt;? <span class="param">inputFormatters</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">clearButtonMode</span> = RTextFieldOverlayVisibilityMode.whileEditing,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">prefixMode</span> = RTextFieldOverlayVisibilityMode.always,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">suffixMode</span> = RTextFieldOverlayVisibilityMode.always,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">padding</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">isBorderless</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">style</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">overrides</span>,</span><span class="member-signature-line">});</span></div></div>

:::details Implementation
```dart
RCupertinoTextField({
  super.key,
  this.value,
  this.controller,
  this.onChanged,
  this.onSubmitted,
  this.onEditingComplete,
  this.onTapOutside,
  this.placeholder,
  this.label,
  this.helperText,
  this.errorText,
  this.prefix,
  this.suffix,
  this.obscureText = false,
  this.enabled = true,
  this.readOnly = false,
  this.autofocus = false,
  this.focusNode,
  this.keyboardType,
  this.textInputAction,
  this.textCapitalization = TextCapitalization.none,
  this.autocorrect = true,
  this.enableSuggestions = true,
  this.smartDashesType,
  this.smartQuotesType,
  this.maxLines = 1,
  this.minLines,
  this.maxLength,
  this.maxLengthEnforcement,
  this.showCursor,
  this.keyboardAppearance,
  this.scrollPadding = const EdgeInsets.all(20.0),
  this.dragStartBehavior = DragStartBehavior.start,
  this.enableInteractiveSelection,
  this.inputFormatters,
  this.clearButtonMode = RTextFieldOverlayVisibilityMode.whileEditing,
  this.prefixMode = RTextFieldOverlayVisibilityMode.always,
  this.suffixMode = RTextFieldOverlayVisibilityMode.always,
  this.padding,
  this.isBorderless = false,
  this.style,
  this.overrides,
}) {
  if (value != null && controller != null) {
    throw ArgumentError(
      'Cannot provide both value and controller. '
      'Use either controlled mode (value + onChanged) or '
      'controller-driven mode (controller only).',
    );
  }
}
```
:::

### RCupertinoTextField.borderless() <span class="docs-badge docs-badge-tip">factory</span> {#borderless}

<div class="member-signature"><div class="member-signature-code"><span class="member-signature-line"><span class="kw">factory</span> <span class="fn">RCupertinoTextField.borderless</span>({</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">key</span>,</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">value</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">controller</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">onChanged</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">onSubmitted</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">onEditingComplete</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">onTapOutside</span>,</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">placeholder</span>,</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">label</span>,</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">helperText</span>,</span><span class="member-signature-line">  <span class="type">String</span>? <span class="param">errorText</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">prefix</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">suffix</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">obscureText</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">enabled</span> = <span class="kw">true</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">readOnly</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">autofocus</span> = <span class="kw">false</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">focusNode</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">keyboardType</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">textInputAction</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">textCapitalization</span> = TextCapitalization.none,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">autocorrect</span> = <span class="kw">true</span>,</span><span class="member-signature-line">  <span class="type">bool</span> <span class="param">enableSuggestions</span> = <span class="kw">true</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">smartDashesType</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">smartQuotesType</span>,</span><span class="member-signature-line">  <span class="type">int</span>? <span class="param">maxLines</span> = <span class="num-lit">1</span>,</span><span class="member-signature-line">  <span class="type">int</span>? <span class="param">minLines</span>,</span><span class="member-signature-line">  <span class="type">int</span>? <span class="param">maxLength</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">maxLengthEnforcement</span>,</span><span class="member-signature-line">  <span class="type">bool</span>? <span class="param">showCursor</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">keyboardAppearance</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">scrollPadding</span> = const EdgeInsets.all(20.0),</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">dragStartBehavior</span> = DragStartBehavior.start,</span><span class="member-signature-line">  <span class="type">bool</span>? <span class="param">enableInteractiveSelection</span>,</span><span class="member-signature-line">  <span class="type">List</span>&lt;<span class="type">dynamic</span>&gt;? <span class="param">inputFormatters</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">clearButtonMode</span> = RTextFieldOverlayVisibilityMode.whileEditing,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">prefixMode</span> = RTextFieldOverlayVisibilityMode.always,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">suffixMode</span> = RTextFieldOverlayVisibilityMode.always,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">padding</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">style</span>,</span><span class="member-signature-line">  <span class="type">dynamic</span> <span class="param">overrides</span>,</span><span class="member-signature-line">})</span></div></div>

Creates a borderless Cupertino text field.

This is a convenience constructor that sets [isBorderless](/api/src_textfield_r_cupertino_text_field/RCupertinoTextField#prop-isborderless) to true.

:::details Implementation
```dart
factory RCupertinoTextField.borderless({
  Key? key,
  String? value,
  TextEditingController? controller,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
  VoidCallback? onEditingComplete,
  TapRegionCallback? onTapOutside,
  String? placeholder,
  String? label,
  String? helperText,
  String? errorText,
  Widget? prefix,
  Widget? suffix,
  bool obscureText = false,
  bool enabled = true,
  bool readOnly = false,
  bool autofocus = false,
  FocusNode? focusNode,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  TextCapitalization textCapitalization = TextCapitalization.none,
  bool autocorrect = true,
  bool enableSuggestions = true,
  SmartDashesType? smartDashesType,
  SmartQuotesType? smartQuotesType,
  int? maxLines = 1,
  int? minLines,
  int? maxLength,
  MaxLengthEnforcement? maxLengthEnforcement,
  bool? showCursor,
  Brightness? keyboardAppearance,
  EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
  DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  bool? enableInteractiveSelection,
  List<TextInputFormatter>? inputFormatters,
  RTextFieldOverlayVisibilityMode clearButtonMode =
      RTextFieldOverlayVisibilityMode.whileEditing,
  RTextFieldOverlayVisibilityMode prefixMode =
      RTextFieldOverlayVisibilityMode.always,
  RTextFieldOverlayVisibilityMode suffixMode =
      RTextFieldOverlayVisibilityMode.always,
  EdgeInsetsGeometry? padding,
  RTextFieldStyle? style,
  RenderOverrides? overrides,
}) {
  return RCupertinoTextField(
    key: key,
    value: value,
    controller: controller,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    onEditingComplete: onEditingComplete,
    onTapOutside: onTapOutside,
    placeholder: placeholder,
    label: label,
    helperText: helperText,
    errorText: errorText,
    prefix: prefix,
    suffix: suffix,
    obscureText: obscureText,
    enabled: enabled,
    readOnly: readOnly,
    autofocus: autofocus,
    focusNode: focusNode,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    textCapitalization: textCapitalization,
    autocorrect: autocorrect,
    enableSuggestions: enableSuggestions,
    smartDashesType: smartDashesType,
    smartQuotesType: smartQuotesType,
    maxLines: maxLines,
    minLines: minLines,
    maxLength: maxLength,
    maxLengthEnforcement: maxLengthEnforcement,
    showCursor: showCursor,
    keyboardAppearance: keyboardAppearance,
    scrollPadding: scrollPadding,
    dragStartBehavior: dragStartBehavior,
    enableInteractiveSelection: enableInteractiveSelection,
    inputFormatters: inputFormatters,
    clearButtonMode: clearButtonMode,
    prefixMode: prefixMode,
    suffixMode: suffixMode,
    padding: padding,
    isBorderless: true,
    style: style,
    overrides: overrides,
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

Visibility mode for the clear button.

Default is [RTextFieldOverlayVisibilityMode.whileEditing](/api/src_renderers_textfield_r_text_field_overlay_visibility_mode/RTextFieldOverlayVisibilityMode#value-whileediting) (Cupertino default).

:::details Implementation
```dart
final RTextFieldOverlayVisibilityMode clearButtonMode;
```
:::

### controller <span class="docs-badge docs-badge-tip">final</span> {#prop-controller}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">controller</span></div></div>

:::details Implementation
```dart
final TextEditingController? controller;
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

### focusNode <span class="docs-badge docs-badge-tip">final</span> {#prop-focusnode}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">focusNode</span></div></div>

:::details Implementation
```dart
final FocusNode? focusNode;
```
:::

### hashCode <span class="docs-badge docs-badge-tip">no setter</span> <span class="docs-badge docs-badge-info">inherited</span> {#prop-hashcode}

<div class="member-signature"><div class="member-signature-code"><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></div></div>

The hash code for this object.

A hash code is a single integer which represents the state of the object
that affects [operator ==](/api/src_textfield_r_cupertino_text_field/RCupertinoTextField#operator-equals) comparisons.

All objects have hash codes.
The default hash code implemented by [Object](https://api.flutter.dev/flutter/dart-core/Object-class.html)
represents only the identity of the object,
the same way as the default [operator ==](/api/src_textfield_r_cupertino_text_field/RCupertinoTextField#operator-equals) implementation only considers objects
equal if they are identical (see [identityHashCode](https://api.flutter.dev/flutter/dart-core/identityHashCode.html)).

If [operator ==](/api/src_textfield_r_cupertino_text_field/RCupertinoTextField#operator-equals) is overridden to use the object state instead,
the hash code must also be changed to represent that state,
otherwise the object cannot be used in hash based data structures
like the default [Set](https://api.flutter.dev/flutter/dart-core/Set-class.html) and [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) implementations.

Hash codes must be the same for objects that are equal to each other
according to [operator ==](/api/src_textfield_r_cupertino_text_field/RCupertinoTextField#operator-equals).
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

If a subclass overrides [hashCode](/api/src_textfield_r_cupertino_text_field/RCupertinoTextField#prop-hashcode), it should override the
[operator ==](/api/src_textfield_r_cupertino_text_field/RCupertinoTextField#operator-equals) operator as well to maintain consistency.

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

### isBorderless <span class="docs-badge docs-badge-tip">final</span> {#prop-isborderless}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">bool</span> <span class="fn">isBorderless</span></div></div>

Whether to render without a visible border.

When true, the text field blends with its background.

:::details Implementation
```dart
final bool isBorderless;
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

### onChanged <span class="docs-badge docs-badge-tip">final</span> {#prop-onchanged}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">onChanged</span></div></div>

:::details Implementation
```dart
final ValueChanged<String>? onChanged;
```
:::

### onEditingComplete <span class="docs-badge docs-badge-tip">final</span> {#prop-oneditingcomplete}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">onEditingComplete</span></div></div>

:::details Implementation
```dart
final VoidCallback? onEditingComplete;
```
:::

### onSubmitted <span class="docs-badge docs-badge-tip">final</span> {#prop-onsubmitted}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">onSubmitted</span></div></div>

:::details Implementation
```dart
final ValueChanged<String>? onSubmitted;
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

Advanced per-instance overrides.

:::details Implementation
```dart
final RenderOverrides? overrides;
```
:::

### padding <span class="docs-badge docs-badge-tip">final</span> {#prop-padding}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">padding</span></div></div>

Custom padding for the text field container.

Overrides the default iOS 7px padding.

:::details Implementation
```dart
final EdgeInsetsGeometry? padding;
```
:::

### placeholder <span class="docs-badge docs-badge-tip">final</span> {#prop-placeholder}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span>? <span class="fn">placeholder</span></div></div>

:::details Implementation
```dart
final String? placeholder;
```
:::

### prefix <span class="docs-badge docs-badge-tip">final</span> {#prop-prefix}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">prefix</span></div></div>

Widget to display before text inside the input.

:::details Implementation
```dart
final Widget? prefix;
```
:::

### prefixMode <span class="docs-badge docs-badge-tip">final</span> {#prop-prefixmode}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">prefixMode</span></div></div>

Visibility mode for the prefix widget.

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

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">style</span></div></div>

Style sugar for common token overrides.

:::details Implementation
```dart
final RTextFieldStyle? style;
```
:::

### suffix <span class="docs-badge docs-badge-tip">final</span> {#prop-suffix}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">suffix</span></div></div>

Widget to display after text inside the input.

:::details Implementation
```dart
final Widget? suffix;
```
:::

### suffixMode <span class="docs-badge docs-badge-tip">final</span> {#prop-suffixmode}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">dynamic</span> <span class="fn">suffixMode</span></div></div>

Visibility mode for the suffix widget.

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

### value <span class="docs-badge docs-badge-tip">final</span> {#prop-value}

<div class="member-signature"><div class="member-signature-code"><span class="kw">final</span> <span class="type">String</span>? <span class="fn">value</span></div></div>

:::details Implementation
```dart
final String? value;
```
:::

## Methods {#section-methods}

### build() {#build}

<div class="member-signature"><div class="member-signature-code"><span class="type">dynamic</span> <span class="fn">build</span>(<span class="type">dynamic</span> <span class="param">context</span>)</div></div>

:::details Implementation
```dart
@override
Widget build(BuildContext context) {
  &#47;&#47; Build Cupertino-specific overrides
  final cupertinoOverrides = CupertinoTextFieldOverrides(
    padding: padding,
    isBorderless: isBorderless,
  );

  &#47;&#47; Merge overrides
  final baseOverrides = RenderOverrides.only(cupertinoOverrides);
  final effectiveOverrides =
      overrides != null ? baseOverrides.merge(overrides!) : baseOverrides;

  &#47;&#47; Build slots
  final slots = (prefix != null || suffix != null)
      ? RTextFieldSlots(prefix: prefix, suffix: suffix)
      : null;

  return RTextField(
    value: value,
    controller: controller,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    onEditingComplete: onEditingComplete,
    onTapOutside: onTapOutside,
    placeholder: placeholder,
    label: label,
    helperText: helperText,
    errorText: errorText,
    obscureText: obscureText,
    enabled: enabled,
    readOnly: readOnly,
    autofocus: autofocus,
    focusNode: focusNode,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    textCapitalization: textCapitalization,
    autocorrect: autocorrect,
    enableSuggestions: enableSuggestions,
    smartDashesType: smartDashesType,
    smartQuotesType: smartQuotesType,
    maxLines: maxLines,
    minLines: minLines,
    maxLength: maxLength,
    maxLengthEnforcement: maxLengthEnforcement,
    showCursor: showCursor,
    keyboardAppearance: keyboardAppearance,
    scrollPadding: scrollPadding,
    dragStartBehavior: dragStartBehavior,
    enableInteractiveSelection: enableInteractiveSelection,
    inputFormatters: inputFormatters,
    clearButtonMode: clearButtonMode,
    prefixMode: prefixMode,
    suffixMode: suffixMode,
    style: style,
    slots: slots,
    overrides: effectiveOverrides,
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

