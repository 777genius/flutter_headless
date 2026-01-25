import 'package:flutter/widgets.dart';

import '../render_overrides.dart';
import 'r_button_renderer.dart';
import 'r_button_resolved_tokens.dart';

/// Token resolver capability for Button components.
///
/// This is a capability contract (ISP): components request this interface
/// via [HeadlessTheme.capability<RButtonTokenResolver>()].
///
/// The resolver computes visual tokens based on:
/// - spec (variant, size)
/// - current widget states (pressed, hovered, focused, disabled)
/// - platform density / constraints
///
/// The component calls this to get resolved tokens, then passes them
/// to the renderer. The renderer never does token resolution.
///
/// See `docs/V1_DECISIONS.md` → "Token Resolution Layer".
abstract interface class RButtonTokenResolver {
  /// Resolve visual tokens for the given button state.
  ///
  /// [context] - BuildContext for theme/density access
  /// [spec] - Button specification (variant, size)
  /// [states] - Current widget states (pressed, hovered, etc.)
  /// [constraints] - Optional layout constraints (for min hit target policy)
  /// [overrides] - Per-instance style/token overrides
  RButtonResolvedTokens resolve({
    required BuildContext context,
    required RButtonSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  });
}
