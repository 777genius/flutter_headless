import 'package:flutter/foundation.dart';

import 'cupertino_override_types.dart';

/// Preset-specific advanced overrides for Cupertino dropdowns.
///
/// These knobs are opt-in and reduce portability across presets.
@immutable
final class CupertinoDropdownOverrides {
  const CupertinoDropdownOverrides({
    this.density,
    this.cornerStyle,
  });

  /// Density policy for trigger/menu/item spacing and sizes.
  final CupertinoComponentDensity? density;

  /// Corner radius policy for trigger/menu shapes.
  final CupertinoCornerStyle? cornerStyle;

  /// Whether any override is set.
  bool get hasOverrides => density != null || cornerStyle != null;
}
