import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';
import 'helpers/autocomplete_test_scenario.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E (keyboard)', () {
    testWidgets('IT-KBD-01: Home/End move highlight while menu is open',
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

      await tester.tapAutocompleteField();
      tester.expectMenuOpen();

      await tester.pressKey(LogicalKeyboardKey.end, settle: true);
      // "Fiji" should be reachable by End for the 'fi' query list.
      expect(find.text('Fiji'), findsOneWidget);

      await tester.pressKey(LogicalKeyboardKey.home, settle: true);
      expect(find.text('Finland'), findsOneWidget);
    });

    testWidgets('IT-KBD-02: PageUp/PageDown map to first/last',
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

      await tester.tapAutocompleteField();
      tester.expectMenuOpen();

      await tester.pressKey(LogicalKeyboardKey.pageDown, settle: true);
      expect(find.text('Fiji'), findsOneWidget);

      await tester.pressKey(LogicalKeyboardKey.pageUp, settle: true);
      expect(find.text('Finland'), findsOneWidget);
    });

    testWidgets('IT-KBD-03: Shift+Tab closes menu and refocus does not reopen',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteTestScenario(
            openOnFocus: true,
            openOnTap: false,
            openOnInput: false,
            initialValue: TextEditingValue(text: 'fi'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      tester.expectMenuOpen();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pressKey(LogicalKeyboardKey.tab, settle: true);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      tester.expectMenuClosed();

      // Refocus: should NOT reopen due to dismissed-policy.
      await tester.tapAutocompleteField();
      tester.expectMenuClosed();
    });
  });
}

