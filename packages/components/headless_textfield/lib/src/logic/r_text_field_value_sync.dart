import 'package:flutter/widgets.dart';

/// Handles controlled value sync + IME composing deferral for `RTextField`.
final class RTextFieldValueSync {
  String? _lastNotifiedValue;
  String? _pendingValue;

  void seedLastNotified(String value) {
    _lastNotifiedValue = value;
  }

  /// Returns true if a pending value was applied and widget should rebuild.
  bool applyPendingIfComposingFinished(TextEditingController controller) {
    if (_pendingValue == null) return false;
    if (controller.value.composing.isValid) return false;

    final pending = _pendingValue;
    _pendingValue = null;
    if (pending == null || pending == controller.text) return false;

    _updateControllerText(controller, pending);
    return true;
  }

  void syncControlledValue({
    required TextEditingController controller,
    required String? value,
  }) {
    if (value == controller.text) {
      _pendingValue = null;
      return;
    }

    if (controller.value.composing.isValid) {
      _pendingValue = value;
      return;
    }

    final target = _pendingValue ?? value;
    _pendingValue = null;

    if (target == null || target == controller.text) return;
    _updateControllerText(controller, target);
  }

  bool notifyIfChanged(String text, ValueChanged<String>? onChanged) {
    if (text == _lastNotifiedValue) return false;
    _lastNotifiedValue = text;
    onChanged?.call(text);
    return true;
  }

  void clearPending() {
    _pendingValue = null;
  }

  void resetLastNotified(String value) {
    _lastNotifiedValue = value;
  }

  void _updateControllerText(TextEditingController controller, String newText) {
    final oldSelection = controller.selection;
    controller.text = newText;

    final newLength = newText.length;
    if (oldSelection.isValid) {
      controller.selection = TextSelection(
        baseOffset: oldSelection.baseOffset.clamp(0, newLength),
        extentOffset: oldSelection.extentOffset.clamp(0, newLength),
      );
    }
    _lastNotifiedValue = newText;
  }
}

