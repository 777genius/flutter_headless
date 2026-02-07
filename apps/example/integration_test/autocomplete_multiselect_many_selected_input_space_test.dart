import 'package:flutter_test/flutter_test.dart';

import 'helpers/autocomplete_many_items_scenario.dart';
import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';

void main() {
  testWidgets(
    'IT-MULTI-SPACE-01: many selected values still leave room to type',
    (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteManyItemsScenario(
            openOnFocus: true,
            openOnInput: true,
            openOnTap: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();
      tester.expectMenuOpen(expectedText: 'Argentina');

      final surface = find.byWidgetPredicate(
        (w) => w.runtimeType.toString() == 'MaterialMenuSurface',
      );
      expect(surface, findsOneWidget);

      for (final name in const <String>[
        'Germany',
        'Japan',
        'France',
        'United States',
        'Norway',
        'Sweden',
        'Italy',
        'Portugal',
        'Canada',
      ]) {
        await tester
            .tap(find.descendant(of: surface, matching: find.text(name)));
        await tester.pumpAndSettle();
        tester.expectMenuOpen(expectedText: 'Argentina');
      }

      await tester.enterAutocompleteText('fi');
      tester.expectMenuOpen(expectedText: 'Finland');
      expect(find.text('Finland'), findsWidgets);
    },
  );
}
