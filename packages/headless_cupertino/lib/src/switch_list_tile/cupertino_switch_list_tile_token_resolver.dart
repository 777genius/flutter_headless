import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

/// Cupertino token resolver for SwitchListTile components.
class CupertinoSwitchListTileTokenResolver
    implements RSwitchListTileTokenResolver {
  const CupertinoSwitchListTileTokenResolver({
    this.brightness,
  });

  final Brightness? brightness;

  @override
  RSwitchListTileResolvedTokens resolve({
    required BuildContext context,
    required RSwitchListTileSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    final motionTheme = HeadlessThemeProvider.of(context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.cupertino;

    final q = HeadlessWidgetStateQuery(states);
    final tileOverrides = overrides?.get<RSwitchListTileOverrides>();

    final effectiveBrightness =
        brightness ?? MediaQuery.platformBrightnessOf(context);
    final isDark = effectiveBrightness == Brightness.dark;

    final baseTitle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: isDark ? CupertinoColors.white : CupertinoColors.black,
    );
    final baseSubtitle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: isDark
          ? CupertinoColors.systemGrey
          : CupertinoColors.secondaryLabel,
    );

    Color? titleColor;
    Color? subtitleColor;

    if (q.isDisabled) {
      titleColor = CupertinoColors.systemGrey.withValues(alpha: 0.5);
      subtitleColor = CupertinoColors.systemGrey.withValues(alpha: 0.5);
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

    return RSwitchListTileResolvedTokens(
      contentPadding: tileOverrides?.contentPadding ??
          spec.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minHeight: tileOverrides?.minHeight ?? minHeight,
      horizontalGap: tileOverrides?.horizontalGap ?? 12,
      verticalGap: tileOverrides?.verticalGap ?? 2,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      disabledOpacity: tileOverrides?.disabledOpacity ?? 1.0,
      pressOverlayColor: tileOverrides?.pressOverlayColor ??
          CupertinoColors.systemGrey.withValues(alpha: 0.12),
      pressOpacity: tileOverrides?.pressOpacity ?? 0.4,
      motion: tileOverrides?.motion ??
          RSwitchListTileMotionTokens(
            stateChangeDuration: motionTheme.button.stateChangeDuration,
          ),
    );
  }

  double _resolveMinHeight(
    RSwitchListTileSpec spec,
    BoxConstraints? constraints,
  ) {
    final lineCount = spec.isThreeLine
        ? 3
        : spec.hasSubtitle
            ? 2
            : 1;
    final base = switch (lineCount) {
      1 => spec.dense ? 44.0 : 52.0,
      2 => spec.dense ? 56.0 : 64.0,
      _ => spec.dense ? 68.0 : 76.0,
    };
    final minFromConstraints = constraints?.minHeight ?? 0;
    return base < minFromConstraints ? minFromConstraints : base;
  }
}
