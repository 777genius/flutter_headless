import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_multi_select_scenario.dart';
import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E (multi-select chips)', () {
    testWidgets(
        'IT-MS-01: deleting chip removes selection and does not open menu',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteMultiSelectScenario(
            openOnFocus: false,
            openOnInput: false,
            openOnTap: false,
            initialValue: TextEditingValue(text: 'fi'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Focus field, open menu via keyboard.
      await tester.tapAutocompleteField();
      tester.expectMenuClosed();
      await tester.pressKey(LogicalKeyboardKey.arrowDown, settle: true);
      tester.expectMenuOpen();

      // Select Finland to create a chip, then close the menu.
      await tester.tap(find.text('Finland'));
      await tester.pumpAndSettle();
      tester.expectMultiSelected(['Finland']);
      tester.expectMultiCount(1);

      await tester.pressKey(LogicalKeyboardKey.escape, settle: true);
      tester.expectMenuClosed();

      // Trigger chip deletion (removeById path).
      final chip = find.widgetWithText(InputChip, 'Finland');
      expect(chip, findsOneWidget);
      final chipWidget = tester.widget<InputChip>(chip);
      expect(chipWidget.onDeleted, isNotNull);
      chipWidget.onDeleted!.call();
      await tester.pumpAndSettle();

      tester.expectMultiSelected(const []);
      tester.expectMultiCount(0);
      tester.expectMenuClosed();
    });
  });
}
