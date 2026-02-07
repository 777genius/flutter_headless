import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'autocomplete_selection_controller.dart';
import 'autocomplete_selection_mode.dart';

/// Multiple selection controller for Autocomplete.
///
/// Owns highlight navigation via listbox, but delegates selection ownership to
/// the widget (controlled list + callback).
final class AutocompleteMultipleSelectionController<T>
    implements AutocompleteSelectionController<T> {
  AutocompleteMultipleSelectionController({
    required TextEditingController controller,
    required HeadlessItemAdapter<T> itemAdapter,
    required List<T> selectedValues,
    required ValueChanged<List<T>> onSelectionChanged,
    required bool clearQueryOnSelection,
    required VoidCallback notifyStateChanged,
  })  : _controller = controller,
        _itemAdapter = itemAdapter,
        _selectedValues = List<T>.unmodifiable(selectedValues),
        _onSelectionChanged = onSelectionChanged,
        _clearQueryOnSelection = clearQueryOnSelection,
        _notifyStateChanged = notifyStateChanged {
    _rebuildSelectedIds();
  }

  TextEditingController _controller;
  HeadlessItemAdapter<T> _itemAdapter;
  List<T> _selectedValues;
  ValueChanged<List<T>> _onSelectionChanged;
  bool _clearQueryOnSelection;
  final VoidCallback _notifyStateChanged;

  final ListboxController _listbox = ListboxController();
  final Map<ListboxItemId, int> _indexById = <ListboxItemId, int>{};

  List<T> _options = const [];
  List<HeadlessListItemModel> _items = const [];
  int _itemsSignature = -1;

  String _lastText = '';

  final Set<ListboxItemId> _selectedIds = <ListboxItemId>{};
  bool _hasPendingSelection = false;
  bool _isApplyingSelectionText = false;
  bool _isDisposed = false;

  @override
  bool get isApplyingSelectionText => _isApplyingSelectionText;

  @override
  String? get committedText => null;

  @override
  int? get selectedIndex => null;

  @override
  Iterable<ListboxItemId> get selectedIds => _selectedIds;

  @override
  void setSelectedIdsOptimistic(Set<ListboxItemId> ids) {
    _selectedIds
      ..clear()
      ..addAll(ids);
    _hasPendingSelection = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isDisposed) return;
      if (!_hasPendingSelection) return;
      _hasPendingSelection = false;
      _rebuildSelectedIds();
      _notifyStateChanged();
    });
    _notifyStateChanged();
  }

  @override
  Set<int>? get selectedItemsIndices {
    if (_selectedIds.isEmpty) return const <int>{};
    final indices = <int>{};
    for (final id in _selectedIds) {
      final idx = _indexById[id];
      if (idx != null) indices.add(idx);
    }
    return indices;
  }

  @override
  int? get highlightedIndex => _indexById[_listbox.highlightedId];

  void updateSelection({
    required List<T> selectedValues,
    required ValueChanged<List<T>> onSelectionChanged,
    required bool clearQueryOnSelection,
  }) {
    _selectedValues = List<T>.unmodifiable(selectedValues);
    _onSelectionChanged = onSelectionChanged;
    _clearQueryOnSelection = clearQueryOnSelection;
    _hasPendingSelection = false;
    _rebuildSelectedIds();
  }

  @override
  void updateSelectionMode({
    required AutocompleteSelectionMode<T> mode,
    required bool clearQueryOnSelection,
  }) {
    if (mode is! AutocompleteMultipleSelectionMode<T>) {
      throw StateError('Expected multiple selection mode.');
    }
    updateSelection(
      selectedValues: mode.selectedValues,
      onSelectionChanged: mode.onSelectionChanged,
      clearQueryOnSelection: clearQueryOnSelection,
    );
  }

  @override
  void updateItemAdapter(HeadlessItemAdapter<T> adapter) {
    if (identical(_itemAdapter, adapter)) return;
    _itemAdapter = adapter;
    _rebuildSelectedIds();
  }

  @override
  void updateController(TextEditingController controller) {
    _controller = controller;
    _lastText = controller.text;
  }

  @override
  bool handleTextChanged(TextEditingValue value) {
    final text = value.text;
    if (text == _lastText) return false;
    _lastText = text;
    if (_isApplyingSelectionText) return false;
    return true;
  }

  @override
  bool updateOptions({
    required List<T> options,
    required List<HeadlessListItemModel> items,
  }) {
    _options = options;
    final signature = Object.hashAll(items);
    final itemsChanged =
        signature != _itemsSignature || !identical(items, _items);
    if (!itemsChanged) return false;

    _itemsSignature = signature;
    _items = items;
    _indexById
      ..clear()
      ..addEntries(
        items.asMap().entries.map(
              (entry) => MapEntry(entry.value.id, entry.key),
            ),
      );

    final metas = List<ListboxItemMeta>.generate(
      items.length,
      (index) => ListboxItemMeta(
        id: items[index].id,
        isDisabled: items[index].isDisabled,
        typeaheadLabel: items[index].typeaheadLabel,
      ),
    );
    _listbox.setMetas(metas);
    _listbox.setSelectedId(null);
    _listbox.setHighlightedId(_resolveHighlightId());
    return true;
  }

  @override
  void selectByIndex({
    required int index,
    required bool closeOnSelected,
    required VoidCallback closeMenu,
  }) {
    if (index < 0 || index >= _options.length) return;
    final item = _items[index];
    if (item.isDisabled) return;

    final selectedId = item.id;
    final wasSelected = _selectedIds.contains(selectedId);
    final nextSelectedIds = Set<ListboxItemId>.from(_selectedIds);
    if (wasSelected) {
      nextSelectedIds.remove(selectedId);
    } else {
      nextSelectedIds.add(selectedId);
    }

    // Optimistic UI update: reflect selection immediately (checkboxes, indices),
    // then revert at end of frame unless parent rebuild confirms the new list.
    setSelectedIdsOptimistic(nextSelectedIds);

    final next = List<T>.from(_selectedValues);
    if (wasSelected) {
      next.removeWhere((v) => _itemAdapter.id(v) == selectedId);
    } else {
      next.add(_options[index]);
    }

    _onSelectionChanged(List<T>.unmodifiable(next));

    if (_clearQueryOnSelection) {
      _applyQueryText('');
    }

    if (closeOnSelected) closeMenu();
    _notifyStateChanged();
  }

  @override
  void highlightIndex(int index) {
    if (index < 0 || index >= _items.length) return;
    final item = _items[index];
    if (item.isDisabled) return;
    _listbox.setHighlightedId(item.id);
  }

  @override
  void navigateUp() {
    _syncHighlightedId();
    _listbox.highlightPrevious();
  }

  @override
  void navigateDown() {
    _syncHighlightedId();
    _listbox.highlightNext();
  }

  @override
  void navigateToFirst() {
    _listbox.highlightFirst();
  }

  @override
  void navigateToLast() {
    _listbox.highlightLast();
  }

  @override
  void resetTypeahead() {
    _listbox.resetTypeahead();
  }

  @override
  bool removeLastSelected() {
    if (_selectedValues.isEmpty) return false;
    final removedId = _itemAdapter.id(_selectedValues.last);
    final nextIds = Set<ListboxItemId>.from(_selectedIds)..remove(removedId);
    setSelectedIdsOptimistic(nextIds);

    final next = List<T>.from(_selectedValues)..removeLast();
    _onSelectionChanged(List<T>.unmodifiable(next));
    _notifyStateChanged();
    return true;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _listbox.dispose();
  }

  void _rebuildSelectedIds() {
    _selectedIds.clear();
    for (final v in _selectedValues) {
      final id = _itemAdapter.id(v);
      assert(() {
        final again = _itemAdapter.id(v);
        if (again != id) {
          debugPrint(
            '[headless_autocomplete] RAutocomplete.multiple: unstable itemAdapter.id detected. '
            'Value: $v, first: $id, second: $again.',
          );
        }
        return true;
      }());
      _selectedIds.add(id);
    }
    if (_selectedIds.length != _selectedValues.length) {
      assert(() {
        debugPrint(
          '[headless_autocomplete] RAutocomplete.multiple: selectedValues contains duplicate ids. '
          'Selection behavior may be ambiguous. Ensure itemAdapter.id(value) is unique.',
        );
        return true;
      }());
    }
  }

  void _applyQueryText(String text) {
    _lastText = text;
    _isApplyingSelectionText = true;
    try {
      _controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
        composing: TextRange.empty,
      );
    } finally {
      _isApplyingSelectionText = false;
    }
  }

  void _syncHighlightedId() {
    final currentIndex = highlightedIndex;
    if (currentIndex != null &&
        currentIndex >= 0 &&
        currentIndex < _items.length) {
      _listbox.setHighlightedId(_items[currentIndex].id);
      return;
    }
    final fallback = _resolveHighlightId();
    if (fallback != null) {
      _listbox.setHighlightedId(fallback);
    }
  }

  ListboxItemId? _resolveHighlightId() {
    final current = _listbox.highlightedId;
    final currentIndex = current == null ? null : _indexById[current];
    if (currentIndex != null && !_items[currentIndex].isDisabled) {
      return current;
    }
    return _firstEnabledId();
  }

  ListboxItemId? _firstEnabledId() {
    for (final item in _items) {
      if (!item.isDisabled) return item.id;
    }
    return null;
  }
}
