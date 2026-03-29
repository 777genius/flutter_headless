import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

final class RSwitchListTileSwitchShell extends StatelessWidget {
  const RSwitchListTileSwitchShell({
    super.key,
    required this.isDisabled,
    required this.mouseCursor,
    required this.onHoverChanged,
    required this.onPressedChanged,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.child,
  });

  final bool isDisabled;
  final MouseCursor? mouseCursor;
  final ValueChanged<bool> onHoverChanged;
  final ValueChanged<bool> onPressedChanged;
  final GestureDragStartCallback onDragStart;
  final GestureDragUpdateCallback onDragUpdate;
  final GestureDragEndCallback onDragEnd;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) {
        onHoverChanged(false);
        onPressedChanged(false);
      },
      cursor: isDisabled
          ? SystemMouseCursors.forbidden
          : (mouseCursor ?? SystemMouseCursors.click),
      child: Listener(
        onPointerDown: (_) => onPressedChanged(true),
        onPointerUp: (_) => onPressedChanged(false),
        onPointerCancel: (_) => onPressedChanged(false),
        child: RawGestureDetector(
          behavior: HitTestBehavior.opaque,
          gestures: <Type, GestureRecognizerFactory>{
            HorizontalDragGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<
                    HorizontalDragGestureRecognizer>(
              () => HorizontalDragGestureRecognizer(debugOwner: this),
              (HorizontalDragGestureRecognizer instance) {
                instance
                  ..onStart = onDragStart
                  ..onUpdate = onDragUpdate
                  ..onEnd = onDragEnd;
              },
            ),
          },
          child: child,
        ),
      ),
    );
  }
}
