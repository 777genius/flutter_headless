import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless/headless.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_multi_select_scenario.dart';
import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';

final _menuSurface = find.byWidgetPredicate(
  (w) => w.runtimeType.toString() == 'MaterialMenuSurface',
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E (multi-select toxic flags)', () {
    testWidgets(
        'IT-TOXIC-MS-01: openOnFocus+openOnInput true, selection does not flicker, '
        'Escape dismisses, delete chip does not reopen, typing reopens',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteMultiSelectScenario(
            openOnFocus: true,
            openOnInput: true,
            openOnTap: true,
            includeFocusTarget: true,
            presentation: RAutocompleteSelectedValuesPresentation.chips,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Focus field; menu should open (openOnFocus) and have items.
      await tester.tapAutocompleteField();
      tester.expectMenuOpen();
      expect(_menuSurface, findsOneWidget);

      // Select Finland. In multi-select the menu must remain open and not flicker.
      await tester.tap(find.text('Finland'));
      await tester.pump(); // first frame after selection

      for (var i = 0; i < 12; i++) {
        expect(_menuSurface, findsOneWidget);
        await tester.pump(const Duration(milliseconds: 16));
      }

      tester.expectMultiSelected(['Finland']);
      tester.expectMultiCount(1);

      // Escape should dismiss and keep dismissed state.
      await tester.pressKey(LogicalKeyboardKey.escape, settle: true);
      tester.expectMenuClosed();
      expect(_menuSurface, findsNothing);

      // Move focus away, then delete chip. This requests focus back to the field,
      // but must not open menu via openOnFocus.
      await tester.tap(find.byKey(const Key('other_focus_target')));
      await tester.pumpAndSettle();

      final chip = find.widgetWithText(InputChip, 'Finland');
      expect(chip, findsOneWidget);
      final chipWidget = tester.widget<InputChip>(chip);
      expect(chipWidget.onDeleted, isNotNull);
      chipWidget.onDeleted!.call();
      await tester.pumpAndSettle();

      tester.expectMultiSelected(const []);
      tester.expectMultiCount(0);
      tester.expectMenuClosed();
      expect(_menuSurface, findsNothing);

      // Now typing should be treated as user input and reopen (openOnInput).
      await tester.enterAutocompleteText('fi');
      tester.expectMenuOpen(expectedText: 'Finland');
      expect(_menuSurface, findsOneWidget);
    });
  });
}

