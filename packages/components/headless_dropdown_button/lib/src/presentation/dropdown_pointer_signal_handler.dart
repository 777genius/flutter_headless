import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

final class DropdownPointerSignalHandler {
  const DropdownPointerSignalHandler({
    required BuildContext? Function() triggerContextGetter,
  }) : _triggerContextGetter = triggerContextGetter;

  final BuildContext? Function() _triggerContextGetter;

  void handle(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;

    final triggerContext = _triggerContextGetter();
    if (triggerContext == null) return;

    final axis = event.scrollDelta.dx.abs() > event.scrollDelta.dy.abs()
        ? Axis.horizontal
        : Axis.vertical;
    final scrollable = Scrollable.maybeOf(triggerContext, axis: axis) ??
        Scrollable.maybeOf(triggerContext);
    if (scrollable != null) {
      final delta =
          axis == Axis.horizontal ? event.scrollDelta.dx : event.scrollDelta.dy;
      scrollable.position.pointerScroll(delta);
      return;
    }

    final primaryController = PrimaryScrollController.maybeOf(triggerContext);
    primaryController?.position.pointerScroll(event.scrollDelta.dy);
  }
}
