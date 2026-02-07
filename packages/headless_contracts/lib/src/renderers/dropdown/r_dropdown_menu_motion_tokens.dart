import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

/// Motion tokens for dropdown menu open/close.
///
/// The goal is to keep motion decisions (durations/curves) out of renderers so:
/// - presets can't drift accidentally,
/// - motion can be customized per theme/preset,
/// - conformance can verify behavior.
@immutable
final class RDropdownMenuMotionTokens {
  const RDropdownMenuMotionTokens({
    required this.enterDuration,
    required this.exitDuration,
    required this.enterCurve,
    required this.exitCurve,
    required this.scaleBegin,
  });

  /// Duration for enter animation (opening/open → visible).
  final Duration enterDuration;

  /// Duration for exit animation (closing → removed).
  final Duration exitDuration;

  /// Curve for enter animation.
  final Curve enterCurve;

  /// Curve for exit animation.
  final Curve exitCurve;

  /// Initial scale value for menu (end is always 1.0).
  final double scaleBegin;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RDropdownMenuMotionTokens &&
        other.enterDuration == enterDuration &&
        other.exitDuration == exitDuration &&
        other.enterCurve == enterCurve &&
        other.exitCurve == exitCurve &&
        other.scaleBegin == scaleBegin;
  }

  @override
  int get hashCode => Object.hash(
      enterDuration, exitDuration, enterCurve, exitCurve, scaleBegin);
}
