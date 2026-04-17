import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';

import '../../contracts/r_pin_input_overrides.dart';
import '../../contracts/r_pin_input_renderer.dart';
import '../../contracts/r_pin_input_resolved_tokens.dart';
import '../../contracts/r_pin_input_token_resolver.dart';
import '../../contracts/r_pin_input_types.dart';
import 'demo_pin_input_variant_defaults.dart';

final class DemoPinInputTokenResolver implements RPinInputTokenResolver {
  const DemoPinInputTokenResolver({
    this.colorScheme,
    this.textTheme,
  });

  final ColorScheme? colorScheme;
  final TextTheme? textTheme;

  @override
  RPinInputResolvedTokens resolve({
    required BuildContext context,
    required RPinInputSpec spec,
    required RPinInputState state,
    RenderOverrides? overrides,
  }) {
    ThemeData? theme;
    try {
      theme = Theme.of(context);
    } catch (_) {
      theme = null;
    }
    final scheme = colorScheme ??
        theme?.colorScheme ??
        DemoPinInputVariantDefaults.fallbackColorScheme;
    final text =
        textTheme ?? theme?.textTheme ?? Typography.material2021().black;
    final contractOverrides = overrides?.get<RPinInputOverrides>();
    final radius = contractOverrides?.cellBorderRadius ??
        DemoPinInputVariantDefaults.radiusFor(spec.variant);
    final size = Size(
      contractOverrides?.cellWidth ??
          DemoPinInputVariantDefaults.widthFor(spec.variant),
      contractOverrides?.cellHeight ?? 64,
    );
    final baseTextStyle = (contractOverrides?.textStyle ??
            text.headlineSmall ??
            const TextStyle(fontSize: 24, fontWeight: FontWeight.w600))
        .copyWith(height: 1);
    final chromeKind = spec.variant == RPinInputVariant.underlined
        ? RPinInputCellChromeKind.underline
        : RPinInputCellChromeKind.box;
    final useTransparentUnderlineBackground =
        spec.variant == RPinInputVariant.underlined;
    final palette =
        DemoPinInputVariantDefaults.paletteFor(scheme, spec.variant);
    final padding = spec.variant == RPinInputVariant.underlined
        ? const EdgeInsets.only(bottom: 10)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 10);

