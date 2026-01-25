import 'package:flutter/widgets.dart';

import '../render_overrides.dart';
import 'r_dropdown_button_renderer.dart';
import 'r_dropdown_resolved_tokens.dart';

/// Token resolver capability for Dropdown components.
///
/// This is a capability contract (ISP): components request this interface
/// via [HeadlessTheme.capability<RDropdownTokenResolver>()].
///
/// The resolver computes visual tokens based on:
/// - spec (variant, size)
/// - trigger widget states (pressed, hovered, focused, disabled)
/// - overlay phase (affects visual state of trigger)
/// - platform density / constraints
///
/// The component calls this to get resolved tokens, then passes them
/// to the renderer. The renderer never does token resolution.
///
/// **Non-generic by design**: Token resolution doesn't depend on the
/// item value type. Only UI-relevant data (states, spec) is used.
///
/// See `docs/V1_DECISIONS.md` → "Token Resolution Layer".
abstract interface class RDropdownTokenResolver {
  /// Resolve visual tokens for the given dropdown state.
  ///
  /// [context] - BuildContext for theme/density access
  /// [spec] - Dropdown specification (variant, size)
  /// [triggerStates] - Widget states for the trigger button
  /// [overlayPhase] - Current overlay lifecycle phase
  /// [constraints] - Optional layout constraints
  /// [overrides] - Per-instance style/token overrides
  RDropdownResolvedTokens resolve({
    required BuildContext context,
    required RDropdownButtonSpec spec,
    required Set<WidgetState> triggerStates,
    required ROverlayPhase overlayPhase,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  });
}
