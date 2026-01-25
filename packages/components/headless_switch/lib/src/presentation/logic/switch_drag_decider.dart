import 'dart:math' as math;

/// Velocity threshold for fling-to-toggle behavior (px/sec).
///
/// If the fling velocity exceeds this threshold, the switch will toggle
/// regardless of the current drag position.
///
/// This matches Flutter's actual Switch implementation (300.0 px/s).
const double kSwitchFlingVelocityThreshold = 300.0;

/// Position threshold for toggle decision when no fling detected.
///
/// If dragT >= 0.5, the switch toggles to "on".
/// If dragT < 0.5, the switch toggles to "off".
const double kSwitchPositionThreshold = 0.5;

/// Computes the next switch value based on drag position and velocity.
///
/// [dragT] is the current 0..1 thumb position.
/// [velocity] is the horizontal fling velocity in px/sec (positive = right).
/// [isRtl] indicates right-to-left layout direction.
///
/// Returns the new switch value (true = on, false = off).
///
/// Logic (matches Flutter Switch):
/// 1. If velocity exceeds threshold → toggle based on velocity direction
/// 2. Otherwise → toggle based on position (>= 0.5 = on)
bool computeNextValue({
  required double dragT,
  required double velocity,
  required bool isRtl,
}) {
  final effectiveVelocity = isRtl ? -velocity : velocity;

  if (effectiveVelocity.abs() >= kSwitchFlingVelocityThreshold) {
    return effectiveVelocity > 0;
  }

  return dragT >= kSwitchPositionThreshold;
}

/// Computes the preview visual value during drag.
///
/// This is used for WidgetStateProperty resolution (e.g., thumbIcon).
/// Returns what the switch value would become if released at current position.
bool computeDragVisualValue({
  required double dragT,
}) {
  return dragT >= kSwitchPositionThreshold;
}

/// Updates the drag position based on horizontal drag delta.
///
/// [currentT] is the current 0..1 thumb position.
/// [deltaX] is the horizontal drag delta in pixels.
/// [travelPx] is the total travel distance in pixels (trackInnerLength).
/// [isRtl] indicates right-to-left layout direction.
///
/// Returns the new 0..1 thumb position, clamped to [0, 1].
double updateDragT({
  required double currentT,
  required double deltaX,
  required double travelPx,
  required bool isRtl,
}) {
  if (travelPx <= 0) return currentT;

  final effectiveDelta = isRtl ? -deltaX : deltaX;
  final deltaT = effectiveDelta / travelPx;

  return (currentT + deltaT).clamp(0.0, 1.0);
}

/// Computes the initial drag T from the current switch value.
///
/// [value] is the current switch value (true = on).
/// [isRtl] indicates right-to-left layout direction (affects position).
///
/// Returns the initial 0..1 thumb position.
double initialDragT({
  required bool value,
  required bool isRtl,
}) {
  return value ? 1.0 : 0.0;
}

/// Computes the thumb travel distance in pixels using Flutter's trackInnerLength formula.
///
/// [trackWidth] is the total track width.
/// [trackHeight] is the track height.
///
/// Returns the travel distance (trackInnerLength).
///
/// Flutter formula:
/// ```
/// trackInnerStart = trackHeight / 2.0
/// trackInnerEnd = trackWidth - trackInnerStart
/// trackInnerLength = trackInnerEnd - trackInnerStart
/// ```
///
/// For Material 3 (trackWidth=52, trackHeight=32):
/// trackInnerStart = 16.0
/// trackInnerEnd = 36.0
/// trackInnerLength = 20.0 px
double computeTravelPx({
  required double trackWidth,
  required double trackHeight,
}) {
  final trackInnerStart = trackHeight / 2.0;
  final trackInnerEnd = trackWidth - trackInnerStart;
  return math.max(0.0, trackInnerEnd - trackInnerStart);
}
