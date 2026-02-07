import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_duplicate_ids_scenario.dart';
import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E (duplicate ids)', () {
    testWidgets('IT-DUP-01: duplicate ids are de-duped (no crash)',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: AutocompleteDuplicateIdsScenario(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAutocompleteField();

      // Exactly one of the duplicate options should be present after de-dupe.
      final alpha1 = find.text('Alpha-1');
      final alpha2 = find.text('Alpha-2');
      expect(alpha1.evaluate().length + alpha2.evaluate().length, 1);

      expect(find.text('Beta'), findsOneWidget);
    });
  });
}
