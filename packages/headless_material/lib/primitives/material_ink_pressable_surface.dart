import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

/// Material implementation of [HeadlessPressableSurfaceFactory].
///
/// Uses `Material` + `InkResponse` for ripple effects.
/// Reads splash factory and colors from [Theme] and [ListTileTheme].
class MaterialInkPressableSurface implements HeadlessPressableSurfaceFactory {
  const MaterialInkPressableSurface();

  @override
  Widget wrap({
    required BuildContext context,
    required HeadlessPressableController controller,
    required bool enabled,
    required VoidCallback onActivate,
    required Widget child,
    RenderOverrides? overrides,
    HeadlessPressableVisualEffectsController? visualEffects,
    FocusNode? focusNode,
    bool autofocus = false,
    MouseCursor? cursorWhenEnabled,
    MouseCursor? cursorWhenDisabled,
  }) {
    return _MaterialInkPressableSurfaceWidget(
      controller: controller,
      enabled: enabled,
      onActivate: onActivate,
      overrides: overrides,
      visualEffects: visualEffects,
      focusNode: focusNode,
      autofocus: autofocus,
      cursorWhenEnabled: cursorWhenEnabled,
      cursorWhenDisabled: cursorWhenDisabled,
      child: child,
    );
  }
}

class _MaterialInkPressableSurfaceWidget extends StatefulWidget {
  const _MaterialInkPressableSurfaceWidget({
    required this.controller,
    required this.enabled,
    required this.onActivate,
    required this.child,
    this.overrides,
    this.visualEffects,
    this.focusNode,
    this.autofocus = false,
    this.cursorWhenEnabled,
    this.cursorWhenDisabled,
  });

  final HeadlessPressableController controller;
  final bool enabled;
  final VoidCallback onActivate;
  final Widget child;
  final RenderOverrides? overrides;
  final HeadlessPressableVisualEffectsController? visualEffects;
  final FocusNode? focusNode;
  final bool autofocus;
  final MouseCursor? cursorWhenEnabled;
  final MouseCursor? cursorWhenDisabled;

  @override
  State<_MaterialInkPressableSurfaceWidget> createState() =>
      _MaterialInkPressableSurfaceWidgetState();
}

class _MaterialInkPressableSurfaceWidgetState
    extends State<_MaterialInkPressableSurfaceWidget> {
  late final HeadlessFocusNodeOwner _focusNodeOwner;

  @override
  void initState() {
    super.initState();
    _focusNodeOwner = HeadlessFocusNodeOwner(
      external: widget.focusNode,
      debugLabel: 'MaterialInkPressableSurface',
    );
  }

  @override
  void didUpdateWidget(covariant _MaterialInkPressableSurfaceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNodeOwner.update(widget.focusNode);
    }
  }

  @override
  void dispose() {
    _focusNodeOwner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listTileTheme = ListTileTheme.of(context);

    final switchListTileOverrides =
        widget.overrides?.get<RSwitchListTileOverrides>();

    final overlayColorProperty = switchListTileOverrides?.overlayColor;
    final defaultOverlayColor = WidgetStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(WidgetState.pressed)) {
          return (listTileTheme.selectedColor?.withValues(alpha: 0.12) ??
              theme.colorScheme.primary.withValues(alpha: 0.12));
        }
        if (states.contains(WidgetState.hovered)) {
          return theme.hoverColor;
        }
        if (states.contains(WidgetState.focused)) {
          return theme.focusColor;
        }
        return null;
      },
    );
    final effectiveOverlayColor = overlayColorProperty ?? defaultOverlayColor;

    final fallbackSplashColor =
        listTileTheme.selectedColor?.withValues(alpha: 0.12) ??
            theme.colorScheme.primary.withValues(alpha: 0.12);
    final fallbackHighlightColor = theme.highlightColor;

    final splashColor = effectiveOverlayColor.resolve({WidgetState.pressed}) ??
        fallbackSplashColor;
    final highlightColor =
        effectiveOverlayColor.resolve({WidgetState.hovered}) ??
            fallbackHighlightColor;
    final focusColor = effectiveOverlayColor.resolve({WidgetState.focused}) ??
        theme.focusColor;
    final hoverColor = effectiveOverlayColor.resolve({WidgetState.hovered}) ??
        theme.hoverColor;

    BorderRadius? borderRadius;
    final rippleShape = switchListTileOverrides?.rippleShape;
    if (rippleShape is RoundedRectangleBorder) {
      final borderRadiusGeometry = rippleShape.borderRadius;
      if (borderRadiusGeometry is BorderRadius) {
        borderRadius = borderRadiusGeometry;
      }
    }
    borderRadius ??= BorderRadius.circular(12);

    final effectiveCursorEnabled =
        widget.cursorWhenEnabled ?? SystemMouseCursors.click;
    final effectiveCursorDisabled =
        widget.cursorWhenDisabled ?? SystemMouseCursors.forbidden;

    return Material(
      type: MaterialType.transparency,
      child: InkResponse(
        onTap: widget.enabled ? widget.onActivate : null,
        focusNode: _focusNodeOwner.node,
        autofocus: widget.autofocus,
        canRequestFocus: widget.enabled,
        splashColor: splashColor,
        highlightColor: highlightColor,
        overlayColor: effectiveOverlayColor,
        focusColor: focusColor,
        hoverColor: hoverColor,
        splashFactory: theme.splashFactory,
        radius: switchListTileOverrides?.splashRadius,
        mouseCursor:
            widget.enabled ? effectiveCursorEnabled : effectiveCursorDisabled,
        containedInkWell: true,
        highlightShape: BoxShape.rectangle,
        borderRadius: borderRadius,
        onFocusChange: (focused) {
          widget.controller.handleFocusChange(focused);
          widget.visualEffects?.focusChanged(focused);
        },
        onHighlightChanged: (highlighted) {
          if (highlighted) {
            widget.controller.handleTapDown();
            widget.visualEffects?.pointerDown(
              localPosition: Offset.zero,
              globalPosition: Offset.zero,
            );
          } else {
            widget.controller.handleTapCancel();
            widget.visualEffects?.pointerCancel();
          }
        },
        child: MouseRegion(
          onEnter: (_) {
            widget.controller.handleMouseEnter();
            widget.visualEffects?.hoverChanged(true);
          },
          onExit: (_) {
            widget.controller.handleMouseExit();
            widget.visualEffects?.hoverChanged(false);
          },
          cursor:
              widget.enabled ? effectiveCursorEnabled : effectiveCursorDisabled,
          child: widget.child,
        ),
      ),
    );
  }
}
