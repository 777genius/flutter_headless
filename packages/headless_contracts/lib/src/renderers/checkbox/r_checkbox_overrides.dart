import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'r_checkbox_motion_tokens.dart';

/// Per-instance override contract for Checkbox components.
///
/// This is the preset-agnostic override type that lives in headless_contracts.
/// Users can customize a specific checkbox instance without depending on
/// preset-specific types.
@immutable
final class RCheckboxOverrides {
  const RCheckboxOverrides({
    this.boxSize,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.activeColor,
    this.inactiveColor,
    this.checkColor,
    this.indeterminateColor,
    this.disabledOpacity,
    this.pressOverlayColor,
    this.pressOpacity,
    this.motion,
    this.minTapTargetSize,
  });

  /// Factory for token-level overrides.
  const factory RCheckboxOverrides.tokens({
    double? boxSize,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color? borderColor,
    Color? activeColor,
    Color? inactiveColor,
    Color? checkColor,
    Color? indeterminateColor,
    double? disabledOpacity,
    Color? pressOverlayColor,
    double? pressOpacity,
    RCheckboxMotionTokens? motion,
    Size? minTapTargetSize,
  }) = RCheckboxOverrides;

  /// Visual size of the checkbox square.
  final double? boxSize;

  /// Corner radius for the checkbox box.
  final BorderRadius? borderRadius;

  /// Border width.
  final double? borderWidth;

  /// Border color.
  final Color? borderColor;

  /// Fill color for checked state.
  final Color? activeColor;

  /// Fill color for unchecked state.
  final Color? inactiveColor;

  /// Color for the checkmark glyph.
  final Color? checkColor;

  /// Color for indeterminate glyph.
  final Color? indeterminateColor;

  /// Opacity applied when disabled (0.0-1.0).
  final double? disabledOpacity;

  /// Overlay color for press feedback (Material-style).
  final Color? pressOverlayColor;

  /// Opacity for pressed feedback (Cupertino-style).
  final double? pressOpacity;

  /// Motion tokens for visual transitions.
  final RCheckboxMotionTokens? motion;

  /// Minimum tap target size (WCAG/platform policy).
  final Size? minTapTargetSize;

  bool get hasOverrides =>
      boxSize != null ||
      borderRadius != null ||
      borderWidth != null ||
      borderColor != null ||
      activeColor != null ||
      inactiveColor != null ||
      checkColor != null ||
      indeterminateColor != null ||
      disabledOpacity != null ||
      pressOverlayColor != null ||
      pressOpacity != null ||
      motion != null ||
      minTapTargetSize != null;
}

