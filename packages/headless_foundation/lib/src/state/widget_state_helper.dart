import 'package:flutter/widgets.dart';

/// Helper for converting interaction states to Flutter's WidgetState set.
///
/// Provides a centralized, consistent way to build WidgetState sets
/// from common interaction boolean flags.
///
/// Example:
/// ```dart
/// final states = WidgetStateHelper.toWidgetStates(
///   isPressed: _isPressed,
///   isHovered: _isHovered,
///   isFocused: _isFocused,
///   isDisabled: widget.isDisabled,
/// );
/// ```
abstract final class WidgetStateHelper {
  /// Converts interaction state flags to a [WidgetState] set.
  ///
  /// All parameters default to false. Only true values are included
  /// in the resulting set.
  static Set<WidgetState> toWidgetStates({
    bool isPressed = false,
    bool isHovered = false,
    bool isFocused = false,
    bool isDisabled = false,
    bool isSelected = false,
    bool isError = false,
    bool isDragged = false,
    bool isScrolledUnder = false,
  }) {
    return {
      if (isPressed) WidgetState.pressed,
      if (isHovered) WidgetState.hovered,
      if (isFocused) WidgetState.focused,
      if (isDisabled) WidgetState.disabled,
      if (isSelected) WidgetState.selected,
      if (isError) WidgetState.error,
      if (isDragged) WidgetState.dragged,
      if (isScrolledUnder) WidgetState.scrolledUnder,
    };
  }

  /// Extracts interaction state flags from a [WidgetState] set.
  ///
  /// Returns a record with all standard interaction states.
  static ({
    bool isPressed,
    bool isHovered,
    bool isFocused,
    bool isDisabled,
    bool isSelected,
    bool isError,
    bool isDragged,
    bool isScrolledUnder,
  }) fromWidgetStates(Set<WidgetState> states) {
    return (
      isPressed: states.contains(WidgetState.pressed),
      isHovered: states.contains(WidgetState.hovered),
      isFocused: states.contains(WidgetState.focused),
      isDisabled: states.contains(WidgetState.disabled),
      isSelected: states.contains(WidgetState.selected),
      isError: states.contains(WidgetState.error),
      isDragged: states.contains(WidgetState.dragged),
      isScrolledUnder: states.contains(WidgetState.scrolledUnder),
    );
  }
}
