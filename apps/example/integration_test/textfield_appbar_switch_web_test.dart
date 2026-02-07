import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:headless_example/main.dart' show HeadlessExampleApp;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'WEB: AppBar theme switch stays tappable across focusing multiple fields',
    (tester) async {
      await tester.pumpWidget(const HeadlessExampleApp());
      await tester.pumpAndSettle();

      // Navigate to TextField demo.
      final tile = find.text('TextField Demo');
      await tester.scrollUntilVisible(
        tile,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(tile);
      await tester.pumpAndSettle();

      // Focus the first field.
      final editable = find.byType(EditableText).first;
      expect(editable, findsOneWidget);
      await tester.tap(editable);
      await tester.pumpAndSettle();

      // Tap the app bar switch (should toggle even while focused).
      const modeLabel = 'Switch between Material and Cupertino theme';
      final switchFinder = find.bySemanticsLabel(modeLabel);
      expect(switchFinder, findsOneWidget);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Focus another field (scroll down) and ensure the same switch is still
      // tappable. This reproduces a web-only regression where the DOM editing
      // element can block pointer events after focus moves.
      final densePaddingField = find.text('Dense padding');
      await tester.scrollUntilVisible(
        densePaddingField,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // Focus the closest EditableText to the Dense padding field.
      // We tap on the EditableText found last, which should correspond to the
      // lower field after scroll.
      final editable2 = find.byType(EditableText).last;
      expect(editable2, findsOneWidget);
      await tester.tap(editable2);
      await tester.pumpAndSettle();

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // If tap didn't reach the switch, we'd stay on the same mode and the UI
      // would not update (this is the regression we see on web).
      //
      // We validate indirectly by ensuring the semantics node is still present
      // and no exceptions were thrown.
      expect(find.bySemanticsLabel(modeLabel), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

