import 'package:flutter/widgets.dart';

import 'r_checkbox_motion_tokens.dart';

/// Resolved visual tokens for checkbox rendering.
@immutable
final class RCheckboxResolvedTokens {
  const RCheckboxResolvedTokens({
    required this.boxSize,
    required this.borderRadius,
    required this.borderWidth,
    required this.borderColor,
    required this.activeColor,
    required this.inactiveColor,
    required this.checkColor,
    required this.indeterminateColor,
    required this.disabledOpacity,
    required this.pressOverlayColor,
    required this.pressOpacity,
    required this.minTapTargetSize,
    this.motion,
  });

  /// Visual size of the checkbox square.
  final double boxSize;

  /// Corner radius for the checkbox box.
  final BorderRadius borderRadius;

  /// Border width.
  final double borderWidth;

  /// Border color.
  final Color borderColor;

  /// Fill color when checked.
  final Color activeColor;

  /// Fill color when unchecked.
  final Color inactiveColor;

  /// Checkmark color.
  final Color checkColor;

  /// Indeterminate mark color.
  final Color indeterminateColor;

  /// Opacity applied when disabled (0.0-1.0).
  final double disabledOpacity;

  /// Overlay color for press feedback (Material-style).
  final Color pressOverlayColor;

  /// Opacity for pressed feedback (Cupertino-style).
  final double pressOpacity;

  /// Minimum tap target size.
  final Size minTapTargetSize;

  /// Motion tokens for visual transitions.
  final RCheckboxMotionTokens? motion;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RCheckboxResolvedTokens &&
        other.boxSize == boxSize &&
        other.borderRadius == borderRadius &&
        other.borderWidth == borderWidth &&
        other.borderColor == borderColor &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor &&
        other.checkColor == checkColor &&
        other.indeterminateColor == indeterminateColor &&
        other.disabledOpacity == disabledOpacity &&
        other.pressOverlayColor == pressOverlayColor &&
        other.pressOpacity == pressOpacity &&
        other.minTapTargetSize == minTapTargetSize &&
        other.motion == motion;
  }

  @override
  int get hashCode => Object.hash(
        boxSize,
        borderRadius,
        borderWidth,
        borderColor,
        activeColor,
        inactiveColor,
        checkColor,
        indeterminateColor,
        disabledOpacity,
        pressOverlayColor,
        pressOpacity,
        minTapTargetSize,
        motion,
      );
}

