import 'package:flutter/foundation.dart';

import 'material_override_types.dart';

/// Preset-specific advanced overrides for Material dropdowns.
///
/// These knobs are opt-in and reduce portability across presets.
@immutable
final class MaterialDropdownOverrides {
  const MaterialDropdownOverrides({
    this.density,
    this.cornerStyle,
  });

  /// Density policy for trigger/menu/item spacing and sizes.
  final MaterialComponentDensity? density;

  /// Corner radius policy for trigger/menu shapes.
  final MaterialCornerStyle? cornerStyle;

  /// Whether any override is set.
  bool get hasOverrides => density != null || cornerStyle != null;
}
