import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

/// Cupertino token resolver for Switch components.
///
/// Implements [RSwitchTokenResolver] with iOS styling.
class CupertinoSwitchTokenResolver implements RSwitchTokenResolver {
  const CupertinoSwitchTokenResolver({
    this.brightness,
  });

  final Brightness? brightness;

  @override
  RSwitchResolvedTokens resolve({
    required BuildContext context,
    required RSwitchSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    final motionTheme =
        HeadlessThemeProvider.of(context)?.capability<HeadlessMotionTheme>() ??
            HeadlessMotionTheme.cupertino;

    final q = HeadlessWidgetStateQuery(states);
    final contractOverrides = overrides?.get<RSwitchOverrides>();

    // Use provided brightness or fallback to platform brightness
    final effectiveBrightness =
        brightness ?? MediaQuery.platformBrightnessOf(context);
    final isDark = effectiveBrightness == Brightness.dark;

    // Cupertino Switch baseline values (iOS style).
    // Cupertino switches have a fixed thumb size (no dynamic sizing like Material 3)
    const defaultTrackSize = Size(51, 31);
    // Flutter: _kThumbRadius = 14.0 -> diameter 28.0
    const defaultThumbSize = Size(28, 28);
    const defaultTrackBorderRadius = BorderRadius.all(Radius.circular(16));
    const defaultThumbPadding = 2.0;

    final isSelected = spec.value || q.isSelected;

    Color activeTrackColor;
    Color inactiveTrackColor;
    Color activeThumbColor;
    Color inactiveThumbColor;
    Color trackOutlineColor;

    if (q.isDisabled) {
      activeTrackColor = CupertinoColors.systemGreen.withValues(alpha: 0.5);
      inactiveTrackColor = isDark
          ? CupertinoColors.systemGrey.withValues(alpha: 0.5)
          : CupertinoColors.systemGrey4.withValues(alpha: 0.5);
      activeThumbColor = CupertinoColors.white.withValues(alpha: 0.8);
      inactiveThumbColor = CupertinoColors.white.withValues(alpha: 0.8);
      trackOutlineColor = isDark
          ? CupertinoColors.systemGrey.withValues(alpha: 0.5)
          : CupertinoColors.systemGrey4.withValues(alpha: 0.5);
    } else {
      activeTrackColor = CupertinoColors.systemGreen;
      inactiveTrackColor =
          isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey4;
      activeThumbColor = CupertinoColors.white;
      inactiveThumbColor = CupertinoColors.white;
      trackOutlineColor =
          isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey4;
    }

    final pressOverlayColor = isSelected
        ? CupertinoColors.systemGreen.withValues(alpha: 0.12)
        : CupertinoColors.systemGrey.withValues(alpha: 0.12);

    // Cupertino doesn't use state layer, but we provide transparent fallback
    final stateLayerColor =
        WidgetStateProperty.all<Color?>(const Color(0x00000000));

    final minTapTargetSize = _resolveMinTapTargetSize(
      constraints: constraints,
      override: contractOverrides?.minTapTargetSize,
    );

    return RSwitchResolvedTokens(
      trackSize: contractOverrides?.trackSize ?? defaultTrackSize,
      trackBorderRadius:
          contractOverrides?.trackBorderRadius ?? defaultTrackBorderRadius,
      trackOutlineColor:
          contractOverrides?.trackOutlineColor ?? trackOutlineColor,
      trackOutlineWidth: contractOverrides?.trackOutlineWidth ?? 0.0,
      activeTrackColor: contractOverrides?.activeTrackColor ?? activeTrackColor,
      inactiveTrackColor:
          contractOverrides?.inactiveTrackColor ?? inactiveTrackColor,
      // Cupertino: thumb size is fixed (no unselected/selected/pressed differentiation)
      thumbSizeUnselected:
          contractOverrides?.thumbSizeUnselected ?? defaultThumbSize,
      thumbSizeSelected:
          contractOverrides?.thumbSizeSelected ?? defaultThumbSize,
      thumbSizePressed: contractOverrides?.thumbSizePressed ?? defaultThumbSize,
      thumbSizeTransition:
          contractOverrides?.thumbSizeTransition ?? defaultThumbSize,
      activeThumbColor: contractOverrides?.activeThumbColor ?? activeThumbColor,
      inactiveThumbColor:
          contractOverrides?.inactiveThumbColor ?? inactiveThumbColor,
      thumbPadding: contractOverrides?.thumbPadding ?? defaultThumbPadding,
      // Flutter: _kDisabledOpacity = 0.5
      disabledOpacity: contractOverrides?.disabledOpacity ?? 0.5,
      pressOverlayColor:
          contractOverrides?.pressOverlayColor ?? pressOverlayColor,
      // Native CupertinoSwitch does not dim the whole control on press.
      pressOpacity: contractOverrides?.pressOpacity ?? 1.0,
      // Flutter: _kSwitchSize = 59×39 (track 51×31 centered inside).
      minTapTargetSize: minTapTargetSize,
      // Cupertino doesn't use state layer
      stateLayerRadius: contractOverrides?.stateLayerRadius ?? 0.0,
      stateLayerColor: contractOverrides?.stateLayerColor ?? stateLayerColor,
      thumbIcon: contractOverrides?.thumbIcon,
      motion: contractOverrides?.motion ??
          RSwitchMotionTokens(
            stateChangeDuration: motionTheme.button.stateChangeDuration,
            thumbSlideDuration: const Duration(milliseconds: 200),
          ),
    );
  }

  Size _resolveMinTapTargetSize({
    required BoxConstraints? constraints,
    required Size? override,
  }) {
    const fallback = Size(59, 39);
    final base = override ?? fallback;
    if (constraints == null) return base;
    return Size(
      constraints.minWidth > 0 ? constraints.minWidth : base.width,
      constraints.minHeight > 0 ? constraints.minHeight : base.height,
    );
  }
}
