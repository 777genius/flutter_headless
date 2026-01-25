import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

void main() {
  group('HeadlessApp', () {
    testWidgets('installs HeadlessThemeProvider and AnchoredOverlayEngineHost',
        (tester) async {
      await tester.pumpWidget(HeadlessApp(
        theme: _TestTheme(),
        appBuilder: (overlayBuilder) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                final theme = HeadlessThemeProvider.of(context);
                expect(theme, isNotNull);
                return overlayBuilder(context, const SizedBox.shrink());
              },
            ),
          );
        },
      ));

      expect(find.byType(AnchoredOverlayEngineHost), findsOneWidget);
    });

    testWidgets('uses provided OverlayController', (tester) async {
      final controller = OverlayController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(HeadlessApp(
        theme: _TestTheme(),
        overlayController: controller,
        appBuilder: (overlayBuilder) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) =>
                  overlayBuilder(context, const SizedBox.shrink()),
            ),
          );
        },
      ));

      final host = tester.widget<AnchoredOverlayEngineHost>(
        find.byType(AnchoredOverlayEngineHost),
      );
      expect(identical(host.controller, controller), isTrue);
    });
  });
}

final class _TestTheme extends HeadlessTheme {
  @override
  T? capability<T>() => null;
}
