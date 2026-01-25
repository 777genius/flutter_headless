import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anchored_overlay_engine/anchored_overlay_engine.dart';

void main() {
  group('AnchoredOverlayLayoutCalculator', () {
    test('keeps placement below when there is enough space', () {
      const viewport = Rect.fromLTWH(0, 0, 400, 800);
      const anchor = Rect.fromLTWH(50, 100, 200, 40);

      const calc = AnchoredOverlayLayoutCalculator(minSpaceToPreferBelow: 150);
      final layout = calc.calculate(
        viewportRect: viewport,
        anchorRect: anchor,
        desiredWidth: 200,
      );

      expect(layout.placement, AnchoredOverlayPlacement.below);
      expect(layout.targetAnchor, Alignment.bottomLeft);
      expect(layout.followerAnchor, Alignment.topLeft);
      expect(layout.maxHeight, isNotNull);
      expect(layout.maxHeight!, greaterThan(0));
    });

    test('flips above when space below is small and space above is bigger', () {
      const viewport = Rect.fromLTWH(0, 0, 400, 800);
      const anchor = Rect.fromLTWH(50, 720, 200, 40); // near bottom

      const calc = AnchoredOverlayLayoutCalculator(minSpaceToPreferBelow: 150);
      final layout = calc.calculate(
        viewportRect: viewport,
        anchorRect: anchor,
        desiredWidth: 200,
      );

      expect(layout.placement, AnchoredOverlayPlacement.above);
      expect(layout.targetAnchor, Alignment.topLeft);
      expect(layout.followerAnchor, Alignment.bottomLeft);
    });

    test('shifts horizontally to stay inside viewport', () {
      const viewport = Rect.fromLTWH(0, 0, 300, 600);
      const anchor = Rect.fromLTWH(260, 100, 40, 40); // near right edge

      const calc = AnchoredOverlayLayoutCalculator();
      final layout = calc.calculate(
        viewportRect: viewport,
        anchorRect: anchor,
        desiredWidth: 200,
      );

      // Desired left is 260, but max left to fit width 200 is 100
      expect(layout.offset.dx, lessThan(0));
      expect(layout.width, 200);
    });
  });

  group('computeOverlayViewportRect', () {
    test('accounts for keyboard by using bottom inset', () {
      const mq = MediaQueryData(
        size: Size(400, 800),
        padding: EdgeInsets.only(top: 20, bottom: 10),
        viewInsets: EdgeInsets.only(bottom: 300),
      );

      final rect = computeOverlayViewportRect(mq, edgePadding: 8);

      // bottom should be 800 - max(10,300) - 8 = 492
      expect(rect.bottom, 492);
      expect(rect.top, 28);
    });
  });
}
