import 'package:flutter/foundation.dart';

/// Selection mode for [RAutocomplete] without mixing single/multiple state.
@immutable
sealed class AutocompleteSelectionMode<T> {
  const AutocompleteSelectionMode();

  bool get isDisabled;
  bool get isMultiple;
}

@immutable
final class AutocompleteSingleSelectionMode<T> extends AutocompleteSelectionMode<T> {
  const AutocompleteSingleSelectionMode({
    required this.onSelected,
  });

  final ValueChanged<T>? onSelected;

  @override
  bool get isDisabled => onSelected == null;

  @override
  bool get isMultiple => false;
}

@immutable
final class AutocompleteMultipleSelectionMode<T>
    extends AutocompleteSelectionMode<T> {
  const AutocompleteMultipleSelectionMode({
    required this.selectedValues,
    required this.onSelectionChanged,
  });

  final List<T> selectedValues;
  final ValueChanged<List<T>> onSelectionChanged;

  @override
  bool get isDisabled => false;

  @override
  bool get isMultiple => true;
}

