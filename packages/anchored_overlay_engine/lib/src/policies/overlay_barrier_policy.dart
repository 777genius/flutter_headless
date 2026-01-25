import 'package:flutter/foundation.dart';

import 'overlay_dismiss_policy.dart';

@immutable
final class OverlayBarrierPolicy {
  const OverlayBarrierPolicy({
    required this.enabled,
    required this.dismissible,
  });

  const OverlayBarrierPolicy.none()
      : enabled = false,
        dismissible = false;

  const OverlayBarrierPolicy.dismissible()
      : enabled = true,
        dismissible = true;

  const OverlayBarrierPolicy.blocking()
      : enabled = true,
        dismissible = false;

  final bool enabled;
  final bool dismissible;

  static OverlayBarrierPolicy fromDismissPolicy(DismissPolicy dismiss) {
    if (dismiss == DismissPolicy.none) {
      return const OverlayBarrierPolicy.none();
    }

    if (dismiss.dismissOnOutsideTap && dismiss.barrierDismissible) {
      return const OverlayBarrierPolicy.dismissible();
    }

    return const OverlayBarrierPolicy.blocking();
  }
}
