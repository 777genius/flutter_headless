import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'autocomplete_item_model_factory.dart';

@immutable
final class _OptionWithId<T> {
  const _OptionWithId({
    required this.value,
    required this.id,
  });

  final T value;
  final ListboxItemId id;
}

@immutable
final class AutocompleteOptionsSnapshot<T> {
  const AutocompleteOptionsSnapshot({
    required this.options,
    required this.items,
  });

  final List<T> options;
  final List<HeadlessListItemModel> items;
}

/// Caches optionsBuilder output and item mapping.
final class AutocompleteOptionsController<T> {
  AutocompleteOptionsController({
    required HeadlessItemAdapter<T> itemAdapter,
  }) : _itemAdapter = itemAdapter;

  HeadlessItemAdapter<T> _itemAdapter;

  String _lastText = '';
  Object? _lastBuilder;
  int? _lastMaxOptions;
  int _lastSelectionSignature = -1;
  bool _lastHideSelected = false;
  bool _lastPinSelected = false;

  List<T> _cachedOptions = const [];
  int _cachedOptionsSignature = -1;

  List<HeadlessListItemModel> _cachedItems = const [];
  int _cachedItemsSignature = -1;
  int _cachedItemsOptionsSignature = -1;

  void updateItemAdapter(HeadlessItemAdapter<T> adapter) {
    if (identical(_itemAdapter, adapter)) return;
    _itemAdapter = adapter;
    _cachedOptionsSignature = -1;
    _cachedItemsSignature = -1;
  }

  AutocompleteOptionsSnapshot<T> resolve({
    required TextEditingValue text,
    required Iterable<T> Function(TextEditingValue value) optionsBuilder,
    required int? maxOptions,
    required Iterable<ListboxItemId> selectedIds,
    required bool hideSelectedOptions,
    required bool pinSelectedOptions,
    required bool cacheEnabled,
  }) {
    final nextText = text.text;
    final builderChanged = !identical(_lastBuilder, optionsBuilder);
    final maxChanged = _lastMaxOptions != maxOptions;
    final textChanged = _lastText != nextText;
    final selectionSig = Object.hashAll(selectedIds);
    final selectionChanged = _lastSelectionSignature != selectionSig;
    final hideChanged = _lastHideSelected != hideSelectedOptions;
    final pinChanged = _lastPinSelected != pinSelectedOptions;

    if (!cacheEnabled ||
        builderChanged ||
        maxChanged ||
        textChanged ||
        selectionChanged ||
        hideChanged ||
        pinChanged) {
      _cachedOptions = _resolveOptions(
        optionsBuilder: optionsBuilder,
        text: text,
        maxOptions: maxOptions,
        selectedIds: selectedIds,
        hideSelectedOptions: hideSelectedOptions,
        pinSelectedOptions: pinSelectedOptions,
      );
      _cachedOptionsSignature = _signatureForOptions(_cachedOptions);
      _lastText = nextText;
      _lastBuilder = optionsBuilder;
      _lastMaxOptions = maxOptions;
      _lastSelectionSignature = selectionSig;
      _lastHideSelected = hideSelectedOptions;
      _lastPinSelected = pinSelectedOptions;
    }

    final optionsSignature = _cachedOptionsSignature;
    if (!cacheEnabled ||
        _cachedItemsSignature == -1 ||
        _cachedItemsOptionsSignature != optionsSignature) {
      final items = _buildItems(
        options: _cachedOptions,
        additionalFeaturesById: const <ListboxItemId, HeadlessItemFeatures?>{},
      );
      _cachedItems = items;
      _cachedItemsSignature = Object.hashAll(items);
      _cachedItemsOptionsSignature = optionsSignature;
    }

    return AutocompleteOptionsSnapshot(
      options: _cachedOptions,
      items: _cachedItems,
    );
  }

  AutocompleteOptionsSnapshot<T> resolveFromOptions({
    required List<T> options,
    required Map<ListboxItemId, HeadlessItemFeatures?> additionalFeaturesById,
    required int? maxOptions,
    required Iterable<ListboxItemId> selectedIds,
    required bool hideSelectedOptions,
    required bool pinSelectedOptions,
  }) {
    final limited = _applyMax(options, maxOptions);
    final optionsWithIds = _mapOptionsToIds(limited);
    final unique = _dedupeById(optionsWithIds);
    final processed = _postProcess(
      options: unique,
      selectedIds: selectedIds,
      hideSelectedOptions: hideSelectedOptions,
      pinSelectedOptions: pinSelectedOptions,
    );
    final finalOptions = processed.map((e) => e.value).toList();
    final items = _buildItems(
      options: finalOptions,
      additionalFeaturesById: additionalFeaturesById,
    );
    return AutocompleteOptionsSnapshot(options: finalOptions, items: items);
  }

