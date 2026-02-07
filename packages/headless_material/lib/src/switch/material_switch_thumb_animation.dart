import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

Size resolveMaterialSwitchUnselectedThumbSize({
  required RSwitchResolvedTokens tokens,
  required bool hasIcon,
}) {
  return hasIcon ? tokens.thumbSizeSelected : tokens.thumbSizeUnselected;
}

TweenSequence<Size> buildMaterialSwitchToggleThumbSizeSequence({
  required RSwitchResolvedTokens tokens,
  required bool hasIcon,
  required bool toSelected,
}) {
  final inactive = resolveMaterialSwitchUnselectedThumbSize(
    tokens: tokens,
    hasIcon: hasIcon,
  );
  final active = tokens.thumbSizeSelected;
  final transitional = tokens.thumbSizeTransition;

  const curveA = Cubic(0.31, 0.00, 0.56, 1.00);
  const curveB = Cubic(0.20, 0.00, 0.00, 1.00);

  if (toSelected) {
    return TweenSequence<Size>([
      TweenSequenceItem<Size>(
        tween: Tween(begin: inactive, end: transitional)
            .chain(CurveTween(curve: curveA)),
        weight: 11,
      ),
      TweenSequenceItem<Size>(
        tween: Tween(begin: transitional, end: active)
            .chain(CurveTween(curve: curveB)),
        weight: 72,
      ),
      TweenSequenceItem<Size>(
        tween: ConstantTween<Size>(active),
        weight: 17,
      ),
    ]);
  }

  return TweenSequence<Size>([
    TweenSequenceItem<Size>(
      tween: ConstantTween<Size>(inactive),
      weight: 17,
    ),
    TweenSequenceItem<Size>(
      tween: Tween(begin: inactive, end: transitional)
          .chain(CurveTween(curve: curveB.flipped)),
      weight: 72,
    ),
    TweenSequenceItem<Size>(
      tween: Tween(begin: transitional, end: active)
          .chain(CurveTween(curve: curveA.flipped)),
      weight: 11,
    ),
  ]);
}

double resolveMaterialSwitchPositionValue({
  required bool isDragging,
  required double? dragT,
  required bool visualValue,
  required bool isToggleAnimating,
  required double toggleControllerValue,
  required bool toggleToSelected,
}) {
  if (isDragging && dragT != null) return dragT.clamp(0.0, 1.0);

  if (isToggleAnimating) {
    final t = toggleControllerValue;
    return toggleToSelected ? t : (1 - t);
  }

  return visualValue ? 1.0 : 0.0;
}

Size resolveMaterialSwitchBaseThumbSize({
  required RSwitchResolvedTokens tokens,
  required bool hasIcon,
  required bool isDragging,
  required double? dragT,
  required bool visualValue,
  required bool isToggleAnimating,
  required bool toggleToSelected,
  required double positionValue,
}) {
  if (isDragging && dragT != null) {
    return Size.lerp(
      resolveMaterialSwitchUnselectedThumbSize(
          tokens: tokens, hasIcon: hasIcon),
      tokens.thumbSizeSelected,
      positionValue,
    )!;
  }

  if (isToggleAnimating) {
    final seq = buildMaterialSwitchToggleThumbSizeSequence(
      tokens: tokens,
      hasIcon: hasIcon,
      toSelected: toggleToSelected,
    );
    return seq.transform(positionValue);
  }

  return visualValue
      ? tokens.thumbSizeSelected
      : resolveMaterialSwitchUnselectedThumbSize(
          tokens: tokens, hasIcon: hasIcon);
}
