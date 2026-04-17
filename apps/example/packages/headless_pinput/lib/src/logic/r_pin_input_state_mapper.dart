import '../contracts/r_pin_input_types.dart';

final class RPinInputStateMapper {
  const RPinInputStateMapper();

  RPinInputCellStateType cellStateFor({
    required int index,
    required int length,
    required int currentLength,
    required bool enabled,
    required bool showErrorState,
    required bool hasVisualFocus,
  }) {
    if (!enabled) return RPinInputCellStateType.disabled;
    if (showErrorState) return RPinInputCellStateType.error;
    final activeIndex = currentLength.clamp(0, length - 1);
    if (hasVisualFocus && index == activeIndex) {
      return RPinInputCellStateType.focused;
    }
    if (index < currentLength) return RPinInputCellStateType.submitted;
    return RPinInputCellStateType.following;
  }

  bool hasVisualFocus({
    required bool useNativeKeyboard,
    required bool focusNodeHasFocus,
    required int currentLength,
    required int length,
  }) {
    final isLastPin = currentLength == length;
    return focusNodeHasFocus || (!useNativeKeyboard && !isLastPin);
  }

  bool shouldShowCursor({
    required bool showCursor,
    required bool enabled,
    required bool hasVisualFocus,
    required bool isActive,
  }) {
    return showCursor && enabled && hasVisualFocus && isActive;
  }
}
