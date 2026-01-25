import 'package:flutter/widgets.dart';

import '../render_overrides.dart';
import 'r_switch_renderer.dart';
import 'r_switch_resolved_tokens.dart';

/// Token resolver capability for Switch components.
///
/// Computes visual tokens based on spec + widget states + overrides.
abstract interface class RSwitchTokenResolver {
  RSwitchResolvedTokens resolve({
    required BuildContext context,
    required RSwitchSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  });
}
