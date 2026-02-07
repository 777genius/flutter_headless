import 'render_overrides.dart';

/// Merge a simple style object into [RenderOverrides] with POLA priority.
///
/// Priority (strong -> weak):
/// 1) explicit [overrides]
/// 2) [style] converted via [toOverride]
RenderOverrides? mergeStyleIntoOverrides<TStyle, TOverride extends Object>({
  required TStyle? style,
  required RenderOverrides? overrides,
  required TOverride Function(TStyle) toOverride,
}) {
  if (style == null) return overrides;
  final fromStyle = RenderOverrides.only<TOverride>(toOverride(style));
  if (overrides == null) return fromStyle;
  return fromStyle.merge(overrides);
}

/// Merge multiple sugar layers into overrides with POLA priority.
///
/// Priority (strong -> weak):
/// 1) [base] — explicit overrides, always win
/// 2) [fallbacks] — sugar layers in order (later = stronger)
///
/// Example for RSwitch with thumbIcon + style sugar:
/// ```dart
/// mergeOverridesWithFallbacks(
///   base: widget.overrides,
///   fallbacks: [
///     // style is weakest sugar
///     if (widget.style != null)
///       RenderOverrides.only(widget.style!.toOverrides()),
///     // thumbIcon is stronger than style, but weaker than overrides
///     if (widget.thumbIcon != null)
///       RenderOverrides.only(RSwitchOverrides.tokens(thumbIcon: widget.thumbIcon)),
///   ],
/// );
/// ```
RenderOverrides? mergeOverridesWithFallbacks({
  required RenderOverrides? base,
  required List<RenderOverrides?> fallbacks,
}) {
  // Filter nulls and fold from left (earlier = weaker)
  final nonNull = fallbacks.whereType<RenderOverrides>().toList();
  if (nonNull.isEmpty) return base;

  var merged = nonNull.first;
  for (var i = 1; i < nonNull.length; i++) {
    merged = merged.merge(nonNull[i]);
  }

  if (base == null) return merged;
  return merged.merge(base);
}
