import 'package:meta/meta.dart';

@immutable
final class HeadlessFocusHoverState {
  const HeadlessFocusHoverState({
    this.isHovered = false,
    this.isFocused = false,
    this.isDisabled = false,
  });

  final bool isHovered;
  final bool isFocused;
  final bool isDisabled;

  HeadlessFocusHoverState copyWith({
    bool? isHovered,
    bool? isFocused,
    bool? isDisabled,
  }) {
    return HeadlessFocusHoverState(
      isHovered: isHovered ?? this.isHovered,
      isFocused: isFocused ?? this.isFocused,
      isDisabled: isDisabled ?? this.isDisabled,
    );
  }
}

