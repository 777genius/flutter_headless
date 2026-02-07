import 'package:flutter/material.dart';
import 'package:headless/headless.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_multi_select_scenario.dart';
import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E (multi-select pin + remove)', () {
    testWidgets(
        'IT-PIN-01: pinSelectedOptions pins and unpins after chip delete',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteMultiSelectScenario(
            openOnFocus: false,
            openOnInput: false,
            openOnTap: true,
            pinSelectedOptions: true,
            presentation: RAutocompleteSelectedValuesPresentation.chips,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      await tester.enterAutocompleteText('ge');
      tester.expectMenuOpen(expectedText: 'Germany');

      await tester.tap(find.text('Germany'));
      await tester.pumpAndSettle();

      tester.expectMultiSelected(['Germany']);
      tester.expectMultiCount(1);

      // Germany should be pinned to the top of the menu.
      final menuTextWidgets = tester.widgetList<Text>(
        find.descendant(
          of: find.byWidgetPredicate(
            (w) => w.runtimeType.toString() == 'MaterialMenuSurface',
          ),
          matching: find.byType(Text),
        ),
      );
      expect(menuTextWidgets.first.data, 'Germany');

      // Delete chip: should unselect and keep menu open.
      final chip = find.widgetWithText(InputChip, 'Germany');
      expect(chip, findsOneWidget);
      final chipWidget = tester.widget<InputChip>(chip);
      expect(chipWidget.onDeleted, isNotNull);
      chipWidget.onDeleted!.call();
      await tester.pumpAndSettle();

      tester.expectMultiSelected(const []);
      tester.expectMultiCount(0);

      // Germany should still be present (not pinned by selection).
      tester.expectMenuOpen(expectedText: 'Germany');
    });
  });
}
