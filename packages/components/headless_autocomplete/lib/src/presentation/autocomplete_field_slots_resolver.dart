import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

import '../logic/autocomplete_item_model_factory.dart';
import '../logic/autocomplete_selection_mode.dart';
import 'autocomplete_combined_prefix.dart';
import 'autocomplete_selected_values_fallback.dart';

RTextFieldSlots? resolveAutocompleteFieldSlots<T>({
  required BuildContext context,
  required RTextFieldSlots? baseSlots,
  required AutocompleteSelectionMode<T> selectionMode,
  required HeadlessItemAdapter<T> itemAdapter,
  required RAutocompleteSelectedValuesPresentation? selectedValuesPresentation,
  required void Function(Set<ListboxItemId> ids) setSelectedIdsOptimistic,
  required void Function({required bool suppressOpenOnFocusOnce}) requestFocus,
}) {
  final userPrefix = baseSlots?.prefix;

  if (selectionMode is! AutocompleteMultipleSelectionMode<T>) {
    return baseSlots;
  }

  if (selectionMode.selectedValues.isEmpty) {
    return baseSlots;
  }

  final selectedItems = <HeadlessListItemModel>[
    for (final v in selectionMode.selectedValues)
      buildAutocompleteItemModel<T>(
        adapter: itemAdapter,
        value: v,
        id: itemAdapter.id(v),
      ),
  ];

  final renderer = HeadlessThemeProvider.maybeCapabilityOf<
      RAutocompleteSelectedValuesRenderer>(
    context,
    componentName: 'RAutocomplete',
  );

  final overrides = selectedValuesPresentation == null
      ? null
      : RenderOverrides.only(
          RAutocompleteSelectedValuesOverrides.tokens(
            presentation: selectedValuesPresentation,
          ),
        );

  final selectedPrefix = renderer?.render(
        RAutocompleteSelectedValuesRenderRequest(
          context: context,
          selectedItems: selectedItems,
          commands: RAutocompleteSelectedValuesCommands(
            removeById: (id) {
              setSelectedIdsOptimistic(
                Set<ListboxItemId>.from(
                  selectionMode.selectedValues.map(itemAdapter.id),
                )..remove(id),
              );
              final next = selectionMode.selectedValues
                  .where((v) => itemAdapter.id(v) != id)
                  .toList();
              if (next.length == selectionMode.selectedValues.length) return;
              selectionMode.onSelectionChanged(List<T>.unmodifiable(next));
              requestFocus(suppressOpenOnFocusOnce: true);
            },
            removeAt: (index) {
              if (index < 0 || index >= selectedItems.length) return;
              final id = selectedItems[index].id;
              setSelectedIdsOptimistic(
                Set<ListboxItemId>.from(
                  selectionMode.selectedValues.map(itemAdapter.id),
                )..remove(id),
              );
              final next = selectionMode.selectedValues
                  .where((v) => itemAdapter.id(v) != id)
                  .toList();
              if (next.length == selectionMode.selectedValues.length) return;
              selectionMode.onSelectionChanged(List<T>.unmodifiable(next));
              requestFocus(suppressOpenOnFocusOnce: true);
            },
          ),
          overrides: overrides,
        ),
      ) ??
      AutocompleteSelectedValuesFallback(selectedItems: selectedItems);

  final effectivePrefix = AutocompleteCombinedPrefix(
    selectedPrefix: selectedPrefix,
    userPrefix: userPrefix,
  );

  return (baseSlots == null)
      ? RTextFieldSlots(prefix: effectivePrefix)
      : RTextFieldSlots(
          leading: baseSlots.leading,
          trailing: baseSlots.trailing,
          prefix: effectivePrefix,
          suffix: baseSlots.suffix,
        );
}
