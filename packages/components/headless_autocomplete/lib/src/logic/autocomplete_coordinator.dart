import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../sources/r_autocomplete_remote_query.dart';
import '../sources/r_autocomplete_source.dart';
import 'autocomplete_config.dart';
import 'autocomplete_input_owner.dart';
import 'autocomplete_keyboard_handler.dart';
import 'autocomplete_menu_coordinator.dart';
import 'autocomplete_options_controller.dart';
import 'autocomplete_debug_log.dart';
import 'autocomplete_selection_controller.dart';
import 'autocomplete_multi_selection_controller.dart';
import 'autocomplete_selection_mode.dart';
import 'autocomplete_source_controller.dart';

final class AutocompleteCoordinator<T> {
  AutocompleteCoordinator({
    required BuildContext Function() contextGetter,
    required VoidCallback notifyStateChanged,
    required Rect Function() anchorRectGetter,
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required TextEditingValue? initialValue,
    required AutocompleteConfig<T> config,
  })  : _contextGetter = contextGetter,
        _notifyWidgetStateChanged = notifyStateChanged,
        _anchorRectGetter = anchorRectGetter,
        _config = config {
    _isDisposed = false;
    _inputOwner = _createInputOwner(
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
    );
    _optionsController = _createOptionsController();
    _selection = _createSelectionController();
    _menuCoordinator = _createMenuCoordinator();
    _keyboardHandler = _createKeyboardHandler();
    _attachInputListeners();
    _initializeSourceController();
    _syncOptions();
  }

  final BuildContext Function() _contextGetter;
  final VoidCallback _notifyWidgetStateChanged;
  final Rect Function() _anchorRectGetter;

  late final AutocompleteInputOwner _inputOwner;
  late final AutocompleteOptionsController<T> _optionsController;
  late AutocompleteSelectionController<T> _selection;
  late final AutocompleteKeyboardHandler _keyboardHandler;
  late final AutocompleteMenuCoordinator _menuCoordinator;
  AutocompleteSourceController<T>? _sourceController;

  AutocompleteConfig<T> _config;
  bool _isDisposed = false;
  bool _syncScheduled = false;
  bool _closeScheduled = false;
  bool _menuRefreshScheduled = false;
  bool _suppressOpenOnFocusOnce = false;

  List<T> _options = const [];
  List<HeadlessListItemModel> _items = const [];

  TextEditingController get controller => _inputOwner.controller;
  FocusNode get focusNode => _inputOwner.focusNode;
  HeadlessFocusHoverController get focusHover => _inputOwner.focusHover;
  bool get isMenuOpen => _menuCoordinator.isMenuOpen;
  bool get isDisabled => _config.isDisabled;

  /// A11y: label of the currently highlighted option (active descendant).
  ///
  /// Used to announce highlighted option changes while keeping input focus on the
  /// text field (combobox/listbox semantics).
  String? get activeDescendantSemanticsLabel {
    final index = _selection.highlightedIndex;
    if (index == null) return null;
    if (index < 0 || index >= _items.length) return null;
    final item = _items[index];
    return item.semanticsLabel ?? item.primaryText;
  }

  KeyEventResult handleKeyEvent(FocusNode node, KeyEvent event) {
    return _keyboardHandler.handle(node, event);
  }

  void handleTapContainer() {
    if (_config.isDisabled) return;
    _menuCoordinator.resetDismissed();
    focusNode.requestFocus();
    if (!_config.openOnTap) return;
    _syncOptions(
      trigger: RAutocompleteRemoteTrigger.tap,
      textOverride: _textOverrideForShowAllOnOpenIfNeeded(
        trigger: RAutocompleteRemoteTrigger.tap,
      ),
    );
    _openMenu();
  }

  void requestFocus({required bool suppressOpenOnFocusOnce}) {
    if (suppressOpenOnFocusOnce) {
      _suppressOpenOnFocusOnce = true;
    }
    focusNode.requestFocus();
  }

  void setSelectedIdsOptimistic(Set<ListboxItemId> ids) {
    _selection.setSelectedIdsOptimistic(ids);
    _syncOptions();
    _menuCoordinator.refreshMenuState();
  }

