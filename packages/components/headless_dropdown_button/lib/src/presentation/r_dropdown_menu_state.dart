import 'package:headless_contracts/headless_contracts.dart';

/// Internal menu state shared with overlay via a notifier.
///
/// Kept in its own file to avoid a monolithic `r_dropdown_button.dart`.
final class RDropdownMenuState {
  const RDropdownMenuState({
    required this.highlightedIndex,
    required this.overlayPhase,
  });

  final int? highlightedIndex;
  final ROverlayPhase overlayPhase;
}
