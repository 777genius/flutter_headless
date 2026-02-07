import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'autocomplete_selection_mode.dart';

/// Selection + highlight state for Autocomplete.
abstract interface class AutocompleteSelectionController<T> {
  bool get isApplyingSelectionText;
  int? get selectedIndex;
  Set<int>? get selectedItemsIndices;
  int? get highlightedIndex;
  Iterable<ListboxItemId> get selectedIds;
  String? get committedText;

  /// Optimistically overrides selected ids (used to keep UI responsive while
  /// awaiting external controlled state to rebuild).
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

  /// Multiple mode: remove the last selected value when query is empty.
  ///
  /// Returns true if selection changed.
  bool removeLastSelected();

  void dispose();
}

/// Single selection controller (classic Autocomplete behavior).
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
        // Material-like behavior for editable combobox:
        // keep the committed selection while the user is narrowing by prefix.
        // This prevents "checkmark disappears on first character" regressions.
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

    final metas = List<ListboxItemMeta>.generate(
      items.length,
      (index) => ListboxItemMeta(
        id: items[index].id,
        isDisabled: items[index].isDisabled,
        typeaheadLabel: items[index].typeaheadLabel,
      ),
    );
    _listbox.setMetas(metas);
    _listbox.setSelectedId(_resolveSelectableId(_selectedId));
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

  @override
  bool removeLastSelected() => false;

  @override
  void dispose() {
    _listbox.dispose();
  }

  void _applyQueryText(String text) {
    _lastText = text;
    _isApplyingSelectionText = true;
    try {
      final selection = TextSelection.collapsed(offset: text.length);
      _controller.value = TextEditingValue(
        text: text,
        selection: selection,
        composing: TextRange.empty,
      );
    } finally {
      _isApplyingSelectionText = false;
    }
  }

  ListboxItemId? _resolveSelectableId(ListboxItemId? id) {
    if (id == null) return null;
    final index = _indexById[id];
    if (index == null) return null;
    if (_items[index].isDisabled) return null;
    return id;
  }

  ListboxItemId? _resolveHighlightId() {
    final current = _listbox.highlightedId;
    final currentIndex = current == null ? null : _indexById[current];
    if (currentIndex != null && !_items[currentIndex].isDisabled) {
      return current;
    }

    final selected = _resolveSelectableId(_selectedId);
    if (selected != null) return selected;
    return _firstEnabledId();
  }

  ListboxItemId? _firstEnabledId() {
    for (final item in _items) {
      if (!item.isDisabled) return item.id;
    }
    return null;
  }
}
