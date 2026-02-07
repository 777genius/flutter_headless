import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

/// Checkbox list tile interaction state.
@immutable
final class RCheckboxListTileState {
  const RCheckboxListTileState({
    this.isPressed = false,
    this.isHovered = false,
    this.isFocused = false,
    this.isDisabled = false,
    this.isSelected = false,
    this.isError = false,
  });

  final bool isPressed;
  final bool isHovered;
  final bool isFocused;
  final bool isDisabled;
  final bool isSelected;
  final bool isError;

  factory RCheckboxListTileState.fromWidgetStates(Set<WidgetState> states) {
    final decoded = WidgetStateHelper.fromWidgetStates(states);
    return RCheckboxListTileState(
      isPressed: decoded.isPressed,
      isHovered: decoded.isHovered,
      isFocused: decoded.isFocused,
      isDisabled: decoded.isDisabled,
      isSelected: decoded.isSelected,
      isError: decoded.isError,
    );
  }

  Set<WidgetState> toWidgetStates() {
    return WidgetStateHelper.toWidgetStates(
      isPressed: isPressed,
      isHovered: isHovered,
      isFocused: isFocused,
      isDisabled: isDisabled,
      isSelected: isSelected,
      isError: isError,
    );
  }
}
