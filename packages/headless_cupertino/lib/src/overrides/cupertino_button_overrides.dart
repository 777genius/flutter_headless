import 'package:flutter/foundation.dart';

import 'cupertino_override_types.dart';

/// Preset-specific advanced overrides for Cupertino buttons.
///
/// These knobs are opt-in and reduce portability across presets.
@immutable
final class CupertinoButtonOverrides {
  const CupertinoButtonOverrides({
    this.density,
    this.cornerStyle,
  });

  /// Density policy for padding/minSize.
  final CupertinoComponentDensity? density;

  /// Corner radius policy for the button shape.
  final CupertinoCornerStyle? cornerStyle;

  /// Whether any override is set.
  bool get hasOverrides => density != null || cornerStyle != null;
}
