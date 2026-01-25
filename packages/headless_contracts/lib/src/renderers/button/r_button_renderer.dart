import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../../slots/slot_override.dart';
import '../render_overrides.dart';
import 'r_button_resolved_tokens.dart';
import 'r_button_semantics.dart';

/// Renderer capability for Button components.
///
/// This is a capability contract (ISP): components request this interface
/// via [HeadlessTheme.capability<RButtonRenderer>()].
///
/// Renderers implement this to provide visual representation.
/// Components never know the concrete renderer implementation.
///
/// See `docs/V1_DECISIONS.md` → "4) Renderer contracts + Slots override".
abstract interface class RButtonRenderer {
  /// Render a button with the given request.
  Widget render(RButtonRenderRequest request);
}

/// Render request containing everything a button renderer needs.
///
/// Follows the pattern: context + spec + state + semantics + slots + tokens + constraints.
/// Only includes what the renderer actually needs (perf + API stability).
///
/// See `docs/V1_DECISIONS.md` → "0.1 Renderer contracts".
@immutable
final class RButtonRenderRequest {
  const RButtonRenderRequest({
    required this.context,
    required this.spec,
    required this.state,
    required this.content,
    this.leadingIcon,
    this.trailingIcon,
    this.spinner,
    this.semantics,
    this.slots,
    this.visualEffects,
    this.resolvedTokens,
    this.constraints,
    this.overrides,
  });

  /// Build context for theme/media query access.
  final BuildContext context;

  /// Static specification (variant, size, semantics).
  final RButtonSpec spec;

  /// Current interaction state.
  final RButtonState state;

  /// Default content widget provided by the component.
  final Widget content;

  /// Optional leading icon widget provided by the component.
  final Widget? leadingIcon;

  /// Optional trailing icon widget provided by the component.
  final Widget? trailingIcon;

  /// Optional spinner widget provided by the component.
  final Widget? spinner;

  /// Semantic information for accessibility.
  ///
  /// Allows renderer to provide tooltip/aria hints if needed.
  final RButtonSemantics? semantics;

  /// Optional slots for partial override (Replace/Decorate/Enhance).
  final RButtonSlots? slots;

  /// Optional visual-only effects controller (pointer/hover/focus events).
  ///
  /// Renderers may use this to drive ripple/highlight animations without
  /// owning activation logic.
  final HeadlessPressableVisualEffectsController? visualEffects;

  /// Pre-resolved visual tokens.
  ///
  /// If provided, renderer should use these directly.
  /// If null, renderer may use default theme values.
  final RButtonResolvedTokens? resolvedTokens;

  /// Layout constraints (e.g., minimum hit target size).
  final BoxConstraints? constraints;

  /// Per-instance override bag for preset customization.
  ///
  /// Allows "style on this specific button" without API pollution.
  /// See `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`.
  final RenderOverrides? overrides;
}

/// Button specification (static, from widget props).
///
/// Contains visual variant, sizing, and semantic information.
/// This is the "what" of the button (not the "how" — that's the renderer).
@immutable
final class RButtonSpec {
  const RButtonSpec({
    this.variant = RButtonVariant.secondary,
    this.size = RButtonSize.medium,
    this.semanticLabel,
  });

  /// Visual variant (primary, secondary, etc.).
  final RButtonVariant variant;

  /// Size variant.
  final RButtonSize size;

  /// Accessibility label (for screen readers).
  final String? semanticLabel;
}

/// Button visual variants.
///
/// Minimal set for v1. More variants can be added in minor releases.
enum RButtonVariant {
  /// Primary action button (high emphasis).
  primary,

  /// Secondary/default button (medium emphasis).
  secondary,
}

/// Button size variants.
enum RButtonSize {
  /// Small size.
  small,

  /// Medium/default size.
  medium,

  /// Large size.
  large,
}

/// Button interaction state.
///
/// Derived from Flutter's WidgetState set, exposed as simple flags
/// for renderer convenience.
@immutable
final class RButtonState {
  const RButtonState({
    this.isPressed = false,
    this.isHovered = false,
    this.isFocused = false,
    this.isDisabled = false,
  });

  /// Whether the button is currently pressed.
  final bool isPressed;

  /// Whether the pointer is hovering over the button.
  final bool isHovered;

  /// Whether the button has keyboard focus.
  final bool isFocused;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// Create state from Flutter's WidgetState set.
  factory RButtonState.fromWidgetStates(Set<WidgetState> states) {
    final decoded = WidgetStateHelper.fromWidgetStates(states);
    return RButtonState(
      isPressed: decoded.isPressed,
      isHovered: decoded.isHovered,
      isFocused: decoded.isFocused,
      isDisabled: decoded.isDisabled,
    );
  }

  /// Convert to Flutter's WidgetState set.
  Set<WidgetState> toWidgetStates() {
    return WidgetStateHelper.toWidgetStates(
      isPressed: isPressed,
      isHovered: isHovered,
      isFocused: isFocused,
      isDisabled: isDisabled,
    );
  }
}

/// Context for the button surface slot.
@immutable
final class RButtonSurfaceContext {
  const RButtonSurfaceContext({
    required this.spec,
    required this.state,
    required this.child,
    this.resolvedTokens,
  });

  final RButtonSpec spec;
  final RButtonState state;
  final Widget child;
  final RButtonResolvedTokens? resolvedTokens;
}

/// Context for the button content slot.
@immutable
final class RButtonContentContext {
  const RButtonContentContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RButtonSpec spec;
  final RButtonState state;
  final Widget child;
}

/// Context for the button icon slots.
@immutable
final class RButtonIconContext {
  const RButtonIconContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RButtonSpec spec;
  final RButtonState state;
  final Widget child;
}

/// Context for the button spinner slot.
@immutable
final class RButtonSpinnerContext {
  const RButtonSpinnerContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RButtonSpec spec;
  final RButtonState state;
  final Widget child;
}

/// Button slots for partial customization (Replace/Decorate/Enhance).
@immutable
final class RButtonSlots {
  const RButtonSlots({
    this.surface,
    this.content,
    this.leadingIcon,
    this.trailingIcon,
    this.spinner,
  });

  final SlotOverride<RButtonSurfaceContext>? surface;
  final SlotOverride<RButtonContentContext>? content;
  final SlotOverride<RButtonIconContext>? leadingIcon;
  final SlotOverride<RButtonIconContext>? trailingIcon;
  final SlotOverride<RButtonSpinnerContext>? spinner;
}
