import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../sources/r_autocomplete_remote_query.dart';

final class AutocompleteKeyboardHandler {
  AutocompleteKeyboardHandler({
    required bool Function() isDisabled,
    required bool Function() isMenuOpen,
    required bool Function() hasOptions,
    required bool Function() isComposing,
    required void Function(RAutocompleteRemoteTrigger trigger) syncOptions,
    required VoidCallback openMenu,
    required void Function({required bool programmatic}) closeMenu,
    required VoidCallback resetDismissed,
    required VoidCallback refreshMenuState,
    required VoidCallback navigateUp,
    required VoidCallback navigateDown,
    required VoidCallback navigateToFirst,
    required VoidCallback navigateToLast,
    required VoidCallback resetTypeahead,
    required int? Function() highlightedIndex,
    required ValueChanged<int> selectIndex,
    required bool Function() isQueryEmpty,
    required bool Function() removeLastSelected,
  })  : _isDisabled = isDisabled,
        _isMenuOpen = isMenuOpen,
        _hasOptions = hasOptions,
        _isComposing = isComposing,
        _syncOptions = syncOptions,
        _openMenu = openMenu,
        _closeMenu = closeMenu,
        _resetDismissed = resetDismissed,
        _refreshMenuState = refreshMenuState,
        _navigateUp = navigateUp,
        _navigateDown = navigateDown,
        _navigateToFirst = navigateToFirst,
        _navigateToLast = navigateToLast,
        _resetTypeahead = resetTypeahead,
        _highlightedIndex = highlightedIndex,
        _selectIndex = selectIndex,
        _isQueryEmpty = isQueryEmpty,
        _removeLastSelected = removeLastSelected;

  final bool Function() _isDisabled;
  final bool Function() _isMenuOpen;
  final bool Function() _hasOptions;
  final bool Function() _isComposing;
  final void Function(RAutocompleteRemoteTrigger trigger) _syncOptions;
  final VoidCallback _openMenu;
  final void Function({required bool programmatic}) _closeMenu;
  final VoidCallback _resetDismissed;
  final VoidCallback _refreshMenuState;
  final VoidCallback _navigateUp;
  final VoidCallback _navigateDown;
  final VoidCallback _navigateToFirst;
  final VoidCallback _navigateToLast;
  final VoidCallback _resetTypeahead;
  final int? Function() _highlightedIndex;
  final ValueChanged<int> _selectIndex;
  final bool Function() _isQueryEmpty;
  final bool Function() _removeLastSelected;

  KeyEventResult handle(FocusNode node, KeyEvent event) {
    if (_isDisabled()) return KeyEventResult.ignored;
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowDown) return _handleArrowDown();
    if (key == LogicalKeyboardKey.arrowUp) return _handleArrowUp();
    if (key == LogicalKeyboardKey.home) return _handleHome();
    if (key == LogicalKeyboardKey.end) return _handleEnd();
    if (key == LogicalKeyboardKey.pageUp) return _handlePageUp();
    if (key == LogicalKeyboardKey.pageDown) return _handlePageDown();
    if (key == LogicalKeyboardKey.enter) return _handleEnter();
    if (key == LogicalKeyboardKey.escape) return _handleEscape();
    if (key == LogicalKeyboardKey.tab) return _handleTab();
    if (key == LogicalKeyboardKey.backspace) return _handleBackspace();
    return KeyEventResult.ignored;
  }

  KeyEventResult _handleArrowDown() {
    if (_isComposing()) return KeyEventResult.ignored;
    _resetDismissed();
    _syncOptions(RAutocompleteRemoteTrigger.keyboard);
    if (!_isMenuOpen()) {
      _openMenu();
      return KeyEventResult.handled;
    }
    if (!_hasOptions()) return KeyEventResult.ignored;
    _navigateDown();
    _refreshMenuState();
    return KeyEventResult.handled;
  }

  KeyEventResult _handleArrowUp() {
    if (_isComposing()) return KeyEventResult.ignored;
    _resetDismissed();
    _syncOptions(RAutocompleteRemoteTrigger.keyboard);
    if (!_isMenuOpen()) {
      _openMenu();
      return KeyEventResult.handled;
    }
    if (!_hasOptions()) return KeyEventResult.ignored;
    _navigateUp();
    _refreshMenuState();
    return KeyEventResult.handled;
  }

  KeyEventResult _handleEnter() {
    if (_isComposing()) return KeyEventResult.ignored;
    if (!_isMenuOpen()) return KeyEventResult.ignored;
    final index = _highlightedIndex();
    if (index == null) return KeyEventResult.ignored;
    _selectIndex(index);
    return KeyEventResult.handled;
  }

  KeyEventResult _handleHome() {
    if (_isComposing()) return KeyEventResult.ignored;
    if (!_isMenuOpen()) return KeyEventResult.ignored;
    if (!_hasOptions()) return KeyEventResult.ignored;
    _navigateToFirst();
    _refreshMenuState();
    return KeyEventResult.handled;
  }

  KeyEventResult _handleEnd() {
    if (_isComposing()) return KeyEventResult.ignored;
    if (!_isMenuOpen()) return KeyEventResult.ignored;
    if (!_hasOptions()) return KeyEventResult.ignored;
    _navigateToLast();
    _refreshMenuState();
    return KeyEventResult.handled;
  }

  KeyEventResult _handlePageUp() {
    // Without viewport knowledge, fall back to "first".
    return _handleHome();
  }

  KeyEventResult _handlePageDown() {
    // Without viewport knowledge, fall back to "last".
    return _handleEnd();
  }

  KeyEventResult _handleEscape() {
    if (_isComposing()) return KeyEventResult.ignored;
    if (!_isMenuOpen()) return KeyEventResult.ignored;
    _resetTypeahead();
    _closeMenu(programmatic: false);
    return KeyEventResult.handled;
  }

  KeyEventResult _handleTab() {
    if (_isMenuOpen()) {
      _resetTypeahead();
      _closeMenu(programmatic: false);
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _handleBackspace() {
    if (!_isQueryEmpty()) return KeyEventResult.ignored;
    final removed = _removeLastSelected();
    return removed ? KeyEventResult.handled : KeyEventResult.ignored;
  }
}
