import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

final class DropdownMenuInteractionShell extends StatelessWidget {
  const DropdownMenuInteractionShell({
    required this.focusNode,
    required this.onKeyEvent,
    required this.child,
    this.onPointerSignal,
    super.key,
  });

  final FocusNode focusNode;
  final KeyEventResult Function(FocusNode, KeyEvent) onKeyEvent;
  final void Function(PointerSignalEvent event)? onPointerSignal;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      onKeyEvent: onKeyEvent,
      child: Listener(
        onPointerSignal: onPointerSignal,
        child: child,
      ),
    );
  }
}
