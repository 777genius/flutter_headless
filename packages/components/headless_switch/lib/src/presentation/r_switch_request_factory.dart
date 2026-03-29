import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'r_switch_style.dart';

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
