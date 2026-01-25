import 'package:flutter/widgets.dart';

import '../lifecycle/overlay_handle_impl.dart';
import '../model/overlay_anchor.dart';
import '../policies/overlay_barrier_policy.dart';
import '../policies/overlay_dismiss_policy.dart';
import '../policies/overlay_focus_policy.dart';
import '../policies/overlay_reposition_policy.dart';
import '../policies/overlay_stack_policy.dart';

final class OverlayEntryData {
  OverlayEntryData({
    required this.handle,
    required this.overlayBuilder,
    required this.dismissPolicy,
    required this.barrierPolicy,
    required this.focusPolicy,
    required this.repositionPolicy,
    required this.stackPolicy,
    required this.focusScopeNode,
    required this.onRemove,
    this.anchor,
    this.restoreFocus,
  });

  final OverlayHandleImpl handle;
  final WidgetBuilder overlayBuilder;
  final DismissPolicy dismissPolicy;
  final OverlayBarrierPolicy barrierPolicy;
  final FocusPolicy focusPolicy;
  final OverlayRepositionPolicy repositionPolicy;
  final OverlayStackPolicy stackPolicy;
  final OverlayAnchor? anchor;
  final FocusScopeNode focusScopeNode;
  final FocusNode? restoreFocus;
  final VoidCallback onRemove;

  bool get needsReposition => repositionPolicy.enabled && anchor != null;
}
