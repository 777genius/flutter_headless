import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';
import 'dart:math' as math;

import '../primitives/cupertino_pressable_opacity.dart';
import 'cupertino_switch_focus_color.dart';
import 'cupertino_switch_focus_ring.dart';
import 'cupertino_switch_track_and_thumb.dart';

/// Cupertino renderer for Switch components.
///
/// Implements [RSwitchRenderer] with iOS styling.
///
/// CRITICAL INVARIANT (v1 policy):
/// - Renderer NEVER calls user callbacks directly.
/// - Activation logic lives in the component (HeadlessPressableRegion).
///
/// Supports drag interpolation via [RSwitchState.dragT]:
/// - When dragging, thumb position and colors interpolate smoothly
/// - When not dragging, uses animated transitions based on [RSwitchSpec.value]
class CupertinoSwitchRenderer implements RSwitchRenderer {
  const CupertinoSwitchRenderer();

  @override
  Widget render(RSwitchRenderRequest request) {
    final tokens = request.resolvedTokens;
    final state = request.state;
    final spec = request.spec;
    final slots = request.slots;
    final policy = HeadlessThemeProvider.of(request.context)
        ?.capability<HeadlessRendererPolicy>();
    assert(
      policy?.requireResolvedTokens != true || tokens != null,
      'CupertinoSwitchRenderer requires resolvedTokens when '
      'HeadlessRendererPolicy.requireResolvedTokens is enabled.',
    );
    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.cupertino;

    final effectiveTokens = tokens ??
        RSwitchResolvedTokens(
          trackSize: const Size(51, 31),
          trackBorderRadius: const BorderRadius.all(Radius.circular(16)),
          trackOutlineColor: CupertinoColors.systemGrey4,
          trackOutlineWidth: 0,
          activeTrackColor: CupertinoColors.systemGreen,
          inactiveTrackColor: CupertinoColors.systemGrey4,
          thumbSizeUnselected: const Size(28, 28),
          thumbSizeSelected: const Size(28, 28),
          thumbSizePressed: const Size(28, 28),
          thumbSizeTransition: const Size(28, 28),
          activeThumbColor: CupertinoColors.white,
          inactiveThumbColor: CupertinoColors.white,
          thumbPadding: 2.0,
          disabledOpacity: 0.5,
          pressOverlayColor:
              CupertinoColors.systemGreen.withValues(alpha: 0.12),
          pressOpacity: 1.0,
          minTapTargetSize: const Size(59, 39),
          stateLayerRadius: 0.0,
          stateLayerColor: WidgetStateProperty.all(const Color(0x00000000)),
          motion: RSwitchMotionTokens(
            stateChangeDuration: motionTheme.button.stateChangeDuration,
            thumbSlideDuration: const Duration(milliseconds: 200),
          ),
        );

    final animationDuration = effectiveTokens.motion?.stateChangeDuration ??
        motionTheme.button.stateChangeDuration;
    final thumbSlideDuration =
        effectiveTokens.motion?.thumbSlideDuration ?? animationDuration;
    final reactionDuration = const Duration(milliseconds: 300);

    final isDragging = state.isDragging;
    final dragT = state.dragT;
    final isOn = spec.value;
    final isRtl = Directionality.of(request.context) == TextDirection.rtl;

    final Color trackColor;
    final Color thumbColor;
    final double positionT;

    if (isDragging && dragT != null) {
      trackColor = Color.lerp(
        effectiveTokens.inactiveTrackColor,
        effectiveTokens.activeTrackColor,
        dragT,
      )!;
      thumbColor = Color.lerp(
        effectiveTokens.inactiveThumbColor,
        effectiveTokens.activeThumbColor,
        dragT,
      )!;
      positionT = dragT;
    } else {
      trackColor = isOn
          ? effectiveTokens.activeTrackColor
          : effectiveTokens.inactiveTrackColor;
      thumbColor = isOn
          ? effectiveTokens.activeThumbColor
          : effectiveTokens.inactiveThumbColor;
      positionT = isOn ? 1.0 : 0.0;
    }

    final visualValue = state.dragVisualValue ?? spec.value;
    final statesForIcon = state.toWidgetStates();
    if (visualValue != state.isSelected) {
      if (visualValue) {
        statesForIcon.add(WidgetState.selected);
      } else {
        statesForIcon.remove(WidgetState.selected);
      }
    }
    final thumbIcon = effectiveTokens.thumbIcon?.resolve(statesForIcon);

    final thumbIconColor = visualValue
        ? effectiveTokens.activeTrackColor
        : CupertinoColors.systemGrey;

    final track = CupertinoSwitchTrackAndThumb(
      tokens: effectiveTokens,
      trackColor: trackColor,
      thumbColor: thumbColor,
      thumbIcon: thumbIcon,
      thumbIconColor: thumbIconColor,
      hasIcon: thumbIcon != null,
      isDragging: isDragging,
      isPressed: state.isPressed,
      isRtl: isRtl,
      positionT: positionT,
      reactionDuration: reactionDuration,
      thumbSlideDuration: thumbSlideDuration,
      slots: slots,
      spec: spec,
      state: state,
    );

    final focusRing = state.isFocused
        ? CupertinoSwitchFocusRing(
            trackSize: effectiveTokens.trackSize,
            focusColor: resolveCupertinoSwitchFocusColor(
              context: request.context,
              activeColor: effectiveTokens.activeTrackColor,
            ),
            child: track,
          )
        : track;

    final minWidth = request.constraints?.minWidth ?? 0;
    final minHeight = request.constraints?.minHeight ?? 0;
    final desiredWidth = math.max(
      effectiveTokens.trackSize.width,
      effectiveTokens.minTapTargetSize.width,
    );
    final desiredHeight = math.max(
      effectiveTokens.trackSize.height,
      effectiveTokens.minTapTargetSize.height,
    );
    Widget result = SizedBox(
      width: math.max(desiredWidth, minWidth),
      height: math.max(desiredHeight, minHeight),
      child: Center(child: focusRing),
    );

    final defaultOverlay = CupertinoPressableOpacity(
      duration: animationDuration,
      pressedOpacity: effectiveTokens.pressOpacity,
      isPressed: state.isPressed,
      isEnabled: !state.isDisabled,
      visualEffects: request.visualEffects,
      child: result,
    );
    result = slots?.pressOverlay != null
        ? slots!.pressOverlay!.build(
            RSwitchPressOverlayContext(
              spec: spec,
              state: state,
              child: defaultOverlay,
            ),
            (_) => defaultOverlay,
          )
        : defaultOverlay;

    if (state.isDisabled && effectiveTokens.disabledOpacity < 1) {
      result = Opacity(
        opacity: effectiveTokens.disabledOpacity,
        child: result,
      );
    }

    return result;
  }
}
