import 'package:flutter/widgets.dart';

enum RPinInputVariant {
  outlined,
  elevated,
  filled,
  filledRounded,
  underlined,
}

enum RPinInputAnimationType {
  none,
  scale,
  fade,
  slide,
  rotation,
}

enum RPinInputAutovalidateMode {
  disabled,
  onSubmit,
}

enum RPinInputHapticFeedbackType {
  disabled,
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
  vibrate,
}

enum RPinInputCellStateType {
  focused,
  submitted,
  following,
  disabled,
  error,
}

@immutable
final class RPinInputCell {
  const RPinInputCell({
    required this.index,
    required this.state,
    required this.rawValue,
    required this.displayText,
    required this.isActive,
    required this.showCursor,
  });

  final int index;
  final RPinInputCellStateType state;
  final String rawValue;
  final String displayText;
  final bool isActive;
  final bool showCursor;
}
