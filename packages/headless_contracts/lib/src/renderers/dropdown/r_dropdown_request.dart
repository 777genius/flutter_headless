import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../render_overrides.dart';
import 'r_dropdown_commands.dart';
import 'r_dropdown_resolved_tokens.dart';
import 'r_dropdown_semantics.dart';
import 'r_dropdown_slots.dart';
import 'r_dropdown_spec.dart';
import 'r_dropdown_state.dart';

/// Render request containing everything a dropdown renderer needs.
///
/// Follows the pattern: context + spec + state + semantics + callbacks + slots + tokens + constraints.
/// Only includes what the renderer actually needs (perf + API stability).
///
/// **Non-generic by design**: Contains only UI data (labels, indices).
/// The component maps `value` ↔ `index` internally before calling the renderer.
///
/// See `docs/V1_DECISIONS.md` → "0.1 Renderer contracts".
@immutable
sealed class RDropdownRenderRequest {
  const RDropdownRenderRequest({
    required this.context,
    required this.spec,
    required this.state,
    required this.items,
    required this.commands,
    this.semantics,
    this.slots,
    this.visualEffects,
    this.resolvedTokens,
    this.constraints,
    this.overrides,
    this.features = HeadlessRequestFeatures.empty,
  });

  /// Build context for theme/media query access.
  final BuildContext context;

  /// Static specification (variant, size, semantics).
  final RDropdownButtonSpec spec;

  /// Current dropdown state (open, selection, highlight).
  final RDropdownButtonState state;

  /// List of items to display in the menu.
  final List<HeadlessListItemModel> items;

  /// Internal component commands.
  ///
  /// Renderer must not call application-level user callbacks directly.
  final RDropdownCommands commands;

  /// Semantic information for accessibility.
  final RDropdownSemantics? semantics;

  /// Optional slots for partial override (Replace/Decorate).
  final RDropdownButtonSlots? slots;

  /// Optional visual-only effects controller (pointer/hover/focus events).
  ///
  /// Intended for trigger visuals (e.g., ripple/highlight) without activation.
  final HeadlessPressableVisualEffectsController? visualEffects;

  /// Pre-resolved visual tokens.
  ///
  /// If provided, renderer should use these directly.
  /// If null, renderer may use default theme values.
  final RDropdownResolvedTokens? resolvedTokens;

  /// Layout constraints (e.g., minimum hit target, max menu height).
  final BoxConstraints? constraints;

  /// Per-instance override bag for preset customization.
  ///
  /// Allows "style on this specific dropdown" without API pollution.
  /// See `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`.
  final RenderOverrides? overrides;

  /// Typed features for the request (e.g., remote loading state, error info).
  ///
  /// Provides data that presets/slots can read to customize UI behavior.
  /// Unlike [overrides], features carry data/state, not visual customization.
  ///
  /// Example: autocomplete remote loading state is passed here so that
  /// empty state slot can show "loading..." or "error + retry" UI.
  final HeadlessRequestFeatures features;
}

/// Render request for the dropdown trigger (anchor).
@immutable
final class RDropdownTriggerRenderRequest extends RDropdownRenderRequest {
  const RDropdownTriggerRenderRequest({
    required super.context,
    required super.spec,
    required super.state,
    required super.items,
    required super.commands,
    super.semantics,
    super.slots,
    super.visualEffects,
    super.resolvedTokens,
    super.constraints,
    super.overrides,
    super.features,
  });
}

/// Render request for the dropdown menu (overlay).
@immutable
final class RDropdownMenuRenderRequest extends RDropdownRenderRequest {
  const RDropdownMenuRenderRequest({
    required super.context,
    required super.spec,
    required super.state,
    required super.items,
    required super.commands,
    super.semantics,
    super.slots,
    super.visualEffects,
    super.resolvedTokens,
    super.constraints,
    super.overrides,
    super.features,
  });
}
