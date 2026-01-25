import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

/// Material 3 token resolver for Switch components.
///
/// Implements [RSwitchTokenResolver] with Material Design 3 styling.
///
/// Token resolution priority (v1):
/// 1. Contract overrides: `overrides.get<RSwitchOverrides>()`
/// 2. Theme defaults / preset defaults
class MaterialSwitchTokenResolver implements RSwitchTokenResolver {
  const MaterialSwitchTokenResolver({
    this.colorScheme,
  });

  final ColorScheme? colorScheme;

  @override
  RSwitchResolvedTokens resolve({
    required BuildContext context,
    required RSwitchSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    final motionTheme = HeadlessThemeProvider.of(context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.material;

    final scheme = colorScheme ?? Theme.of(context).colorScheme;
    final q = HeadlessWidgetStateQuery(states);

    final contractOverrides = overrides?.get<RSwitchOverrides>();

    // Material 3 Switch baseline values.
    const defaultTrackSize = Size(52, 32);
    const defaultTrackBorderRadius = BorderRadius.all(Radius.circular(16));
    const defaultTrackOutlineWidth = 2.0;
    const defaultThumbPadding = 4.0;

    // Material 3 thumb sizes (from Flutter switch.dart _SwitchConfigM3)
    const defaultThumbSizeUnselected = Size(16, 16);
    const defaultThumbSizeSelected = Size(24, 24);
    const defaultThumbSizePressed = Size(28, 28);
    const defaultThumbSizeTransition = Size(34, 22);

    // Material 3 state layer radius (splashRadius = 40.0 / 2 = 20.0)
    const defaultStateLayerRadius = 20.0;

    // Material thumb toggle duration.
    // Ускорили дефолт в демо/проекте в 2 раза относительно Flutter (300ms → 150ms).
    const defaultThumbToggleDuration = Duration(milliseconds: 150);

    final isSelected = spec.value || q.isSelected;

    Color activeTrackColor;
    Color inactiveTrackColor;
    Color activeThumbColor;
    Color inactiveThumbColor;
    Color trackOutlineColor;

    final isInteraction = q.isPressed || q.isHovered || q.isFocused;

    if (q.isDisabled) {
      // Matches Flutter _SwitchDefaultsM3:
      // - track: selected -> onSurface 0.12, unselected -> surfaceContainerHighest 0.12
      // - thumb: selected -> surface (opacity 1.0), unselected -> onSurface 0.38
      // - outline: disabled -> onSurface 0.12
      activeTrackColor = scheme.onSurface.withValues(alpha: 0.12);
      inactiveTrackColor =
          scheme.surfaceContainerHighest.withValues(alpha: 0.12);
      activeThumbColor = scheme.surface;
      inactiveThumbColor = scheme.onSurface.withValues(alpha: 0.38);
      trackOutlineColor = scheme.onSurface.withValues(alpha: 0.12);
    } else {
      // Matches Flutter _SwitchDefaultsM3:
      // - track: selected -> primary, unselected -> surfaceContainerHighest
      // - thumb (selected): onPrimary (normal), primaryContainer (pressed/hovered/focused)
      // - thumb (unselected): outline (normal), onSurfaceVariant (pressed/hovered/focused)
      // - outline: outline (unselected), transparent (selected) handled in renderer
      activeTrackColor = scheme.primary;
      inactiveTrackColor = scheme.surfaceContainerHighest;
      activeThumbColor = isInteraction ? scheme.primaryContainer : scheme.onPrimary;
      inactiveThumbColor = isInteraction ? scheme.onSurfaceVariant : scheme.outline;
      trackOutlineColor = scheme.outline;
    }

    final pressOverlayColor = isSelected
        ? scheme.primary.withValues(alpha: 0.12)
        : scheme.onSurface.withValues(alpha: 0.12);

    // State layer color as WidgetStateProperty.
    // Material 3 overlay opacities:
    // - Pressed: 0.1 (10%)
    // - Focused: 0.1 (10%)
    // - Hovered: 0.08 (8%)
    final stateLayerColor = contractOverrides?.stateLayerColor ??
        WidgetStateProperty.resolveWith((states) {
          final baseColor = isSelected ? scheme.primary : scheme.onSurface;
          if (states.contains(WidgetState.pressed)) {
            return baseColor.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.focused)) {
            return baseColor.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return baseColor.withValues(alpha: 0.08);
          }
          return Colors.transparent;
        });

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
      trackOutlineWidth:
          contractOverrides?.trackOutlineWidth ?? defaultTrackOutlineWidth,
      activeTrackColor:
          contractOverrides?.activeTrackColor ?? activeTrackColor,
      inactiveTrackColor:
          contractOverrides?.inactiveTrackColor ?? inactiveTrackColor,
      thumbSizeUnselected:
          contractOverrides?.thumbSizeUnselected ?? defaultThumbSizeUnselected,
      thumbSizeSelected:
          contractOverrides?.thumbSizeSelected ?? defaultThumbSizeSelected,
      thumbSizePressed:
          contractOverrides?.thumbSizePressed ?? defaultThumbSizePressed,
      thumbSizeTransition:
          contractOverrides?.thumbSizeTransition ?? defaultThumbSizeTransition,
      activeThumbColor:
          contractOverrides?.activeThumbColor ?? activeThumbColor,
      inactiveThumbColor:
          contractOverrides?.inactiveThumbColor ?? inactiveThumbColor,
      thumbPadding: contractOverrides?.thumbPadding ?? defaultThumbPadding,
      disabledOpacity: contractOverrides?.disabledOpacity ?? 1.0,
      pressOverlayColor:
          contractOverrides?.pressOverlayColor ?? pressOverlayColor,
      pressOpacity: contractOverrides?.pressOpacity ?? 1.0,
      minTapTargetSize: minTapTargetSize,
      stateLayerRadius:
          contractOverrides?.stateLayerRadius ?? defaultStateLayerRadius,
      stateLayerColor: stateLayerColor,
      thumbIcon: contractOverrides?.thumbIcon,
      motion: contractOverrides?.motion ??
          RSwitchMotionTokens(
            stateChangeDuration: motionTheme.button.stateChangeDuration,
            thumbSlideDuration: const Duration(milliseconds: 150),
            thumbToggleDuration: defaultThumbToggleDuration,
          ),
    );
  }

  Size _resolveMinTapTargetSize({
    required BoxConstraints? constraints,
    required Size? override,
  }) {
    const fallback = Size(48, 48);
    final base = override ?? fallback;
    if (constraints == null) return base;
    return Size(
      constraints.minWidth > 0 ? constraints.minWidth : base.width,
      constraints.minHeight > 0 ? constraints.minHeight : base.height,
    );
  }
}
