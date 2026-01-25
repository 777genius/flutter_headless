import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Per-instance override contract for Dropdown components.
///
/// This is the preset-agnostic override type that lives in headless_theme.
/// Users can use this to customize a specific dropdown instance without
/// depending on preset-specific types.
///
/// Note: Preset-specific overrides (e.g., MaterialDropdownOverrides) may be
/// added in future versions as an advanced customization layer.
///
/// Usage:
/// ```dart
/// RDropdownButton<String>(
///   value: value,
///   onChanged: setValue,
///   items: items,
///   overrides: RenderOverrides({
///     RDropdownOverrides: RDropdownOverrides.tokens(
///       triggerBackgroundColor: Colors.grey,
///     ),
///   }),
/// );
/// ```
///
/// See `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`.
@immutable
final class RDropdownOverrides {
  const RDropdownOverrides({
    // Trigger
    this.triggerTextStyle,
    this.triggerForegroundColor,
    this.triggerBackgroundColor,
    this.triggerBorderColor,
    this.triggerPadding,
    this.triggerMinSize,
    this.triggerBorderRadius,
    this.triggerIconColor,
    // Menu
    this.menuBackgroundColor,
    this.menuBorderColor,
    this.menuBorderRadius,
    this.menuElevation,
    this.menuMaxHeight,
    this.menuPadding,
    // Item
    this.itemTextStyle,
    this.itemPadding,
    this.itemMinHeight,
  });

  /// Factory for token-level overrides.
  ///
  /// This is the canonical way to override dropdown visuals at the contract level.
  const factory RDropdownOverrides.tokens({
    // Trigger
    TextStyle? triggerTextStyle,
    Color? triggerForegroundColor,
    Color? triggerBackgroundColor,
    Color? triggerBorderColor,
    EdgeInsetsGeometry? triggerPadding,
    Size? triggerMinSize,
    BorderRadius? triggerBorderRadius,
    Color? triggerIconColor,
    // Menu
    Color? menuBackgroundColor,
    Color? menuBorderColor,
    BorderRadius? menuBorderRadius,
    double? menuElevation,
    double? menuMaxHeight,
    EdgeInsetsGeometry? menuPadding,
    // Item
    TextStyle? itemTextStyle,
    EdgeInsetsGeometry? itemPadding,
    double? itemMinHeight,
  }) = RDropdownOverrides;

  // Trigger overrides

  /// Override for trigger text style.
  final TextStyle? triggerTextStyle;

  /// Override for trigger foreground color.
  final Color? triggerForegroundColor;

  /// Override for trigger background color.
  final Color? triggerBackgroundColor;

  /// Override for trigger border color.
  final Color? triggerBorderColor;

  /// Override for trigger padding.
  final EdgeInsetsGeometry? triggerPadding;

  /// Override for trigger minimum size (accessibility).
  final Size? triggerMinSize;

  /// Override for trigger border radius.
  final BorderRadius? triggerBorderRadius;

  /// Override for dropdown arrow icon color.
  final Color? triggerIconColor;

  // Menu overrides

  /// Override for menu background color.
  final Color? menuBackgroundColor;

  /// Override for menu border color.
  final Color? menuBorderColor;

  /// Override for menu border radius.
  final BorderRadius? menuBorderRadius;

  /// Override for menu elevation/shadow.
  final double? menuElevation;

  /// Override for menu max height.
  final double? menuMaxHeight;

  /// Override for menu content padding.
  final EdgeInsetsGeometry? menuPadding;

  // Item overrides

  /// Override for item text style.
  final TextStyle? itemTextStyle;

  /// Override for item padding.
  final EdgeInsetsGeometry? itemPadding;

  /// Override for item minimum height.
  final double? itemMinHeight;

  /// Whether any override is set.
  bool get hasOverrides =>
      triggerTextStyle != null ||
      triggerForegroundColor != null ||
      triggerBackgroundColor != null ||
      triggerBorderColor != null ||
      triggerPadding != null ||
      triggerMinSize != null ||
      triggerBorderRadius != null ||
      triggerIconColor != null ||
      menuBackgroundColor != null ||
      menuBorderColor != null ||
      menuBorderRadius != null ||
      menuElevation != null ||
      menuMaxHeight != null ||
      menuPadding != null ||
      itemTextStyle != null ||
      itemPadding != null ||
      itemMinHeight != null;
}
