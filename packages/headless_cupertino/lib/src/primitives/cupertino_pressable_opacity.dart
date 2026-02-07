import 'package:flutter/cupertino.dart';
import 'package:headless_foundation/headless_foundation.dart';

class CupertinoPressableOpacity extends StatefulWidget {
  const CupertinoPressableOpacity({
    super.key,
    required this.duration,
    required this.pressedOpacity,
    required this.isPressed,
    required this.isEnabled,
    required this.child,
    this.visualEffects,
  });

  final Duration duration;
  final double pressedOpacity;
  final bool isPressed;
  final bool isEnabled;
  final Widget child;
  final HeadlessPressableVisualEffectsController? visualEffects;

  @override
  State<CupertinoPressableOpacity> createState() =>
      _CupertinoPressableOpacityState();
}

class _CupertinoPressableOpacityState extends State<CupertinoPressableOpacity> {
  bool _pointerActive = false;

  @override
  void initState() {
    super.initState();
    widget.visualEffects?.addListener(_handleVisualEvent);
  }

  @override
  void didUpdateWidget(covariant CupertinoPressableOpacity oldWidget) {
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
    final opacity = active ? widget.pressedOpacity : 1.0;
    return AnimatedOpacity(
      duration: widget.duration,
      opacity: opacity,
      child: widget.child,
    );
  }
}
