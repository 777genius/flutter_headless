import 'package:flutter/widgets.dart';

import 'r_pin_input_text_units.dart';

void validatePinInputControlConfig({
  required String? value,
  required TextEditingController? controller,
}) {
  if (value != null && controller != null) {
    throw ArgumentError(
      'Cannot provide both value and controller. '
      'Use either controlled mode (value + onChanged) or '
      'controller-driven mode (controller only).',
    );
  }
}

void requestPinInputFocusOrKeyboard({
  required bool enabled,
  required bool useNativeKeyboard,
  required FocusNode focusNode,
  required EditableTextState? editableTextState,
}) {
  if (!enabled || !useNativeKeyboard) return;
  if (!focusNode.hasFocus) {
    focusNode.requestFocus();
    return;
  }
  editableTextState?.requestKeyboard();
}

String clampPinValue(String value, int length) {
  return clampPinText(value, length);
}
