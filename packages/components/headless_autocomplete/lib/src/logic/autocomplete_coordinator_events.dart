part of 'autocomplete_coordinator.dart';

extension _AutocompleteCoordinatorEvents<T> on AutocompleteCoordinator<T> {
  void _attachInputListeners() {
    _inputOwner.focusHover.addListener(_handleFocusHoverChanged);
  }

  void _notifyStateChanged() {
    if (_menuCoordinator.isMenuOpen && !_menuRefreshScheduled) {
      _menuRefreshScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _menuRefreshScheduled = false;
        if (_isDisposed) return;
        if (!_menuCoordinator.isMenuOpen) return;
        _menuCoordinator.refreshMenuState();
      });
    }
    _notifyWidgetStateChanged();
  }

  void _handleFocusHoverChanged() {
    _notifyStateChanged();
  }

  void _handleFocusChanged(bool hasFocus) {
    if (!hasFocus) {
      if (_config.selectionMode is AutocompleteMultipleSelectionMode<T> &&
          _menuCoordinator.isMenuOpen) {
        autocompleteDebugLog('focusLostIgnored: multiple+menuOpen');
        return;
      }
      autocompleteDebugLog(
        'focusLost: menuOpen=${_menuCoordinator.isMenuOpen} dismissed=${_menuCoordinator.wasDismissed}',
      );
      _scheduleCloseMenu(programmatic: _config.isDisabled);
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
      final hasRemoteSource = _sourceController != null;
      if (!isComposing || !hasRemoteSource) {
        _syncOptions();
      }
      if (!isComposing) {
        _menuCoordinator.resetDismissed();
        _handleOpenOnInput();
      }
      _menuCoordinator.refreshMenuState();
    }
    _notifyStateChanged();
  }

  void _handleOpenOnInput() {
    if (!_config.openOnInput || _config.isDisabled) return;
    _openMenu();
  }

  void _openMenu() {
    if (_menuCoordinator.hasOverlay || _config.isDisabled) return;
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
    if (_config.closeOnSelected) return;
    _syncOptions();
    if (_config.selectionMode is AutocompleteMultipleSelectionMode<T>) {
      focusNode.requestFocus();
    }
  }

  void _highlightIndex(int index) {
    _selection.highlightIndex(index);
    _menuCoordinator.updateHighlight(_selection.highlightedIndex);
  }
}
