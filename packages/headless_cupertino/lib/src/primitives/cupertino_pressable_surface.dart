import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

/// Cupertino implementation of [HeadlessPressableSurfaceFactory].
///
/// Uses opacity feedback for pressed state (iOS-style).
/// Does not use Ink ripple effects.
class CupertinoPressableSurface implements HeadlessPressableSurfaceFactory {
  const CupertinoPressableSurface({
    this.pressedOpacity = 0.4,
    this.duration = const Duration(milliseconds: 100),
  });

  /// Opacity when pressed.
  final double pressedOpacity;

  /// Animation duration for opacity change.
  final Duration duration;

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
    return _CupertinoPressableSurfaceWidget(
      controller: controller,
      enabled: enabled,
      onActivate: onActivate,
      pressedOpacity: pressedOpacity,
      duration: duration,
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

class _CupertinoPressableSurfaceWidget extends StatefulWidget {
  const _CupertinoPressableSurfaceWidget({
    required this.controller,
    required this.enabled,
    required this.onActivate,
    required this.pressedOpacity,
    required this.duration,
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
  final double pressedOpacity;
  final Duration duration;
  final Widget child;
  final RenderOverrides? overrides;
  final HeadlessPressableVisualEffectsController? visualEffects;
  final FocusNode? focusNode;
  final bool autofocus;
  final MouseCursor? cursorWhenEnabled;
  final MouseCursor? cursorWhenDisabled;

  @override
  State<_CupertinoPressableSurfaceWidget> createState() =>
      _CupertinoPressableSurfaceWidgetState();
}

class _CupertinoPressableSurfaceWidgetState
    extends State<_CupertinoPressableSurfaceWidget> {
  late final HeadlessFocusNodeOwner _focusNodeOwner;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _focusNodeOwner = HeadlessFocusNodeOwner(
      external: widget.focusNode,
      debugLabel: 'CupertinoPressableSurface',
    );
  }

  @override
  void didUpdateWidget(covariant _CupertinoPressableSurfaceWidget oldWidget) {
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

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled) return;
    setState(() => _isPressed = true);
    widget.controller.handleTapDown();
    widget.visualEffects?.pointerDown(
      localPosition: details.localPosition,
      globalPosition: details.globalPosition,
    );
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled) return;
    setState(() => _isPressed = false);
    widget.controller.handleTapUp(onActivate: widget.onActivate);
    widget.visualEffects?.pointerUp(
      localPosition: details.localPosition,
      globalPosition: details.globalPosition,
    );
  }

  void _handleTapCancel() {
    if (!widget.enabled) return;
    setState(() => _isPressed = false);
    widget.controller.handleTapCancel();
    widget.visualEffects?.pointerCancel();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveCursorEnabled =
        widget.cursorWhenEnabled ?? SystemMouseCursors.click;
    final effectiveCursorDisabled =
        widget.cursorWhenDisabled ?? SystemMouseCursors.forbidden;

    return Focus(
      focusNode: _focusNodeOwner.node,
      autofocus: widget.autofocus,
      canRequestFocus: widget.enabled,
      skipTraversal: !widget.enabled,
      onFocusChange: (focused) {
        widget.controller.handleFocusChange(focused);
        widget.visualEffects?.focusChanged(focused);
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
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: AnimatedOpacity(
            duration: widget.duration,
            opacity: widget.enabled && _isPressed ? widget.pressedOpacity : 1.0,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
