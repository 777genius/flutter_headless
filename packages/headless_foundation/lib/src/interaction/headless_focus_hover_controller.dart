import 'package:flutter/foundation.dart';

import 'headless_focus_hover_state.dart';

/// Shared interaction controller for focus+hover (no press/activation).
///
/// Intended for components like TextField where the input widget owns focus
/// but visuals need consistent hover/focus state tracking.
final class HeadlessFocusHoverController extends ChangeNotifier {
  HeadlessFocusHoverController({
    bool isDisabled = false,
  }) : _state = HeadlessFocusHoverState(isDisabled: isDisabled);

  HeadlessFocusHoverState _state;
  HeadlessFocusHoverState get state => _state;

  void setDisabled(bool isDisabled) {
    if (_state.isDisabled == isDisabled) return;
    _state = _state.copyWith(isDisabled: isDisabled);
    if (isDisabled && _state.isHovered) {
      _state = _state.copyWith(isHovered: false);
    }
    notifyListeners();
  }

  void handleFocusChange(bool focused) {
    if (_state.isFocused == focused) return;
    _state = _state.copyWith(isFocused: focused);
    notifyListeners();
  }

  void handleMouseEnter() {
    if (_state.isDisabled) return;
    if (_state.isHovered) return;
    _state = _state.copyWith(isHovered: true);
    notifyListeners();
  }

  void handleMouseExit() {
    if (!_state.isHovered) return;
    _state = _state.copyWith(isHovered: false);
    notifyListeners();
  }
}

