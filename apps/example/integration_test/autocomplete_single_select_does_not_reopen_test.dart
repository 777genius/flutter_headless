import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless/headless.dart';

import 'helpers/autocomplete_test_app.dart';

final _menuSurface = find.byWidgetPredicate(
  (w) => w.runtimeType.toString() == 'MaterialMenuSurface',
);

class _SingleSelectReopenScenario extends StatefulWidget {
  const _SingleSelectReopenScenario();

  @override
  State<_SingleSelectReopenScenario> createState() =>
      _SingleSelectReopenScenarioState();
}

class _SingleSelectReopenScenarioState extends State<_SingleSelectReopenScenario> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RAutocomplete<String>(
              source: RAutocompleteLocalSource(
                options: (_) => const ['Alpha', 'Beta', 'Gamma'],
              ),
              itemAdapter: HeadlessItemAdapter<String>(
                id: (v) => ListboxItemId(v),
                primaryText: (v) => v,
                searchText: (v) => v,
              ),
              onSelected: (v) => setState(() => _selected = v),
              openOnTap: true,
              openOnInput: true,
              openOnFocus: true,
              closeOnSelected: true,
              placeholder: 'Pick one',
            ),
            const SizedBox(height: 12),
            Text('Selected: ${_selected ?? 'none'}'),
          ],
        ),
      ),
    );
  }
}

void main() {
  testWidgets('Single-select: selecting closes menu and does not reopen', (tester) async {
    await tester.pumpWidget(
      const AutocompleteTestApp(
        child: _SingleSelectReopenScenario(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(EditableText));
    await tester.pumpAndSettle();
    expect(_menuSurface, findsOneWidget);
    expect(find.text('Alpha'), findsOneWidget);

    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();

    // Must be fully closed after selection.
    expect(_menuSurface, findsNothing);

    // Must stay closed across multiple frames (no close+reopen flicker).
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 16));
      expect(_menuSurface, findsNothing);
    }

    expect(find.text('Selected: Alpha'), findsOneWidget);
  });
}

