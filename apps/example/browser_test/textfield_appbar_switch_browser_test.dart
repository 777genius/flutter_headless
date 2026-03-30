import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:headless_example/main.dart' show HeadlessExampleApp;

import 'helpers/example_app_browser_helpers.dart';

void main() {
  testWidgets(
    'Browser: light/dark AppBar switch stays tappable across focused and scrolled text fields',
    (tester) async {
      await tester.pumpWidget(const HeadlessExampleApp());
      await tester.pumpAndSettle();

      await openExampleDemo(tester, 'TextField Demo');

      const brightnessLabel = 'Switch between light and dark theme';
      final brightnessSwitch = find.bySemanticsLabel(brightnessLabel);
      expect(brightnessSwitch, findsOneWidget);

      final editable = find.byType(EditableText).first;
      expect(editable, findsOneWidget);
      await tester.tap(editable);
      await tester.pumpAndSettle();

      final beforeFirstToggle = browserSwitchValue(tester, brightnessLabel);
      await tester.tap(brightnessSwitch);
      await tester.pumpAndSettle();
      final afterFirstToggle = browserSwitchValue(tester, brightnessLabel);
      expect(afterFirstToggle, isNot(equals(beforeFirstToggle)));

      final searchField = find.text('Search');
      await tester.scrollUntilVisible(
        searchField,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      final lowerEditable = find.byType(EditableText).last;
      expect(lowerEditable, findsOneWidget);
      await tester.tap(lowerEditable);
      await tester.pumpAndSettle();

      final beforeSecondToggle = browserSwitchValue(tester, brightnessLabel);
      await tester.tap(brightnessSwitch);
      await tester.pumpAndSettle();
      final afterSecondToggle = browserSwitchValue(tester, brightnessLabel);

      expect(afterSecondToggle, isNot(equals(beforeSecondToggle)));
      expect(tester.takeException(), isNull);
    },
  );
}
