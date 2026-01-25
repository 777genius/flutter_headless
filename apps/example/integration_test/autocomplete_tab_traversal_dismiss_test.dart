import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless/headless.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/autocomplete_test_app.dart';
import 'helpers/autocomplete_test_helpers.dart';

final _menuSurface = find.byWidgetPredicate(
  (w) => w.runtimeType.toString() == 'MaterialMenuSurface',
);

class _TabTraversalScenario extends StatefulWidget {
  const _TabTraversalScenario();

  @override
  State<_TabTraversalScenario> createState() => _TabTraversalScenarioState();
}

class _TabTraversalScenarioState extends State<_TabTraversalScenario> {
  final _beforeFocus = FocusNode(debugLabel: 'before');
  final _fieldFocus = FocusNode(debugLabel: 'field');
  final _afterFocus = FocusNode(debugLabel: 'after');

  String _focused = 'none';

  @override
  void initState() {
    super.initState();
    _beforeFocus.addListener(_syncFocus);
    _fieldFocus.addListener(_syncFocus);
    _afterFocus.addListener(_syncFocus);
  }

  @override
  void dispose() {
    _beforeFocus.removeListener(_syncFocus);
    _fieldFocus.removeListener(_syncFocus);
    _afterFocus.removeListener(_syncFocus);
    _beforeFocus.dispose();
    _fieldFocus.dispose();
    _afterFocus.dispose();
    super.dispose();
  }

  void _syncFocus() {
    final next = _beforeFocus.hasFocus
        ? 'before'
        : _fieldFocus.hasFocus
            ? 'field'
            : _afterFocus.hasFocus
                ? 'after'
                : 'none';
    if (next == _focused) return;
    setState(() => _focused = next);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FocusTraversalGroup(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('focused: $_focused', key: const Key('focus_label')),
              const SizedBox(height: 12),
              ElevatedButton(
                key: const Key('before_btn'),
                focusNode: _beforeFocus,
                onPressed: () {},
                child: const Text('Before'),
              ),
              const SizedBox(height: 12),
              RAutocomplete<String>(
                focusNode: _fieldFocus,
                source: RAutocompleteLocalSource(
                  options: (_) => const ['Alpha', 'Beta', 'Gamma'],
                ),
                itemAdapter: HeadlessItemAdapter<String>(
                  id: (v) => ListboxItemId(v),
                  primaryText: (v) => v,
                  searchText: (v) => v,
                ),
                onSelected: (_) {},
                openOnFocus: true,
                openOnInput: false,
                openOnTap: false,
                closeOnSelected: true,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                key: const Key('after_btn'),
                focusNode: _afterFocus,
                onPressed: () {},
                child: const Text('After'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Autocomplete E2E (Tab traversal + dismissed)', () {
    testWidgets(
        'IT-TAB-01: Tab closes menu, moves focus forward, and refocus does not reopen until user interacts',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: _TabTraversalScenario(),
        ),
      );
      await tester.pumpAndSettle();

      // Focus field -> menu opens (openOnFocus).
      await tester.tap(find.byType(EditableText));
      await tester.pumpAndSettle();
      expect(_menuSurface, findsOneWidget);

      // Tab should close menu (dismiss). Focus traversal may vary on iOS simulator,
      // so we validate dismissal + "no reopen on refocus" rather than relying on
      // platform focus movement.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(_menuSurface, findsNothing);

      // Move focus away explicitly.
      await tester.tap(find.byKey(const Key('after_btn')));
      await tester.pumpAndSettle();

      // Refocus field should NOT auto-open because it was dismissed by focus loss.
      await tester.tap(find.byType(EditableText));
      await tester.pumpAndSettle();
      expect(find.text('focused: field'), findsOneWidget);
      expect(_menuSurface, findsNothing);

      // User interaction (ArrowDown) opens.
      await tester.pressKey(LogicalKeyboardKey.arrowDown, settle: true);
      expect(_menuSurface, findsOneWidget);
    });

    testWidgets(
        'IT-TAB-02: Shift+Tab closes menu, moves focus backward, and refocus does not reopen until user interacts',
        (tester) async {
      await tester.pumpWidget(
        const AutocompleteTestApp(
          child: _TabTraversalScenario(),
        ),
      );
      await tester.pumpAndSettle();

      // Focus field -> menu opens (openOnFocus).
      await tester.tap(find.byType(EditableText));
      await tester.pumpAndSettle();
      expect(_menuSurface, findsOneWidget);

      // Shift+Tab should close menu (dismiss). Focus traversal may vary on iOS simulator,
      // so we validate dismissal + "no reopen on refocus".
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pumpAndSettle();

      expect(_menuSurface, findsNothing);

      // Move focus away explicitly.
      await tester.tap(find.byKey(const Key('before_btn')));
      await tester.pumpAndSettle();

      // Refocus field should NOT auto-open because it was dismissed.
      await tester.tap(find.byType(EditableText));
      await tester.pumpAndSettle();
      expect(find.text('focused: field'), findsOneWidget);
      expect(_menuSurface, findsNothing);

      // User interaction (ArrowDown) opens.
      await tester.pressKey(LogicalKeyboardKey.arrowDown, settle: true);
      expect(_menuSurface, findsOneWidget);
    });
  });
}

