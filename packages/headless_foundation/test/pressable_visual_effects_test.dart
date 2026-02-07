import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';

void main() {
  testWidgets('dispatches visual effects events on pointer tap',
      (tester) async {
    final pressable = HeadlessPressableController();
    final visualEffects = HeadlessPressableVisualEffectsController();
    final events = <HeadlessPressableVisualEvent>[];

    visualEffects.addListener(() {
      final event = visualEffects.lastEvent;
      if (event != null) events.add(event);
    });

    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    addTearDown(visualEffects.dispose);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: HeadlessPressableRegion(
          controller: pressable,
          focusNode: focusNode,
          autofocus: false,
          enabled: true,
          onActivate: () {},
          visualEffects: visualEffects,
          child: const SizedBox(width: 100, height: 40),
        ),
      ),
    );

    final center = tester.getCenter(find.byType(HeadlessPressableRegion));
    await tester.tapAt(center);
    await tester.pump();

    expect(
      events.whereType<HeadlessPressableVisualPointerDown>().length,
      1,
    );
    expect(
      events.whereType<HeadlessPressableVisualPointerUp>().length,
      1,
    );
  });
}
