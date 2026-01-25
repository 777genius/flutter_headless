import 'package:flutter/foundation.dart';

/// Motion tokens for checkbox list tile visual transitions.
@immutable
final class RCheckboxListTileMotionTokens {
  const RCheckboxListTileMotionTokens({
    required this.stateChangeDuration,
  });

  /// Duration for visual state transitions (focus/hover/pressed/selected).
  final Duration stateChangeDuration;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RCheckboxListTileMotionTokens &&
        other.stateChangeDuration == stateChangeDuration;
  }

  @override
  int get hashCode => stateChangeDuration.hashCode;
}

