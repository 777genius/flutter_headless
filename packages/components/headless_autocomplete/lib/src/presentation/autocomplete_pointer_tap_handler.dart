import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Pointer-level tap handling that is safe around competing gesture arenas.
///
/// - Requests focus on pointer down.
/// - Triggers [onTap] only if the pointer did not drag (tap slop).
final class AutocompletePointerTapHandler extends StatefulWidget {
  const AutocompletePointerTapHandler({
    required this.focusNode,
    required this.onTap,
    required this.child,
    super.key,
  });

  final FocusNode focusNode;
  final VoidCallback onTap;
  final Widget child;

  @override
  State<AutocompletePointerTapHandler> createState() =>
      _AutocompletePointerTapHandlerState();
}

class _AutocompletePointerTapHandlerState
    extends State<AutocompletePointerTapHandler> {
  Offset? _down;
  bool _moved = false;

  void _onDown(PointerDownEvent e) {
    _down = e.position;
    _moved = false;
    widget.focusNode.requestFocus();
  }

  void _onMove(PointerMoveEvent e) {
    final down = _down;
    if (down == null) return;
    if ((e.position - down).distance > kTouchSlop) {
      _moved = true;
    }
  }

  void _onUp(PointerUpEvent e) {
    if (!_moved) widget.onTap();
    _down = null;
    _moved = false;
  }

  void _onCancel(PointerCancelEvent e) {
    _down = null;
    _moved = false;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onDown,
      onPointerMove: _onMove,
      onPointerUp: _onUp,
      onPointerCancel: _onCancel,
      child: widget.child,
    );
  }
}
