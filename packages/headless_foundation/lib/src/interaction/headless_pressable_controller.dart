import 'package:flutter/foundation.dart';

import 'headless_pressable_state.dart';
import 'logic/headless_pressable_key_intent.dart';

/// Shared interaction controller for "pressable" surfaces (buttons, dropdown triggers).
///
/// Responsibilities:
/// - Track pressed/hovered/focused/disabled state
/// - Provide a standardized keyboard activation policy (Space/Enter) with anti-repeat
/// - Provide standardized pointer press policy (tap down/up/cancel)
///
/// Non-responsibilities:
/// - Does NOT add Semantics (component owns Semantics)
/// - Does NOT decide what "activate" means (component provides callbacks)
final class HeadlessPressableController extends ChangeNotifier {
  HeadlessPressableController({
    bool isDisabled = false,
  }) : _state = HeadlessPressableState(isDisabled: isDisabled);

  HeadlessPressableState _state;
  HeadlessPressableState get state => _state;

  // Anti-repeat guards
  bool _spaceDown = false;
  bool _enterDown = false;

  void setDisabled(bool isDisabled) {
    if (_state.isDisabled == isDisabled) return;

    _state = _state.copyWith(isDisabled: isDisabled);

    if (isDisabled) {
      _spaceDown = false;
      _enterDown = false;
      _state = _state.copyWith(isPressed: false);
    }

    notifyListeners();
  }

  void handleFocusChange(bool focused) {
    if (_state.isFocused == focused) return;

    _state = _state.copyWith(isFocused: focused);
    if (!focused) {
      _spaceDown = false;
      _enterDown = false;
      _state = _state.copyWith(isPressed: false);
    }

    notifyListeners();
  }

  void handleMouseEnter() {
    if (_state.isHovered) return;
    _state = _state.copyWith(isHovered: true);
    notifyListeners();
  }

  void handleMouseExit() {
    if (!_state.isHovered) return;
    _state = _state.copyWith(isHovered: false);
    notifyListeners();
  }

  void handleTapDown() {
    if (_state.isDisabled) return;
    if (_state.isPressed) return;
    _state = _state.copyWith(isPressed: true);
    notifyListeners();
  }

  void handleTapCancel() {
    if (!_state.isPressed) return;
    _state = _state.copyWith(isPressed: false);
    notifyListeners();
  }

  void handleTapUp({VoidCallback? onActivate}) {
    if (_state.isDisabled) return;
    if (_state.isPressed) {
      _state = _state.copyWith(isPressed: false);
      notifyListeners();
    }
    onActivate?.call();
  }

  /// Standard button-like keyboard policy (pure intent):
  /// - Space: pressed on down, activate on up
  /// - Enter: activate once on first down (anti-repeat)
  /// - ArrowDown: optional convenience (dropdown trigger)
  bool handleButtonLikeIntent({
    required HeadlessPressableKeyIntent intent,
    required VoidCallback onActivate,
    VoidCallback? onArrowDown,
  }) {
    if (_state.isDisabled) return false;

    switch (intent) {
      case HeadlessPressableSpaceDown():
        if (_spaceDown) return false;
        _spaceDown = true;
        if (!_state.isPressed) {
          _state = _state.copyWith(isPressed: true);
          notifyListeners();
        }
        return true;

      case HeadlessPressableSpaceUp():
        if (!_spaceDown) return false;
        _spaceDown = false;
        if (_state.isPressed) {
          _state = _state.copyWith(isPressed: false);
          notifyListeners();
        }
        onActivate();
        return true;

      case HeadlessPressableEnterDown():
        if (_enterDown) return false;
        _enterDown = true;
        onActivate();
        return true;

      case HeadlessPressableEnterUp():
        if (!_enterDown) return false;
        _enterDown = false;
        return true;

      case HeadlessPressableArrowDown():
        if (onArrowDown == null) return false;
        onArrowDown();
        return true;
    }
  }

  void resetKeyboard() {
    final hadPressed = _state.isPressed;
    _spaceDown = false;
    _enterDown = false;
    if (hadPressed) {
      _state = _state.copyWith(isPressed: false);
      notifyListeners();
    }
  }
}
