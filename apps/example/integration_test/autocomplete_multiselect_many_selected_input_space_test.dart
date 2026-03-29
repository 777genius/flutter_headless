import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_many_items_scenario.dart';
import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'IT-MULTI-SPACE-01: many selected values still leave room to type',
    (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteManyItemsScenario(
            openOnFocus: true,
            openOnInput: true,
            openOnTap: true,
            initialSelectedValues: <String>[
              'Germany',
              'Japan',
              'France',
              'United States',
              'Norway',
              'Sweden',
              'Italy',
              'Portugal',
              'Canada',
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      tester.expectMenuOpen(expectedText: 'Argentina');

      await tester.enterAutocompleteText('fi');
      tester.expectMenuOpen(expectedText: 'Finland');
      expect(find.text('Finland'), findsWidgets);
    },
  );
}
