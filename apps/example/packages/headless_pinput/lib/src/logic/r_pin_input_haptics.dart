import 'package:flutter/services.dart';

import '../contracts/r_pin_input_types.dart';

void maybeUsePinInputHaptic(RPinInputHapticFeedbackType type) {
  switch (type) {
    case RPinInputHapticFeedbackType.disabled:
      return;
    case RPinInputHapticFeedbackType.lightImpact:
      HapticFeedback.lightImpact();
    case RPinInputHapticFeedbackType.mediumImpact:
      HapticFeedback.mediumImpact();
    case RPinInputHapticFeedbackType.heavyImpact:
      HapticFeedback.heavyImpact();
    case RPinInputHapticFeedbackType.selectionClick:
      HapticFeedback.selectionClick();
    case RPinInputHapticFeedbackType.vibrate:
      HapticFeedback.vibrate();
  }
}
