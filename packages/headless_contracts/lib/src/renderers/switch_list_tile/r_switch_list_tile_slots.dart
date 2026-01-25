import 'package:flutter/widgets.dart';

import '../../slots/slot_override.dart';
import 'r_switch_list_tile_spec.dart';
import 'r_switch_list_tile_state.dart';

/// Context for the list tile slot (wraps the default ListTile).
@immutable
final class RSwitchListTileTileContext {
  const RSwitchListTileTileContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RSwitchListTileSpec spec;
  final RSwitchListTileState state;
  final Widget child;
}

/// Context for the switch indicator slot.
@immutable
final class RSwitchListTileSwitchContext {
  const RSwitchListTileSwitchContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RSwitchListTileSpec spec;
  final RSwitchListTileState state;
  final Widget child;
}

/// Context for title/subtitle slots.
@immutable
final class RSwitchListTileTextContext {
  const RSwitchListTileTextContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RSwitchListTileSpec spec;
  final RSwitchListTileState state;
  final Widget child;
}

/// Context for the secondary slot.
@immutable
final class RSwitchListTileSecondaryContext {
  const RSwitchListTileSecondaryContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RSwitchListTileSpec spec;
  final RSwitchListTileState state;
  final Widget child;
}

/// Slots for switch list tile parts (Replace/Decorate/Enhance).
@immutable
final class RSwitchListTileSlots {
  const RSwitchListTileSlots({
    this.tile,
    this.switchIndicator,
    this.title,
    this.subtitle,
    this.secondary,
  });

  /// Wraps the whole ListTile.
  final SlotOverride<RSwitchListTileTileContext>? tile;

  /// Switch visual indicator.
  final SlotOverride<RSwitchListTileSwitchContext>? switchIndicator;

  /// Primary title widget.
  final SlotOverride<RSwitchListTileTextContext>? title;

  /// Optional subtitle widget.
  final SlotOverride<RSwitchListTileTextContext>? subtitle;

  /// Optional secondary widget (placed opposite the switch).
  final SlotOverride<RSwitchListTileSecondaryContext>? secondary;
}
