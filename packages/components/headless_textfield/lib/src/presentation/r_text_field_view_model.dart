import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'r_text_field.dart';
import 'r_text_field_style.dart';

final class RTextFieldViewModel {
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
    required this.enableIMEPersonalizedLearning,
    required this.smartDashesType,
    required this.smartQuotesType,
    required this.autofillHints,
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

  final String? placeholder;
  final String? label;
  final String? helperText;
  final String? errorText;
  final RTextFieldVariant variant;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool enableIMEPersonalizedLearning;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final Iterable<String>? autofillHints;
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
  final RTextFieldOverlayVisibilityMode clearButtonMode;
  final RTextFieldOverlayVisibilityMode prefixMode;
  final RTextFieldOverlayVisibilityMode suffixMode;
  final RTextFieldStyle? style;
  final RTextFieldSlots? slots;
  final RenderOverrides? overrides;
  final VoidCallback? onEditingComplete;
  final TapRegionCallback? onTapOutside;

  bool get isMultiline => maxLines == null || maxLines! > 1;
  bool get hasError => errorText != null;

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
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      autofillHints: widget.autofillHints,
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
}
