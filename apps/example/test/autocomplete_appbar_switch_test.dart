import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:headless_example/main.dart' show HeadlessExampleApp;

import 'helpers/example_app_helpers.dart';

Future<void> _focusPrimaryAutocomplete(WidgetTester tester) async {
  final field = find.text('Search country');
  expect(field, findsOneWidget);
  await tester.tap(field);
  await pumpUi(tester);
}

Future<void> _openAutocompleteMenu(WidgetTester tester, String query) async {
  await _focusPrimaryAutocomplete(tester);
  await tester.enterText(find.byType(EditableText).first, query);
  await pumpUi(tester, duration: const Duration(milliseconds: 400));
}

void main() {
  testWidgets(
    'Theme switch stays tappable while autocomplete menu is open',
    (tester) async {
      await tester.pumpWidget(const HeadlessExampleApp());
      await pumpUi(tester, duration: const Duration(milliseconds: 400));

      await openExampleDemo(tester, 'Autocomplete Demo');
      await _openAutocompleteMenu(tester, 'fi');

      expect(find.text('Finland'), findsOneWidget);

      const modeLabel = 'Switch between Material and Cupertino theme';
      final themeSwitch = find.bySemanticsLabel(modeLabel);
      expect(themeSwitch, findsOneWidget);

      final beforeToggle = switchValue(tester, modeLabel);
      await tester.tap(themeSwitch);
      await pumpUi(tester);
      final afterToggle = switchValue(tester, modeLabel);

      expect(afterToggle, isNot(equals(beforeToggle)));
      expect(find.text('Autocomplete Demo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Light/dark switch stays tappable after reopening autocomplete menu',
    (tester) async {
      await tester.pumpWidget(const HeadlessExampleApp());
      await pumpUi(tester, duration: const Duration(milliseconds: 400));

      await openExampleDemo(tester, 'Autocomplete Demo');
      await _openAutocompleteMenu(tester, 'fi');

      const brightnessLabel = 'Switch between light and dark theme';
      final brightnessSwitch = find.bySemanticsLabel(brightnessLabel);
      expect(brightnessSwitch, findsOneWidget);

      final beforeFirstToggle = switchValue(tester, brightnessLabel);
      await tester.tap(brightnessSwitch);
      await pumpUi(tester);
      final afterFirstToggle = switchValue(tester, brightnessLabel);
      expect(afterFirstToggle, isNot(equals(beforeFirstToggle)));

      await _openAutocompleteMenu(tester, 'fr');
      expect(find.text('France'), findsOneWidget);

      final beforeSecondToggle = switchValue(tester, brightnessLabel);
      await tester.tap(brightnessSwitch);
      await pumpUi(tester);
      final afterSecondToggle = switchValue(tester, brightnessLabel);

      expect(afterSecondToggle, isNot(equals(beforeSecondToggle)));
      expect(tester.takeException(), isNull);
    },
  );
}
