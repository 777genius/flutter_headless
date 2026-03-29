import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

import '_debug_utils.dart';
import 'logic/switch_drag_decider.dart';
import 'r_switch_style.dart';

final class ResolvedSwitchRenderData {
  const ResolvedSwitchRenderData({
    required this.request,
    required this.overrides,
    required this.travelPx,
  });

  final RSwitchRenderRequest request;
  final RenderOverrides? overrides;
  final double travelPx;
}

RenderOverrides? mergeSwitchStyleIntoOverrides({
  required RenderOverrides? overrides,
  required RSwitchStyle? style,
  required WidgetStateProperty<Icon?>? thumbIcon,
}) {
  return mergeOverridesWithFallbacks(
    base: overrides,
    fallbacks: [
      if (style != null) RenderOverrides.only(style.toOverrides()),
      if (thumbIcon != null)
        RenderOverrides.only(RSwitchOverrides.tokens(thumbIcon: thumbIcon)),
    ],
  );
}

RSwitchSpec createSwitchSpec({
  required bool value,
  required String? semanticLabel,
  required DragStartBehavior dragStartBehavior,
}) {
  return RSwitchSpec(
    value: value,
    semanticLabel: semanticLabel,
    dragStartBehavior: dragStartBehavior,
  );
}

RSwitchState createSwitchState({
  required bool isPressed,
  required bool isHovered,
  required bool isFocused,
  required bool isDisabled,
  required bool value,
  required double? dragT,
  required bool? dragVisualValue,
}) {
  return RSwitchState(
    isPressed: isPressed,
    isHovered: isHovered,
    isFocused: isFocused,
    isDisabled: isDisabled,
    isSelected: value,
    dragT: dragT,
    dragVisualValue: dragVisualValue,
  );
}

BoxConstraints createSwitchBaseConstraints() {
  return BoxConstraints(
    minWidth: WcagConstants.kMinTouchTargetSize.width,
    minHeight: WcagConstants.kMinTouchTargetSize.height,
  );
}

BoxConstraints resolveSwitchConstraints(
  BoxConstraints base,
  RSwitchResolvedTokens? tokens,
) {
  if (tokens == null) return base;
  return BoxConstraints(
    minWidth: math.max(base.minWidth, tokens.minTapTargetSize.width),
    minHeight: math.max(base.minHeight, tokens.minTapTargetSize.height),
  );
}

ResolvedSwitchRenderData resolveSwitchRenderData({
  required BuildContext context,
  required bool value,
  required bool isDisabled,
  required String? semanticLabel,
  required DragStartBehavior dragStartBehavior,
  required RSwitchStyle? style,
  required RenderOverrides? overrides,
  required WidgetStateProperty<Icon?>? thumbIcon,
  required RSwitchSlots? slots,
  required HeadlessPressableVisualEffectsController visualEffects,
  required bool isPressed,
  required bool isHovered,
  required bool isFocused,
  required double? dragT,
  required bool? dragVisualValue,
}) {
  final theme = HeadlessThemeProvider.themeOf(context);
  final tokenResolver = theme.capability<RSwitchTokenResolver>();
  final mergedOverrides = mergeSwitchStyleIntoOverrides(
    overrides: overrides,
    style: style,
    thumbIcon: thumbIcon,
  );
  final trackedOverrides = trackSwitchOverrides(mergedOverrides);
  final spec = createSwitchSpec(
    value: value,
    semanticLabel: semanticLabel,
    dragStartBehavior: dragStartBehavior,
  );
  final state = createSwitchState(
    isPressed: isPressed,
    isHovered: isHovered,
    isFocused: isFocused,
    isDisabled: isDisabled,
    value: value,
    dragT: dragT,
    dragVisualValue: dragVisualValue,
  );
  final baseConstraints = createSwitchBaseConstraints();
  final resolvedTokens = tokenResolver?.resolve(
    context: context,
    spec: spec,
    states: state.toWidgetStates(),
    constraints: baseConstraints,
    overrides: trackedOverrides,
  );
  final constraints = resolveSwitchConstraints(baseConstraints, resolvedTokens);

  return ResolvedSwitchRenderData(
    request: RSwitchRenderRequest(
      context: context,
      spec: spec,
      state: state,
      semantics: RSwitchSemantics(
        label: semanticLabel,
        isEnabled: !isDisabled,
        value: value,
      ),
      slots: slots,
      visualEffects: visualEffects,
      resolvedTokens: resolvedTokens,
      constraints: constraints,
      overrides: trackedOverrides,
    ),
    overrides: trackedOverrides,
    travelPx: resolvedTokens == null
        ? 0
        : computeTravelPx(
            trackWidth: resolvedTokens.trackSize.width,
            trackHeight: resolvedTokens.trackSize.height,
          ),
  );
}
