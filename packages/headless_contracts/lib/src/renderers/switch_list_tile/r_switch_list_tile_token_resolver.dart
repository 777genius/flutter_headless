import 'package:flutter/widgets.dart';

import '../render_overrides.dart';
import 'r_switch_list_tile_resolved_tokens.dart';
import 'r_switch_list_tile_spec.dart';

/// Token resolver capability for SwitchListTile components.
abstract interface class RSwitchListTileTokenResolver {
  RSwitchListTileResolvedTokens resolve({
    required BuildContext context,
    required RSwitchListTileSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  });
}
