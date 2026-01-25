import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/renderers.dart';
import 'package:headless_theme/headless_theme.dart';

import '../primitives/cupertino_pressable_opacity.dart';

/// Cupertino renderer for Checkbox components.
///
/// Implements [RCheckboxRenderer] with Cupertino styling.
///
/// CRITICAL INVARIANT (v1 policy):
/// - Renderer NEVER calls user callbacks directly.
/// - Activation logic lives in the component (HeadlessPressableRegion).
class CupertinoCheckboxRenderer implements RCheckboxRenderer {
  const CupertinoCheckboxRenderer();

  @override
  Widget render(RCheckboxRenderRequest request) {
    final tokens = request.resolvedTokens;
    final state = request.state;
    final spec = request.spec;
    final slots = request.slots;
    final policy =
        HeadlessThemeProvider.of(request.context)?.capability<HeadlessRendererPolicy>();
    assert(
      policy?.requireResolvedTokens != true || tokens != null,
      'CupertinoCheckboxRenderer requires resolvedTokens when '
      'HeadlessRendererPolicy.requireResolvedTokens is enabled.',
    );
    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.cupertino;

    final effectiveTokens = tokens ??
        RCheckboxResolvedTokens(
          boxSize: 18,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderWidth: 2,
          borderColor: CupertinoColors.activeBlue,
          activeColor: CupertinoColors.activeBlue,
          inactiveColor: CupertinoColors.transparent,
          checkColor: CupertinoColors.white,
          indeterminateColor: CupertinoColors.white,
          disabledOpacity: 0.6,
          pressOverlayColor: CupertinoColors.activeBlue.withValues(alpha: 0.12),
          pressOpacity: 0.4,
          minTapTargetSize: const Size(44, 44),
          motion: RCheckboxMotionTokens(
            stateChangeDuration: motionTheme.button.stateChangeDuration,
          ),
        );

    final animationDuration = effectiveTokens.motion?.stateChangeDuration ??
        motionTheme.button.stateChangeDuration;

    final isChecked = spec.value == true;
    final isIndeterminate = spec.isIndeterminate;
    final showMark = isChecked || isIndeterminate;

    final fillColor = showMark ? effectiveTokens.activeColor : effectiveTokens.inactiveColor;
    final borderColor = showMark ? effectiveTokens.activeColor : effectiveTokens.borderColor;

    final defaultMark = isIndeterminate
        ? _IndeterminateMark(
            color: effectiveTokens.indeterminateColor,
            size: effectiveTokens.boxSize,
          )
        : Icon(
            CupertinoIcons.checkmark,
            size: effectiveTokens.boxSize * 0.8,
            color: effectiveTokens.checkColor,
          );
    final mark = slots?.mark != null
        ? slots!.mark!.build(
            RCheckboxMarkContext(
              spec: spec,
              state: state,
              child: defaultMark,
            ),
            (_) => defaultMark,
          )
        : defaultMark;

    final defaultBox = AnimatedContainer(
      duration: animationDuration,
      width: effectiveTokens.boxSize,
      height: effectiveTokens.boxSize,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: effectiveTokens.borderRadius,
        border: Border.all(
          color: borderColor,
          width: effectiveTokens.borderWidth,
        ),
      ),
      child: AnimatedSwitcher(
        duration: animationDuration,
        child: showMark ? Center(child: mark) : const SizedBox.shrink(),
      ),
    );
    final box = slots?.box != null
        ? slots!.box!.build(
            RCheckboxBoxContext(
              spec: spec,
              state: state,
              child: defaultBox,
            ),
            (_) => defaultBox,
          )
        : defaultBox;

    Widget result = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: request.constraints?.minWidth ?? effectiveTokens.minTapTargetSize.width,
        minHeight: request.constraints?.minHeight ?? effectiveTokens.minTapTargetSize.height,
      ),
      child: Center(child: box),
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
            RCheckboxPressOverlayContext(
              spec: spec,
              state: state,
              child: defaultOverlay,
            ),
            (_) => defaultOverlay,
          )
        : defaultOverlay;

    if (state.isDisabled) {
      result = Opacity(
        opacity: effectiveTokens.disabledOpacity,
        child: result,
      );
    }

    return result;
  }
}

class _IndeterminateMark extends StatelessWidget {
  const _IndeterminateMark({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final width = size * 0.6;
    return SizedBox(
      width: width,
      height: 2,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}

