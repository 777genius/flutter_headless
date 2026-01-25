import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import '../primitives/cupertino_pressable_opacity.dart';
/// Cupertino renderer for Button components.
///
/// Implements [RButtonRenderer] with iOS styling.
///
/// CRITICAL INVARIANT (v1 policy):
/// - Renderer NEVER calls `callbacks.onPressed` directly.
/// - Single activation source: the component handles pointer/key events.
/// - Renderer only provides visual representation.
///
/// See `docs/V1_DECISIONS.md` → "0.1 Renderer contracts".
class CupertinoButtonRenderer implements RButtonRenderer {
  const CupertinoButtonRenderer();

  @override
  Widget render(RButtonRenderRequest request) {
    final tokens = request.resolvedTokens;
    final state = request.state;
    final slots = request.slots;
    final policy = HeadlessThemeProvider.of(request.context)
        ?.capability<HeadlessRendererPolicy>();
    final requireTokens = policy?.requireResolvedTokens == true;
    if (requireTokens && tokens == null) {
      throw StateError(
        '[Headless] CupertinoButtonRenderer требует resolvedTokens.\n'
        'Как исправить:\n'
        '- Используй preset: HeadlessCupertinoApp(...)\n'
        '- Или предоставь RButtonTokenResolver в HeadlessTheme\n'
        '- Или отключи strict: HeadlessCupertinoApp(requireResolvedTokens: false, ...)',
      );
    }
    assert(
      !requireTokens || tokens != null,
      'CupertinoButtonRenderer requires resolvedTokens when '
      'HeadlessRendererPolicy.requireResolvedTokens is enabled.',
    );
    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.cupertino;

    // Get effective values (use tokens if available, otherwise defaults)
    final backgroundColor =
        tokens?.backgroundColor ?? CupertinoColors.transparent;
    final foregroundColor =
        tokens?.foregroundColor ?? CupertinoColors.activeBlue;
    final borderColor = tokens?.borderColor ?? CupertinoColors.transparent;
    final borderRadius =
        tokens?.borderRadius ?? const BorderRadius.all(Radius.circular(8));
    final padding = tokens?.padding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    final textStyle = tokens?.textStyle ??
        const TextStyle(fontSize: 17, fontWeight: FontWeight.w500);
    final minSize = tokens?.minSize ?? const Size(44, 44);
    final disabledOpacity = tokens?.disabledOpacity ?? 0.38;
    final motionDuration =
        tokens?.motion?.stateChangeDuration ?? motionTheme.button.stateChangeDuration;

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

    final pressedOpacity = tokens?.pressOpacity ?? 0.4;

    // Build the visual button (no callbacks - single activation source)
    final base = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minSize.width,
        minHeight: minSize.height,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: borderColor != CupertinoColors.transparent
              ? Border.all(
                  color: borderColor,
                  width: state.isFocused ? 2 : 1,
                )
              : null,
        ),
        child: Padding(
          padding: padding,
          child: DefaultTextStyle(
            style: textStyle.copyWith(color: foregroundColor),
            child: IconTheme(
              data: IconThemeData(color: foregroundColor),
              child: content,
            ),
          ),
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

    Widget button = CupertinoPressableOpacity(
      duration: motionDuration,
      pressedOpacity: pressedOpacity,
      isPressed: state.isPressed,
      isEnabled: !state.isDisabled,
      visualEffects: request.visualEffects,
      child: surface,
    );

    if (state.isDisabled) {
      button = Opacity(
        opacity: disabledOpacity,
        child: button,
      );
    }

    return button;
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
            if (widget != children.last) const SizedBox(width: 6),
          ],
        )
        .toList(),
  );
}
