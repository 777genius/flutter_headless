import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Per-instance override contract for Button components.
///
/// This is the preset-agnostic override type that lives in headless_theme.
/// Users can use this to customize a specific button instance without
/// depending on preset-specific types.
///
/// Note: Preset-specific overrides (e.g., MaterialButtonOverrides) may be
/// added in future versions as an advanced customization layer.
///
/// Usage:
/// ```dart
/// RTextButton(
///   onPressed: save,
///   overrides: RenderOverrides({
///     RButtonOverrides: RButtonOverrides.tokens(
///       backgroundColor: Colors.red,
///     ),
///   }),
///   child: const Text('Save'),
/// );
/// ```
///
/// See `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`.
@immutable
final class RButtonOverrides {
  const RButtonOverrides({
    this.textStyle,
    this.foregroundColor,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.minSize,
    this.borderRadius,
    this.disabledOpacity,
  });

  /// Factory for token-level overrides.
  ///
  /// This is the canonical way to override button visuals at the contract level.
  const factory RButtonOverrides.tokens({
    TextStyle? textStyle,
    Color? foregroundColor,
    Color? backgroundColor,
    Color? borderColor,
    EdgeInsetsGeometry? padding,
    Size? minSize,
    BorderRadius? borderRadius,
    double? disabledOpacity,
  }) = RButtonOverrides;

  /// Override for text style.
  final TextStyle? textStyle;

  /// Override for foreground (text/icon) color.
  final Color? foregroundColor;

  /// Override for background color.
  final Color? backgroundColor;

  /// Override for border color.
  final Color? borderColor;

  /// Override for padding.
  final EdgeInsetsGeometry? padding;

  /// Override for minimum size.
  final Size? minSize;

  /// Override for border radius.
  final BorderRadius? borderRadius;

  /// Override for disabled opacity (0.0-1.0).
  final double? disabledOpacity;

  /// Whether any override is set.
  bool get hasOverrides =>
      textStyle != null ||
      foregroundColor != null ||
      backgroundColor != null ||
      borderColor != null ||
      padding != null ||
      minSize != null ||
      borderRadius != null ||
      disabledOpacity != null;
}
