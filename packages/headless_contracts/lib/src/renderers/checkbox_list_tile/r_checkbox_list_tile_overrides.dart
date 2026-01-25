import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'r_checkbox_list_tile_motion_tokens.dart';

/// Per-instance override contract for CheckboxListTile components.
@immutable
final class RCheckboxListTileOverrides {
  const RCheckboxListTileOverrides({
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
  });

  const factory RCheckboxListTileOverrides.tokens({
    EdgeInsetsGeometry? contentPadding,
    double? minHeight,
    double? horizontalGap,
    double? verticalGap,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    double? disabledOpacity,
    Color? pressOverlayColor,
    double? pressOpacity,
    RCheckboxListTileMotionTokens? motion,
  }) = RCheckboxListTileOverrides;

  final EdgeInsetsGeometry? contentPadding;
  final double? minHeight;
  final double? horizontalGap;
  final double? verticalGap;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double? disabledOpacity;
  final Color? pressOverlayColor;
  final double? pressOpacity;
  final RCheckboxListTileMotionTokens? motion;

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
      motion != null;
}

