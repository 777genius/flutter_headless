import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Simple, Flutter-like styling sugar for [RSwitchListTile].
///
/// This type is NOT a new renderer contract.
/// It is a convenience layer that is internally converted to
/// `RenderOverrides.only(RSwitchListTileOverrides.tokens(...))`.
///
/// Priority (strong -> weak):
/// 1) `overrides: RenderOverrides(...)`
/// 2) `style: RSwitchListTileStyle(...)`
/// 3) theme/preset defaults (token resolvers)
@immutable
final class RSwitchListTileStyle {
  const RSwitchListTileStyle({
    this.contentPadding,
    this.minHeight,
    this.horizontalGap,
    this.verticalGap,
    this.titleStyle,
    this.subtitleStyle,
    this.disabledOpacity,
  });

  final EdgeInsetsGeometry? contentPadding;
  final double? minHeight;
  final double? horizontalGap;
  final double? verticalGap;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double? disabledOpacity;

  RSwitchListTileOverrides toOverrides() {
    return RSwitchListTileOverrides.tokens(
      contentPadding: contentPadding,
      minHeight: minHeight,
      horizontalGap: horizontalGap,
      verticalGap: verticalGap,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      disabledOpacity: disabledOpacity,
    );
  }
}