  void updateConfig({
    required AutocompleteConfig<T> config,
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required TextEditingValue? initialValue,
  }) {
    final prevConfig = _config;
    _config = config;
    _inputOwner.update(
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      isDisabled: config.isDisabled,
    );
    _selection.updateController(_inputOwner.controller);

    final modeChanged = prevConfig.selectionMode.runtimeType !=
        config.selectionMode.runtimeType;
    if (modeChanged) {
      _selection.dispose();
      _selection = _createSelectionController();
    } else {
      _selection.updateSelectionMode(
        mode: config.selectionMode,
        clearQueryOnSelection: config.clearQueryOnSelection,
      );
    }

    final prevSelectionSig = _selectionSignature(
      mode: prevConfig.selectionMode,
      itemAdapter: prevConfig.itemAdapter,
    );
    final nextSelectionSig = _selectionSignature(
      mode: config.selectionMode,
      itemAdapter: config.itemAdapter,
    );

    if (prevConfig.isDisabled != config.isDisabled) {
      _scheduleCloseMenu(programmatic: true);
    }
    if (!identical(prevConfig.itemAdapter, config.itemAdapter)) {
      _optionsController.updateItemAdapter(config.itemAdapter);
      _selection.updateItemAdapter(config.itemAdapter);
      _scheduleSyncOptions();
    }
    if (!identical(prevConfig.optionsBuilder, config.optionsBuilder) ||
        prevConfig.maxOptions != config.maxOptions) {
      _scheduleSyncOptions();
    }
    if (prevConfig.hideSelectedOptions != config.hideSelectedOptions ||
        prevConfig.pinSelectedOptions != config.pinSelectedOptions) {
      _scheduleSyncOptions();
    }

    // Critical: selection changes (e.g. chip removal) must refresh options/menu
    // because hideSelectedOptions/pinSelectedOptions and checked state depend on it.
    //
    // Must be scheduled (not immediate) to avoid triggering rebuilds during
    // didUpdateWidget/build.
    if (prevSelectionSig != nextSelectionSig) {
      _scheduleSyncOptions();
    }
  }

  void dispose() {
    _isDisposed = true;
    _sourceController?.dispose();
    _menuCoordinator.dispose();
    _selection.dispose();
    _inputOwner.focusHover.removeListener(_handleFocusHoverChanged);
    _inputOwner.dispose();
  }

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

    // Only create controller for remote/hybrid sources
    if (source is! RAutocompleteRemoteSource<T> &&
        source is! RAutocompleteHybridSource<T>) {
      return;
    }

