import 'package:flutter_test/flutter_test.dart';
import 'package:headless/headless.dart';

import 'helpers/autocomplete_multi_select_scenario.dart';
import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';

final _menuSurface = find.byWidgetPredicate(
  (w) => w.runtimeType.toString() == 'MaterialMenuSurface',
);

void main() {
  testWidgets(
      'Multi-select: selecting an item keeps menu open (allows multiple picks)',
      (tester) async {
    await tester.pumpWidget(
      const AutocompleteTestApp(
        child: AutocompleteMultiSelectScenario(
          hideSelectedOptions: false,
          pinSelectedOptions: false,
          presentation: RAutocompleteSelectedValuesPresentation.chips,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tapAutocompleteField();
    tester.expectMenuOpen();
    expect(_menuSurface, findsOneWidget);

    await tester.tap(find.text('Finland'));
    await tester.pump(); // first frame after selection

    // Must remain open across multiple frames (no close+reopen flicker).
    for (var i = 0; i < 12; i++) {
      expect(_menuSurface, findsOneWidget);
      await tester.pump(const Duration(milliseconds: 16));
    }

    // Menu must remain open so user can select multiple items.
    tester.expectMenuOpen();

    // Pick another item without re-opening.
    await tester.tap(find.text('France'));
    await tester.pumpAndSettle();
    tester.expectMenuOpen();

    expect(find.text('Finland'), findsWidgets);
    expect(find.text('France'), findsWidgets);
  });
}

