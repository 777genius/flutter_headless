import 'package:flutter/material.dart';
import 'package:headless_foundation/headless_foundation.dart';

class MaterialPressableOverlay extends StatefulWidget {
  const MaterialPressableOverlay({
    super.key,
    required this.borderRadius,
    required this.overlayColor,
    required this.duration,
    required this.isPressed,
    required this.isEnabled,
    required this.child,
    this.visualEffects,
  });

  final BorderRadius borderRadius;
  final Color overlayColor;
  final Duration duration;
  final bool isPressed;
  final bool isEnabled;
  final Widget child;
  final HeadlessPressableVisualEffectsController? visualEffects;

  @override
  State<MaterialPressableOverlay> createState() =>
      _MaterialPressableOverlayState();
}

class _MaterialPressableOverlayState extends State<MaterialPressableOverlay> {
  bool _pointerActive = false;

  @override
  void initState() {
    super.initState();
    widget.visualEffects?.addListener(_handleVisualEvent);
  }

  @override
  void didUpdateWidget(covariant MaterialPressableOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visualEffects != widget.visualEffects) {
      oldWidget.visualEffects?.removeListener(_handleVisualEvent);
      widget.visualEffects?.addListener(_handleVisualEvent);
    }
  }

  @override
  void dispose() {
    widget.visualEffects?.removeListener(_handleVisualEvent);
    super.dispose();
  }

  void _handleVisualEvent() {
    final event = widget.visualEffects?.lastEvent;
    if (event is HeadlessPressableVisualPointerDown) {
      _setPointerActive(true);
      return;
    }
    if (event is HeadlessPressableVisualPointerUp ||
        event is HeadlessPressableVisualPointerCancel) {
      _setPointerActive(false);
    }
  }

  void _setPointerActive(bool value) {
    if (_pointerActive == value) return;
    setState(() => _pointerActive = value);
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.isEnabled && (widget.isPressed || _pointerActive);
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Stack(
        children: [
          widget.child,
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: active ? 1 : 0,
              duration: widget.duration,
              child: DecoratedBox(
                decoration: BoxDecoration(color: widget.overlayColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
