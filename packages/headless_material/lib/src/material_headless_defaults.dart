import 'package:flutter/foundation.dart';

import 'overrides/material_button_overrides.dart';
import 'overrides/material_dropdown_overrides.dart';
import 'overrides/material_list_tile_overrides.dart';

/// User-friendly defaults for MaterialHeadlessTheme.
///
/// These defaults are applied when per-instance overrides are not provided.
@immutable
final class MaterialHeadlessDefaults {
  const MaterialHeadlessDefaults({
    this.button,
    this.dropdown,
    this.listTile,
  });

  final MaterialButtonOverrides? button;
  final MaterialDropdownOverrides? dropdown;
  final MaterialListTileOverrides? listTile;
}
