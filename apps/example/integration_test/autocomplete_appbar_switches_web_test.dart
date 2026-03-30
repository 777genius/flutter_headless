import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:headless_switch/headless_switch.dart';

import 'package:headless_example/main.dart' show HeadlessExampleApp;

bool _switchValue(WidgetTester tester, String semanticLabel) {
  return tester
      .widget<RSwitch>(
        find.byWidgetPredicate(
          (widget) =>
              widget is RSwitch && widget.semanticLabel == semanticLabel,
        ),
      )
      .value;
}

Future<void> _openAutocompleteDemo(WidgetTester tester) async {
  final tile = find.text('Autocomplete Demo');
  await tester.scrollUntilVisible(
    tile,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.tap(tile);
  await tester.pumpAndSettle();
}

Future<void> _focusPrimaryAutocomplete(WidgetTester tester) async {
  final field = find.bySemanticsLabel('Country search');
  expect(field, findsOneWidget);
  await tester.tap(field);
  await tester.pumpAndSettle();
}

Future<void> _openAutocompleteMenu(
  WidgetTester tester, {
  required String query,
  required String expectedText,
}) async {
  await _focusPrimaryAutocomplete(tester);
  await tester.enterText(find.byType(EditableText).first, query);
  await tester.pumpAndSettle();
  expect(find.text(expectedText), findsOneWidget);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'WEB: AppBar theme switch stays tappable while autocomplete menu is open',
    (tester) async {
      await tester.pumpWidget(const HeadlessExampleApp());
      await tester.pumpAndSettle();

      await _openAutocompleteDemo(tester);
      await _openAutocompleteMenu(
        tester,
        query: 'fi',
        expectedText: 'Finland',
      );

      const modeLabel = 'Switch between Material and Cupertino theme';
      final themeSwitch = find.bySemanticsLabel(modeLabel);
      expect(themeSwitch, findsOneWidget);

      final beforeToggle = _switchValue(tester, modeLabel);
      await tester.tap(themeSwitch);
      await tester.pumpAndSettle();
      final afterToggle = _switchValue(tester, modeLabel);

      expect(afterToggle, isNot(equals(beforeToggle)));
      expect(find.text('Autocomplete Demo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'WEB: Light/dark AppBar switch stays tappable after reopening autocomplete menu',
    (tester) async {
      await tester.pumpWidget(const HeadlessExampleApp());
      await tester.pumpAndSettle();

      await _openAutocompleteDemo(tester);
      await _openAutocompleteMenu(
        tester,
        query: 'fi',
        expectedText: 'Finland',
      );

      const brightnessLabel = 'Switch between light and dark theme';
      final brightnessSwitch = find.bySemanticsLabel(brightnessLabel);
      expect(brightnessSwitch, findsOneWidget);

      final beforeFirstToggle = _switchValue(tester, brightnessLabel);
      await tester.tap(brightnessSwitch);
      await tester.pumpAndSettle();
      final afterFirstToggle = _switchValue(tester, brightnessLabel);
      expect(afterFirstToggle, isNot(equals(beforeFirstToggle)));

      await _openAutocompleteMenu(
        tester,
        query: 'fr',
        expectedText: 'France',
      );
      expect(find.text('France'), findsOneWidget);

      final beforeSecondToggle = _switchValue(tester, brightnessLabel);
      await tester.tap(brightnessSwitch);
      await tester.pumpAndSettle();
      final afterSecondToggle = _switchValue(tester, brightnessLabel);

      expect(afterSecondToggle, isNot(equals(beforeSecondToggle)));
      expect(tester.takeException(), isNull);
    },
  );
}
