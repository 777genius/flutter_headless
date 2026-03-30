@Tags(['browser'])
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:headless_example/main.dart' show HeadlessExampleApp;

import 'helpers/example_app_browser_helpers.dart';

Future<void> _focusPrimaryAutocomplete(WidgetTester tester) async {
  final field = find.bySemanticsLabel('Country search');
  expect(field, findsOneWidget);
  await tester.tap(field);
  await pumpBrowserUi(tester);
}

Future<void> _openAutocompleteMenu(WidgetTester tester, String query) async {
  await _focusPrimaryAutocomplete(tester);
  await tester.enterText(find.byType(EditableText).first, query);
  await pumpBrowserUi(tester, duration: const Duration(milliseconds: 400));
}

void main() {
  testWidgets(
    'Browser: theme switch stays tappable while autocomplete menu is open',
    (tester) async {
      await tester.pumpWidget(const HeadlessExampleApp());
      await pumpBrowserUi(tester, duration: const Duration(milliseconds: 400));

      await openExampleDemo(tester, 'Autocomplete Demo');
      await _openAutocompleteMenu(tester, 'fi');

      expect(find.text('Finland'), findsOneWidget);

      const modeLabel = 'Switch between Material and Cupertino theme';
      final themeSwitch = find.bySemanticsLabel(modeLabel);
      expect(themeSwitch, findsOneWidget);

      final beforeToggle = browserSwitchValue(tester, modeLabel);
      await tester.tap(themeSwitch);
      await pumpBrowserUi(tester);
      final afterToggle = browserSwitchValue(tester, modeLabel);

      expect(afterToggle, isNot(equals(beforeToggle)));
      expect(find.text('Autocomplete Demo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Browser: light/dark switch stays tappable after reopening autocomplete menu',
    (tester) async {
      await tester.pumpWidget(const HeadlessExampleApp());
      await pumpBrowserUi(tester, duration: const Duration(milliseconds: 400));

      await openExampleDemo(tester, 'Autocomplete Demo');
      await _openAutocompleteMenu(tester, 'fi');

      const brightnessLabel = 'Switch between light and dark theme';
      final brightnessSwitch = find.bySemanticsLabel(brightnessLabel);
      expect(brightnessSwitch, findsOneWidget);

      final beforeFirstToggle = browserSwitchValue(tester, brightnessLabel);
      await tester.tap(brightnessSwitch);
      await pumpBrowserUi(tester);
      final afterFirstToggle = browserSwitchValue(tester, brightnessLabel);
      expect(afterFirstToggle, isNot(equals(beforeFirstToggle)));

      await _openAutocompleteMenu(tester, 'fr');
      expect(find.text('France'), findsOneWidget);

      final beforeSecondToggle = browserSwitchValue(tester, brightnessLabel);
      await tester.tap(brightnessSwitch);
      await pumpBrowserUi(tester);
      final afterSecondToggle = browserSwitchValue(tester, brightnessLabel);

      expect(afterSecondToggle, isNot(equals(beforeSecondToggle)));
      expect(tester.takeException(), isNull);
    },
  );
}
