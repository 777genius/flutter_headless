import 'package:headless_contracts/headless_contracts.dart';

import 'headless_widget_state_query.dart';

/// Canonical “dominant” visual state for dropdown trigger.
///
/// v1 precedence (high → low):
/// - disabled
/// - open (overlayPhase opening/open)
/// - pressed
/// - hovered
/// - focused
/// - none
enum HeadlessDropdownTriggerVisualState {
  disabled,
  open,
  pressed,
  hovered,
  focused,
  none,
}

HeadlessDropdownTriggerVisualState resolveDropdownTriggerVisualState({
  required HeadlessWidgetStateQuery q,
  required ROverlayPhase overlayPhase,
}) {
  if (q.isDisabled) return HeadlessDropdownTriggerVisualState.disabled;

  final isOpen = overlayPhase == ROverlayPhase.opening ||
      overlayPhase == ROverlayPhase.open;
  if (isOpen) return HeadlessDropdownTriggerVisualState.open;

  if (q.isPressed) return HeadlessDropdownTriggerVisualState.pressed;
  if (q.isHovered) return HeadlessDropdownTriggerVisualState.hovered;
  if (q.isFocused) return HeadlessDropdownTriggerVisualState.focused;
  return HeadlessDropdownTriggerVisualState.none;
}
