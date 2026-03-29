import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'autocomplete_selection_listbox_helpers.dart';
import 'autocomplete_selection_mode.dart';

abstract interface class AutocompleteSelectionController<T> {
  bool get isApplyingSelectionText;
  int? get selectedIndex;
  Set<int>? get selectedItemsIndices;
  int? get highlightedIndex;
  Iterable<ListboxItemId> get selectedIds;
  String? get committedText;

  void setSelectedIdsOptimistic(Set<ListboxItemId> ids);

  void updateItemAdapter(HeadlessItemAdapter<T> adapter);
  void updateController(TextEditingController controller);

  void updateSelectionMode({
    required AutocompleteSelectionMode<T> mode,
    required bool clearQueryOnSelection,
  });

  bool handleTextChanged(TextEditingValue value);

  bool updateOptions({
    required List<T> options,
    required List<HeadlessListItemModel> items,
  });

  void selectByIndex({
    required int index,
    required bool closeOnSelected,
    required VoidCallback closeMenu,
  });

  void highlightIndex(int index);

  void navigateUp();
  void navigateDown();
  void navigateToFirst();
  void navigateToLast();
  void resetTypeahead();

  bool removeLastSelected();

  void dispose();
}

final class AutocompleteSingleSelectionController<T>
    implements AutocompleteSelectionController<T> {
  AutocompleteSingleSelectionController({
    required TextEditingController controller,
    required HeadlessItemAdapter<T> itemAdapter,
    required ValueChanged<T>? onSelected,
    required bool clearQueryOnSelection,
    required VoidCallback notifyStateChanged,
  })  : _controller = controller,
        _itemAdapter = itemAdapter,
        _onSelected = onSelected,
        _clearQueryOnSelection = clearQueryOnSelection,
        _notifyStateChanged = notifyStateChanged;

  TextEditingController _controller;
  HeadlessItemAdapter<T> _itemAdapter;
  ValueChanged<T>? _onSelected;
  bool _clearQueryOnSelection;
  final VoidCallback _notifyStateChanged;

  final ListboxController _listbox = ListboxController();
  final Map<ListboxItemId, int> _indexById = <ListboxItemId, int>{};

  List<T> _options = const [];
  List<HeadlessListItemModel> _items = const [];
  int _itemsSignature = -1;

  ListboxItemId? _selectedId;
  String? _lastSelectedText;
  String _lastText = '';
  bool _isApplyingSelectionText = false;

  @override
  bool get isApplyingSelectionText => _isApplyingSelectionText;

  ListboxItemId? get selectedId => _selectedId;

  @override
  String? get committedText => _lastSelectedText;

  @override
  int? get selectedIndex => _indexById[_selectedId];

  @override
  Set<int>? get selectedItemsIndices => null;

  @override
  int? get highlightedIndex => _indexById[_listbox.highlightedId];

  @override
  Iterable<ListboxItemId> get selectedIds => _selectedId == null
      ? const <ListboxItemId>[]
      : <ListboxItemId>[_selectedId!];

  @override
  void setSelectedIdsOptimistic(Set<ListboxItemId> ids) {}

  void updateOnSelected(ValueChanged<T>? onSelected) {
    _onSelected = onSelected;
  }

  void updateClearQueryOnSelection(bool clear) {
    _clearQueryOnSelection = clear;
  }

  @override
  void updateSelectionMode({
    required AutocompleteSelectionMode<T> mode,
    required bool clearQueryOnSelection,
  }) {
    if (mode is! AutocompleteSingleSelectionMode<T>) {
      throw StateError('Expected single selection mode.');
    }
    _onSelected = mode.onSelected;
    _clearQueryOnSelection = clearQueryOnSelection;
  }

  @override
  void updateItemAdapter(HeadlessItemAdapter<T> adapter) {
    if (identical(_itemAdapter, adapter)) return;
    _itemAdapter = adapter;
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
    if (_isApplyingSelectionText) {
      return false;
    }
    final committed = _lastSelectedText;
    if (_selectedId != null && committed != null) {
      if (text.isEmpty) {
        _selectedId = null;
        _lastSelectedText = null;
        _listbox.setSelectedId(null);
      } else {
        final keepSelected =
            committed.toLowerCase().startsWith(text.toLowerCase());
        if (!keepSelected) {
          _selectedId = null;
          _lastSelectedText = null;
          _listbox.setSelectedId(null);
        }
      }
    }
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

    setAutocompleteListboxMetas(_listbox, items);
    _listbox.setSelectedId(
      resolveAutocompleteSelectableId(
        id: _selectedId,
        indexById: _indexById,
        items: _items,
      ),
    );
    _listbox.setHighlightedId(
      resolveAutocompleteHighlightId(
        listbox: _listbox,
        indexById: _indexById,
        items: _items,
        preferredId: _selectedId,
      ),
    );
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

    _selectedId = item.id;
    _listbox.setSelectedId(item.id);
    if (_clearQueryOnSelection) {
      _applyQueryText('');
    } else {
      _applyQueryText(item.primaryText);
      _lastSelectedText = item.primaryText;
    }
    _onSelected?.call(_options[index]);
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
    syncAutocompleteHighlightedId(
      listbox: _listbox,
      highlightedIndex: highlightedIndex,
      indexById: _indexById,
      items: _items,
      preferredId: _selectedId,
    );
    _listbox.highlightPrevious();
  }

  @override
  void navigateDown() {
    syncAutocompleteHighlightedId(
      listbox: _listbox,
      highlightedIndex: highlightedIndex,
      indexById: _indexById,
      items: _items,
      preferredId: _selectedId,
    );
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
  bool removeLastSelected() => false;

  @override
  void dispose() {
    _listbox.dispose();
  }

  void _applyQueryText(String text) {
    applyAutocompleteQueryText(
      controller: _controller,
      text: text,
      updateLastText: (value) => _lastText = value,
      setApplyingSelectionText: (value) => _isApplyingSelectionText = value,
    );
  }
}
