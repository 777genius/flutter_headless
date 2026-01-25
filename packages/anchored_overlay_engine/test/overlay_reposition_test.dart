import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anchored_overlay_engine/anchored_overlay_engine.dart';

void main() {
  testWidgets('OverlayController.requestReposition coalesces to <= 1 per frame',
      (tester) async {
    final controller = OverlayController();
    var notifyCount = 0;
    controller.addListener(() => notifyCount++);

    // No overlays: should be no-op
    controller.requestReposition();
    await tester.pump();
    expect(notifyCount, 0);

    // Add an overlay so controller has entries
    controller.show(
      OverlayRequest(
        overlayBuilder: (_) => const SizedBox(),
        anchor: OverlayAnchor(
          rect: () => const Rect.fromLTWH(0, 0, 100, 40),
        ),
      ),
    );
    await tester.pump();

    // Multiple requests in the same frame should coalesce into one notify
    controller.requestReposition();
    controller.requestReposition();
    controller.requestReposition();

    expect(notifyCount, 1, reason: 'Only show() should have notified so far');

    await tester.pump();
    expect(notifyCount, 2,
        reason: 'Reposition should notify once on next frame');
  });
}
