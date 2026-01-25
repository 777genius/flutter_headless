import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';
import 'helpers/autocomplete_test_scenario.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E (outside tap)', () {
    testWidgets(
        'IT-OUT-01: tap outside closes and does not immediately reopen when openOnFocus=true',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteTestScenario(
            openOnFocus: true,
            openOnTap: true,
            openOnInput: false,
            initialValue: TextEditingValue(text: 'fi'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      tester.expectMenuOpen();

      await tester.closeAutocompleteByTapOutside();
      tester.expectMenuClosed();

      // Ensure it stays closed after a bit of settling.
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
      tester.expectMenuClosed();
    });
  });
}

