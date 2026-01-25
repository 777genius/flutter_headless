import 'package:flutter/widgets.dart';

import '../policies/overlay_barrier_policy.dart';
import '../policies/overlay_dismiss_policy.dart';
import '../policies/overlay_focus_policy.dart';
import '../policies/overlay_reposition_policy.dart';
import '../policies/overlay_stack_policy.dart';
import 'overlay_anchor.dart';

@immutable
final class OverlayRequest {
  const OverlayRequest({
    required this.overlayBuilder,
    this.anchor,
    this.barrier,
    this.dismiss = DismissPolicy.modal,
    this.focus = const NonModalFocusPolicy(),
    this.reposition = OverlayRepositionPolicy.anchored,
    this.stack = OverlayStackPolicy.lifo,
    this.restoreFocus,
  });

  final WidgetBuilder overlayBuilder;
  final OverlayAnchor? anchor;
  final OverlayBarrierPolicy? barrier;
  final DismissPolicy dismiss;
  final FocusPolicy focus;
  final OverlayRepositionPolicy reposition;
  final OverlayStackPolicy stack;
  final FocusNode? restoreFocus;
}
