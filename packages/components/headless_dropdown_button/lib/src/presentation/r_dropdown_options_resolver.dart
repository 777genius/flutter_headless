import 'package:headless_foundation/headless_foundation.dart';

import 'r_dropdown_option.dart';

final class RDropdownOptionsResolver<T> {
  List<RDropdownOption<T>>? _cachedOptions;
  List<T>? _cachedItems;
  HeadlessItemAdapter<T>? _cachedAdapter;
  int _cachedItemsLength = -1;
  int _cachedItemsSignature = 0;
  List<RDropdownOption<T>>? _cachedExplicitOptions;
  List<RDropdownOption<T>>? _cachedExplicitSource;
  int _cachedExplicitLength = -1;
  int _cachedExplicitSignature = 0;
  List<HeadlessListItemModel>? _cachedRenderItems;
  List<RDropdownOption<T>>? _cachedRenderSource;
  int _cachedRenderLength = -1;
  int _cachedRenderSignature = 0;

  List<RDropdownOption<T>> resolve({
    required List<T>? items,
    required HeadlessItemAdapter<T>? itemAdapter,
    required List<RDropdownOption<T>>? options,
  }) {
    final explicitOptions = options;
    if (explicitOptions != null) {
      final signature = _signatureForOptions(explicitOptions);
      if (identical(_cachedExplicitSource, explicitOptions) &&
          _cachedExplicitLength == explicitOptions.length &&
          _cachedExplicitSignature == signature &&
          _cachedExplicitOptions != null) {
        return _cachedExplicitOptions!;
      }

      final built = List<RDropdownOption<T>>.unmodifiable(explicitOptions);
      _cachedExplicitOptions = built;
      _cachedExplicitSource = explicitOptions;
      _cachedExplicitLength = explicitOptions.length;
      _cachedExplicitSignature = signature;
      _cachedOptions = null;
      _cachedItems = null;
      _cachedAdapter = null;
      _cachedItemsLength = -1;
      _cachedItemsSignature = 0;
      assert(_assertUniqueOptionIds(built));
      return built;
    }

    final values = items!;
    final adapter = itemAdapter!;

    if (identical(_cachedItems, values) &&
        identical(_cachedAdapter, adapter) &&
        _cachedItemsLength == values.length &&
        _cachedOptions != null) {
      final signature = _signatureForItems(values);
      if (_cachedItemsSignature == signature) {
        return _cachedOptions!;
      }
    }

    final signature = _signatureForItems(values);
    final built = List<RDropdownOption<T>>.unmodifiable(
      values.map((value) => RDropdownOption(
            value: value,
            item: adapter.build(value),
          )),
    );

    _cachedItems = values;
    _cachedAdapter = adapter;
    _cachedItemsLength = values.length;
    _cachedItemsSignature = signature;
    _cachedOptions = built;
    assert(_assertUniqueOptionIds(built));
    return built;
  }

  List<HeadlessListItemModel> itemsForRender({
    required List<T>? items,
    required HeadlessItemAdapter<T>? itemAdapter,
    required List<RDropdownOption<T>>? options,
  }) {
    final resolved = resolve(
      items: items,
      itemAdapter: itemAdapter,
      options: options,
    );
    if (identical(resolved, _cachedRenderSource) &&
        _cachedRenderItems != null &&
        _cachedRenderLength == resolved.length) {
      final signature = _signatureForOptions(resolved);
      if (_cachedRenderSignature == signature) {
        return _cachedRenderItems!;
      }
    }

    final signature = _signatureForOptions(resolved);
    final built = List<HeadlessListItemModel>.unmodifiable(
      resolved.map((option) => option.item),
    );
    _cachedRenderSource = resolved;
    _cachedRenderItems = built;
    _cachedRenderLength = resolved.length;
    _cachedRenderSignature = signature;
    return built;
  }

  int _signatureForItems(List<T> values) {
    return Object.hashAll(values);
  }

  int _signatureForOptions(List<RDropdownOption<T>> options) {
    return Object.hashAll(
      options.map((option) => Object.hash(option.value, option.item)),
    );
  }

  ListboxItemId? selectedId({
    required T? value,
    required List<T>? items,
    required HeadlessItemAdapter<T>? itemAdapter,
    required List<RDropdownOption<T>>? options,
  }) {
    if (value == null) return null;
    if (options != null) {
      for (final option in resolve(
        items: items,
        itemAdapter: itemAdapter,
        options: options,
      )) {
        if (option.value == value) return option.item.id;
      }
      return null;
    }

    final adapter = itemAdapter;
    if (adapter == null) return null;
    return adapter.id(value);
  }

  bool _assertUniqueOptionIds(List<RDropdownOption<T>> options) {
    final seen = <ListboxItemId>{};
    for (final option in options) {
      if (!seen.add(option.item.id)) {
        assert(
          false,
          'RDropdownButton options contain duplicate id: ${option.item.id}',
        );
        return false;
      }
    }
    return true;
  }
}
