import 'package:flutter/widgets.dart';

final class RPinInputValueSync {
  String? _lastNotifiedValue;
  String? _pendingValue;

  void seedLastNotified(String value) {
    _lastNotifiedValue = value;
  }

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

  void _updateControllerText(TextEditingController controller, String value) {
    final selection = controller.selection;
    controller.text = value;
    final length = value.length;
    if (selection.isValid) {
      controller.selection = TextSelection(
        baseOffset: selection.baseOffset.clamp(0, length),
        extentOffset: selection.extentOffset.clamp(0, length),
      );
    }
    _lastNotifiedValue = value;
  }
}
