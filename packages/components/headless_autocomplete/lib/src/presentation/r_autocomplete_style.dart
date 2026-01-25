import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Simple, Flutter-like styling sugar for [RAutocomplete].
///
/// This type is NOT a new renderer contract.
/// It is a convenience layer that is internally converted to
/// `RenderOverrides.only(...)` for the field and options menu.
///
/// Priority (strong -> weak):
/// 1) explicit overrides
/// 2) style sugar
/// 3) theme/preset defaults
@immutable
final class RAutocompleteStyle {
  const RAutocompleteStyle({
    this.field,
    this.options,
  });

  /// Styling for the input field.
  final RAutocompleteFieldStyle? field;

  /// Styling for the options menu.
  final RAutocompleteOptionsStyle? options;
}

/// Styling sugar for the input field of [RAutocomplete].
@immutable
final class RAutocompleteFieldStyle {
  const RAutocompleteFieldStyle({
    this.containerPadding,
    this.containerBackgroundColor,
    this.containerBorderColor,
    this.containerBorderWidth,
    this.containerRadius,
    this.containerBorderRadius,
    this.textStyle,
    this.textColor,
    this.placeholderColor,
    this.labelColor,
    this.minSize,
  }) : assert(
          containerRadius == null || containerBorderRadius == null,
          'Provide either containerRadius or containerBorderRadius, not both.',
        );

  final EdgeInsetsGeometry? containerPadding;
  final Color? containerBackgroundColor;
  final Color? containerBorderColor;
  final double? containerBorderWidth;
  final double? containerRadius;
  final BorderRadius? containerBorderRadius;

  final TextStyle? textStyle;
  final Color? textColor;
  final Color? placeholderColor;
  final Color? labelColor;
  final Size? minSize;

  RTextFieldOverrides toOverrides() {
    final resolvedRadius = containerBorderRadius ??
        (containerRadius == null
            ? null
            : BorderRadius.all(Radius.circular(containerRadius!)));

    return RTextFieldOverrides.tokens(
      containerPadding: containerPadding,
      containerBackgroundColor: containerBackgroundColor,
      containerBorderColor: containerBorderColor,
      containerBorderRadius: resolvedRadius,
      containerBorderWidth: containerBorderWidth,
      textStyle: textStyle,
      textColor: textColor,
      placeholderColor: placeholderColor,
      labelColor: labelColor,
      minSize: minSize,
    );
  }
}

/// Styling sugar for the options menu of [RAutocomplete].
@immutable
final class RAutocompleteOptionsStyle {
  const RAutocompleteOptionsStyle({
    this.optionsBackgroundColor,
    this.optionsBorderColor,
    this.optionsRadius,
    this.optionsBorderRadius,
    this.optionsElevation,
    this.optionsMaxHeight,
    this.optionsPadding,
    this.optionTextStyle,
    this.optionPadding,
    this.optionMinHeight,
  }) : assert(
          optionsRadius == null || optionsBorderRadius == null,
          'Provide either optionsRadius or optionsBorderRadius, not both.',
        );

  final Color? optionsBackgroundColor;
  final Color? optionsBorderColor;
  final double? optionsRadius;
  final BorderRadius? optionsBorderRadius;
  final double? optionsElevation;
  final double? optionsMaxHeight;
  final EdgeInsetsGeometry? optionsPadding;
  final TextStyle? optionTextStyle;
  final EdgeInsetsGeometry? optionPadding;
  final double? optionMinHeight;

  RDropdownOverrides toOverrides() {
    final resolvedRadius = optionsBorderRadius ??
        (optionsRadius == null
            ? null
            : BorderRadius.all(Radius.circular(optionsRadius!)));

    return RDropdownOverrides.tokens(
      menuBackgroundColor: optionsBackgroundColor,
      menuBorderColor: optionsBorderColor,
      menuBorderRadius: resolvedRadius,
      menuElevation: optionsElevation,
      menuMaxHeight: optionsMaxHeight,
      menuPadding: optionsPadding,
      itemTextStyle: optionTextStyle,
      itemPadding: optionPadding,
      itemMinHeight: optionMinHeight,
    );
  }
}
