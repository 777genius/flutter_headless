import 'package:flutter/widgets.dart';

import '../logic/r_phone_field_controller.dart';

final class RPhoneFieldCaretRestorer {
  const RPhoneFieldCaretRestorer();

  void restoreSelectionAfterCountryChange({
    required bool Function() isMounted,
    required FocusNode focusNode,
    required RPhoneFieldController controller,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isMounted()) return;
      if (!focusNode.hasFocus && focusNode.canRequestFocus) {
        focusNode.requestFocus();
      }
      controller.collapseSelectionToEnd();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!isMounted()) return;
        controller.collapseSelectionToEnd();
      });
    });
  }

  void restoreFocus({
    required bool Function() isMounted,
    required FocusNode focusNode,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isMounted()) return;
      if (focusNode.canRequestFocus) {
        focusNode.requestFocus();
      }
    });
  }
}
