import 'package:flutter/foundation.dart';

/// Motion tokens for button visual transitions.
///
/// The goal is to avoid hardcoding durations inside preset renderers.
@immutable
final class RButtonMotionTokens {
  const RButtonMotionTokens({
    required this.stateChangeDuration,
  });

  /// Duration for visual state transitions (focus/hover/pressed).
  final Duration stateChangeDuration;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RButtonMotionTokens &&
        other.stateChangeDuration == stateChangeDuration;
  }

  @override
  int get hashCode => stateChangeDuration.hashCode;
}

