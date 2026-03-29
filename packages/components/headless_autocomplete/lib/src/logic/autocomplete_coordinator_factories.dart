part of 'autocomplete_coordinator.dart';

extension _AutocompleteCoordinatorFactories<T> on AutocompleteCoordinator<T> {
  AutocompleteInputOwner _createInputOwner({
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required TextEditingValue? initialValue,
  }) {
    return AutocompleteInputOwner(
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      isDisabled: _config.isDisabled,
      onTextChanged: _handleControllerChange,
      onFocusChanged: _handleFocusChanged,
    );
  }

  AutocompleteOptionsController<T> _createOptionsController() {
    return AutocompleteOptionsController(
      itemAdapter: _config.itemAdapter,
    );
  }

  AutocompleteSelectionController<T> _createSelectionController() {
    final mode = _config.selectionMode;
    return switch (mode) {
      AutocompleteSingleSelectionMode<T>() =>
        AutocompleteSingleSelectionController(
          controller: _inputOwner.controller,
          itemAdapter: _config.itemAdapter,
          onSelected: mode.onSelected,
          clearQueryOnSelection: _config.clearQueryOnSelection,
          notifyStateChanged: _notifyStateChanged,
        ),
      AutocompleteMultipleSelectionMode<T>() =>
        AutocompleteMultipleSelectionController(
          controller: _inputOwner.controller,
          itemAdapter: _config.itemAdapter,
          selectedValues: mode.selectedValues,
          onSelectionChanged: mode.onSelectionChanged,
          clearQueryOnSelection: _config.clearQueryOnSelection,
          notifyStateChanged: _notifyStateChanged,
        ),
    };
  }

  AutocompleteMenuCoordinator _createMenuCoordinator() {
    return AutocompleteMenuCoordinator(
      contextGetter: _contextGetter,
      isDisposedGetter: () => _isDisposed,
      anchorRectGetter: _anchorRectGetter,
      anchorFocusNodeGetter: () => _inputOwner.focusNode,
      highlightedIndexGetter: () => _selection.highlightedIndex,
      itemsGetter: () => _items,
      selectedIndexGetter: () => _selection.selectedIndex,
      selectedItemsIndicesGetter: () => _selection.selectedItemsIndices,
      focusHoverGetter: () => _inputOwner.focusHover,
      isDisabledGetter: () => _config.isDisabled,
      menuSlotsGetter: () => _config.menuSlots,
      menuOverridesGetter: () => _config.menuOverrides,
      placeholderGetter: () => _config.placeholder,
      semanticLabelGetter: () => _config.semanticLabel,
      featuresGetter: _getRequestFeatures,
      notifyStateChanged: _notifyStateChanged,
      selectIndex: _selectIndex,
      highlightIndex: _highlightIndex,
    );
  }

  HeadlessRequestFeatures _getRequestFeatures() {
    return _sourceController?.requestFeatures ?? HeadlessRequestFeatures.empty;
  }

  void _initializeSourceController() {
    final source = _config.source;
    if (!_config.needsSourceController) return;
    _sourceController = AutocompleteSourceController<T>(
      source: source,
      itemAdapter: _config.itemAdapter,
      onStateChanged: _handleSourceStateChanged,
    );
  }

  AutocompleteKeyboardHandler _createKeyboardHandler() {
    return AutocompleteKeyboardHandler(
      isDisabled: () => _config.isDisabled,
      isMenuOpen: () => _menuCoordinator.isMenuOpen,
      hasOptions: () => _options.isNotEmpty,
      isComposing: () {
        final value = controller.value;
        return value.composing.isValid && !value.composing.isCollapsed;
      },
      syncOptions: (trigger) => _syncOptions(trigger: trigger),
      openMenu: _openMenu,
      closeMenu: _closeMenu,
      resetDismissed: _menuCoordinator.resetDismissed,
      refreshMenuState: _menuCoordinator.refreshMenuState,
      navigateUp: _selection.navigateUp,
      navigateDown: _selection.navigateDown,
      navigateToFirst: _selection.navigateToFirst,
      navigateToLast: _selection.navigateToLast,
      resetTypeahead: _selection.resetTypeahead,
      highlightedIndex: () => _selection.highlightedIndex,
      selectIndex: _selectIndex,
      isQueryEmpty: () {
        final value = controller.value;
        final isComposing =
            value.composing.isValid && !value.composing.isCollapsed;
        if (isComposing) return false;
        if (!value.selection.isCollapsed) return false;
        return value.text.isEmpty;
      },
      removeLastSelected: _selection.removeLastSelected,
    );
  }
}
