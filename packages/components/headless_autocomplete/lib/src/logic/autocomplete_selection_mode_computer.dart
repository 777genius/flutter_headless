import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'autocomplete_selected_values_normalizer.dart';
import 'autocomplete_selection_mode.dart';

final class AutocompleteSelectionModeComputer<T> {
  bool _didWarnDuplicateSelectedValues = false;
  bool _didWarnUnstableSelectedValueId = false;

  AutocompleteSelectionMode<T> compute({
    required ValueChanged<T>? onSelected,
    required ValueChanged<List<T>>? onSelectionChanged,
    required List<T>? selectedValues,
    required HeadlessItemAdapter<T> itemAdapter,
  }) {
    if (onSelectionChanged == null) {
      return AutocompleteSingleSelectionMode<T>(onSelected: onSelected);
    }

    final raw = selectedValues ?? <T>[];
    final normalized = normalizeSelectedValuesById<T>(
      values: raw,
      adapter: itemAdapter,
    );

    if (!_didWarnDuplicateSelectedValues && normalized.length != raw.length) {
      _didWarnDuplicateSelectedValues = true;
      assert(() {
        debugPrint(
          '[headless_autocomplete] RAutocomplete.multiple: selectedValues contains duplicate ids. '
          'Duplicates are ignored to keep selection deterministic.',
        );
        return true;
      }());
    }

    if (!_didWarnUnstableSelectedValueId && raw.isNotEmpty) {
      final v = raw.first;
      final first = itemAdapter.id(v);
      final second = itemAdapter.id(v);
      if (first != second) {
        _didWarnUnstableSelectedValueId = true;
        assert(() {
          debugPrint(
            '[headless_autocomplete] RAutocomplete.multiple: unstable itemAdapter.id detected (selectedValues). '
            'Value: $v, first: $first, second: $second.',
          );
          return true;
        }());
      }
    }

    return AutocompleteMultipleSelectionMode<T>(
      selectedValues: normalized,
      onSelectionChanged: onSelectionChanged,
    );
  }
}
