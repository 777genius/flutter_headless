import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_multi_select_scenario.dart';
import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E (multi-select hide + delete)', () {
    testWidgets('IT-MS-02: hideSelectedOptions + delete chip restores option',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteMultiSelectScenario(
            openOnFocus: false,
            openOnInput: false,
            openOnTap: true,
            hideSelectedOptions: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      await tester.enterAutocompleteText('fi');
      tester.expectMenuOpen(expectedText: 'Finland');

      await tester.tap(find.text('Finland'));
      await tester.pumpAndSettle();

      tester.expectMultiSelected(['Finland']);
      tester.expectMultiCount(1);

      // Menu stays open in multiple mode by default; Finland should be hidden now.
      tester.expectMenuClosed(expectedText: 'Finland');

      // Delete chip programmatically (stable for iOS).
      final chip = find.widgetWithText(InputChip, 'Finland');
      expect(chip, findsOneWidget);
      final chipWidget = tester.widget<InputChip>(chip);
      expect(chipWidget.onDeleted, isNotNull);
      chipWidget.onDeleted!.call();
      await tester.pumpAndSettle();

      tester.expectMultiSelected(const []);
      tester.expectMultiCount(0);

      // Now Finland should be back in menu.
      tester.expectMenuOpen(expectedText: 'Finland');
    });
  });
}

