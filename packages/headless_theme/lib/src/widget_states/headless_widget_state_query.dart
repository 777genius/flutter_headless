import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'headless_interaction_visual_state.dart';

/// Canonical WidgetState interpretation for token resolvers.
///
/// Purpose: make preset token resolution consistent by:
/// - applying v1 normalization (`disabled` suppresses pressed/hovered/dragged)
/// - providing a single place to read the standard flags
final class HeadlessWidgetStateQuery {
  HeadlessWidgetStateQuery(
    Set<WidgetState> raw, {
    StateResolutionPolicy policy = const StateResolutionPolicy(),
  })  : normalized = policy.normalize(raw),
        _flags = WidgetStateHelper.fromWidgetStates(policy.normalize(raw));

  /// Normalized set (safe to pass into state-based maps if needed).
  final Set<WidgetState> normalized;

  final ({
    bool isPressed,
    bool isHovered,
    bool isFocused,
    bool isDisabled,
    bool isSelected,
    bool isError,
    bool isDragged,
    bool isScrolledUnder,
  }) _flags;

  bool get isPressed => _flags.isPressed;
  bool get isHovered => _flags.isHovered;
  bool get isFocused => _flags.isFocused;
  bool get isDisabled => _flags.isDisabled;
  bool get isSelected => _flags.isSelected;
  bool get isError => _flags.isError;
  bool get isDragged => _flags.isDragged;
  bool get isScrolledUnder => _flags.isScrolledUnder;

  HeadlessInteractionVisualState get interactionVisualState {
    if (isDisabled) return HeadlessInteractionVisualState.disabled;
    if (isPressed) return HeadlessInteractionVisualState.pressed;
    if (isHovered) return HeadlessInteractionVisualState.hovered;
    if (isFocused) return HeadlessInteractionVisualState.focused;
    return HeadlessInteractionVisualState.none;
  }
}
