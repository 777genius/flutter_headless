import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_rich_scenario.dart';
import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';
import 'helpers/autocomplete_multi_select_scenario.dart';
import 'helpers/autocomplete_test_scenario.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E Tests', () {
    testWidgets('IT-01: Tap opens menu when query exists', (tester) async {
      await tester.pumpWidget(
        AutocompleteTestApp(
          child: AutocompleteTestScenario(
            initialValue: const TextEditingValue(text: 'fi'),
            openOnFocus: false,
            openOnInput: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      tester.expectMenuClosed();
      await tester.tapAutocompleteField();
      tester.expectMenuOpen();
    });

    testWidgets('IT-02: Typing filters options and opens menu', (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteTestScenario(
            openOnFocus: false,
            openOnTap: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      await tester.enterAutocompleteText('fr');

      expect(find.text('France'), findsOneWidget);
      expect(find.text('Finland'), findsNothing);
    });

    testWidgets('IT-03: openOnInput opens menu on typing', (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteTestScenario(
            openOnFocus: false,
            openOnTap: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      tester.expectMenuClosed();

      await tester.enterAutocompleteText('fi');
      tester.expectMenuOpen();
    });

    testWidgets('IT-04: openOnFocus opens menu on focus gain', (tester) async {
      await tester.pumpWidget(
        AutocompleteTestApp(
          child: AutocompleteTestScenario(
            initialValue: const TextEditingValue(text: 'fi'),
            openOnTap: false,
            openOnInput: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      tester.expectMenuClosed();
      await tester.tapAutocompleteField();
      tester.expectMenuOpen();
    });

    testWidgets('IT-05: ArrowDown + Enter selects second option', (tester) async {
      await tester.pumpWidget(
        AutocompleteTestApp(
          child: AutocompleteTestScenario(
            initialValue: const TextEditingValue(text: 'fi'),
            openOnFocus: false,
            openOnInput: false,
            openOnTap: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      await tester.pressKey(LogicalKeyboardKey.arrowDown, settle: true);
      await tester.pressKey(LogicalKeyboardKey.arrowDown);
      await tester.pressKey(LogicalKeyboardKey.enter, settle: true);

      tester.expectSelected('Fiji');
    });

    testWidgets('IT-06: Tap outside closes menu', (tester) async {
      await tester.pumpWidget(
        AutocompleteTestApp(
          child: AutocompleteTestScenario(
            initialValue: const TextEditingValue(text: 'fi'),
            openOnFocus: false,
            openOnInput: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      tester.expectMenuOpen();

      await tester.closeAutocompleteByTapOutside();
      tester.expectMenuClosed();
    });

    testWidgets('IT-07: Rich item content renders dial code', (tester) async {
      await tester.pumpWidget(
        AutocompleteTestApp(
          child: AutocompleteRichScenario(
            initialValue: const TextEditingValue(text: 'fr'),
            openOnFocus: false,
            openOnInput: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      tester.expectMenuOpen(expectedText: 'France');

      expect(find.text('+33'), findsOneWidget);
      expect(find.text('FR'), findsWidgets);
    });

    testWidgets('IT-08: closeOnSelected=false keeps menu open', (tester) async {
      await tester.pumpWidget(
        AutocompleteTestApp(
          child: AutocompleteTestScenario(
            initialValue: const TextEditingValue(text: 'fi'),
            openOnFocus: false,
            openOnInput: false,
            closeOnSelected: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      tester.expectMenuOpen();

      await tester.tap(find.text('Fiji'));
      await tester.pumpAndSettle();

      tester.expectSelected('Fiji');
      tester.expectMenuOpen(expectedText: 'Fiji');
    });

    testWidgets('IT-09: tap reopens menu after dismiss', (tester) async {
      await tester.pumpWidget(
        AutocompleteTestApp(
          child: AutocompleteTestScenario(
            initialValue: const TextEditingValue(text: 'fi'),
            openOnFocus: false,
            openOnInput: false,
            openOnTap: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      tester.expectMenuOpen();

      await tester.closeAutocompleteByTapOutside();
      tester.expectMenuClosed();

      await tester.tapAutocompleteField();
      tester.expectMenuOpen();
    });

    testWidgets('IT-10: Multi-select toggles and clears query', (tester) async {
      await tester.pumpWidget(
        AutocompleteTestApp(
          child: AutocompleteMultiSelectScenario(
            initialValue: const TextEditingValue(text: 'fi'),
            openOnTap: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      tester.expectMenuOpen();

      await tester.tap(find.text('Finland'));
      await tester.pumpAndSettle();

      tester.expectMultiSelected(['Finland']);
      tester.expectMultiCount(1);

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.controller.text, '');
      tester.expectMenuOpen(expectedText: 'Finland');
      expect(find.byType(Checkbox), findsWidgets);
    });

    testWidgets('IT-11: Backspace removes last selected', (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteMultiSelectScenario(
            openOnTap: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      await tester.tap(find.text('Finland'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('France'));
      await tester.pumpAndSettle();

      tester.expectMultiSelected(['Finland', 'France']);
      tester.expectMultiCount(2);

      await tester.pressKey(LogicalKeyboardKey.backspace, settle: true);
      tester.expectMultiSelected(['Finland']);
      tester.expectMultiCount(1);
    });

    testWidgets('IT-12: hideSelectedOptions removes selected from menu',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteMultiSelectScenario(
            openOnTap: true,
            hideSelectedOptions: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      await tester.tap(find.text('Finland'));
      await tester.pumpAndSettle();

      // Finland should be hidden now.
      expect(find.text('Finland'), findsNothing);
      expect(find.text('France'), findsOneWidget);
    });

    testWidgets('IT-13: pinSelectedOptions moves selected to top',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteMultiSelectScenario(
            openOnTap: true,
            pinSelectedOptions: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      await tester.tap(find.text('Germany'));
      await tester.pumpAndSettle();

      final textWidgets = tester.widgetList<Text>(
        find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Text),
        ),
      );
      expect(textWidgets.first.data, 'Germany');
    });
  });
}
