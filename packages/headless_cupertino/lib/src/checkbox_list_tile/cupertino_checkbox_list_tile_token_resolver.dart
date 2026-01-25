import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

/// Cupertino token resolver for CheckboxListTile components.
class CupertinoCheckboxListTileTokenResolver
    implements RCheckboxListTileTokenResolver {
  const CupertinoCheckboxListTileTokenResolver({
    this.brightness,
  });

  final Brightness? brightness;

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
        HeadlessMotionTheme.cupertino;

    final q = HeadlessWidgetStateQuery(states);
    final tileOverrides = overrides?.get<RCheckboxListTileOverrides>();
    final resolvedBrightness =
        brightness ?? CupertinoTheme.of(context).brightness;
    final isDark = resolvedBrightness == Brightness.dark;

    final textTheme = CupertinoTheme.of(context).textTheme;
    final baseTitle = textTheme.textStyle;
    final baseSubtitle =
        textTheme.textStyle.copyWith(fontSize: 12);

    Color titleColor = isDark ? CupertinoColors.white : CupertinoColors.black;
    Color subtitleColor = CupertinoColors.secondaryLabel;

    if (q.isDisabled) {
      titleColor = CupertinoColors.inactiveGray;
      subtitleColor = CupertinoColors.inactiveGray;
    } else if (q.isSelected) {
      final selectedColor = spec.selectedColor ?? CupertinoColors.activeBlue;
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
    final defaultPadding = const EdgeInsetsDirectional.only(start: 20, end: 14);

    return RCheckboxListTileResolvedTokens(
      contentPadding:
          tileOverrides?.contentPadding ?? spec.contentPadding ?? defaultPadding,
      minHeight: tileOverrides?.minHeight ?? minHeight,
      horizontalGap: tileOverrides?.horizontalGap ?? 16,
      verticalGap: tileOverrides?.verticalGap ?? 3,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      disabledOpacity: tileOverrides?.disabledOpacity ?? 1.0,
      pressOverlayColor: tileOverrides?.pressOverlayColor ??
          CupertinoColors.activeBlue.withValues(alpha: 0.12),
      pressOpacity: tileOverrides?.pressOpacity ?? 0.4,
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
    final hasSubtitle = spec.hasSubtitle || spec.isThreeLine;
    final base = hasSubtitle ? 48.0 : 44.0;
    final minFromConstraints = constraints?.minHeight ?? 0;
    return base < minFromConstraints ? minFromConstraints : base;
  }
}

