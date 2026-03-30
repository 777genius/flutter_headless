@Tags(['browser'])
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:headless_example/main.dart' show HeadlessExampleApp;

import 'helpers/example_app_browser_helpers.dart';

void main() {
  testWidgets(
    'Browser: light/dark AppBar switch stays tappable across focused and scrolled text fields',
    (tester) async {
      await tester.pumpWidget(const HeadlessExampleApp());
      await pumpBrowserUi(tester, duration: const Duration(milliseconds: 400));

      await openExampleDemo(tester, 'TextField Demo');

      const brightnessLabel = 'Switch between light and dark theme';
      final brightnessSwitch = find.bySemanticsLabel(brightnessLabel);
      expect(brightnessSwitch, findsOneWidget);

      final editable = find.byType(EditableText).first;
      expect(editable, findsOneWidget);
      await tester.tap(editable);
      await pumpBrowserUi(tester);

      final beforeFirstToggle = browserSwitchValue(tester, brightnessLabel);
      await tester.tap(brightnessSwitch);
      await pumpBrowserUi(tester);
      final afterFirstToggle = browserSwitchValue(tester, brightnessLabel);
      expect(afterFirstToggle, isNot(equals(beforeFirstToggle)));

      final searchField = find.text('Search');
      await tester.scrollUntilVisible(
        searchField,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await pumpBrowserUi(tester);

      final lowerEditable = find.byType(EditableText).last;
      expect(lowerEditable, findsOneWidget);
      await tester.tap(lowerEditable);
      await pumpBrowserUi(tester);

      final beforeSecondToggle = browserSwitchValue(tester, brightnessLabel);
      await tester.tap(brightnessSwitch);
      await pumpBrowserUi(tester);
      final afterSecondToggle = browserSwitchValue(tester, brightnessLabel);

      expect(afterSecondToggle, isNot(equals(beforeSecondToggle)));
      expect(tester.takeException(), isNull);
    },
  );
}
