import 'package:flutter/foundation.dart';

/// Motion tokens for checkbox visual transitions.
///
/// The goal is to avoid hardcoding durations inside preset renderers.
@immutable
final class RCheckboxMotionTokens {
  const RCheckboxMotionTokens({
    required this.stateChangeDuration,
  });

  /// Duration for visual state transitions (focus/hover/pressed/checked).
  final Duration stateChangeDuration;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RCheckboxMotionTokens &&
        other.stateChangeDuration == stateChangeDuration;
  }

  @override
  int get hashCode => stateChangeDuration.hashCode;
}

