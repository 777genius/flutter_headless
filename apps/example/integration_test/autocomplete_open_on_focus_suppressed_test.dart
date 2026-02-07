import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:headless/headless.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_multi_select_scenario.dart';
import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E (openOnFocus suppressed after chip delete)', () {
    testWidgets(
        'IT-FOCUS-01: deleting chip requests focus but does not open menu via openOnFocus',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteMultiSelectScenario(
            openOnFocus: true,
            openOnInput: false,
            openOnTap: false,
            includeFocusTarget: true,
            presentation: RAutocompleteSelectedValuesPresentation.chips,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open menu via keyboard and select an item to create a chip.
      await tester.tapAutocompleteField();
      await tester.pressKey(LogicalKeyboardKey.arrowDown, settle: true);
      tester.expectMenuOpen();

      await tester.tap(find.text('Finland'));
      await tester.pumpAndSettle();
      tester.expectMultiSelected(['Finland']);
      tester.expectMultiCount(1);

      // Close menu and move focus away from the field.
      await tester.pressKey(LogicalKeyboardKey.escape, settle: true);
      tester.expectMenuClosed();
      await tester.tap(find.byKey(const Key('other_focus_target')));
      await tester.pumpAndSettle();

      // Delete chip (this triggers requestFocus(suppressOpenOnFocusOnce: true)).
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
