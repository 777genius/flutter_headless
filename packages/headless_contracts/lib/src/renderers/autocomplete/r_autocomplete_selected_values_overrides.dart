import 'package:flutter/foundation.dart';

/// Presentation style for selected values (multi-select).
enum RAutocompleteSelectedValuesPresentation {
  chips,
  commaSeparated,
}

/// Per-instance overrides for selected values rendering (contract level).
@immutable
final class RAutocompleteSelectedValuesOverrides {
  const RAutocompleteSelectedValuesOverrides({
    this.presentation,
  });

  const RAutocompleteSelectedValuesOverrides.tokens({
    this.presentation,
  });

  final RAutocompleteSelectedValuesPresentation? presentation;
}

