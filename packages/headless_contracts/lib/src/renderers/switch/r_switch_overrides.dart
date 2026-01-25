import 'package:flutter/widgets.dart';

import 'r_switch_motion_tokens.dart';

/// Per-instance override contract for Switch components.
///
/// This is the preset-agnostic override type that lives in headless_contracts.
/// Users can customize a specific switch instance without depending on
/// preset-specific types.
@immutable
final class RSwitchOverrides {
  const RSwitchOverrides({
    this.trackSize,
    this.trackBorderRadius,
    this.trackOutlineColor,
    this.trackOutlineWidth,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.thumbSizeUnselected,
    this.thumbSizeSelected,
    this.thumbSizePressed,
    this.thumbSizeTransition,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.thumbPadding,
    this.disabledOpacity,
    this.pressOverlayColor,
    this.pressOpacity,
    this.thumbIcon,
    this.motion,
    this.minTapTargetSize,
    this.stateLayerRadius,
    this.stateLayerColor,
  });

  /// Factory for token-level overrides.
  const factory RSwitchOverrides.tokens({
    Size? trackSize,
    BorderRadius? trackBorderRadius,
    Color? trackOutlineColor,
    double? trackOutlineWidth,
    Color? activeTrackColor,
    Color? inactiveTrackColor,
    Size? thumbSizeUnselected,
    Size? thumbSizeSelected,
    Size? thumbSizePressed,
    Size? thumbSizeTransition,
    Color? activeThumbColor,
    Color? inactiveThumbColor,
    double? thumbPadding,
    double? disabledOpacity,
    Color? pressOverlayColor,
    double? pressOpacity,
    WidgetStateProperty<Icon?>? thumbIcon,
    RSwitchMotionTokens? motion,
    Size? minTapTargetSize,
    double? stateLayerRadius,
    WidgetStateProperty<Color?>? stateLayerColor,
  }) = RSwitchOverrides;

  /// Size of the track (background).
  final Size? trackSize;

  /// Corner radius for the track.
  final BorderRadius? trackBorderRadius;

  /// Outline color for the track.
  final Color? trackOutlineColor;

  /// Outline width for the track.
  final double? trackOutlineWidth;

  /// Track color when switch is on.
  final Color? activeTrackColor;

  /// Track color when switch is off.
  final Color? inactiveTrackColor;

  /// Thumb size when switch is OFF (unselected).
  /// Material 3: Size(16, 16)
  final Size? thumbSizeUnselected;

  /// Thumb size when switch is ON (selected).
  /// Material 3: Size(24, 24)
  final Size? thumbSizeSelected;

  /// Thumb size when pressed or dragging.
  /// Material 3: Size(28, 28)
  final Size? thumbSizePressed;

  /// Transitional thumb size during toggle animation (stretched phase).
  /// Material 3: Size(34, 22)
  final Size? thumbSizeTransition;

  /// Thumb color when switch is on.
  final Color? activeThumbColor;

  /// Thumb color when switch is off.
  final Color? inactiveThumbColor;

  /// Padding between thumb and track edge during drag.
  ///
  /// Material: 4.0, Cupertino: 2.0.
  final double? thumbPadding;

  /// Opacity applied when disabled (0.0-1.0).
  final double? disabledOpacity;

  /// Overlay color for press feedback (Material-style).
  final Color? pressOverlayColor;

  /// Opacity for pressed feedback (Cupertino-style).
  final double? pressOpacity;

  /// Optional icon displayed on the thumb.
  final WidgetStateProperty<Icon?>? thumbIcon;

  /// Motion tokens for visual transitions.
  final RSwitchMotionTokens? motion;

  /// Minimum tap target size (WCAG/platform policy).
  final Size? minTapTargetSize;

  /// Radius of the state layer (radial reaction) around thumb.
  /// Material 3: 20.0 px
  final double? stateLayerRadius;

  /// State layer color as WidgetStateProperty.
  /// Resolves to primary (selected) or onSurface (unselected) with opacity.
  final WidgetStateProperty<Color?>? stateLayerColor;

  bool get hasOverrides =>
      trackSize != null ||
      trackBorderRadius != null ||
      trackOutlineColor != null ||
      trackOutlineWidth != null ||
      activeTrackColor != null ||
      inactiveTrackColor != null ||
      thumbSizeUnselected != null ||
      thumbSizeSelected != null ||
      thumbSizePressed != null ||
      thumbSizeTransition != null ||
      activeThumbColor != null ||
      inactiveThumbColor != null ||
      thumbPadding != null ||
      disabledOpacity != null ||
      pressOverlayColor != null ||
      pressOpacity != null ||
      thumbIcon != null ||
      motion != null ||
      minTapTargetSize != null ||
      stateLayerRadius != null ||
      stateLayerColor != null;
}
