import 'package:headless_foundation/headless_foundation.dart';

import 'r_dropdown_option.dart';

/// Callback interface for selection controller.
abstract interface class DropdownSelectionHost<T> {
  List<RDropdownOption<T>> get options;
  ListboxItemId? get selectedId;
  T? get selectedValue;

  void onValueSelected(T value);
  void closeMenu();

  int? get highlightedIndex;
  void updateHighlight(int? index);
}

/// Controls dropdown selection, navigation, and typeahead.
///
/// Manages item highlighting, keyboard navigation with wrap-around,
/// and typeahead search functionality.
final class DropdownSelectionController<T> {
  DropdownSelectionController(this._host);

  final DropdownSelectionHost<T> _host;
  final ListboxController _listbox = ListboxController();
  final Map<ListboxItemId, int> _indexById = <ListboxItemId, int>{};
  List<RDropdownOption<T>>? _syncedOptions;
  int _syncedOptionsLength = -1;

  void _syncItems() {
    final options = _host.options;
    final needsRebuild = !identical(options, _syncedOptions) ||
        options.length != _syncedOptionsLength;

    if (needsRebuild) {
      _indexById.clear();
      final metas = List<ListboxItemMeta>.generate(
        options.length,
        (index) {
          final item = options[index].item;
          _indexById[item.id] = index;
          return ListboxItemMeta(
            id: item.id,
            isDisabled: item.isDisabled,
            typeaheadLabel: item.typeaheadLabel,
          );
        },
      );
      _listbox.setMetas(metas);
      _syncedOptions = options;
      _syncedOptionsLength = options.length;
    }

    final selectedId = _host.selectedId;
    if (_listbox.selectedId != selectedId) {
      _listbox.setSelectedId(selectedId);
    }
  }

  /// Selects item by index and closes menu.
  void selectByIndex(int index) {
    final options = _host.options;
    if (index < 0 || index >= options.length) return;
    final option = options[index];
    if (option.item.isDisabled) return;

    _host.onValueSelected(option.value);
    _host.closeMenu();
  }

  /// Highlights item by index.
  void highlightIndex(int index) {
    final options = _host.options;
    if (index < 0 || index >= options.length) return;
    final option = options[index];
    if (option.item.isDisabled) return;

    _host.updateHighlight(index);
    _syncItems();
    _listbox.setHighlightedId(option.item.id);
  }

  /// Navigates to previous enabled item (with wrap-around).
  void navigateUp() {
    _syncItems();
    final currentIndex = _host.highlightedIndex;
    if (currentIndex != null) {
      final options = _host.options;
      if (currentIndex >= 0 && currentIndex < options.length) {
        _listbox.setHighlightedId(options[currentIndex].item.id);
      }
    }
    _listbox.highlightPrevious();
    _applyHighlightFromListbox();
  }

  /// Navigates to next enabled item (with wrap-around).
  void navigateDown() {
    _syncItems();
    final currentIndex = _host.highlightedIndex;
    if (currentIndex != null) {
      final options = _host.options;
      if (currentIndex >= 0 && currentIndex < options.length) {
        _listbox.setHighlightedId(options[currentIndex].item.id);
      }
    }
    _listbox.highlightNext();
    _applyHighlightFromListbox();
  }

  /// Selects currently highlighted item.
  void selectHighlighted() {
    final index = _host.highlightedIndex;
    if (index != null) {
      selectByIndex(index);
    }
  }

  /// Navigates to first enabled item.
  void navigateToFirst() {
    _syncItems();
    _listbox.highlightFirst();
    _applyHighlightFromListbox();
  }

  /// Navigates to last enabled item.
  void navigateToLast() {
    _syncItems();
    _listbox.highlightLast();
    _applyHighlightFromListbox();
  }

  /// Handles typeahead character input.
  void handleTypeahead(String char) {
    _syncItems();
    final currentIndex = _host.highlightedIndex;
    if (currentIndex != null) {
      final options = _host.options;
      if (currentIndex >= 0 && currentIndex < options.length) {
        _listbox.setHighlightedId(options[currentIndex].item.id);
      }
    }
    _listbox.handleTypeahead(char);
    _applyHighlightFromListbox();
  }

  /// Finds index of currently selected value.
  int? findSelectedIndex() {
    _syncItems();
    final id = _host.selectedId;
    if (id == null) return null;
    return _indexById[id];
  }

  /// Finds first enabled item index.
  int? findFirstEnabledIndex() {
    final options = _host.options;
    for (var i = 0; i < options.length; i++) {
      if (!options[i].item.isDisabled) return i;
    }
    return null;
  }

  /// Finds last enabled item index.
  int? findLastEnabledIndex() {
    final options = _host.options;
    for (var i = options.length - 1; i >= 0; i--) {
      if (!options[i].item.isDisabled) return i;
    }
    return null;
  }

  /// Resets typeahead state.
  void resetTypeahead() {
    _listbox.resetTypeahead();
  }

  void _applyHighlightFromListbox() {
    final id = _listbox.state.highlightedId;
    if (id == null) return;
    final index = _indexById[id] ?? _findIndexById(id);
    if (index == null) return;
    if (_host.highlightedIndex == index) return;
    _host.updateHighlight(index);
  }

  int? _findIndexById(ListboxItemId id) {
    final options = _host.options;
    for (var i = 0; i < options.length; i++) {
      if (options[i].item.id == id) return i;
    }
    return null;
  }

  /// Disposes controller resources.
  void dispose() {
    _listbox.dispose();
  }
}
