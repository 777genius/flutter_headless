import 'package:flutter/widgets.dart';

import 'r_pin_input_text_units.dart';

extension RPinInputControllerExt on TextEditingController {
  void setPin(String value, {int? maxLength}) {
    text = clampPinText(value, maxLength);
    moveCursorToEnd();
  }

  void appendPin(String value, {required int maxLength}) {
    if (pinTextLength(text) >= maxLength) return;
    text = clampPinText('$text$value', maxLength);
    moveCursorToEnd();
  }

  void deletePin() {
    if (text.isEmpty) return;
    text = removeLastPinCharacter(text);
    moveCursorToEnd();
  }

  void moveCursorToEnd() {
    selection = TextSelection.collapsed(offset: pinTextCodeUnitLength(text));
  }
}
