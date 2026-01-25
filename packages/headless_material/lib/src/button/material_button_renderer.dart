import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import 'package:headless_material/primitives.dart';
import 'material_button_token_resolver.dart';
/// Material 3 renderer for Button components.
///
/// Implements [RButtonRenderer] with Material Design 3 visuals.
///
/// CRITICAL INVARIANT (v1 policy):
/// - Renderer NEVER calls `callbacks.onPressed` directly.
/// - Single activation source: the component handles pointer/key events.
/// - Renderer only provides visual representation (shape, colors, ink effects).
///
/// This renderer uses a visual overlay for pressed feedback and keeps
/// activation logic in the component to avoid double-invoke.
///
/// See `docs/V1_DECISIONS.md` → "0.1 Renderer contracts".
class MaterialButtonRenderer implements RButtonRenderer {
  const MaterialButtonRenderer();

  @override
  Widget render(RButtonRenderRequest request) {
    final state = request.state;
    final slots = request.slots;
    final tokens = _resolveTokens(request);
    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.material;

    final backgroundColor = tokens.backgroundColor;
    final foregroundColor = tokens.foregroundColor;
    final borderColor = tokens.borderColor;
    final borderRadius = tokens.borderRadius;
    final padding = tokens.padding;
    final textStyle = tokens.textStyle;
    final minSize = tokens.minSize;
    final disabledOpacity = tokens.disabledOpacity;
    final pressOverlayColor = tokens.pressOverlayColor;
    final motionDuration =
        tokens.motion?.stateChangeDuration ?? motionTheme.button.stateChangeDuration;

    final defaultLeadingIcon = request.leadingIcon;
    final leadingIcon = slots?.leadingIcon != null
        ? slots!.leadingIcon!.build(
            RButtonIconContext(
              spec: request.spec,
              state: state,
              child: defaultLeadingIcon ?? const SizedBox.shrink(),
            ),
            (_) => defaultLeadingIcon ?? const SizedBox.shrink(),
          )
        : defaultLeadingIcon;
    final defaultTrailingIcon = request.trailingIcon;
    final trailingIcon = slots?.trailingIcon != null
        ? slots!.trailingIcon!.build(
            RButtonIconContext(
              spec: request.spec,
              state: state,
              child: defaultTrailingIcon ?? const SizedBox.shrink(),
            ),
            (_) => defaultTrailingIcon ?? const SizedBox.shrink(),
          )
        : defaultTrailingIcon;
    final defaultSpinner = request.spinner;
    final spinner = slots?.spinner != null
        ? slots!.spinner!.build(
            RButtonSpinnerContext(
              spec: request.spec,
              state: state,
              child: defaultSpinner ?? const SizedBox.shrink(),
            ),
            (_) => defaultSpinner ?? const SizedBox.shrink(),
          )
        : defaultSpinner;

    final hasSpinner = spinner != null || slots?.spinner != null;
    final baseContent = request.content;
    final contentRow = hasSpinner
        ? (spinner ?? const SizedBox.shrink())
        : _composeContentRow(
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon,
            child: baseContent,
            foregroundColor: foregroundColor,
          );
    final content = slots?.content != null
        ? slots!.content!.build(
            RButtonContentContext(
              spec: request.spec,
              state: state,
              child: contentRow,
            ),
            (_) => contentRow,
          )
        : contentRow;

    // Build the visual button (no callbacks - single activation source)
    // NOTE: Semantics is handled by the component, not the renderer (Variant B policy).
    // The renderer uses request.semantics for tooltip/label if needed.
    final base = MaterialButtonSurface(
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      border: borderColor != Colors.transparent
          ? Border.all(
              color: borderColor,
              width: 1,
            )
          : null,
      padding: padding,
      animationDuration: motionDuration,
      child: DefaultTextStyle(
        style: textStyle.copyWith(color: foregroundColor),
        child: IconTheme(
          data: IconThemeData(color: foregroundColor),
          child: content,
        ),
      ),
    );
    final surface = slots?.surface != null
        ? slots!.surface!.build(
            RButtonSurfaceContext(
              spec: request.spec,
              state: state,
              child: base,
              resolvedTokens: tokens,
            ),
            (_) => base,
          )
        : base;

    final withEffects = MaterialPressableOverlay(
      borderRadius: borderRadius,
      overlayColor: pressOverlayColor,
      duration: motionDuration,
      isPressed: state.isPressed,
      isEnabled: !state.isDisabled,
      visualEffects: request.visualEffects,
      child: surface,
    );

    Widget button = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minSize.width,
        minHeight: minSize.height,
      ),
      child: withEffects,
    );

    // Apply disabled opacity
    if (state.isDisabled) {
      button = Opacity(
        opacity: disabledOpacity,
        child: button,
      );
    }

    return button;
  }

  RButtonResolvedTokens _resolveTokens(RButtonRenderRequest request) {
    final policy = HeadlessThemeProvider.of(request.context)
        ?.capability<HeadlessRendererPolicy>();
    final requireTokens = policy?.requireResolvedTokens == true;
    final resolved = request.resolvedTokens;
    if (requireTokens && resolved == null) {
      throw StateError(
        '[Headless] MaterialButtonRenderer требует resolvedTokens.\n'
        'Как исправить:\n'
        '- Используй preset: HeadlessMaterialApp(...)\n'
        '- Или предоставь RButtonTokenResolver в HeadlessTheme\n'
        '- Или отключи strict: HeadlessMaterialApp(requireResolvedTokens: false, ...)',
      );
    }
    assert(
      !requireTokens || resolved != null,
      'MaterialButtonRenderer requires resolvedTokens when '
      'HeadlessRendererPolicy.requireResolvedTokens is enabled.',
    );
    if (resolved != null) return resolved;

    return const MaterialButtonTokenResolver().resolve(
      context: request.context,
      spec: request.spec,
      states: request.state.toWidgetStates(),
      constraints: request.constraints,
      overrides: request.overrides,
    );
  }
}

Widget _composeContentRow({
  required Widget child,
  required Color foregroundColor,
  Widget? leadingIcon,
  Widget? trailingIcon,
}) {
  if (leadingIcon == null && trailingIcon == null) {
    return child;
  }
  final children = <Widget>[];
  if (leadingIcon != null) {
    children.add(
      IconTheme(
        data: IconThemeData(color: foregroundColor, size: 18),
        child: leadingIcon,
      ),
    );
  }
  children.add(child);
  if (trailingIcon != null) {
    children.add(
      IconTheme(
        data: IconThemeData(color: foregroundColor, size: 18),
        child: trailingIcon,
      ),
    );
  }
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: children
        .expand(
          (widget) => [
            widget,
            if (widget != children.last) const SizedBox(width: 8),
          ],
        )
        .toList(),
  );
}
