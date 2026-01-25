import 'package:headless_contracts/headless_contracts.dart';

/// Internal menu state shared with overlay via a notifier.
final class RAutocompleteMenuState {
  const RAutocompleteMenuState({
    required this.highlightedIndex,
    required this.overlayPhase,
  });

  final int? highlightedIndex;
  final ROverlayPhase overlayPhase;
}
