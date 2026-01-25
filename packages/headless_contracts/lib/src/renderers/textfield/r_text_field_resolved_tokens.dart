import 'package:flutter/widgets.dart';

/// Resolved visual tokens for TextField rendering.
///
/// These are the final computed values that a renderer uses.
/// Token resolution flow: spec + states → resolver → tokens → renderer.
///
/// All fields are required to ensure preset interoperability.
@immutable
final class RTextFieldResolvedTokens {
  const RTextFieldResolvedTokens({
    // Container
    required this.containerPadding,
    required this.containerBackgroundColor,
    required this.containerBorderColor,
    required this.containerBorderRadius,
    required this.containerBorderWidth,
    required this.containerElevation,
    required this.containerAnimationDuration,
    // Label / Helper / Error
    required this.labelStyle,
    required this.labelColor,
    required this.helperStyle,
    required this.helperColor,
    required this.errorStyle,
    required this.errorColor,
    required this.messageSpacing,
    // Input
    required this.textStyle,
    required this.textColor,
    required this.placeholderStyle,
    required this.placeholderColor,
    required this.cursorColor,
    required this.selectionColor,
    required this.disabledOpacity,
    // Icons / Slots
    required this.iconColor,
    required this.iconSpacing,
    // Sizing
    required this.minSize,
  });

  // Container tokens
  final EdgeInsetsGeometry containerPadding;
  final Color containerBackgroundColor;
  final Color containerBorderColor;
  final BorderRadius containerBorderRadius;
  final double containerBorderWidth;
  final double containerElevation;
  final Duration containerAnimationDuration;

  // Label / Helper / Error tokens
  final TextStyle labelStyle;
  final Color labelColor;
  final TextStyle helperStyle;
  final Color helperColor;
  final TextStyle errorStyle;
  final Color errorColor;
  final double messageSpacing;

  // Input tokens
  final TextStyle textStyle;
  final Color textColor;
  final TextStyle placeholderStyle;
  final Color placeholderColor;
  final Color cursorColor;
  final Color selectionColor;
  final double disabledOpacity;

  // Icons / Slots tokens
  final Color iconColor;
  final double iconSpacing;

  // Sizing
  final Size minSize;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RTextFieldResolvedTokens &&
        other.containerPadding == containerPadding &&
        other.containerBackgroundColor == containerBackgroundColor &&
        other.containerBorderColor == containerBorderColor &&
        other.containerBorderRadius == containerBorderRadius &&
        other.containerBorderWidth == containerBorderWidth &&
        other.containerElevation == containerElevation &&
        other.containerAnimationDuration == containerAnimationDuration &&
        other.labelStyle == labelStyle &&
        other.labelColor == labelColor &&
        other.helperStyle == helperStyle &&
        other.helperColor == helperColor &&
        other.errorStyle == errorStyle &&
        other.errorColor == errorColor &&
        other.messageSpacing == messageSpacing &&
        other.textStyle == textStyle &&
        other.textColor == textColor &&
        other.placeholderStyle == placeholderStyle &&
        other.placeholderColor == placeholderColor &&
        other.cursorColor == cursorColor &&
        other.selectionColor == selectionColor &&
        other.disabledOpacity == disabledOpacity &&
        other.iconColor == iconColor &&
        other.iconSpacing == iconSpacing &&
        other.minSize == minSize;
  }

  @override
  int get hashCode => Object.hashAll([
        containerPadding,
        containerBackgroundColor,
        containerBorderColor,
        containerBorderRadius,
        containerBorderWidth,
        containerElevation,
        containerAnimationDuration,
        labelStyle,
        labelColor,
        helperStyle,
        helperColor,
        errorStyle,
        errorColor,
        messageSpacing,
        textStyle,
        textColor,
        placeholderStyle,
        placeholderColor,
        cursorColor,
        selectionColor,
        disabledOpacity,
        iconColor,
        iconSpacing,
        minSize,
      ]);
}
