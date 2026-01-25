import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless/headless.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_test_app.dart';

final _menuSurface = find.byWidgetPredicate(
  (w) => w.runtimeType.toString() == 'MaterialMenuSurface',
);

class _SingleToxicScenario extends StatefulWidget {
  const _SingleToxicScenario();

  @override
  State<_SingleToxicScenario> createState() => _SingleToxicScenarioState();
}

class _SingleToxicScenarioState extends State<_SingleToxicScenario> {
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
              openOnFocus: true,
              openOnInput: true,
              openOnTap: true,
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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E (single toxic flags)', () {
    testWidgets(
        'IT-TOXIC-S-01: openOnFocus+openOnInput true, selection closes and does not flicker reopen, '
        'typing reopens',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: _SingleToxicScenario(),
        ),
      );
      await tester.pumpAndSettle();

      // Focus field; menu should open (openOnFocus).
      await tester.tap(find.byType(EditableText));
      await tester.pumpAndSettle();
      expect(_menuSurface, findsOneWidget);
      expect(find.text('Alpha'), findsOneWidget);

      // Select Alpha. Menu must close and not reopen (no flicker).
      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();

      expect(_menuSurface, findsNothing);
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 16));
        expect(_menuSurface, findsNothing);
      }
      expect(find.text('Selected: Alpha'), findsOneWidget);

      // Typing should reopen (openOnInput).
      await tester.enterText(find.byType(EditableText), 'b');
      await tester.pumpAndSettle();
      expect(_menuSurface, findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);

      // Escape dismisses (optional sanity check).
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(_menuSurface, findsNothing);
    });
  });
}