    return RPinInputResolvedTokens(
      defaultCell: _cellTokens(
        chromeKind: chromeKind,
        size: size,
        padding: padding,
        textStyle: baseTextStyle,
        textColor: contractOverrides?.textColor ?? scheme.onSurface,
        backgroundColor:
            contractOverrides?.backgroundColor ?? palette.background,
        borderColor: contractOverrides?.borderColor ?? palette.border,
        borderWidth: contractOverrides?.cellBorderWidth ?? palette.borderWidth,
        borderRadius: BorderRadius.circular(radius),
        boxShadows: palette.shadows,
      ),
      focusedCell: _cellTokens(
        chromeKind: chromeKind,
        size: size,
        padding: padding,
        textStyle: baseTextStyle,
        textColor: contractOverrides?.textColor ?? scheme.onSurface,
        backgroundColor: DemoPinInputVariantDefaults.focusedBackground(
            palette, spec.variant),
        borderColor: contractOverrides?.borderColor ?? scheme.primary,
        borderWidth: contractOverrides?.cellBorderWidth ?? 2,
        borderRadius: BorderRadius.circular(radius),
        boxShadows: DemoPinInputVariantDefaults.focusedShadows(
            palette, spec.variant, scheme),
      ),
      submittedCell: _cellTokens(
        chromeKind: chromeKind,
        size: size,
        padding: padding,
        textStyle: baseTextStyle,
        textColor: contractOverrides?.textColor ?? scheme.onSurface,
        backgroundColor:
            DemoPinInputVariantDefaults.submittedBackground(palette, scheme),
        borderColor: contractOverrides?.borderColor ??
            DemoPinInputVariantDefaults.submittedBorder(scheme),
        borderWidth: contractOverrides?.cellBorderWidth ?? palette.borderWidth,
        borderRadius: BorderRadius.circular(radius),
        boxShadows: palette.shadows,
      ),
      followingCell: _cellTokens(
        chromeKind: chromeKind,
        size: size,
        padding: padding,
        textStyle: baseTextStyle,
        textColor: contractOverrides?.textColor ??
            scheme.onSurface.withValues(alpha: 0.72),
        backgroundColor: contractOverrides?.backgroundColor ??
            (useTransparentUnderlineBackground
                ? Colors.transparent
                : palette.background.withValues(alpha: 0.9)),
        borderColor: contractOverrides?.borderColor ??
            palette.border.withValues(alpha: 0.65),
        borderWidth: contractOverrides?.cellBorderWidth ?? palette.borderWidth,
        borderRadius: BorderRadius.circular(radius),
        boxShadows: palette.shadows,
      ),
      disabledCell: _cellTokens(
        chromeKind: chromeKind,
        size: size,
        padding: padding,
        textStyle: baseTextStyle,
        textColor: contractOverrides?.textColor ??
            scheme.onSurface.withValues(alpha: 0.38),
        backgroundColor: contractOverrides?.backgroundColor ??
            (useTransparentUnderlineBackground
                ? Colors.transparent
                : scheme.surfaceContainerHighest.withValues(alpha: 0.35)),
        borderColor: contractOverrides?.borderColor ??
            scheme.outline.withValues(alpha: 0.24),
        borderWidth: contractOverrides?.cellBorderWidth ?? palette.borderWidth,
        borderRadius: BorderRadius.circular(radius),
        boxShadows: const [],
      ),
      errorCell: _cellTokens(
        chromeKind: chromeKind,
        size: size,
        padding: padding,
        textStyle: baseTextStyle,
        textColor: contractOverrides?.textColor ?? scheme.onSurface,
        backgroundColor: contractOverrides?.backgroundColor ??
            (useTransparentUnderlineBackground
                ? Colors.transparent
                : scheme.errorContainer.withValues(alpha: 0.22)),
        borderColor: contractOverrides?.borderColor ?? scheme.error,
        borderWidth: contractOverrides?.cellBorderWidth ?? 2,
        borderRadius: BorderRadius.circular(radius),
        boxShadows: const [],
      ),
      cellGap: contractOverrides?.cellGap ?? 12,
      cursorColor: contractOverrides?.cursorColor ?? scheme.primary,
      cursorKind: spec.variant == RPinInputVariant.underlined
          ? RPinInputCursorKind.bottomBar
          : RPinInputCursorKind.bar,
      cursorWidth: spec.variant == RPinInputVariant.underlined ? 18 : 2,
      cursorHeightFactor:
          spec.variant == RPinInputVariant.underlined ? 0.04 : 0.5,
      cursorBottomInset: spec.variant == RPinInputVariant.underlined ? 8 : 0,
      errorStyle: (contractOverrides?.errorStyle ??
              text.bodySmall ??
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          .copyWith(color: contractOverrides?.errorColor ?? scheme.error),
      errorColor: contractOverrides?.errorColor ?? scheme.error,
      errorTopSpacing: contractOverrides?.errorTopSpacing ?? 10,
    );
  }

  static RPinInputCellResolvedTokens _cellTokens({
    required RPinInputCellChromeKind chromeKind,
    required Size size,
    required EdgeInsetsGeometry padding,
    required TextStyle textStyle,
    required Color textColor,
    required Color backgroundColor,
    required Color borderColor,
    required double borderWidth,
    required BorderRadius borderRadius,
    required List<BoxShadow> boxShadows,
  }) {
    return RPinInputCellResolvedTokens(
      chromeKind: chromeKind,
      size: size,
      padding: padding,
      textStyle: textStyle,
      textColor: textColor,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      boxShadows: boxShadows,
    );
  }
}
