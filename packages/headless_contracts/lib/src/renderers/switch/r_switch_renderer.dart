import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../../slots/slot_override.dart';
import '../render_overrides.dart';
import 'r_switch_resolved_tokens.dart';
import 'r_switch_semantics.dart';

/// Renderer capability for Switch components.
abstract interface class RSwitchRenderer {
  /// Render a switch with the given request.
  Widget render(RSwitchRenderRequest request);
}

/// Render request containing everything a switch renderer needs.
@immutable
final class RSwitchRenderRequest {
  const RSwitchRenderRequest({
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

  /// Static specification (value, semanticLabel, etc.).
  final RSwitchSpec spec;

  /// Current interaction state.
  final RSwitchState state;

  /// Semantic information for accessibility.
  final RSwitchSemantics? semantics;

  /// Optional slots for partial override (Replace/Decorate/Enhance).
  final RSwitchSlots? slots;

  /// Optional visual-only effects controller (pointer/hover/focus events).
  final HeadlessPressableVisualEffectsController? visualEffects;

  /// Pre-resolved visual tokens.
  final RSwitchResolvedTokens? resolvedTokens;

  /// Layout constraints (e.g., minimum hit target size).
  final BoxConstraints? constraints;

  /// Per-instance override bag for preset customization.
  final RenderOverrides? overrides;
}

/// Switch specification (static, from widget props).
@immutable
final class RSwitchSpec {
  const RSwitchSpec({
    required this.value,
    this.semanticLabel,
    this.dragStartBehavior = DragStartBehavior.start,
  });

  /// Whether the switch is on.
  final bool value;

  /// Accessibility label for screen readers.
  final String? semanticLabel;

  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], the drag behavior used to move
  /// the switch from on to off will begin at the position where the drag
  /// gesture won the arena. If set to [DragStartBehavior.down], it will
  /// begin at the position where a down event was first detected.
  ///
  /// Defaults to [DragStartBehavior.start].
  final DragStartBehavior dragStartBehavior;
}

/// Switch interaction state.
@immutable
final class RSwitchState {
  const RSwitchState({
    this.isPressed = false,
    this.isHovered = false,
    this.isFocused = false,
    this.isDisabled = false,
    this.isSelected = false,
    this.dragT,
    this.dragVisualValue,
  });

  final bool isPressed;
  final bool isHovered;
  final bool isFocused;
  final bool isDisabled;

  /// Whether the switch is on (= value).
  final bool isSelected;

  /// 0..1 thumb position during drag (null = not dragging).
  ///
  /// When dragging:
  /// - 0.0 = thumb at "off" position
  /// - 1.0 = thumb at "on" position
  /// - intermediate values = thumb between positions
  ///
  /// Renderers should use this for:
  /// - Thumb alignment interpolation: `Alignment.lerp(left, right, dragT)`
  /// - Color interpolation: `Color.lerp(inactiveColor, activeColor, dragT)`
  final double? dragT;

  /// Preview value for WidgetStateProperty during drag (null = normal mode).
  ///
  /// During drag, this represents what the switch value would become
  /// if the user releases at the current position. Useful for:
  /// - Resolving thumbIcon based on predicted outcome
  /// - Any other WidgetStateProperty that depends on isSelected
  final bool? dragVisualValue;

  /// Whether the switch is currently being dragged.
  bool get isDragging => dragT != null;

  factory RSwitchState.fromWidgetStates(Set<WidgetState> states) {
    final decoded = WidgetStateHelper.fromWidgetStates(states);
    return RSwitchState(
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

  /// Creates a copy with the given fields replaced.
  RSwitchState copyWith({
    bool? isPressed,
    bool? isHovered,
    bool? isFocused,
    bool? isDisabled,
    bool? isSelected,
    double? Function()? dragT,
    bool? Function()? dragVisualValue,
  }) {
    return RSwitchState(
      isPressed: isPressed ?? this.isPressed,
      isHovered: isHovered ?? this.isHovered,
      isFocused: isFocused ?? this.isFocused,
      isDisabled: isDisabled ?? this.isDisabled,
      isSelected: isSelected ?? this.isSelected,
      dragT: dragT != null ? dragT() : this.dragT,
      dragVisualValue:
          dragVisualValue != null ? dragVisualValue() : this.dragVisualValue,
    );
  }
}

/// Context for switch track slot.
@immutable
final class RSwitchTrackContext {
  const RSwitchTrackContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RSwitchSpec spec;
  final RSwitchState state;
  final Widget child;
}

/// Context for switch thumb slot.
@immutable
final class RSwitchThumbContext {
  const RSwitchThumbContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RSwitchSpec spec;
  final RSwitchState state;
  final Widget child;
}

/// Context for switch press overlay slot.
@immutable
final class RSwitchPressOverlayContext {
  const RSwitchPressOverlayContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RSwitchSpec spec;
  final RSwitchState state;
  final Widget child;
}

/// Switch slots for partial customization (Replace/Decorate/Enhance).
@immutable
final class RSwitchSlots {
  const RSwitchSlots({
    this.track,
    this.thumb,
    this.pressOverlay,
  });

  final SlotOverride<RSwitchTrackContext>? track;
  final SlotOverride<RSwitchThumbContext>? thumb;
  final SlotOverride<RSwitchPressOverlayContext>? pressOverlay;
}
