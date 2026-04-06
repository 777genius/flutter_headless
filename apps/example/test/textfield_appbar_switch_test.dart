import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:headless_example/main.dart' show HeadlessExampleApp;

import 'helpers/example_app_helpers.dart';

void main() {
  testWidgets(
    'Light/dark AppBar switch stays tappable across focused and scrolled text fields',
    (tester) async {
      await tester.pumpWidget(const HeadlessExampleApp());
      await pumpUi(tester, duration: const Duration(milliseconds: 400));

      await openExampleDemo(tester, 'TextField Demo');

      const brightnessLabel = 'Switch between light and dark theme';
      final brightnessSwitch = find.bySemanticsLabel(brightnessLabel);
      expect(brightnessSwitch, findsOneWidget);

      final editable = find.byType(EditableText).first;
      expect(editable, findsOneWidget);
      await tester.tap(editable);
      await pumpUi(tester);

      final beforeFirstToggle = switchValue(tester, brightnessLabel);
      await tester.tap(brightnessSwitch);
      await pumpUi(tester);
      final afterFirstToggle = switchValue(tester, brightnessLabel);
      expect(afterFirstToggle, isNot(equals(beforeFirstToggle)));

      final searchField = find.text('Search');
      await tester.scrollUntilVisible(
        searchField,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await pumpUi(tester);

      final lowerEditable = find.byType(EditableText).last;
      expect(lowerEditable, findsOneWidget);
      await tester.tap(lowerEditable);
      await pumpUi(tester);

      final beforeSecondToggle = switchValue(tester, brightnessLabel);
      await tester.tap(brightnessSwitch);
      await pumpUi(tester);
      final afterSecondToggle = switchValue(tester, brightnessLabel);

      expect(afterSecondToggle, isNot(equals(beforeSecondToggle)));
      expect(tester.takeException(), isNull);
    },
  );
}
