import 'package:flutter/widgets.dart';

import '../logic/r_text_field_value_sync.dart';

void validateTextFieldControlConfig({
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

void requestTextFieldFocusOrKeyboard({
  required bool enabled,
  required FocusNode focusNode,
  required EditableTextState? editableTextState,
}) {
  if (!enabled) return;
  if (!focusNode.hasFocus) {
    focusNode.requestFocus();
    return;
  }
  editableTextState?.requestKeyboard();
}

void clearTextFieldValue({
  required bool enabled,
  required TextEditingController controller,
  required RTextFieldValueSync valueSync,
  required ValueChanged<String>? onChanged,
}) {
  if (!enabled) return;
  controller.value = const TextEditingValue(
    text: '',
    selection: TextSelection.collapsed(offset: 0),
    composing: TextRange.empty,
  );
  valueSync.notifyIfChanged('', onChanged);
}
