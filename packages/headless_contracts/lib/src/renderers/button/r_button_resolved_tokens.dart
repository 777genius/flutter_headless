import 'package:flutter/widgets.dart';

import 'r_button_motion_tokens.dart';

/// Resolved visual tokens for button rendering.
///
/// These are the **final, computed values** that a renderer uses.
/// Token resolution happens in the component (or theme), not in the renderer.
///
/// The renderer receives these values and applies them directly without
/// any additional computation or state-dependent logic.
///
/// See `docs/V1_DECISIONS.md` → "Token Resolution Layer".
@immutable
final class RButtonResolvedTokens {
  const RButtonResolvedTokens({
    required this.textStyle,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.padding,
    required this.minSize,
    required this.borderRadius,
    required this.disabledOpacity,
    required this.pressOverlayColor,
    required this.pressOpacity,
    this.motion,
  });

  /// Text style for button label.
  final TextStyle textStyle;

  /// Foreground color (icon, text).
  final Color foregroundColor;

  /// Background fill color.
  final Color backgroundColor;

  /// Border/outline color.
  final Color borderColor;

  /// Content padding.
  final EdgeInsetsGeometry padding;

  /// Minimum touch target size (WCAG/platform guidelines).
  final Size minSize;

  /// Corner radius for button shape.
  final BorderRadius borderRadius;

  /// Opacity applied when button is disabled (0.0-1.0).
  ///
  /// Used by renderer to dim the entire button in disabled state.
  /// Default is typically 0.38 (Material Design guideline).
  final double disabledOpacity;

  /// Overlay color for visual press feedback (Material-style).
  final Color pressOverlayColor;

  /// Opacity for pressed feedback (Cupertino-style).
  final double pressOpacity;

  /// Motion tokens for visual transitions.
  ///
  /// If null, renderer uses its preset defaults.
  final RButtonMotionTokens? motion;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RButtonResolvedTokens &&
        other.textStyle == textStyle &&
        other.foregroundColor == foregroundColor &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.padding == padding &&
        other.minSize == minSize &&
        other.borderRadius == borderRadius &&
        other.disabledOpacity == disabledOpacity &&
        other.pressOverlayColor == pressOverlayColor &&
        other.pressOpacity == pressOpacity &&
        other.motion == motion;
  }

  @override
  int get hashCode => Object.hash(
        textStyle,
        foregroundColor,
        backgroundColor,
        borderColor,
        padding,
        minSize,
        borderRadius,
        disabledOpacity,
        pressOverlayColor,
        pressOpacity,
        motion,
      );
}
