import 'package:flutter/foundation.dart';

import 'material_override_types.dart';

/// Preset-specific advanced overrides for Material buttons.
///
/// These knobs are opt-in and reduce portability across presets.
@immutable
final class MaterialButtonOverrides {
  const MaterialButtonOverrides({
    this.density,
    this.cornerStyle,
  });

  /// Density policy for padding/minSize.
  final MaterialComponentDensity? density;

  /// Corner radius policy for the button shape.
  final MaterialCornerStyle? cornerStyle;

  /// Whether any override is set.
  bool get hasOverrides => density != null || cornerStyle != null;
}
