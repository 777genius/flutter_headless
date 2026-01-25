import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_theme/headless_theme.dart';

void main() {
  group('HeadlessMaterialApp', () {
    testWidgets('installs HeadlessThemeProvider and AnchoredOverlayEngineHost',
        (tester) async {
      await tester.pumpWidget(HeadlessMaterialApp(
        home: Builder(
          builder: (context) {
            final theme = HeadlessThemeProvider.of(context);
            expect(theme, isNotNull);
            return const SizedBox.shrink();
          },
        ),
      ));

      expect(find.byType(AnchoredOverlayEngineHost), findsOneWidget);
    });

    testWidgets('uses provided OverlayController and does not create its own',
        (tester) async {
      final controller = OverlayController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(HeadlessMaterialApp(
        overlayController: controller,
        home: const SizedBox.shrink(),
      ));

      final host = tester.widget<AnchoredOverlayEngineHost>(
        find.byType(AnchoredOverlayEngineHost),
      );
      expect(identical(host.controller, controller), isTrue);
    });
  });
}
