part of 'autocomplete_coordinator.dart';

extension _AutocompleteCoordinatorSync<T> on AutocompleteCoordinator<T> {
  void _handleSourceStateChanged() {
    final sourceController = _sourceController;
    if (sourceController == null) return;
    final resultsWithFeatures = sourceController.resultsWithFeatures;
    final featureById = <ListboxItemId, HeadlessItemFeatures?>{};
    for (final record in resultsWithFeatures) {
      final (value, features) = record;
      featureById[_config.itemAdapter.id(value)] = features;
    }

    final selectedIds = switch (_config.selectionMode) {
      AutocompleteMultipleSelectionMode<T>() => _selection.selectedIds,
      _ => const <ListboxItemId>[],
    };
    final snapshot = _optionsController.resolveFromOptions(
      options: resultsWithFeatures.map((result) => result.$1).toList(),
      additionalFeaturesById: featureById,
      maxOptions: _config.maxOptions,
      selectedIds: selectedIds,
      hideSelectedOptions: _config.hideSelectedOptions,
      pinSelectedOptions: _config.pinSelectedOptions,
    );

    _options = snapshot.options;
    _items = snapshot.items;
    _selection.updateOptions(options: _options, items: _items);
    _menuCoordinator.refreshMenuState();
    _notifyStateChanged();
  }

  void _syncOptions({
    RAutocompleteRemoteTrigger trigger = RAutocompleteRemoteTrigger.input,
    TextEditingValue? textOverride,
  }) {
    final effectiveText = textOverride ?? controller.value;
    final sourceController = _sourceController;
    if (sourceController != null) {
      sourceController.resolve(text: effectiveText, trigger: trigger);
      return;
    }

    final selectedIds = switch (_config.selectionMode) {
      AutocompleteMultipleSelectionMode<T>() => _selection.selectedIds,
      _ => const <ListboxItemId>[],
    };
    final snapshot = _optionsController.resolve(
      text: effectiveText,
      optionsBuilder: _config.optionsBuilder,
      maxOptions: _config.maxOptions,
      selectedIds: selectedIds,
      hideSelectedOptions: _config.hideSelectedOptions,
      pinSelectedOptions: _config.pinSelectedOptions,
      cacheEnabled: _config.localCacheEnabled,
    );
    final optionsChanged = !identical(snapshot.options, _options) ||
        !identical(snapshot.items, _items);
    if (!optionsChanged) return;
    _options = snapshot.options;
    _items = snapshot.items;
    _selection.updateOptions(options: _options, items: _items);
    _menuCoordinator.refreshMenuState();
  }

  void _scheduleSyncOptions() {
    if (_syncScheduled) return;
    _syncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncScheduled = false;
      if (_isDisposed) return;
      _syncOptions();
    });
  }

  TextEditingValue? _textOverrideForShowAllOnOpenIfNeeded({
    required RAutocompleteRemoteTrigger trigger,
  }) {
    if (!_shouldShowAllOnOpen(trigger: trigger)) return null;
    final committed = _selection.committedText;
    if (committed == null || committed.isEmpty) return null;
    if (controller.text != committed) return null;
    return const TextEditingValue(
      text: '',
      selection: TextSelection.collapsed(offset: 0),
      composing: TextRange.empty,
    );
  }

  bool _shouldShowAllOnOpen({
    required RAutocompleteRemoteTrigger trigger,
  }) {
    if (trigger != RAutocompleteRemoteTrigger.focus &&
        trigger != RAutocompleteRemoteTrigger.tap) {
      return false;
    }
    if (_config.selectionMode is AutocompleteMultipleSelectionMode<T>) {
      return false;
    }
    return _selection.selectedIndex != null;
  }

  int _selectionSignature({
    required AutocompleteSelectionMode<T> mode,
    required HeadlessItemAdapter<T> itemAdapter,
  }) {
    return switch (mode) {
      AutocompleteMultipleSelectionMode<T>(:final selectedValues) =>
        Object.hashAll(selectedValues.map(itemAdapter.id)),
      _ => 0,
    };
  }
}
