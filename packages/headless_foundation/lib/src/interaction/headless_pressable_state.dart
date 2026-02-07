import 'package:meta/meta.dart';

@immutable
final class HeadlessPressableState {
  const HeadlessPressableState({
    this.isPressed = false,
    this.isHovered = false,
    this.isFocused = false,
    this.isDisabled = false,
  });

  final bool isPressed;
  final bool isHovered;
  final bool isFocused;
  final bool isDisabled;

  HeadlessPressableState copyWith({
    bool? isPressed,
    bool? isHovered,
    bool? isFocused,
    bool? isDisabled,
  }) {
    return HeadlessPressableState(
      isPressed: isPressed ?? this.isPressed,
      isHovered: isHovered ?? this.isHovered,
      isFocused: isFocused ?? this.isFocused,
      isDisabled: isDisabled ?? this.isDisabled,
    );
  }
}
