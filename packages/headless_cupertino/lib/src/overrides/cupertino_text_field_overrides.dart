import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Preset-specific advanced overrides for Cupertino text fields.
///
/// These knobs are opt-in and reduce portability across presets.
@immutable
final class CupertinoTextFieldOverrides {
  const CupertinoTextFieldOverrides({
    this.padding,
    this.isBorderless,
  });

  /// Custom padding for the text field container.
  ///
  /// Default is EdgeInsets.all(7.0) per iOS HIG.
  final EdgeInsetsGeometry? padding;

  /// Whether to render without a visible border.
  ///
  /// When true, renders a transparent border (text field blends with background).
  /// Default is false (shows standard Cupertino border).
  final bool? isBorderless;

  /// Whether any override is set.
  bool get hasOverrides => padding != null || isBorderless != null;
}
