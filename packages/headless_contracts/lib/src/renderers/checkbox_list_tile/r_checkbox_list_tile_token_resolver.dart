import 'package:flutter/widgets.dart';

import '../render_overrides.dart';
import 'r_checkbox_list_tile_spec.dart';
import 'r_checkbox_list_tile_resolved_tokens.dart';

/// Token resolver capability for CheckboxListTile components.
abstract interface class RCheckboxListTileTokenResolver {
  RCheckboxListTileResolvedTokens resolve({
    required BuildContext context,
    required RCheckboxListTileSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  });
}
