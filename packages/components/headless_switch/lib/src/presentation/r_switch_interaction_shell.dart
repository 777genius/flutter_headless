import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

final class RSwitchInteractionShell extends StatelessWidget {
  const RSwitchInteractionShell({
    super.key,
    required this.isDisabled,
    required this.value,
    required this.semanticLabel,
    required this.dragStartBehavior,
    required this.controller,
    required this.focusNode,
    required this.autofocus,
    required this.mouseCursor,
    required this.onActivate,
    required this.onFocusChange,
    required this.onKeyEvent,
    required this.onMouseEnter,
    required this.onMouseExit,
    required this.onTapDown,
    required this.onTapUp,
    required this.onCancel,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.child,
  });

  final bool isDisabled;
  final bool value;
  final String? semanticLabel;
  final DragStartBehavior dragStartBehavior;
  final HeadlessPressableController controller;
  final FocusNode focusNode;
  final bool autofocus;
  final MouseCursor? mouseCursor;
  final VoidCallback onActivate;
  final ValueChanged<bool> onFocusChange;
  final KeyEventResult Function(FocusNode, KeyEvent) onKeyEvent;
  final ValueChanged<PointerEnterEvent> onMouseEnter;
  final ValueChanged<PointerExitEvent> onMouseExit;
  final GestureTapDragDownCallback onTapDown;
  final GestureTapDragUpCallback onTapUp;
  final GestureCancelCallback onCancel;
  final GestureTapDragStartCallback onDragStart;
  final GestureTapDragUpdateCallback onDragUpdate;
  final GestureTapDragEndCallback onDragEnd;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      enabled: !isDisabled,
      toggled: value,
      label: semanticLabel,
      excludeSemantics: semanticLabel != null,
      child: RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          TapAndHorizontalDragGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<
                  TapAndHorizontalDragGestureRecognizer>(
            () => TapAndHorizontalDragGestureRecognizer(debugOwner: this),
            (TapAndHorizontalDragGestureRecognizer instance) {
              instance
                ..onTapDown = onTapDown
                ..onTapUp = onTapUp
                ..onCancel = onCancel
                ..onDragStart = onDragStart
                ..onDragUpdate = onDragUpdate
                ..onDragEnd = onDragEnd
                ..dragStartBehavior = dragStartBehavior;
            },
          ),
        },
        child: Focus(
          focusNode: focusNode,
          autofocus: autofocus,
          canRequestFocus: !isDisabled,
          skipTraversal: isDisabled,
          onFocusChange: onFocusChange,
          onKeyEvent: onKeyEvent,
          child: MouseRegion(
            onEnter: onMouseEnter,
            onExit: onMouseExit,
            cursor: isDisabled
                ? SystemMouseCursors.forbidden
                : (mouseCursor ?? SystemMouseCursors.click),
            child: child,
          ),
        ),
      ),
    );
  }
}
