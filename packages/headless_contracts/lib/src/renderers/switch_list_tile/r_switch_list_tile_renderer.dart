import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../render_overrides.dart';
import 'r_switch_list_tile_resolved_tokens.dart';
import 'r_switch_list_tile_semantics.dart';
import 'r_switch_list_tile_slots.dart';
import 'r_switch_list_tile_spec.dart';
import 'r_switch_list_tile_state.dart';

/// Renderer capability for SwitchListTile components.
abstract interface class RSwitchListTileRenderer {
  Widget render(RSwitchListTileRenderRequest request);
}

/// Render request containing everything a switch list tile renderer needs.
@immutable
final class RSwitchListTileRenderRequest {
  const RSwitchListTileRenderRequest({
    required this.context,
    required this.spec,
    required this.state,
    required this.switchWidget,
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
  final RSwitchListTileSpec spec;
  final RSwitchListTileState state;
  final Widget switchWidget;
  final Widget title;
  final Widget? subtitle;
  final Widget? secondary;
  final RSwitchListTileSemantics? semantics;
  final RSwitchListTileSlots? slots;
  final HeadlessPressableVisualEffectsController? visualEffects;
  final RSwitchListTileResolvedTokens? resolvedTokens;
  final BoxConstraints? constraints;
  final RenderOverrides? overrides;
}
