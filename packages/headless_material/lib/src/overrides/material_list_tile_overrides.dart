import 'package:flutter/material.dart';

/// Preset-specific advanced overrides for Material list-tile-like components.
///
/// These knobs are opt-in and reduce portability across presets.
@immutable
final class MaterialListTileOverrides {
  const MaterialListTileOverrides({
    this.titleAlignment,
  });

  /// Vertical alignment policy for leading/trailing relative to title/subtitle.
  ///
  /// Applied only by Material renderers that use [ListTile].
  final ListTileTitleAlignment? titleAlignment;

  bool get hasOverrides => titleAlignment != null;
}

