import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

/// Material 3 token resolver for CheckboxListTile components.
class MaterialCheckboxListTileTokenResolver
    implements RCheckboxListTileTokenResolver {
  const MaterialCheckboxListTileTokenResolver({
    this.colorScheme,
    this.textTheme,
  });

  final ColorScheme? colorScheme;
  final TextTheme? textTheme;

  @override
  RCheckboxListTileResolvedTokens resolve({
    required BuildContext context,
    required RCheckboxListTileSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    final motionTheme = HeadlessThemeProvider.of(context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.material;

    final theme = Theme.of(context);
    final scheme = colorScheme ?? theme.colorScheme;
    final text = textTheme ?? theme.textTheme;
    final useMaterial3 = theme.useMaterial3;
    final q = HeadlessWidgetStateQuery(states);

    final tileOverrides = overrides?.get<RCheckboxListTileOverrides>();

    final baseTitle = useMaterial3
        ? (text.bodyLarge ?? const TextStyle(fontSize: 16))
        : (text.titleMedium ?? const TextStyle(fontSize: 16));
    final baseSubtitle = useMaterial3
        ? (text.bodyMedium ?? const TextStyle(fontSize: 14))
        : (text.bodyMedium ??
                const TextStyle(fontSize: 14))
            .copyWith(color: text.bodySmall?.color);

    Color? titleColor = useMaterial3 ? scheme.onSurface : null;
    Color? subtitleColor =
        useMaterial3 ? scheme.onSurfaceVariant : baseSubtitle.color;

    if (q.isDisabled) {
      titleColor = scheme.onSurface.withValues(alpha: 0.38);
      subtitleColor = scheme.onSurface.withValues(alpha: 0.38);
    } else if (q.isSelected) {
      final selectedColor = spec.selectedColor ?? scheme.primary;
      titleColor = selectedColor;
      subtitleColor = selectedColor;
    }

    final titleStyle =
        (tileOverrides?.titleStyle ?? baseTitle).copyWith(color: titleColor);
    final subtitleStyle =
        (tileOverrides?.subtitleStyle ?? baseSubtitle).copyWith(
      color: subtitleColor,
    );

    final minHeight = _resolveMinHeight(spec, constraints);
    final defaultPadding = useMaterial3
        ? const EdgeInsetsDirectional.only(start: 16, end: 24)
        : const EdgeInsets.symmetric(horizontal: 16);
    final defaultVerticalGap = useMaterial3 ? 2.0 : 4.0;

    return RCheckboxListTileResolvedTokens(
      contentPadding: tileOverrides?.contentPadding ??
          spec.contentPadding ??
          defaultPadding,
      minHeight: tileOverrides?.minHeight ?? minHeight,
      horizontalGap: tileOverrides?.horizontalGap ?? 16,
      verticalGap: tileOverrides?.verticalGap ?? defaultVerticalGap,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      disabledOpacity: tileOverrides?.disabledOpacity ?? 1.0,
      pressOverlayColor: tileOverrides?.pressOverlayColor ??
          scheme.primary.withValues(alpha: 0.12),
      pressOpacity: tileOverrides?.pressOpacity ?? 1.0,
      motion: tileOverrides?.motion ??
          RCheckboxListTileMotionTokens(
            stateChangeDuration: motionTheme.button.stateChangeDuration,
          ),
    );
  }

  double _resolveMinHeight(
    RCheckboxListTileSpec spec,
    BoxConstraints? constraints,
  ) {
    final lineCount = spec.isThreeLine
        ? 3
        : spec.hasSubtitle
            ? 2
            : 1;
    final base = switch (lineCount) {
      1 => spec.dense ? 48.0 : 56.0,
      2 => spec.dense ? 64.0 : 72.0,
      _ => spec.dense ? 76.0 : 88.0,
    };
    final minFromConstraints = constraints?.minHeight ?? 0;
    return base < minFromConstraints ? minFromConstraints : base;
  }
}

