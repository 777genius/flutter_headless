import 'package:flutter/widgets.dart';

import 'r_switch_list_tile_motion_tokens.dart';

/// Per-instance override contract for SwitchListTile components.
@immutable
final class RSwitchListTileOverrides {
  const RSwitchListTileOverrides({
    this.contentPadding,
    this.minHeight,
    this.horizontalGap,
    this.verticalGap,
    this.titleStyle,
    this.subtitleStyle,
    this.disabledOpacity,
    this.pressOverlayColor,
    this.pressOpacity,
    this.motion,
    this.rippleShape,
    this.splashRadius,
    this.overlayColor,
  });

  const factory RSwitchListTileOverrides.tokens({
    EdgeInsetsGeometry? contentPadding,
    double? minHeight,
    double? horizontalGap,
    double? verticalGap,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    double? disabledOpacity,
    Color? pressOverlayColor,
    double? pressOpacity,
    RSwitchListTileMotionTokens? motion,
    ShapeBorder? rippleShape,
    double? splashRadius,
    WidgetStateProperty<Color?>? overlayColor,
  }) = RSwitchListTileOverrides;

  final EdgeInsetsGeometry? contentPadding;
  final double? minHeight;
  final double? horizontalGap;
  final double? verticalGap;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double? disabledOpacity;
  final Color? pressOverlayColor;
  final double? pressOpacity;
  final RSwitchListTileMotionTokens? motion;

  /// Custom shape for ripple/splash effects (Material).
  final ShapeBorder? rippleShape;

  /// Custom splash radius for ripple effects (Material).
  final double? splashRadius;

  /// State-dependent overlay color for interaction feedback.
  final WidgetStateProperty<Color?>? overlayColor;

  bool get hasOverrides =>
      contentPadding != null ||
      minHeight != null ||
      horizontalGap != null ||
      verticalGap != null ||
      titleStyle != null ||
      subtitleStyle != null ||
      disabledOpacity != null ||
      pressOverlayColor != null ||
      pressOpacity != null ||
      motion != null ||
      rippleShape != null ||
      splashRadius != null ||
      overlayColor != null;
}
