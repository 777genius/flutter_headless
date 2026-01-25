import 'listbox_item_id.dart';
import 'listbox_item_meta.dart';

final class ItemRegistry {
  ItemRegistry();

  final Map<ListboxItemId, _RegisteredItem> _items = {};
  List<ListboxItemId> _orderedIdsCache = const [];
  List<ListboxItemId> _orderedEnabledIdsCache = const [];
  bool _isDirty = true;

  void register(ListboxItemMeta meta, {required int order}) {
    _items[meta.id] = _RegisteredItem(meta: meta, order: order);
    _isDirty = true;
  }

  void unregister(ListboxItemId id) {
    if (_items.remove(id) != null) {
      _isDirty = true;
    }
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    _isDirty = true;
  }

  ListboxItemMeta? getMeta(ListboxItemId id) => _items[id]?.meta;

  bool contains(ListboxItemId id) => _items.containsKey(id);

  List<ListboxItemId> get orderedIds {
    _ensureCaches();
    return _orderedIdsCache;
  }

  List<ListboxItemId> get orderedEnabledIds {
    _ensureCaches();
    return _orderedEnabledIdsCache;
  }

  void _ensureCaches() {
    if (!_isDirty) return;
    final entries = _items.values.toList(growable: false)
      ..sort((a, b) => a.order.compareTo(b.order));
    final ids = <ListboxItemId>[];
    final enabled = <ListboxItemId>[];
    for (final entry in entries) {
      final id = entry.meta.id;
      ids.add(id);
      if (!entry.meta.isDisabled) {
        enabled.add(id);
      }
    }
    _orderedIdsCache = List<ListboxItemId>.unmodifiable(ids);
    _orderedEnabledIdsCache = List<ListboxItemId>.unmodifiable(enabled);
    _isDirty = false;
  }
}

final class _RegisteredItem {
  const _RegisteredItem({
    required this.meta,
    required this.order,
  });

  final ListboxItemMeta meta;
  final int order;
}

