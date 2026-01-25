import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';
import 'helpers/autocomplete_test_scenario.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E (IME / composing)', () {
    testWidgets('IT-IME-01: ArrowDown ignored while composing (menu stays closed)',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteTestScenario(
            openOnFocus: false,
            openOnTap: false,
            openOnInput: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      tester.expectMenuClosed();

      await tester.setAutocompleteEditingValue(
        const TextEditingValue(
          text: 'fi',
          selection: TextSelection.collapsed(offset: 2),
          composing: TextRange(start: 0, end: 2),
        ),
      );

      await tester.pressKey(LogicalKeyboardKey.arrowDown, settle: true);
      tester.expectMenuClosed();
    });

    testWidgets('IT-IME-02: openOnInput does not open menu while composing',
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

      await tester.setAutocompleteEditingValue(
        const TextEditingValue(
          text: 'fi',
          selection: TextSelection.collapsed(offset: 2),
          composing: TextRange(start: 0, end: 2),
        ),
      );

      tester.expectMenuClosed();
    });

    testWidgets('IT-IME-03: Enter ignored while composing (no selection)',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteTestScenario(
            openOnFocus: false,
            openOnTap: false,
            openOnInput: false,
            initialValue: TextEditingValue(text: 'fi'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      await tester.pressKey(LogicalKeyboardKey.arrowDown, settle: true);
      tester.expectMenuOpen();

      // Put the text field into composing mode.
      await tester.setAutocompleteEditingValue(
        const TextEditingValue(
          text: 'fi',
          selection: TextSelection.collapsed(offset: 2),
          composing: TextRange(start: 0, end: 2),
        ),
      );

      await tester.pressKey(LogicalKeyboardKey.enter, settle: true);

      // Selection should remain none.
      tester.expectSelected(null);
      // Menu should still be open (Enter ignored).
      tester.expectMenuOpen();
    });

    testWidgets('IT-IME-04: Escape ignored while composing (menu stays open)',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteTestScenario(
            openOnFocus: false,
            openOnTap: false,
            openOnInput: false,
            initialValue: TextEditingValue(text: 'fi'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      await tester.pressKey(LogicalKeyboardKey.arrowDown, settle: true);
      tester.expectMenuOpen();

      // Put the text field into composing mode.
      await tester.setAutocompleteEditingValue(
        const TextEditingValue(
          text: 'fi',
          selection: TextSelection.collapsed(offset: 2),
          composing: TextRange(start: 0, end: 2),
        ),
      );

      await tester.pressKey(LogicalKeyboardKey.escape, settle: true);

      // Menu should still be open (Escape ignored).
      tester.expectMenuOpen();
    });

    testWidgets(
        'IT-IME-05: Tab closes menu while composing; composing updates do not reopen',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteTestScenario(
            openOnFocus: false,
            openOnTap: false,
            openOnInput: true,
            initialValue: TextEditingValue(text: 'fi'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      await tester.pressKey(LogicalKeyboardKey.arrowDown, settle: true);
      tester.expectMenuOpen();

      // Put the text field into composing mode.
      await tester.setAutocompleteEditingValue(
        const TextEditingValue(
          text: 'fi',
          selection: TextSelection.collapsed(offset: 2),
          composing: TextRange(start: 0, end: 2),
        ),
      );

      // Tab should close the menu even while composing (focus traversal + dismissed).
      await tester.pressKey(LogicalKeyboardKey.tab, settle: true);
      tester.expectMenuClosed();

      // Further composing updates (text changes) must NOT reopen.
      await tester.setAutocompleteEditingValue(
        const TextEditingValue(
          text: 'fin',
          selection: TextSelection.collapsed(offset: 3),
          composing: TextRange(start: 0, end: 3),
        ),
      );
      tester.expectMenuClosed();
    });
  });
}

