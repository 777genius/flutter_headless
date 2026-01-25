import 'package:flutter/foundation.dart';

/// Motion tokens for switch list tile visual transitions.
@immutable
final class RSwitchListTileMotionTokens {
  const RSwitchListTileMotionTokens({
    required this.stateChangeDuration,
  });

  /// Duration for visual state transitions (focus/hover/pressed/selected).
  final Duration stateChangeDuration;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RSwitchListTileMotionTokens &&
        other.stateChangeDuration == stateChangeDuration;
  }

  @override
  int get hashCode => stateChangeDuration.hashCode;
}
