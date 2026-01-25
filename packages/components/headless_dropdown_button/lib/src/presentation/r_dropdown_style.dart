import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Simple, Flutter-like styling sugar for [RDropdownButton].
///
/// This type is NOT a new renderer contract.
/// It is a convenience layer that is internally converted to
/// `RenderOverrides.only(RDropdownOverrides.tokens(...))`.
///
/// Priority (strong -> weak):
/// 1) `overrides: RenderOverrides(...)`
/// 2) `style: RDropdownStyle(...)`
/// 3) theme/preset defaults (token resolvers)
@immutable
final class RDropdownStyle {
  const RDropdownStyle({
    this.triggerTextStyle,
    this.triggerForegroundColor,
    this.triggerBackgroundColor,
    this.triggerBorderColor,
    this.triggerPadding,
    this.triggerMinSize,
    this.triggerRadius,
    this.triggerBorderRadius,
    this.triggerIconColor,
    this.menuBackgroundColor,
    this.menuBorderRadius,
    this.itemTextStyle,
  }) : assert(
          triggerRadius == null || triggerBorderRadius == null,
          'Provide either triggerRadius or triggerBorderRadius, not both.',
        );

  // Trigger
  final TextStyle? triggerTextStyle;
  final Color? triggerForegroundColor;
  final Color? triggerBackgroundColor;
  final Color? triggerBorderColor;
  final EdgeInsetsGeometry? triggerPadding;
  final Size? triggerMinSize;
  final double? triggerRadius;
  final BorderRadius? triggerBorderRadius;
  final Color? triggerIconColor;

  // Menu
  final Color? menuBackgroundColor;
  final BorderRadius? menuBorderRadius;

  // Items
  final TextStyle? itemTextStyle;

  RDropdownOverrides toOverrides() {
    final resolvedTriggerRadius = triggerBorderRadius ??
        (triggerRadius == null
            ? null
            : BorderRadius.all(Radius.circular(triggerRadius!)));

    return RDropdownOverrides.tokens(
      triggerTextStyle: triggerTextStyle,
      triggerForegroundColor: triggerForegroundColor,
      triggerBackgroundColor: triggerBackgroundColor,
      triggerBorderColor: triggerBorderColor,
      triggerPadding: triggerPadding,
      triggerMinSize: triggerMinSize,
      triggerBorderRadius: resolvedTriggerRadius,
      triggerIconColor: triggerIconColor,
      menuBackgroundColor: menuBackgroundColor,
      menuBorderRadius: menuBorderRadius,
      itemTextStyle: itemTextStyle,
    );
  }
}
