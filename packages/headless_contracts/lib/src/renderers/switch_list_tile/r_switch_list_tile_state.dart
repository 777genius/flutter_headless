import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

/// Switch list tile interaction state.
@immutable
final class RSwitchListTileState {
  const RSwitchListTileState({
    this.isPressed = false,
    this.isHovered = false,
    this.isFocused = false,
    this.isDisabled = false,
    this.isSelected = false,
  });

  final bool isPressed;
  final bool isHovered;
  final bool isFocused;
  final bool isDisabled;
  final bool isSelected;

  factory RSwitchListTileState.fromWidgetStates(Set<WidgetState> states) {
    final decoded = WidgetStateHelper.fromWidgetStates(states);
    return RSwitchListTileState(
      isPressed: decoded.isPressed,
      isHovered: decoded.isHovered,
      isFocused: decoded.isFocused,
      isDisabled: decoded.isDisabled,
      isSelected: decoded.isSelected,
    );
  }

  Set<WidgetState> toWidgetStates() {
    return WidgetStateHelper.toWidgetStates(
      isPressed: isPressed,
      isHovered: isHovered,
      isFocused: isFocused,
      isDisabled: isDisabled,
      isSelected: isSelected,
    );
  }
}
