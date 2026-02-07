import 'package:flutter/material.dart';
import 'package:headless_contracts/renderers.dart';
import 'package:headless_theme/headless_theme.dart';
import 'dart:math' as math;

import 'material_switch_token_resolver.dart';
import 'material_switch_track_and_thumb.dart';

/// Material 3 renderer for Switch components.
///
/// Invariants:
/// - Renderer never calls user callbacks directly.
/// - Interaction/gestures live in the component (HeadlessPressableRegion).
///
/// Supports drag interpolation via [RSwitchState.dragT].
class MaterialSwitchRenderer implements RSwitchRenderer {
  const MaterialSwitchRenderer();

  @override
  Widget render(RSwitchRenderRequest request) {
    final state = request.state;
    final spec = request.spec;
    final tokens = _resolveTokens(request);

    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.material;

    final animationDuration = tokens.motion?.stateChangeDuration ??
        motionTheme.button.stateChangeDuration;
    final thumbToggleDuration =
        tokens.motion?.thumbToggleDuration ?? animationDuration;

    final isDragging = state.isDragging;
    final dragT = state.dragT;
    final isOn = spec.value;
    final isRtl = Directionality.of(request.context) == TextDirection.rtl;

    final Color trackColor;
    final Color thumbColor;
    final Color outlineColor;
    final double outlineWidth;

    if (isDragging && dragT != null) {
      trackColor = Color.lerp(
        tokens.inactiveTrackColor,
        tokens.activeTrackColor,
        dragT,
      )!;
      thumbColor = Color.lerp(
        tokens.inactiveThumbColor,
        tokens.activeThumbColor,
        dragT,
      )!;
      outlineColor = Color.lerp(
        tokens.trackOutlineColor,
        Colors.transparent,
        dragT,
      )!;
      outlineWidth = tokens.trackOutlineWidth * (1 - dragT);
    } else {
      trackColor = isOn ? tokens.activeTrackColor : tokens.inactiveTrackColor;
      thumbColor = isOn ? tokens.activeThumbColor : tokens.inactiveThumbColor;
      outlineColor = isOn ? Colors.transparent : tokens.trackOutlineColor;
      outlineWidth = isOn ? 0.0 : tokens.trackOutlineWidth;
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
    final thumbIcon = tokens.thumbIcon?.resolve(statesForIcon);
    final hasIcon = thumbIcon != null;

    final thumbIconColor =
        visualValue ? tokens.activeTrackColor : tokens.inactiveTrackColor;

    final stateLayerStates = state.toWidgetStates();
    final stateLayerColor = tokens.stateLayerColor.resolve(stateLayerStates);
    final showStateLayer =
        state.isPressed || state.isHovered || state.isFocused || isDragging;

    Widget result = MaterialSwitchTrackAndThumb(
      tokens: tokens,
      trackColor: trackColor,
      outlineColor: outlineColor,
      outlineWidth: outlineWidth,
      thumbColor: thumbColor,
      thumbIcon: thumbIcon,
      thumbIconColor: thumbIconColor,
      hasIcon: hasIcon,
      isDragging: isDragging,
      isPressed: state.isPressed,
      isRtl: isRtl,
      visualValue: visualValue,
      dragT: state.dragT,
      animationDuration: animationDuration,
      thumbToggleDuration: thumbToggleDuration,
      stateLayerColor: stateLayerColor,
      showStateLayer: showStateLayer,
      slots: request.slots,
      spec: spec,
      state: state,
    );

    final minWidth = request.constraints?.minWidth ?? 0;
    final minHeight = request.constraints?.minHeight ?? 0;
    final desiredWidth =
        math.max(tokens.trackSize.width, tokens.minTapTargetSize.width);
    final desiredHeight =
        math.max(tokens.trackSize.height, tokens.minTapTargetSize.height);
    result = SizedBox(
      width: math.max(desiredWidth, minWidth),
      height: math.max(desiredHeight, minHeight),
      child: Center(child: result),
    );

    if (state.isDisabled && tokens.disabledOpacity < 1) {
      result = Opacity(
        opacity: tokens.disabledOpacity,
        child: result,
      );
    }

    return result;
  }

  RSwitchResolvedTokens _resolveTokens(RSwitchRenderRequest request) {
    final policy = HeadlessThemeProvider.of(request.context)
        ?.capability<HeadlessRendererPolicy>();
    final requireTokens = policy?.requireResolvedTokens == true;
    final resolved = request.resolvedTokens;
    if (requireTokens && resolved == null) {
      throw StateError(
        '[Headless] MaterialSwitchRenderer requires resolvedTokens.\n'
        'Fix:\n'
        '- Use preset: HeadlessMaterialApp(...)\n'
        '- Or provide RSwitchTokenResolver in HeadlessTheme\n'
        '- Or disable strict: HeadlessMaterialApp(requireResolvedTokens: false, ...)',
      );
    }
    assert(
      !requireTokens || resolved != null,
      'MaterialSwitchRenderer requires resolvedTokens when '
      'HeadlessRendererPolicy.requireResolvedTokens is enabled.',
    );
    if (resolved != null) return resolved;

    return const MaterialSwitchTokenResolver().resolve(
      context: request.context,
      spec: request.spec,
      states: request.state.toWidgetStates(),
      constraints: request.constraints,
      overrides: request.overrides,
    );
  }
}
