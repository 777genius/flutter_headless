import 'package:flutter/widgets.dart';

/// Per-instance overrides for TextField components (contract level).
///
/// This is a "token patch": all fields are nullable.
/// Resolver takes base tokens and applies this patch on top.
///
/// Overrides affect only visual/layout, never behavior (focus/IME/selection).
///
/// See `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`.
@immutable
final class RTextFieldOverrides {
  const RTextFieldOverrides({
    // Container
    this.containerPadding,
    this.containerBackgroundColor,
    this.containerBorderColor,
    this.containerBorderRadius,
    this.containerBorderWidth,
    this.containerElevation,
    this.containerAnimationDuration,
    // Label / Helper / Error
    this.labelStyle,
    this.labelColor,
    this.helperStyle,
    this.helperColor,
    this.errorStyle,
    this.errorColor,
    this.messageSpacing,
    // Input
    this.textStyle,
    this.textColor,
    this.placeholderStyle,
    this.placeholderColor,
    this.cursorColor,
    this.selectionColor,
    // Icons / Slots
    this.iconColor,
    this.iconSpacing,
    // Sizing
    this.minSize,
  });

  /// Named constructor for token overrides.
  const RTextFieldOverrides.tokens({
    this.containerPadding,
    this.containerBackgroundColor,
    this.containerBorderColor,
    this.containerBorderRadius,
    this.containerBorderWidth,
    this.containerElevation,
    this.containerAnimationDuration,
    this.labelStyle,
    this.labelColor,
    this.helperStyle,
    this.helperColor,
    this.errorStyle,
    this.errorColor,
    this.messageSpacing,
    this.textStyle,
    this.textColor,
    this.placeholderStyle,
    this.placeholderColor,
    this.cursorColor,
    this.selectionColor,
    this.iconColor,
    this.iconSpacing,
    this.minSize,
  });

  // Container overrides
  final EdgeInsetsGeometry? containerPadding;
  final Color? containerBackgroundColor;
  final Color? containerBorderColor;
  final BorderRadius? containerBorderRadius;
  final double? containerBorderWidth;
  final double? containerElevation;
  final Duration? containerAnimationDuration;

  // Label / Helper / Error overrides
  final TextStyle? labelStyle;
  final Color? labelColor;
  final TextStyle? helperStyle;
  final Color? helperColor;
  final TextStyle? errorStyle;
  final Color? errorColor;
  final double? messageSpacing;

  // Input overrides
  final TextStyle? textStyle;
  final Color? textColor;
  final TextStyle? placeholderStyle;
  final Color? placeholderColor;
  final Color? cursorColor;
  final Color? selectionColor;

  // Icons / Slots overrides
  final Color? iconColor;
  final double? iconSpacing;

  // Sizing overrides
  final Size? minSize;
}
