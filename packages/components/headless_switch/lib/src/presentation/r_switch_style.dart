import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Simple, Flutter-like styling sugar for [RSwitch].
///
/// This type is NOT a new renderer contract.
/// It is a convenience layer that is internally converted to
/// `RenderOverrides.only(RSwitchOverrides.tokens(...))`.
///
/// Priority (strong -> weak):
/// 1) `overrides: RenderOverrides(...)`
/// 2) `thumbIcon:` parameter (direct parameter wins over style.thumbIcon)
/// 3) `style: RSwitchStyle(...)`
/// 4) theme/preset defaults (token resolvers)
@immutable
final class RSwitchStyle {
  const RSwitchStyle({
    this.trackSize,
    this.trackBorderRadius,
    this.trackOutlineColor,
    this.trackOutlineWidth,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.thumbIcon,
    this.disabledOpacity,
    this.minTapTargetSize,
  });

  final Size? trackSize;
  final BorderRadius? trackBorderRadius;
  final Color? trackOutlineColor;
  final double? trackOutlineWidth;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final WidgetStateProperty<Icon?>? thumbIcon;
  final double? disabledOpacity;
  final Size? minTapTargetSize;

  RSwitchOverrides toOverrides() {
    return RSwitchOverrides.tokens(
      trackSize: trackSize,
      trackBorderRadius: trackBorderRadius,
      trackOutlineColor: trackOutlineColor,
      trackOutlineWidth: trackOutlineWidth,
      activeTrackColor: activeTrackColor,
      inactiveTrackColor: inactiveTrackColor,
      activeThumbColor: activeThumbColor,
      inactiveThumbColor: inactiveThumbColor,
      thumbIcon: thumbIcon,
      disabledOpacity: disabledOpacity,
      minTapTargetSize: minTapTargetSize,
    );
  }
}
