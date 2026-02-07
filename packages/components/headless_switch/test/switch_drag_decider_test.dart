import 'package:flutter_test/flutter_test.dart';
import 'package:headless_switch/src/presentation/logic/switch_drag_decider.dart';

void main() {
  group('computeNextValue', () {
    group('without fling velocity', () {
      test('returns true when dragT >= 0.5', () {
        expect(
          computeNextValue(dragT: 0.5, velocity: 0, isRtl: false),
          isTrue,
        );
        expect(
          computeNextValue(dragT: 0.75, velocity: 0, isRtl: false),
          isTrue,
        );
        expect(
          computeNextValue(dragT: 1.0, velocity: 0, isRtl: false),
          isTrue,
        );
      });

      test('returns false when dragT < 0.5', () {
        expect(
          computeNextValue(dragT: 0.49, velocity: 0, isRtl: false),
          isFalse,
        );
        expect(
          computeNextValue(dragT: 0.25, velocity: 0, isRtl: false),
          isFalse,
        );
        expect(
          computeNextValue(dragT: 0.0, velocity: 0, isRtl: false),
          isFalse,
        );
      });
    });

    group('with fling velocity (LTR)', () {
      test('returns true when velocity >= threshold (right fling)', () {
        expect(
          computeNextValue(dragT: 0.1, velocity: 350, isRtl: false),
          isTrue,
        );
        expect(
          computeNextValue(dragT: 0.1, velocity: 500, isRtl: false),
          isTrue,
        );
      });

      test('returns false when velocity <= -threshold (left fling)', () {
        expect(
          computeNextValue(dragT: 0.9, velocity: -350, isRtl: false),
          isFalse,
        );
        expect(
          computeNextValue(dragT: 0.9, velocity: -500, isRtl: false),
          isFalse,
        );
      });

      test('uses position when velocity below threshold', () {
        expect(
          computeNextValue(dragT: 0.6, velocity: 100, isRtl: false),
          isTrue,
        );
        expect(
          computeNextValue(dragT: 0.4, velocity: 100, isRtl: false),
          isFalse,
        );
      });

      test('T22: velocity 250 px/s does NOT toggle (below 300 threshold)', () {
        expect(
          computeNextValue(dragT: 0.3, velocity: 250, isRtl: false),
          isFalse,
        );
        expect(
          computeNextValue(dragT: 0.7, velocity: -250, isRtl: false),
          isTrue,
        );
      });

      test('T23: velocity 350 px/s DOES toggle (above 300 threshold)', () {
        expect(
          computeNextValue(dragT: 0.3, velocity: 350, isRtl: false),
          isTrue,
        );
        expect(
          computeNextValue(dragT: 0.7, velocity: -350, isRtl: false),
          isFalse,
        );
      });
    });

    group('with fling velocity (RTL)', () {
      test('returns true when velocity <= -threshold (left fling in RTL)', () {
        expect(
          computeNextValue(dragT: 0.1, velocity: -350, isRtl: true),
          isTrue,
        );
        expect(
          computeNextValue(dragT: 0.1, velocity: -500, isRtl: true),
          isTrue,
        );
      });

      test('returns false when velocity >= threshold (right fling in RTL)', () {
        expect(
          computeNextValue(dragT: 0.9, velocity: 350, isRtl: true),
          isFalse,
        );
        expect(
          computeNextValue(dragT: 0.9, velocity: 500, isRtl: true),
          isFalse,
        );
      });
    });
  });

  group('computeDragVisualValue', () {
    test('returns true when dragT >= 0.5', () {
      expect(computeDragVisualValue(dragT: 0.5), isTrue);
      expect(computeDragVisualValue(dragT: 0.75), isTrue);
      expect(computeDragVisualValue(dragT: 1.0), isTrue);
    });

    test('returns false when dragT < 0.5', () {
      expect(computeDragVisualValue(dragT: 0.49), isFalse);
      expect(computeDragVisualValue(dragT: 0.25), isFalse);
      expect(computeDragVisualValue(dragT: 0.0), isFalse);
    });
  });

  group('updateDragT', () {
    const travelPx = 24.0;

    group('LTR', () {
      test('increases with positive deltaX', () {
        final result = updateDragT(
          currentT: 0.5,
          deltaX: 12,
          travelPx: travelPx,
          isRtl: false,
        );
        expect(result, equals(1.0));
      });

      test('decreases with negative deltaX', () {
        final result = updateDragT(
          currentT: 0.5,
          deltaX: -12,
          travelPx: travelPx,
          isRtl: false,
        );
        expect(result, equals(0.0));
      });

      test('clamps to 0', () {
        final result = updateDragT(
          currentT: 0.1,
          deltaX: -100,
          travelPx: travelPx,
          isRtl: false,
        );
        expect(result, equals(0.0));
      });

      test('clamps to 1', () {
        final result = updateDragT(
          currentT: 0.9,
          deltaX: 100,
          travelPx: travelPx,
          isRtl: false,
        );
        expect(result, equals(1.0));
      });
    });

    group('RTL', () {
      test('increases with negative deltaX', () {
        final result = updateDragT(
          currentT: 0.5,
          deltaX: -12,
          travelPx: travelPx,
          isRtl: true,
        );
        expect(result, equals(1.0));
      });

      test('decreases with positive deltaX', () {
        final result = updateDragT(
          currentT: 0.5,
          deltaX: 12,
          travelPx: travelPx,
          isRtl: true,
        );
        expect(result, equals(0.0));
      });
    });

    test('returns current value when travelPx is 0', () {
      final result = updateDragT(
        currentT: 0.5,
        deltaX: 100,
        travelPx: 0,
        isRtl: false,
      );
      expect(result, equals(0.5));
    });

    test('returns current value when travelPx is negative', () {
      final result = updateDragT(
        currentT: 0.5,
        deltaX: 100,
        travelPx: -10,
        isRtl: false,
      );
      expect(result, equals(0.5));
    });
  });

  group('initialDragT', () {
    test('returns 1.0 when value is true', () {
      expect(initialDragT(value: true, isRtl: false), equals(1.0));
      expect(initialDragT(value: true, isRtl: true), equals(1.0));
    });

    test('returns 0.0 when value is false', () {
      expect(initialDragT(value: false, isRtl: false), equals(0.0));
      expect(initialDragT(value: false, isRtl: true), equals(0.0));
    });
  });

  group('computeTravelPx', () {
    test('computes travel distance using trackInnerLength formula (Material 3)',
        () {
      // Material 3: trackWidth=52, trackHeight=32
      // trackInnerStart = 32 / 2 = 16
      // trackInnerEnd = 52 - 16 = 36
      // trackInnerLength = 36 - 16 = 20
      final result = computeTravelPx(
        trackWidth: 52,
        trackHeight: 32,
      );
      expect(result, equals(20.0));
    });

    test('returns 0 when track is very narrow', () {
      final result = computeTravelPx(
        trackWidth: 10,
        trackHeight: 32,
      );
      expect(result, equals(0.0));
    });

    test('computes travel distance for Cupertino-like dimensions', () {
      // Cupertino: trackWidth=51, trackHeight=31
      // trackInnerStart = 31 / 2 = 15.5
      // trackInnerEnd = 51 - 15.5 = 35.5
      // trackInnerLength = 35.5 - 15.5 = 20
      final result = computeTravelPx(
        trackWidth: 51,
        trackHeight: 31,
      );
      expect(result, equals(20.0));
    });

    test('handles square track', () {
      // trackWidth=40, trackHeight=40
      // trackInnerStart = 20
      // trackInnerEnd = 20
      // trackInnerLength = 0
      final result = computeTravelPx(
        trackWidth: 40,
        trackHeight: 40,
      );
      expect(result, equals(0.0));
    });
  });

  group('constants', () {
    test('kSwitchFlingVelocityThreshold is 300 (Flutter parity)', () {
      expect(kSwitchFlingVelocityThreshold, equals(300.0));
    });

    test('kSwitchPositionThreshold is 0.5', () {
      expect(kSwitchPositionThreshold, equals(0.5));
    });
  });
}
