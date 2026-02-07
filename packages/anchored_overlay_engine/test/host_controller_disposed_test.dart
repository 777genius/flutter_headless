import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anchored_overlay_engine/anchored_overlay_engine.dart';

void main() {
  testWidgets(
      'AnchoredOverlayEngineHost does not crash if controller is disposed before host',
      (tester) async {
    final controller = OverlayController();

    await tester.pumpWidget(
      MaterialApp(
        home: AnchoredOverlayEngineHost(
          controller: controller,
          child: const Text('App'),
        ),
      ),
    );

    // Simulate user-managed lifecycle: dispose controller early.
    controller.dispose();

    // Now dispose host.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
