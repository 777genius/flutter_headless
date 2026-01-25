import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

/// Overlay lifecycle phases.
///
/// See `docs/V1_DECISIONS.md` → "0.2 Overlay" → "Close contract v1".
enum ROverlayPhase {
  /// Overlay is entering (mount animation).
  opening,

  /// Overlay is fully visible.
  open,

  /// Overlay is exiting (exit animation).
  closing,

  /// Overlay is removed from tree.
  closed,
}

/// Dropdown interaction state.
///
/// Contains the current overlay phase, selection, and highlight state.
/// Uses indices instead of generic values — the component handles the mapping.
@immutable
final class RDropdownButtonState {
  const RDropdownButtonState({
    required this.overlayPhase,
    this.selectedIndex,
    this.selectedItemsIndices,
    this.highlightedIndex,
    this.isTriggerPressed = false,
    this.isTriggerHovered = false,
    this.isTriggerFocused = false,
    this.isDisabled = false,
  });

  /// Current overlay lifecycle phase.
  final ROverlayPhase overlayPhase;

  /// Index of currently selected item (null if none).
  final int? selectedIndex;

  /// Indices of selected items in the current menu (null when not applicable).
  ///
  /// This enables renderer variants that need a set-like selection signal
  /// (e.g. multi-select menus with checkboxes) without making the renderer generic.
  ///
  /// For single-select dropdowns this is typically left null.
  final Set<int>? selectedItemsIndices;

  /// Index of currently highlighted item in the menu (null if none).
  ///
  /// Highlighted != Selected. Highlight is keyboard navigation state.
  final int? highlightedIndex;

  /// Whether the trigger button is pressed.
  final bool isTriggerPressed;

  /// Whether the pointer is hovering over the trigger.
  final bool isTriggerHovered;

  /// Whether the trigger has keyboard focus.
  final bool isTriggerFocused;

  /// Whether the dropdown is disabled.
  final bool isDisabled;

  /// Whether the menu is currently visible (opening or open).
  bool get isOpen =>
      overlayPhase == ROverlayPhase.opening ||
      overlayPhase == ROverlayPhase.open;

  /// Convert trigger state to Flutter's WidgetState set.
  ///
  /// Used for token resolution.
  Set<WidgetState> toTriggerWidgetStates() {
    return WidgetStateHelper.toWidgetStates(
      isPressed: isTriggerPressed,
      isHovered: isTriggerHovered,
      isFocused: isTriggerFocused,
      isDisabled: isDisabled,
    );
  }
}
