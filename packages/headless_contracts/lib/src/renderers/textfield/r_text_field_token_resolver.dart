import 'package:flutter/widgets.dart';

import '../render_overrides.dart';
import 'r_text_field_renderer.dart';
import 'r_text_field_resolved_tokens.dart';

/// Token resolver capability for TextField components.
///
/// This is a capability contract (ISP): components request this interface
/// via [HeadlessTheme.capability<RTextFieldTokenResolver>()].
///
/// The resolver computes visual tokens based on:
/// - spec (label, error, multiline, etc.)
/// - current widget states (focused, hovered, disabled, error)
/// - platform density / constraints
///
/// The component calls this to get resolved tokens, then passes them
/// to the renderer. The renderer never does token resolution.
///
/// See `docs/V1_DECISIONS.md` → "Token Resolution Layer".
abstract interface class RTextFieldTokenResolver {
  /// Resolve visual tokens for the given text field state.
  ///
  /// [context] - BuildContext for theme/density access
  /// [spec] - TextField specification (placeholder, label, error, etc.)
  /// [states] - Current widget states (focused, hovered, etc.)
  /// [constraints] - Optional layout constraints
  /// [overrides] - Per-instance style/token overrides
  RTextFieldResolvedTokens resolve({
    required BuildContext context,
    required RTextFieldSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  });
}
