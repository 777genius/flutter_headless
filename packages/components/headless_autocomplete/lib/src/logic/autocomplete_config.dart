import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../sources/r_autocomplete_source.dart';
import 'autocomplete_selection_mode.dart';

@immutable
final class AutocompleteConfig<T> {
  const AutocompleteConfig({
    required this.optionsBuilder,
    required this.localCacheEnabled,
    required this.itemAdapter,
    required this.disabled,
    required this.selectionMode,
    required this.openOnFocus,
    required this.openOnInput,
    required this.openOnTap,
    required this.closeOnSelected,
    required this.maxOptions,
    required this.placeholder,
    required this.semanticLabel,
    required this.menuSlots,
    required this.menuOverrides,
    required this.clearQueryOnSelection,
    required this.hideSelectedOptions,
    required this.pinSelectedOptions,
    required this.source,
  });

  /// Source-first API for autocomplete data.
  ///
  /// When provided, enables remote/hybrid modes with full state management.
  /// For local sources, [optionsBuilder] is still used for filtering.
  final RAutocompleteSource<T> source;

  final Iterable<T> Function(TextEditingValue textEditingValue) optionsBuilder;
  final bool localCacheEnabled;
  final HeadlessItemAdapter<T> itemAdapter;
  final bool disabled;
  final AutocompleteSelectionMode<T> selectionMode;
  final bool openOnFocus;
  final bool openOnInput;
  final bool openOnTap;
  final bool closeOnSelected;
  final int? maxOptions;
  final String? placeholder;
  final String? semanticLabel;
  final RDropdownButtonSlots? menuSlots;
  final RenderOverrides? menuOverrides;

  /// Clears the query text after a successful selection.
  ///
  /// For multiple mode this is typically true.
  final bool clearQueryOnSelection;

  /// Whether to hide already-selected options from the menu (multiple mode).
  final bool hideSelectedOptions;

  /// Whether to pin selected options to the top of the menu (multiple mode).
  final bool pinSelectedOptions;

  bool get isDisabled => disabled || selectionMode.isDisabled;

  /// Whether this config requires a source controller for async operations.
  bool get needsSourceController {
    final s = source;
    return s is RAutocompleteRemoteSource<T> ||
        s is RAutocompleteHybridSource<T>;
  }
}
