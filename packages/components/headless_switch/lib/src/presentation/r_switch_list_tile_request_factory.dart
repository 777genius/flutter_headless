import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

import '_debug_utils.dart';
import 'logic/switch_drag_decider.dart';
import 'r_switch_list_tile_style.dart';

final class ResolvedSwitchListTileRenderData {
  const ResolvedSwitchListTileRenderData({
    required this.spec,
    required this.state,
    required this.switchSpec,
    required this.switchState,
    required this.overrides,
    required this.resolvedTokens,
    required this.constraints,
    required this.travelPx,
  });

  final RSwitchListTileSpec spec;
  final RSwitchListTileState state;
  final RSwitchSpec switchSpec;
  final RSwitchState switchState;
  final RenderOverrides? overrides;
  final RSwitchListTileResolvedTokens? resolvedTokens;
  final BoxConstraints constraints;
  final double travelPx;
}

ResolvedSwitchListTileRenderData resolveSwitchListTileRenderData({
  required BuildContext context,
  required bool value,
  required bool isDisabled,
  required Widget? subtitle,
  required RSwitchControlAffinity controlAffinity,
  required bool dense,
  required bool isThreeLine,
  required bool selected,
  required Color? selectedColor,
  required EdgeInsetsGeometry? contentPadding,
  required String? semanticLabel,
  required RSwitchListTileStyle? style,
  required RenderOverrides? overrides,
  required bool isPressed,
  required bool isHovered,
  required bool isFocused,
  required bool switchHovered,
  required bool switchPressed,
  required double? dragT,
  required bool? dragVisualValue,
}) {
  final trackedOverrides = trackSwitchOverrides(
    mergeStyleIntoOverrides(
      style: style,
      overrides: overrides,
      toOverride: (s) => s.toOverrides(),
    ),
  );
  final spec = RSwitchListTileSpec(
    value: value,
    semanticLabel: semanticLabel,
    selected: selected,
    selectedColor: selectedColor,
    contentPadding: contentPadding,
    controlAffinity: controlAffinity,
    isThreeLine: isThreeLine,
    dense: dense,
    hasSubtitle: subtitle != null,
  );
  final state = RSwitchListTileState(
    isPressed: isPressed,
    isHovered: isHovered,
    isFocused: isFocused,
    isDisabled: isDisabled,
    isSelected: spec.selected,
  );
  final baseConstraints = BoxConstraints(
    minHeight: WcagConstants.kMinTouchTargetSize.height,
  );

  final theme = HeadlessThemeProvider.themeOf(context);
  final tokenResolver = theme.capability<RSwitchListTileTokenResolver>();
  final resolvedTokens = tokenResolver?.resolve(
    context: context,
    spec: spec,
    states: state.toWidgetStates(),
    constraints: baseConstraints,
    overrides: trackedOverrides,
  );
  final constraints = resolvedTokens == null
      ? baseConstraints
      : BoxConstraints(
          minHeight:
              math.max(baseConstraints.minHeight, resolvedTokens.minHeight),
        );

  final switchSpec = RSwitchSpec(
    value: value,
    semanticLabel: semanticLabel,
  );
  final switchState = RSwitchState(
    isFocused: isFocused,
    isHovered: switchHovered,
    isPressed: switchPressed,
    isDisabled: isDisabled,
    isSelected: value,
    dragT: dragT,
    dragVisualValue: dragVisualValue,
  );
  final switchTokenResolver = theme.capability<RSwitchTokenResolver>();
  final switchTokens = switchTokenResolver?.resolve(
    context: context,
    spec: switchSpec,
    states: switchState.toWidgetStates(),
    constraints: BoxConstraints(
      minWidth: WcagConstants.kMinTouchTargetSize.width,
      minHeight: WcagConstants.kMinTouchTargetSize.height,
    ),
    overrides: trackedOverrides,
  );

  return ResolvedSwitchListTileRenderData(
    spec: spec,
    state: state,
    switchSpec: switchSpec,
    switchState: switchState,
    overrides: trackedOverrides,
    resolvedTokens: resolvedTokens,
    constraints: constraints,
    travelPx: switchTokens == null
        ? 0
        : computeTravelPx(
            trackWidth: switchTokens.trackSize.width,
            trackHeight: switchTokens.trackSize.height,
          ),
  );
}
