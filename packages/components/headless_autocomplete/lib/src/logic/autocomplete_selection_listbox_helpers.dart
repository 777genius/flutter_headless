import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

void setAutocompleteListboxMetas(
  ListboxController listbox,
  List<HeadlessListItemModel> items,
) {
  final metas = List<ListboxItemMeta>.generate(
    items.length,
    (index) => ListboxItemMeta(
      id: items[index].id,
      isDisabled: items[index].isDisabled,
      typeaheadLabel: items[index].typeaheadLabel,
    ),
  );
  listbox.setMetas(metas);
}

void applyAutocompleteQueryText({
  required TextEditingController controller,
  required String text,
  required ValueChanged<String> updateLastText,
  required ValueChanged<bool> setApplyingSelectionText,
}) {
  updateLastText(text);
  setApplyingSelectionText(true);
  try {
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
      composing: TextRange.empty,
    );
  } finally {
    setApplyingSelectionText(false);
  }
}

ListboxItemId? resolveAutocompleteSelectableId({
  required ListboxItemId? id,
  required Map<ListboxItemId, int> indexById,
  required List<HeadlessListItemModel> items,
}) {
  if (id == null) return null;
  final index = indexById[id];
  if (index == null) return null;
  if (items[index].isDisabled) return null;
  return id;
}

ListboxItemId? firstEnabledAutocompleteId(List<HeadlessListItemModel> items) {
  for (final item in items) {
    if (!item.isDisabled) return item.id;
  }
  return null;
}

ListboxItemId? resolveAutocompleteHighlightId({
  required ListboxController listbox,
  required Map<ListboxItemId, int> indexById,
  required List<HeadlessListItemModel> items,
  ListboxItemId? preferredId,
}) {
  final current = listbox.highlightedId;
  final currentIndex = current == null ? null : indexById[current];
  if (currentIndex != null && !items[currentIndex].isDisabled) {
    return current;
  }
  final preferred = resolveAutocompleteSelectableId(
    id: preferredId,
    indexById: indexById,
    items: items,
  );
  return preferred ?? firstEnabledAutocompleteId(items);
}

void syncAutocompleteHighlightedId({
  required ListboxController listbox,
  required int? highlightedIndex,
  required Map<ListboxItemId, int> indexById,
  required List<HeadlessListItemModel> items,
  ListboxItemId? preferredId,
}) {
  if (highlightedIndex != null &&
      highlightedIndex >= 0 &&
      highlightedIndex < items.length) {
    listbox.setHighlightedId(items[highlightedIndex].id);
    return;
  }
  final fallback = resolveAutocompleteHighlightId(
    listbox: listbox,
    indexById: indexById,
    items: items,
    preferredId: preferredId,
  );
  if (fallback != null) {
    listbox.setHighlightedId(fallback);
  }
}

void rebuildAutocompleteSelectedIds<T>({
  required List<T> selectedValues,
  required HeadlessItemAdapter<T> itemAdapter,
  required Set<ListboxItemId> selectedIds,
}) {
  selectedIds.clear();
  for (final value in selectedValues) {
    final id = itemAdapter.id(value);
    assert(() {
      final again = itemAdapter.id(value);
      if (again != id) {
        debugPrint(
          '[headless_autocomplete] RAutocomplete.multiple: unstable itemAdapter.id detected. '
          'Value: $value, first: $id, second: $again.',
        );
      }
      return true;
    }());
    selectedIds.add(id);
  }
  if (selectedIds.length != selectedValues.length) {
    assert(() {
      debugPrint(
        '[headless_autocomplete] RAutocomplete.multiple: selectedValues contains duplicate ids. '
        'Selection behavior may be ambiguous. Ensure itemAdapter.id(value) is unique.',
      );
      return true;
    }());
  }
}
