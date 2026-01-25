import 'package:flutter/widgets.dart';

import 'r_switch_motion_tokens.dart';

/// Resolved visual tokens for switch rendering.
@immutable
final class RSwitchResolvedTokens {
  const RSwitchResolvedTokens({
    required this.trackSize,
    required this.trackBorderRadius,
    required this.trackOutlineColor,
    required this.trackOutlineWidth,
    required this.activeTrackColor,
    required this.inactiveTrackColor,
    required this.thumbSizeUnselected,
    required this.thumbSizeSelected,
    required this.thumbSizePressed,
    required this.thumbSizeTransition,
    required this.activeThumbColor,
    required this.inactiveThumbColor,
    required this.thumbPadding,
    required this.disabledOpacity,
    required this.pressOverlayColor,
    required this.pressOpacity,
    required this.minTapTargetSize,
    required this.stateLayerRadius,
    required this.stateLayerColor,
    this.thumbIcon,
    this.motion,
  });

  /// Size of the track (background).
  final Size trackSize;

  /// Corner radius for the track.
  final BorderRadius trackBorderRadius;

  /// Outline color for the track.
  final Color trackOutlineColor;

  /// Outline width for the track.
  final double trackOutlineWidth;

  /// Track color when switch is on.
  final Color activeTrackColor;

  /// Track color when switch is off.
  final Color inactiveTrackColor;

  /// Thumb size when switch is OFF (unselected).
  /// Material 3: Size(16, 16)
  final Size thumbSizeUnselected;

  /// Thumb size when switch is ON (selected).
  /// Material 3: Size(24, 24)
  final Size thumbSizeSelected;

  /// Thumb size when pressed or dragging.
  /// Material 3: Size(28, 28)
  final Size thumbSizePressed;

  /// Transitional thumb size during toggle animation (stretched phase).
  /// Material 3: Size(34, 22)
  final Size thumbSizeTransition;

  /// Thumb color when switch is on.
  final Color activeThumbColor;

  /// Thumb color when switch is off.
  final Color inactiveThumbColor;

  /// Padding between thumb and track edge during drag.
  ///
  /// Material: 4.0, Cupertino: 2.0.
  final double thumbPadding;

  /// Opacity applied when disabled (0.0-1.0).
  final double disabledOpacity;

  /// Overlay color for press feedback (Material-style).
  final Color pressOverlayColor;

  /// Opacity for pressed feedback (Cupertino-style).
  final double pressOpacity;

  /// Minimum tap target size.
  final Size minTapTargetSize;

  /// Radius of the state layer (radial reaction) around thumb.
  /// Material 3: 20.0 px
  final double stateLayerRadius;

  /// State layer color as WidgetStateProperty.
  /// Resolves to primary (selected) or onSurface (unselected) with opacity.
  final WidgetStateProperty<Color?> stateLayerColor;

  /// Optional icon displayed on the thumb.
  final WidgetStateProperty<Icon?>? thumbIcon;

  /// Motion tokens for visual transitions.
  final RSwitchMotionTokens? motion;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RSwitchResolvedTokens &&
        other.trackSize == trackSize &&
        other.trackBorderRadius == trackBorderRadius &&
        other.trackOutlineColor == trackOutlineColor &&
        other.trackOutlineWidth == trackOutlineWidth &&
        other.activeTrackColor == activeTrackColor &&
        other.inactiveTrackColor == inactiveTrackColor &&
        other.thumbSizeUnselected == thumbSizeUnselected &&
        other.thumbSizeSelected == thumbSizeSelected &&
        other.thumbSizePressed == thumbSizePressed &&
        other.thumbSizeTransition == thumbSizeTransition &&
        other.activeThumbColor == activeThumbColor &&
        other.inactiveThumbColor == inactiveThumbColor &&
        other.thumbPadding == thumbPadding &&
        other.disabledOpacity == disabledOpacity &&
        other.pressOverlayColor == pressOverlayColor &&
        other.pressOpacity == pressOpacity &&
        other.minTapTargetSize == minTapTargetSize &&
        other.stateLayerRadius == stateLayerRadius &&
        other.stateLayerColor == stateLayerColor &&
        other.thumbIcon == thumbIcon &&
        other.motion == motion;
  }

  @override
  int get hashCode => Object.hash(
        trackSize,
        trackBorderRadius,
        trackOutlineColor,
        trackOutlineWidth,
        activeTrackColor,
        inactiveTrackColor,
        thumbSizeUnselected,
        thumbSizeSelected,
        thumbSizePressed,
        thumbSizeTransition,
        activeThumbColor,
        inactiveThumbColor,
        thumbPadding,
        disabledOpacity,
        pressOverlayColor,
        pressOpacity,
        minTapTargetSize,
        stateLayerRadius,
        stateLayerColor,
      );
}
