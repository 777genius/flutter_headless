import 'package:flutter/widgets.dart';

import 'package:anchored_overlay_engine/anchored_overlay_engine.dart';

/// Focus transfer policy for anchored menu overlays.
enum HeadlessMenuFocusTransferPolicy {
  /// Keep focus on the anchor (Autocomplete default).
  keepFocusOnAnchor,

  /// Transfer focus to the menu after mount (Dropdown default).
  transferToMenu,
}

/// Minimal overlay state for anchored menus.
@immutable
final class HeadlessMenuState {
  const HeadlessMenuState({
    required this.phase,
  });

  final OverlayPhase phase;

  bool get isOpen =>
      phase == OverlayPhase.opening || phase == OverlayPhase.open;
}
