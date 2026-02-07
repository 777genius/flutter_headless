import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_textfield/headless_textfield.dart';

import '../overrides/cupertino_text_field_overrides.dart';

/// Cupertino-styled text field with DX-friendly API.
///
/// A convenience wrapper around [RTextField] that provides Cupertino-specific
/// defaults and exposes Cupertino-specific properties directly.
///
/// Defaults:
/// - [clearButtonMode] = [RTextFieldOverlayVisibilityMode.whileEditing]
/// - [prefixMode] = [RTextFieldOverlayVisibilityMode.always]
/// - [suffixMode] = [RTextFieldOverlayVisibilityMode.always]
/// - [isBorderless] = false
///
/// Example:
/// ```dart
/// RCupertinoTextField(
///   placeholder: 'Enter text',
///   clearButtonMode: RTextFieldOverlayVisibilityMode.whileEditing,
/// )
/// ```
class RCupertinoTextField extends StatelessWidget {
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

  /// Creates a borderless Cupertino text field.
  ///
  /// This is a convenience constructor that sets [isBorderless] to true.
  ///
  /// Example:
  /// ```dart
  /// RCupertinoTextField.borderless(
  ///   placeholder: 'Search...',
  /// )
  /// ```
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

  // Standard TextField props
  final String? value;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final TapRegionCallback? onTapOutside;
  final String? placeholder;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final bool? showCursor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final DragStartBehavior dragStartBehavior;
  final bool? enableInteractiveSelection;
  final List<TextInputFormatter>? inputFormatters;

  // Cupertino-specific props
  /// Widget to display before text inside the input.
  final Widget? prefix;

  /// Widget to display after text inside the input.
  final Widget? suffix;

  /// Visibility mode for the clear button.
  ///
  /// Default is [RTextFieldOverlayVisibilityMode.whileEditing] (Cupertino default).
  final RTextFieldOverlayVisibilityMode clearButtonMode;

  /// Visibility mode for the prefix widget.
  final RTextFieldOverlayVisibilityMode prefixMode;

  /// Visibility mode for the suffix widget.
  final RTextFieldOverlayVisibilityMode suffixMode;

  /// Custom padding for the text field container.
  ///
  /// Overrides the default iOS 7px padding.
  final EdgeInsetsGeometry? padding;

  /// Whether to render without a visible border.
  ///
  /// When true, the text field blends with its background.
  final bool isBorderless;

  /// Style sugar for common token overrides.
  final RTextFieldStyle? style;

  /// Advanced per-instance overrides.
  final RenderOverrides? overrides;

  @override
  Widget build(BuildContext context) {
    // Build Cupertino-specific overrides
    final cupertinoOverrides = CupertinoTextFieldOverrides(
      padding: padding,
      isBorderless: isBorderless,
    );

    // Merge overrides
    final baseOverrides = RenderOverrides.only(cupertinoOverrides);
    final effectiveOverrides = overrides != null
        ? baseOverrides.merge(overrides!)
        : baseOverrides;

    // Build slots
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
}
