import 'package:flutter/widgets.dart';

import '../../slots/slot_override.dart';
import 'r_checkbox_list_tile_spec.dart';
import 'r_checkbox_list_tile_state.dart';

/// Context for the list tile slot (wraps the default ListTile).
@immutable
final class RCheckboxListTileTileContext {
  const RCheckboxListTileTileContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RCheckboxListTileSpec spec;
  final RCheckboxListTileState state;
  final Widget child;
}

/// Context for the checkbox indicator slot.
@immutable
final class RCheckboxListTileCheckboxContext {
  const RCheckboxListTileCheckboxContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RCheckboxListTileSpec spec;
  final RCheckboxListTileState state;
  final Widget child;
}

/// Context for title/subtitle slots.
@immutable
final class RCheckboxListTileTextContext {
  const RCheckboxListTileTextContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RCheckboxListTileSpec spec;
  final RCheckboxListTileState state;
  final Widget child;
}

/// Context for the secondary slot.
@immutable
final class RCheckboxListTileSecondaryContext {
  const RCheckboxListTileSecondaryContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RCheckboxListTileSpec spec;
  final RCheckboxListTileState state;
  final Widget child;
}

/// Slots for checkbox list tile parts (Replace/Decorate/Enhance).
@immutable
final class RCheckboxListTileSlots {
  const RCheckboxListTileSlots({
    this.tile,
    this.checkbox,
    this.title,
    this.subtitle,
    this.secondary,
  });

  /// Wraps the whole ListTile.
  final SlotOverride<RCheckboxListTileTileContext>? tile;

  /// Checkbox visual indicator.
  final SlotOverride<RCheckboxListTileCheckboxContext>? checkbox;

  /// Primary title widget.
  final SlotOverride<RCheckboxListTileTextContext>? title;

  /// Optional subtitle widget.
  final SlotOverride<RCheckboxListTileTextContext>? subtitle;

  /// Optional secondary widget (placed opposite the checkbox).
  final SlotOverride<RCheckboxListTileSecondaryContext>? secondary;
}
