import 'package:flutter/widgets.dart';

import '../render_overrides.dart';
import 'r_checkbox_renderer.dart';
import 'r_checkbox_resolved_tokens.dart';

/// Token resolver capability for Checkbox components.
///
/// Computes visual tokens based on spec + widget states + overrides.
abstract interface class RCheckboxTokenResolver {
  RCheckboxResolvedTokens resolve({
    required BuildContext context,
    required RCheckboxSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  });
}

