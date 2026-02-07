import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';
import 'helpers/autocomplete_test_scenario.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E (dismissed-policy)', () {
    testWidgets('IT-DIS-01: Escape dismiss + tap resets dismissed and reopens',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteTestScenario(
            openOnFocus: false,
            openOnTap: true,
            openOnInput: false,
            initialValue: TextEditingValue(text: 'fi'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open menu.
      await tester.tapAutocompleteField();
      tester.expectMenuOpen();

      // Dismiss (Escape).
      await tester.pressKey(LogicalKeyboardKey.escape, settle: true);
      tester.expectMenuClosed();

      // Tap should reset dismissed and reopen.
      await tester.tapAutocompleteField();
      tester.expectMenuOpen();
    });

    testWidgets(
        'IT-DIS-02: Escape dismiss + input resets dismissed and reopens',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteTestScenario(
            openOnFocus: false,
            openOnTap: false,
            openOnInput: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      tester.expectMenuClosed();

      await tester.enterAutocompleteText('fi');
      tester.expectMenuOpen();

      // Dismiss (Escape).
      await tester.pressKey(LogicalKeyboardKey.escape, settle: true);
      tester.expectMenuClosed();

      // Input should reset dismissed and open again.
      await tester.enterAutocompleteText('fin');
      tester.expectMenuOpen(expectedText: 'Finland');
    });
  });
}
