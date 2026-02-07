import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_multi_select_scenario.dart';
import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';

final _menuSurface = find.byWidgetPredicate(
  (w) => w.runtimeType.toString() == 'MaterialMenuSurface',
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E (multi-select toggle stays open)', () {
    testWidgets('IT-MS-TOGGLE-01: tap toggles selection without closing menu',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteMultiSelectScenario(
            openOnFocus: true,
            openOnInput: true,
            openOnTap: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      tester.expectMenuOpen();
      expect(_menuSurface, findsOneWidget);

      // Toggle ON.
      await tester.tap(
        find.descendant(
          of: _menuSurface,
          matching: find.text('Finland'),
        ),
      );
      await tester.pumpAndSettle();
      expect(_menuSurface, findsOneWidget);
      tester.expectMultiSelected(['Finland']);
      tester.expectMultiCount(1);

      // Toggle OFF (tap again).
      await tester.tap(
        find.descendant(
          of: _menuSurface,
          matching: find.text('Finland'),
        ),
      );
      await tester.pumpAndSettle();
      expect(_menuSurface, findsOneWidget);
      tester.expectMultiSelected(const []);
      tester.expectMultiCount(0);

      // Escape closes (sanity).
      await tester.pressKey(LogicalKeyboardKey.escape, settle: true);
      tester.expectMenuClosed();
      expect(_menuSurface, findsNothing);
    });
  });
}