    _sourceController = AutocompleteSourceController<T>(
      source: source,
      itemAdapter: _config.itemAdapter,
      onStateChanged: _handleSourceStateChanged,
    );
  }

  void _handleSourceStateChanged() {
    final sourceController = _sourceController;
    if (sourceController == null) return;

    final resultsWithFeatures = sourceController.resultsWithFeatures;

    final featureById = <ListboxItemId, HeadlessItemFeatures?>{};
    for (final record in resultsWithFeatures) {
      final (value, features) = record;
      final id = _config.itemAdapter.id(value);
      featureById[id] = features;
    }

    final selectedIds = switch (_config.selectionMode) {
      AutocompleteMultipleSelectionMode<T>() => _selection.selectedIds,
      _ => const <ListboxItemId>[],
    };

    final snapshot = _optionsController.resolveFromOptions(
      options: resultsWithFeatures.map((r) => r.$1).toList(),
      additionalFeaturesById: featureById,
      maxOptions: _config.maxOptions,
      selectedIds: selectedIds,
      hideSelectedOptions: _config.hideSelectedOptions,
      pinSelectedOptions: _config.pinSelectedOptions,
    );

    _options = snapshot.options;
    _items = snapshot.items;
    _selection.updateOptions(options: _options, items: _items);

    // Refresh menu and notify
    _menuCoordinator.refreshMenuState();
    _notifyStateChanged();
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

  void _attachInputListeners() {
    _inputOwner.focusHover.addListener(_handleFocusHoverChanged);
  }

  void _notifyStateChanged() {
    if (_menuCoordinator.isMenuOpen) {
      if (!_menuRefreshScheduled) {
        _menuRefreshScheduled = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _menuRefreshScheduled = false;
          if (_isDisposed) return;
          if (!_menuCoordinator.isMenuOpen) return;
          _menuCoordinator.refreshMenuState();
        });
      }
    }
    _notifyWidgetStateChanged();
  }

  void _handleFocusHoverChanged() {
    _notifyStateChanged();
  }

  void _handleFocusChanged(bool hasFocus) {
    if (!hasFocus) {
      // Multiple selection: do not close the menu on focus loss.
      //
      // Rationale: taps inside the overlay may temporarily move focus away from
      // the input on some platforms. In multi-select, the menu must remain open
      // for consecutive selections. Outside taps are handled by the overlay's
      // dismiss policy, and Tab/Escape are handled by the keyboard handler.
      if (_config.selectionMode is AutocompleteMultipleSelectionMode<T> &&
          _menuCoordinator.isMenuOpen) {
        autocompleteDebugLog('focusLostIgnored: multiple+menuOpen');
        return;
      }
      autocompleteDebugLog(
        'focusLost: menuOpen=${_menuCoordinator.isMenuOpen} dismissed=${_menuCoordinator.wasDismissed}',
      );
      // Focus loss should behave like a user-driven dismiss:
      // - prevents immediate reopen via openOnFocus
      // - matches Tab / click-away expectations
      //
      // Exception: when disabled, treat as programmatic.
      final programmatic = _config.isDisabled;
      _scheduleCloseMenu(programmatic: programmatic);
      return;
    }
    if (_suppressOpenOnFocusOnce) {
      _suppressOpenOnFocusOnce = false;
      return;
    }
    if (_config.isDisabled ||
        !_config.openOnFocus ||
        _menuCoordinator.wasDismissed) {
      return;
    }
    _syncOptions(
      trigger: RAutocompleteRemoteTrigger.focus,
      textOverride: _textOverrideForShowAllOnOpenIfNeeded(
        trigger: RAutocompleteRemoteTrigger.focus,
      ),
    );
    _openMenu();
  }

  void _handleControllerChange() {
    final value = controller.value;
    final isComposing = value.composing.isValid && !value.composing.isCollapsed;

    final textChanged = _selection.handleTextChanged(value);
    if (textChanged) {
      // For remote sources: skip load during IME composing to avoid
      // unnecessary network requests for intermediate text.
      // For local sources: always sync (fast, no network).
      final hasRemoteSource = _sourceController != null;
      if (!isComposing || !hasRemoteSource) {
        _syncOptions();
      }

      // IME composing updates should not "undismiss" the menu. Otherwise a user
      // can dismiss (e.g. outside tap), keep composing, and the menu will later
      // reopen automatically when composing ends.
      if (!isComposing) {
        _menuCoordinator.resetDismissed();
        _handleOpenOnInput();
      }
    }
    if (textChanged) _menuCoordinator.refreshMenuState();
    _notifyStateChanged();
  }

  void _handleOpenOnInput() {
    if (!_config.openOnInput || _config.isDisabled) return;
    _openMenu();
  }

  void _openMenu() {
    if (_menuCoordinator.hasOverlay) return;
    if (_config.isDisabled) return;
    _menuCoordinator.openMenu();
  }

  void _closeMenu({required bool programmatic}) {
    if (_menuCoordinator.isMenuOpen) {
      _selection.resetTypeahead();
    }
    _menuCoordinator.closeMenu(programmatic: programmatic);
  }

  void _scheduleCloseMenu({required bool programmatic}) {
    if (_closeScheduled) return;
    _closeScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _closeScheduled = false;
      if (_isDisposed) return;

      // Critical: focus can transiently drop during pointer interactions.
      // If focus is already back, do not close.
      if (!programmatic && focusNode.hasFocus) {
        autocompleteDebugLog('closeCancelled: focusRestored');
        return;
      }

      _closeMenu(programmatic: programmatic);
    });
  }

  void _selectIndex(int index) {
    if (_config.isDisabled) return;
    autocompleteDebugLog(
      'selectIndex: $index menuOpen=${_menuCoordinator.isMenuOpen} closeOnSelected=${_config.closeOnSelected}',
    );
    _selection.selectByIndex(
      index: index,
      closeOnSelected: _config.closeOnSelected,
      closeMenu: () => _closeMenu(programmatic: true),
    );
    _menuCoordinator.refreshMenuState();
    if (!_config.closeOnSelected) {
      _syncOptions();
      // Keep focus on input after selection in multiple mode, otherwise some
      // platforms may drop focus when tapping menu items.
      if (_config.selectionMode is AutocompleteMultipleSelectionMode<T>) {
        focusNode.requestFocus();
      }
    }
  }

  void _highlightIndex(int index) {
    _selection.highlightIndex(index);
    _menuCoordinator.updateHighlight(_selection.highlightedIndex);
  }

  void _syncOptions({
    RAutocompleteRemoteTrigger trigger = RAutocompleteRemoteTrigger.input,
    TextEditingValue? textOverride,
  }) {
    final effectiveText = textOverride ?? controller.value;
    // For remote/hybrid sources, trigger source controller
    final sourceController = _sourceController;
    if (sourceController != null) {
      sourceController.resolve(
        text: effectiveText,
        trigger: trigger,
      );
      // Source controller will notify via _handleSourceStateChanged
      // For hybrid, local results are already handled by source controller
      return;
    }

    // Local-only source: use traditional options controller
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

    // Only when the input still shows the committed value:
    // user hasn't started editing yet.
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
    // This behavior is primarily for single-select "committed selection"
    // cases (text equals chosen option). Multiple mode typically clears query.
    if (_config.selectionMode is AutocompleteMultipleSelectionMode<T>)
      return false;
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
