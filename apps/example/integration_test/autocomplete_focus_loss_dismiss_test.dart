import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';
import 'helpers/autocomplete_test_scenario.dart';

final _menuSurface = find.byWidgetPredicate(
  (w) => w.runtimeType.toString() == 'MaterialMenuSurface',
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E (focus loss dismiss)', () {
    testWidgets(
        'IT-FOCUSLOSS-01: focus loss closes menu and prevents openOnFocus reopen until user interacts',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteTestScenario(
            openOnFocus: true,
            openOnInput: false,
            openOnTap: false,
            closeOnSelected: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Focus field and open via keyboard.
      await tester.tapAutocompleteField();
      await tester.enterAutocompleteText('fi');
      await tester.pressKey(LogicalKeyboardKey.arrowDown, settle: true);
      tester.expectMenuOpen();
      expect(_menuSurface, findsOneWidget);

      // Force focus loss (simulates Tab/click-away focus leaving the field).
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      tester.expectMenuClosed();
      expect(_menuSurface, findsNothing);

      // Refocus should NOT auto-open because it was dismissed.
      await tester.tapAutocompleteField();
      await tester.pumpAndSettle();
      tester.expectMenuClosed();

      // But user interaction (ArrowDown) should open.
      await tester.pressKey(LogicalKeyboardKey.arrowDown, settle: true);
      tester.expectMenuOpen();
    });
  });
}

