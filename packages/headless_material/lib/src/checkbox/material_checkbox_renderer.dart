import 'package:flutter/material.dart';
import 'package:headless_contracts/renderers.dart';
import 'package:headless_theme/headless_theme.dart';

import 'package:headless_material/primitives.dart';
import 'material_checkbox_token_resolver.dart';

/// Material 3 renderer for Checkbox components.
///
/// Implements [RCheckboxRenderer] with Material Design 3 visuals.
///
/// CRITICAL INVARIANT (v1 policy):
/// - Renderer NEVER calls user callbacks directly.
/// - Activation logic lives in the component (HeadlessPressableRegion).
class MaterialCheckboxRenderer implements RCheckboxRenderer {
  const MaterialCheckboxRenderer();

  @override
  Widget render(RCheckboxRenderRequest request) {
    final state = request.state;
    final spec = request.spec;
    final slots = request.slots;
    final tokens = _resolveTokens(request);
    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.material;

    final animationDuration = tokens.motion?.stateChangeDuration ??
        motionTheme.button.stateChangeDuration;

    final isChecked = spec.value == true;
    final isIndeterminate = spec.isIndeterminate;
    final showMark = isChecked || isIndeterminate;

    final fillColor = showMark ? tokens.activeColor : tokens.inactiveColor;
    final borderColor = showMark ? tokens.activeColor : tokens.borderColor;

    final defaultMark = isIndeterminate
        ? _IndeterminateMark(
            color: tokens.indeterminateColor,
            size: tokens.boxSize,
          )
        : Icon(
            Icons.check,
            size: tokens.boxSize * 0.85,
            color: tokens.checkColor,
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
      width: tokens.boxSize,
      height: tokens.boxSize,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: tokens.borderRadius,
        border: Border.all(
          color: borderColor,
          width: tokens.borderWidth,
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
        minWidth: request.constraints?.minWidth ?? tokens.minTapTargetSize.width,
        minHeight: request.constraints?.minHeight ?? tokens.minTapTargetSize.height,
      ),
      child: Center(child: box),
    );

    final defaultOverlay = MaterialPressableOverlay(
      borderRadius: BorderRadius.circular(999),
      overlayColor: tokens.pressOverlayColor,
      duration: animationDuration,
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
        opacity: tokens.disabledOpacity,
        child: result,
      );
    }

    return result;
  }

  RCheckboxResolvedTokens _resolveTokens(RCheckboxRenderRequest request) {
    final policy = HeadlessThemeProvider.of(request.context)
        ?.capability<HeadlessRendererPolicy>();
    final requireTokens = policy?.requireResolvedTokens == true;
    final resolved = request.resolvedTokens;
    if (requireTokens && resolved == null) {
      throw StateError(
        '[Headless] MaterialCheckboxRenderer требует resolvedTokens.\n'
        'Как исправить:\n'
        '- Используй preset: HeadlessMaterialApp(...)\n'
        '- Или предоставь RCheckboxTokenResolver в HeadlessTheme\n'
        '- Или отключи strict: HeadlessMaterialApp(requireResolvedTokens: false, ...)',
      );
    }
    assert(
      !requireTokens || resolved != null,
      'MaterialCheckboxRenderer requires resolvedTokens when '
      'HeadlessRendererPolicy.requireResolvedTokens is enabled.',
    );
    if (resolved != null) return resolved;

    return const MaterialCheckboxTokenResolver().resolve(
      context: request.context,
      spec: request.spec,
      states: request.state.toWidgetStates(),
      constraints: request.constraints,
      overrides: request.overrides,
    );
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

