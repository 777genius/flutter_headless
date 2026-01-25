import 'package:flutter/widgets.dart';

import 'r_switch_list_tile_motion_tokens.dart';

/// Resolved visual tokens for switch list tile rendering.
@immutable
final class RSwitchListTileResolvedTokens {
  const RSwitchListTileResolvedTokens({
    required this.contentPadding,
    required this.minHeight,
    required this.horizontalGap,
    required this.verticalGap,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.disabledOpacity,
    required this.pressOverlayColor,
    required this.pressOpacity,
    this.motion,
  });

  final EdgeInsetsGeometry contentPadding;
  final double minHeight;
  final double horizontalGap;
  final double verticalGap;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final double disabledOpacity;
  final Color pressOverlayColor;
  final double pressOpacity;
  final RSwitchListTileMotionTokens? motion;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RSwitchListTileResolvedTokens &&
        other.contentPadding == contentPadding &&
        other.minHeight == minHeight &&
        other.horizontalGap == horizontalGap &&
        other.verticalGap == verticalGap &&
        other.titleStyle == titleStyle &&
        other.subtitleStyle == subtitleStyle &&
        other.disabledOpacity == disabledOpacity &&
        other.pressOverlayColor == pressOverlayColor &&
        other.pressOpacity == pressOpacity &&
        other.motion == motion;
  }

  @override
  int get hashCode => Object.hash(
        contentPadding,
        minHeight,
        horizontalGap,
        verticalGap,
        titleStyle,
        subtitleStyle,
        disabledOpacity,
        pressOverlayColor,
        pressOpacity,
        motion,
      );
}
