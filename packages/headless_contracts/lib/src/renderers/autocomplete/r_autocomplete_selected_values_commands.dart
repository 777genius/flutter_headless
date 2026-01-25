import 'package:flutter/foundation.dart';
import 'package:headless_foundation/headless_foundation.dart';

/// Commands for rendering and interacting with selected values (multi-select).
@immutable
final class RAutocompleteSelectedValuesCommands {
  const RAutocompleteSelectedValuesCommands({
    required this.removeById,
    required this.removeAt,
  });

  /// Removes a selected value by its stable item id.
  ///
  /// Recommended for renderers that may display selected items in any order.
  final void Function(ListboxItemId id) removeById;

  /// Removes a selected value by its index in `selectedItems`.
  ///
  /// Convenience for simple renderers that keep the request order.
  final void Function(int index) removeAt;
}

