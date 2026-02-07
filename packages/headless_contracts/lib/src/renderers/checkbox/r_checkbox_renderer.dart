import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../../slots/slot_override.dart';

import '../render_overrides.dart';
import 'r_checkbox_resolved_tokens.dart';
import 'r_checkbox_semantics.dart';

/// Renderer capability for Checkbox components.
abstract interface class RCheckboxRenderer {
  /// Render a checkbox with the given request.
  Widget render(RCheckboxRenderRequest request);
}

/// Render request containing everything a checkbox renderer needs.
@immutable
final class RCheckboxRenderRequest {
  const RCheckboxRenderRequest({
    required this.context,
    required this.spec,
    required this.state,
    this.semantics,
    this.slots,
    this.visualEffects,
    this.resolvedTokens,
    this.constraints,
    this.overrides,
  });

  /// Build context for theme/media query access.
  final BuildContext context;

  /// Static specification (value, tristate, etc.).
  final RCheckboxSpec spec;

  /// Current interaction state.
  final RCheckboxState state;

  /// Semantic information for accessibility.
  final RCheckboxSemantics? semantics;

  /// Optional slots for partial override (Replace/Decorate/Enhance).
  final RCheckboxSlots? slots;

  /// Optional visual-only effects controller (pointer/hover/focus events).
  final HeadlessPressableVisualEffectsController? visualEffects;

  /// Pre-resolved visual tokens.
  final RCheckboxResolvedTokens? resolvedTokens;

  /// Layout constraints (e.g., minimum hit target size).
  final BoxConstraints? constraints;

  /// Per-instance override bag for preset customization.
  final RenderOverrides? overrides;
}

/// Checkbox specification (static, from widget props).
@immutable
final class RCheckboxSpec {
  const RCheckboxSpec({
    required this.value,
    this.tristate = false,
    this.isError = false,
    this.semanticLabel,
  }) : assert(
          tristate || value != null,
          'If tristate is false, value must be non-null.',
        );

  /// Whether the checkbox is checked.
  ///
  /// If [tristate] is true, this can also be null (indeterminate).
  final bool? value;

  /// Whether the checkbox supports the indeterminate state.
  final bool tristate;

  /// Whether the checkbox wants to show an error state.
  final bool isError;

  /// Accessibility label for screen readers.
  final String? semanticLabel;

  bool get isChecked => value == true;
  bool get isIndeterminate => tristate && value == null;
}

/// Checkbox interaction state.
@immutable
final class RCheckboxState {
  const RCheckboxState({
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

  factory RCheckboxState.fromWidgetStates(Set<WidgetState> states) {
    final decoded = WidgetStateHelper.fromWidgetStates(states);
    return RCheckboxState(
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

/// Context for checkbox box slot.
@immutable
final class RCheckboxBoxContext {
  const RCheckboxBoxContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RCheckboxSpec spec;
  final RCheckboxState state;
  final Widget child;
}

/// Context for checkbox mark slot.
@immutable
final class RCheckboxMarkContext {
  const RCheckboxMarkContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RCheckboxSpec spec;
  final RCheckboxState state;
  final Widget child;
}

/// Context for checkbox press overlay slot.
@immutable
final class RCheckboxPressOverlayContext {
  const RCheckboxPressOverlayContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RCheckboxSpec spec;
  final RCheckboxState state;
  final Widget child;
}

/// Checkbox slots for partial customization (Replace/Decorate/Enhance).
@immutable
final class RCheckboxSlots {
  const RCheckboxSlots({
    this.box,
    this.mark,
    this.pressOverlay,
  });

  final SlotOverride<RCheckboxBoxContext>? box;
  final SlotOverride<RCheckboxMarkContext>? mark;
  final SlotOverride<RCheckboxPressOverlayContext>? pressOverlay;
}
