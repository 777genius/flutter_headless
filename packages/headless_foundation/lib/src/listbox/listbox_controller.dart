import 'package:flutter/foundation.dart';

import 'item_registry.dart';
import 'listbox_item.dart';
import 'listbox_item_id.dart';
import 'listbox_item_meta.dart';
import 'listbox_navigation_command.dart';
import 'listbox_navigation_policy.dart';
import 'listbox_state.dart';
import 'listbox_typeahead.dart';
import 'typeahead_label.dart';

/// Foundation listbox controller (keyboard navigation + typeahead).
///
/// - Ядро использует [ItemRegistry] и не зависит от UI.
/// - Для простых кейсов допускается convenience API [setItems].
final class ListboxController extends ChangeNotifier {
  ListboxController({
    ItemRegistry? registry,
    this.navigationPolicy = const ListboxNavigationPolicy(),
    ListboxTypeaheadConfig typeaheadConfig = const ListboxTypeaheadConfig(),
    DateTime Function()? now,
  })  : _registry = registry ?? ItemRegistry(),
        _typeahead = ListboxTypeaheadBuffer(config: typeaheadConfig, now: now);

  final ItemRegistry _registry;
  final ListboxNavigationPolicy navigationPolicy;
  final ListboxTypeaheadBuffer _typeahead;

  ListboxItemId? _highlightedId;
  ListboxItemId? _selectedId;

  ListboxItemId? get highlightedId => _highlightedId;
  ListboxItemId? get selectedId => _selectedId;

  ListboxState get state => ListboxState(
        highlightedId: _highlightedId,
        selectedId: _selectedId,
      );

  /// Convenience adapter: регистрирует items списком (подходит для маленьких списков).
  void setItems(List<ListboxItem> items) {
    final metas = List<ListboxItemMeta>.generate(
      items.length,
      (index) {
        final item = items[index];
        return ListboxItemMeta(
          id: item.id,
          isDisabled: item.isDisabled,
          typeaheadLabel: HeadlessTypeaheadLabel.normalize(item.label),
        );
      },
    );
    _applyMetas(metas);
  }

  /// Convenience adapter: register metas list (already normalized).
  void setMetas(List<ListboxItemMeta> metas) {
    _applyMetas(metas);
  }

  void register(ListboxItemMeta meta, {required int order}) {
    _registry.register(meta, order: order);
    notifyListeners();
  }

  void unregister(ListboxItemId id) {
    _registry.unregister(id);
    if (_highlightedId == id) _highlightedId = null;
    if (_selectedId == id) _selectedId = null;
    notifyListeners();
  }

  void setSelectedId(ListboxItemId? id) {
    if (id == null) {
      if (_selectedId == null) return;
      _selectedId = null;
      notifyListeners();
      return;
    }

    final meta = _registry.getMeta(id);
    if (meta == null || meta.isDisabled) {
      if (_selectedId == null) return;
      _selectedId = null;
      notifyListeners();
      return;
    }
    if (_selectedId == id) return;
    _selectedId = id;
    notifyListeners();
  }

  void setHighlightedId(ListboxItemId? id) {
    if (id == null) {
      if (_highlightedId == null) return;
      _highlightedId = null;
      notifyListeners();
      return;
    }

    final meta = _registry.getMeta(id);
    if (meta == null || meta.isDisabled) return;
    if (_highlightedId == id) return;
    _highlightedId = id;
    notifyListeners();
  }

  void highlightFirst() {
    final enabled = _registry.orderedEnabledIds;
    if (enabled.isEmpty) return;
    setHighlightedId(enabled.first);
  }

  void highlightLast() {
    final enabled = _registry.orderedEnabledIds;
    if (enabled.isEmpty) return;
    setHighlightedId(enabled.last);
  }

  void highlightNext() {
    final enabled = _registry.orderedEnabledIds;
    if (enabled.isEmpty) return;

    final fromId = _highlightedId ?? _selectedId;
    final fromIndex = fromId == null ? -1 : enabled.indexOf(fromId);
    final start = fromIndex < 0 ? -1 : fromIndex;

    final nextIndex =
        _nextIndex(enabledLength: enabled.length, fromIndex: start);
    if (nextIndex == null) return;
    setHighlightedId(enabled[nextIndex]);
  }