  void _reportDuplicateId(ListboxItemId id) {
    assert(() {
      debugPrint(
        '[headless_autocomplete] RAutocomplete: duplicate itemAdapter.id detected: $id. '
        'Subsequent duplicates are ignored.',
      );
      return true;
    }());
  }

  List<T> _resolveOptions({
    required Iterable<T> Function(TextEditingValue value) optionsBuilder,
    required TextEditingValue text,
    required int? maxOptions,
    required Iterable<ListboxItemId> selectedIds,
    required bool hideSelectedOptions,
    required bool pinSelectedOptions,
  }) {
    final raw = optionsBuilder(text);
    final limited = _applyMax(raw, maxOptions);
    final optionsWithIds = _mapOptionsToIds(limited);
    final unique = _dedupeById(optionsWithIds);
    final processed = _postProcess(
      options: unique,
      selectedIds: selectedIds,
      hideSelectedOptions: hideSelectedOptions,
      pinSelectedOptions: pinSelectedOptions,
    );
    return processed.map((e) => e.value).toList();
  }

  List<T> _applyMax(Iterable<T> raw, int? maxOptions) {
    if (maxOptions == null) return List<T>.from(raw);
    if (maxOptions <= 0) return <T>[];
    return raw.take(maxOptions).toList();
  }

  List<_OptionWithId<T>> _postProcess({
    required List<_OptionWithId<T>> options,
    required Iterable<ListboxItemId> selectedIds,
    required bool hideSelectedOptions,
    required bool pinSelectedOptions,
  }) {
    final selected = selectedIds.toSet();
    if (selected.isEmpty) return options;
    if (hideSelectedOptions) {
      return options.where((o) => !selected.contains(o.id)).toList();
    }
    if (pinSelectedOptions) {
      final pinned = <_OptionWithId<T>>[];
      final rest = <_OptionWithId<T>>[];
      for (final o in options) {
        (selected.contains(o.id) ? pinned : rest).add(o);
      }
      return [...pinned, ...rest];
    }
    return options;
  }

  int _signatureForOptions(List<T> options) {
    // IMPORTANT:
    // Do NOT rely on `T`'s `==/hashCode` here.
    //
    // Many domain objects implement equality by `id` only. In that case,
    // `Object.hashAll(options)` would stay the same even if UI-relevant fields
    // (like label) change between rebuilds, causing stale menu items.
    return Object.hashAll(
      options.map(
        (o) => Object.hash(
          _itemAdapter.id(o),
          _itemAdapter.primaryText(o),
          _itemAdapter.isDisabled?.call(o) ?? false,
          _itemAdapter.semanticsLabel?.call(o),
          _itemAdapter.searchText?.call(o),
        ),
      ),
    );
  }

  List<_OptionWithId<T>> _mapOptionsToIds(List<T> options) {
    final result = <_OptionWithId<T>>[];
    for (final o in options) {
      final id = _itemAdapter.id(o);
      assert(() {
        final again = _itemAdapter.id(o);
        if (again != id) {
          debugPrint(
            '[headless_autocomplete] RAutocomplete: unstable itemAdapter.id detected. '
            'Value: $o, first: $id, second: $again.',
          );
        }
        return true;
      }());
      result.add(_OptionWithId(value: o, id: id));
    }
    return result;
  }

  List<_OptionWithId<T>> _dedupeById(List<_OptionWithId<T>> options) {
    if (options.isEmpty) return options;
    final seen = <ListboxItemId>{};
    final result = <_OptionWithId<T>>[];
    for (final o in options) {
      if (!seen.add(o.id)) {
        _reportDuplicateId(o.id);
        continue;
      }
      result.add(o);
    }
    return result;
  }

  List<HeadlessListItemModel> _buildItems({
    required List<T> options,
    required Map<ListboxItemId, HeadlessItemFeatures?> additionalFeaturesById,
  }) {
    final withIds = _dedupeById(_mapOptionsToIds(options));
    return withIds
        .map(
          (e) => buildAutocompleteItemModel<T>(
            adapter: _itemAdapter,
            value: e.value,
            id: e.id,
            additionalFeatures: additionalFeaturesById[e.id],
          ),
        )
        .toList();
  }
}
