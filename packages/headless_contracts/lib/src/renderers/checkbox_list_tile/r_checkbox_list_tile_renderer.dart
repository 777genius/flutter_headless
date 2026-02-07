import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../render_overrides.dart';
import 'r_checkbox_list_tile_resolved_tokens.dart';
import 'r_checkbox_list_tile_semantics.dart';
import 'r_checkbox_list_tile_slots.dart';
import 'r_checkbox_list_tile_spec.dart';
import 'r_checkbox_list_tile_state.dart';

/// Renderer capability for CheckboxListTile components.
abstract interface class RCheckboxListTileRenderer {
  Widget render(RCheckboxListTileRenderRequest request);
}

/// Render request containing everything a checkbox list tile renderer needs.
@immutable
final class RCheckboxListTileRenderRequest {
  const RCheckboxListTileRenderRequest({
    required this.context,
    required this.spec,
    required this.state,
    required this.checkbox,
    required this.title,
    this.subtitle,
    this.secondary,
    this.semantics,
    this.slots,
    this.visualEffects,
    this.resolvedTokens,
    this.constraints,
    this.overrides,
  });

  final BuildContext context;
  final RCheckboxListTileSpec spec;
  final RCheckboxListTileState state;
  final Widget checkbox;
  final Widget title;
  final Widget? subtitle;
  final Widget? secondary;
  final RCheckboxListTileSemantics? semantics;
  final RCheckboxListTileSlots? slots;
  final HeadlessPressableVisualEffectsController? visualEffects;
  final RCheckboxListTileResolvedTokens? resolvedTokens;
  final BoxConstraints? constraints;
  final RenderOverrides? overrides;
}