  void highlightPrevious() {
    final enabled = _registry.orderedEnabledIds;
    if (enabled.isEmpty) return;

    final fromId = _highlightedId ?? _selectedId;
    final fromIndex = fromId == null ? enabled.length : enabled.indexOf(fromId);
    final start = fromIndex < 0 ? enabled.length : fromIndex;

    final prevIndex =
        _previousIndex(enabledLength: enabled.length, fromIndex: start);
    if (prevIndex == null) return;
    setHighlightedId(enabled[prevIndex]);
  }

  void selectHighlighted() {
    final id = _highlightedId;
    if (id == null) return;
    setSelectedId(id);
  }

  void resetTypeahead() => _typeahead.reset();

  ListboxItemId? handleTypeahead(String char) {
    final enabled = _registry.orderedEnabledIds;
    if (enabled.isEmpty) return null;

    final query = HeadlessTypeaheadLabel.normalize(_typeahead.push(char));
    if (query.isEmpty) return null;
    final from = _highlightedId == null ? -1 : enabled.indexOf(_highlightedId!);
    final startIndex = (from < 0 ? -1 : from) + 1;

    for (var step = 0; step < enabled.length; step++) {
      final idx = (startIndex + step) % enabled.length;
      final id = enabled[idx];
      final meta = _registry.getMeta(id);
      if (meta == null) continue;
      if (meta.typeaheadLabel.startsWith(query)) {
        setHighlightedId(id);
        return id;
      }
    }

    return null;
  }

  void navigate(ListboxNavigation nav) {
    switch (nav) {
      case MoveHighlight(:final delta):
        if (delta > 0) {
          highlightNext();
        } else if (delta < 0) {
          highlightPrevious();
        }
      case JumpToFirst():
        highlightFirst();
      case JumpToLast():
        highlightLast();
      case TypeaheadChar(:final char):
        handleTypeahead(char);
      case SelectHighlighted():
        selectHighlighted();
    }
  }

  int? _nextIndex({required int enabledLength, required int fromIndex}) {
    if (enabledLength == 0) return null;
    final idx = fromIndex + 1;
    if (navigationPolicy.looping) {
      return idx % enabledLength;
    }
    if (idx < 0 || idx >= enabledLength) return null;
    return idx;
  }

  int? _previousIndex({required int enabledLength, required int fromIndex}) {
    if (enabledLength == 0) return null;
    final idx = fromIndex - 1;
    if (navigationPolicy.looping) {
      return ((idx % enabledLength) + enabledLength) % enabledLength;
    }
    if (idx < 0 || idx >= enabledLength) return null;
    return idx;
  }

  void _normalizeStateAfterRegistryChange() {
    if (_highlightedId != null && !_registry.contains(_highlightedId!)) {
      _highlightedId = null;
    }
    if (_selectedId != null && !_registry.contains(_selectedId!)) {
      _selectedId = null;
    }
  }

  void _applyMetas(List<ListboxItemMeta> metas) {
    assert(_assertValidMetas(metas));
    _registry.clear();
    for (var i = 0; i < metas.length; i++) {
      _registry.register(metas[i], order: i);
    }
    _normalizeStateAfterRegistryChange();
    notifyListeners();
  }

  bool _assertValidMetas(List<ListboxItemMeta> metas) {
    final seen = <ListboxItemId>{};
    for (final meta in metas) {
      if (!seen.add(meta.id)) {
        assert(false, 'ListboxController: duplicate id ${meta.id}.');
        return false;
      }
      final normalized = HeadlessTypeaheadLabel.normalize(meta.typeaheadLabel);
      if (normalized != meta.typeaheadLabel) {
        assert(
          false,
          'ListboxController: typeaheadLabel must be normalized.',
        );
        return false;
      }
    }
    return true;
  }
}
