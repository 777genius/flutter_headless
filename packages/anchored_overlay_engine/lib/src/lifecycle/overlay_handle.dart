import 'package:flutter/foundation.dart';

import 'overlay_phase.dart';

/// Default fail-safe timeout duration for closing phase.
const Duration kOverlayFailSafeTimeout = Duration(seconds: 5);

/// Callback for fail-safe timeout diagnostic.
typedef OverlayTimeoutCallback = void Function(OverlayHandle handle);

/// Minimal overlay handle contract.
abstract interface class OverlayHandle {
  ValueListenable<OverlayPhase> get phase;

  bool get isOpen;

  void close();

  void completeClose();
}
