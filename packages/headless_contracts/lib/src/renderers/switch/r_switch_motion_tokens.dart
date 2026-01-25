import 'package:flutter/foundation.dart';

/// Motion tokens for switch visual transitions.
///
/// The goal is to avoid hardcoding durations inside preset renderers.
@immutable
final class RSwitchMotionTokens {
  const RSwitchMotionTokens({
    required this.stateChangeDuration,
    this.thumbSlideDuration,
    this.thumbToggleDuration,
  });

  /// Duration for visual state transitions (focus/hover/pressed/checked).
  final Duration stateChangeDuration;

  /// Duration for thumb sliding animation.
  /// If null, defaults to [stateChangeDuration].
  final Duration? thumbSlideDuration;

  /// Duration for thumb toggle animation (TweenSequence).
  /// Material 3: 300ms
  /// If null, defaults to [stateChangeDuration].
  final Duration? thumbToggleDuration;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RSwitchMotionTokens &&
        other.stateChangeDuration == stateChangeDuration &&
        other.thumbSlideDuration == thumbSlideDuration &&
        other.thumbToggleDuration == thumbToggleDuration;
  }

  @override
  int get hashCode => Object.hash(
        stateChangeDuration,
        thumbSlideDuration,
        thumbToggleDuration,
      );
}
