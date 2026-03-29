import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../sources/r_autocomplete_remote_query.dart';
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

part 'autocomplete_coordinator_events.dart';
part 'autocomplete_coordinator_factories.dart';
part 'autocomplete_coordinator_sync.dart';

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

  void suppressOpenOnFocusOnce() {
    _suppressOpenOnFocusOnce = true;
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
}
