import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../../slots/slot_override.dart';
import 'r_dropdown_commands.dart';
import 'r_dropdown_spec.dart';
import 'r_dropdown_state.dart';

// =============================================================================
// Slot Contexts (non-generic)
// =============================================================================

/// Context for the anchor (trigger button) slot.
@immutable
final class RDropdownAnchorContext {
  const RDropdownAnchorContext({
    required this.spec,
    required this.state,
    required this.selectedItem,
    required this.commands,
  });

  /// Dropdown specification.
  final RDropdownButtonSpec spec;

  /// Current state (focus, hover, pressed, disabled).
  final RDropdownButtonState state;

  /// Currently selected item (null if none).
  final HeadlessListItemModel? selectedItem;

  /// Commands for trigger interaction.
  final RDropdownCommands commands;
}

/// Context for the chevron slot inside the trigger.
@immutable
final class RDropdownChevronContext {
  const RDropdownChevronContext({
    required this.spec,
    required this.state,
    required this.selectedItem,
    required this.commands,
    required this.child,
  });

  /// Dropdown specification.
  final RDropdownButtonSpec spec;

  /// Current state (focus, hover, pressed, disabled).
  final RDropdownButtonState state;

  /// Currently selected item (null if none).
  final HeadlessListItemModel? selectedItem;

  /// Commands for trigger interaction.
  final RDropdownCommands commands;

  /// Default chevron widget from the renderer.
  final Widget child;
}

/// Context for the menu slot.
@immutable
final class RDropdownMenuContext {
  const RDropdownMenuContext({
    required this.spec,
    required this.state,
    required this.items,
    required this.commands,
    required this.itemBuilder,
    this.features = HeadlessRequestFeatures.empty,
  });

  /// Dropdown specification.
  final RDropdownButtonSpec spec;

  /// Current state.
  final RDropdownButtonState state;

  /// List of items.
  final List<HeadlessListItemModel> items;

  /// Commands.
  final RDropdownCommands commands;

  /// Builder for individual items (respects slot overrides).
  final Widget Function(int index) itemBuilder;

  /// Request features (e.g., remote loading state).
  ///
  /// Allows slots to read typed data like loading/error status
  /// to customize their UI accordingly.
  final HeadlessRequestFeatures features;
}

/// Context for an individual menu item slot.
@immutable
final class RDropdownItemContext {
  const RDropdownItemContext({
    required this.item,
    required this.index,
    required this.isHighlighted,
    required this.isSelected,
    required this.commands,
  });

  /// The item data.
  final HeadlessListItemModel item;

  /// Index in the items list.
  final int index;

  /// Whether this item is keyboard-highlighted.
  final bool isHighlighted;

  /// Whether this item is the selected value.
  final bool isSelected;

  /// Commands.
  final RDropdownCommands commands;
}

/// Context for item content inside the menu item.
@immutable
final class RDropdownItemContentContext {
  const RDropdownItemContentContext({
    required this.item,
    required this.index,
    required this.isHighlighted,
    required this.isSelected,
    required this.commands,
    required this.child,
  });

  /// The item data.
  final HeadlessListItemModel item;

  /// Index in the items list.
  final int index;

  /// Whether this item is keyboard-highlighted.
  final bool isHighlighted;

  /// Whether this item is the selected value.
  final bool isSelected;

  /// Commands.
  final RDropdownCommands commands;

  /// Default content widget from the renderer.
  final Widget child;
}

/// Context for the menu surface (background/container) slot.
@immutable
final class RDropdownMenuSurfaceContext {
  const RDropdownMenuSurfaceContext({
    required this.spec,
    required this.state,
    required this.child,
    required this.commands,
    this.features = HeadlessRequestFeatures.empty,
  });

  /// Dropdown specification.
  final RDropdownButtonSpec spec;

  /// Current state.
  final RDropdownButtonState state;

  /// The menu content widget.
  final Widget child;

  /// Commands.
  final RDropdownCommands commands;

  /// Request features (e.g., remote loading state).
  ///
  /// Allows surface decoration to show loading indicators
  /// or other status-based UI even when items are present.
  final HeadlessRequestFeatures features;
}

// =============================================================================
// Slots (non-generic)
// =============================================================================

/// Dropdown slots for partial customization (Replace/Decorate pattern).
///
/// Allows overriding specific visual parts without reimplementing
/// the entire renderer.
///
/// Slot policy (v1):
/// - Prefer [Decorate]/[Enhance] to preserve default structure/semantics.
/// - [Replace] is a full takeover and must preserve essential behavior
///   (e.g. item tap should still call commands, menu close contract must still
///   be respected by the renderer).
///
/// See `docs/V1_DECISIONS.md` → "4) Renderer contracts + Slots override".
@immutable
final class RDropdownButtonSlots {
  const RDropdownButtonSlots({
    this.anchor,
    this.chevron,
    this.menu,
    this.item,
    this.itemContent,
    this.menuSurface,
    this.emptyState,
  });

  /// Override for the trigger button.
  final SlotOverride<RDropdownAnchorContext>? anchor;

  /// Override for the chevron icon inside the trigger.
  final SlotOverride<RDropdownChevronContext>? chevron;

  /// Override for the menu (list of items).
  final SlotOverride<RDropdownMenuContext>? menu;

  /// Override for individual items.
  final SlotOverride<RDropdownItemContext>? item;

  /// Override for item content inside the menu item.
  final SlotOverride<RDropdownItemContentContext>? itemContent;

  /// Override for the menu surface (background/container).
  final SlotOverride<RDropdownMenuSurfaceContext>? menuSurface;

  /// Override for empty state when the item list is empty.
  final SlotOverride<RDropdownMenuContext>? emptyState;
}
