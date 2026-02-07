import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless/headless.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';

class _ImeDismissedCycleScenario extends StatelessWidget {
  const _ImeDismissedCycleScenario();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            RAutocomplete<String>(
              source: RAutocompleteLocalSource(
                options: (_) => const ['Finland', 'France', 'Germany'],
              ),
              itemAdapter: HeadlessItemAdapter<String>(
                id: (v) => ListboxItemId(v),
                primaryText: (v) => v,
                searchText: (v) => v,
              ),
              onSelected: (_) {},
              openOnFocus: false,
              openOnInput: true,
              openOnTap: true,
              closeOnSelected: true,
            ),
            const SizedBox(height: 500), // a safe outside area to tap
          ],
        ),
      ),
    );
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E (IME composing + dismissed cycle)', () {
    testWidgets(
      'IT-IME-DISMISS-01: dismiss while composing does not get reset by composing updates; no auto-open after commit',
      (tester) async {
        await tester.pumpWidget(
          const AutocompleteTestApp(
            child: _ImeDismissedCycleScenario(),
          ),
        );
        await tester.pumpAndSettle();

        // Open via tap.
        await tester.tap(find.byType(EditableText));
        await tester.pumpAndSettle();
        tester.expectMenuOpen();

        // Simulate IME composing update.
        await tester.setAutocompleteEditingValue(
          const TextEditingValue(
            text: 'f',
            selection: TextSelection.collapsed(offset: 1),
            composing: TextRange(start: 0, end: 1),
          ),
        );

        // Dismiss via outside tap.
        await tester.closeAutocompleteByTapOutside();
        tester.expectMenuClosed();

        // Another composing update should NOT "undismiss" anything.
        await tester.setAutocompleteEditingValue(
          const TextEditingValue(
            text: 'fi',
            selection: TextSelection.collapsed(offset: 2),
            composing: TextRange(start: 0, end: 2),
          ),
        );
        tester.expectMenuClosed();

        // Commit composition (composing empty). Menu must stay closed until user interacts.
        await tester.setAutocompleteEditingValue(
          const TextEditingValue(
            text: 'fi',
            selection: TextSelection.collapsed(offset: 2),
            composing: TextRange.empty,
          ),
        );
        tester.expectMenuClosed();

        // Explicit user intent opens it again.
        await tester.pressKey(LogicalKeyboardKey.arrowDown, settle: true);
        tester.expectMenuOpen();
      },
    );
  });
}
