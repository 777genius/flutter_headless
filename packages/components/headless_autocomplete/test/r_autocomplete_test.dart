import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_autocomplete/headless_autocomplete.dart';
import 'package:headless_autocomplete/r_autocomplete_style.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

final _adapter = HeadlessItemAdapter<String>.simple(
  id: (v) => ListboxItemId(v),
  titleText: (v) => v,
);

final _dupIdAdapter = HeadlessItemAdapter<String>.simple(
  id: (_) => const ListboxItemId('dup'),
  titleText: (v) => v,
);

@immutable
final class _Option {
  const _Option(this.id, this.label);
  final String id;
  final String label;
}

final _optionAdapter = HeadlessItemAdapter<_Option>(
  id: (v) => ListboxItemId(v.id),
  primaryText: (v) => v.label,
  searchText: (v) => v.label,
);

final _alwaysDisabledAdapter = HeadlessItemAdapter<String>(
  id: (v) => ListboxItemId(v),
  primaryText: (v) => v,
  searchText: (v) => v,
  isDisabled: (_) => true,
);

@immutable
final class _EqByIdOption {
  const _EqByIdOption(this.id, this.label);

  final String id;
  final String label;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _EqByIdOption && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

final _eqByIdAdapter = HeadlessItemAdapter<_EqByIdOption>(
  id: (v) => ListboxItemId(v.id),
  primaryText: (v) => v.label,
  searchText: (v) => v.label,
);

class _TestTextFieldRenderer implements RTextFieldRenderer {
  RTextFieldRenderRequest? lastRequest;

  @override
  Widget render(RTextFieldRenderRequest request) {
    lastRequest = request;
    // Consume overrides in tests to avoid "Unconsumed RenderOverrides" debug output.
    request.overrides?.get<RTextFieldOverrides>();
    return GestureDetector(
      key: const Key('autocomplete-field'),
      behavior: HitTestBehavior.opaque,
      onTap: request.commands?.tapContainer,
      child: request.input,
    );
  }
}

class _TestDropdownRenderer implements RDropdownButtonRenderer {
  RDropdownRenderRequest? lastRequest;

  @override
  Widget render(RDropdownRenderRequest request) {
    lastRequest = request;
    // Consume overrides in tests to avoid "Unconsumed RenderOverrides" debug output.
    request.overrides?.get<RDropdownOverrides>();
    if (request.state.overlayPhase == ROverlayPhase.closing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        request.commands.completeClose();
      });
    }

    return switch (request) {
      RDropdownTriggerRenderRequest() => const SizedBox.shrink(),
      RDropdownMenuRenderRequest() => _createMenu(request),
    };
  }

  Widget _createMenu(RDropdownMenuRenderRequest request) {
    return Material(
      child: Container(
        key: const Key('autocomplete-menu'),
        color: const Color(0xFFFFFFFF),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            for (var i = 0; i < request.items.length; i++)
              GestureDetector(
                key: Key('menu-item-$i'),
                onTap: request.items[i].isDisabled
                    ? null
                    : () => request.commands.selectIndex(i),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(request.items[i].primaryText),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TestTheme extends HeadlessTheme {
  _TestTheme(this._fieldRenderer, this._menuRenderer);

  final _TestTextFieldRenderer _fieldRenderer;
  final _TestDropdownRenderer _menuRenderer;

  @override
  T? capability<T>() {
    if (T == RTextFieldRenderer) return _fieldRenderer as T;
    if (T == RDropdownButtonRenderer) return _menuRenderer as T;
    if (T == RAutocompleteSelectedValuesRenderer) {
      return const _TestSelectedValuesRenderer() as T;
    }
    return null;
  }
}

final class _TestSelectedValuesRenderer
    implements RAutocompleteSelectedValuesRenderer {
  const _TestSelectedValuesRenderer();

  static RAutocompleteSelectedValuesRenderRequest? lastRequest;

  @override
  Widget render(RAutocompleteSelectedValuesRenderRequest request) {
    lastRequest = request;
    return const SizedBox(key: Key('selected-values-renderer'));
  }
}

Widget _createTestWidget({
  required _TestTextFieldRenderer fieldRenderer,
  required _TestDropdownRenderer menuRenderer,
  required Widget child,
  OverlayController? overlayController,
}) {
  final controller = overlayController ?? OverlayController();
  return MaterialApp(
    home: HeadlessThemeProvider(
      theme: _TestTheme(fieldRenderer, menuRenderer),
      child: AnchoredOverlayEngineHost(
        controller: controller,
        child: Scaffold(body: Center(child: child)),
      ),
    ),
  );
}

void main() {
  group('Selection / Text sync', () {
    testWidgets('selecting option updates text and selection', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final controller = TextEditingController();
      String? selected;

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          controller: controller,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (v) => selected = v,
          openOnTap: true,
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('menu-item-1')));
      await tester.pumpAndSettle();

      expect(selected, 'Beta');
      expect(controller.text, 'Beta');
      expect(controller.selection.isCollapsed, isTrue);
      expect(controller.selection.baseOffset, 'Beta'.length);
      controller.dispose();
    });

    testWidgets(
        'typing prefix after selection keeps selectedIndex (checkmark stays)',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final controller = TextEditingController();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          controller: controller,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta', 'Gamma']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: true,
          openOnInput: true,
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('menu-item-1'))); // Beta
      await tester.pumpAndSettle();

      // Replace by typing prefix; selection should remain (Beta still matches).
      await tester.enterText(find.byType(EditableText), 'b');
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.selectedIndex, 1);
      controller.dispose();
    });

    testWidgets('reopen after selection shows all options (filter starts on input)',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final controller = TextEditingController();

      const all = ['Alpha', 'Beta', 'Gamma'];

      Iterable<String> optionsBuilder(TextEditingValue value) {
        final q = value.text.toLowerCase();
        if (q.isEmpty) return all;
        return all.where((o) => o.toLowerCase().contains(q));
      }

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          controller: controller,
          source: RAutocompleteLocalSource(options: optionsBuilder),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: true,
          openOnFocus: false,
          openOnInput: true,
        ),
      ));

      // Open and select "Beta" (would normally make query="Beta" and filter to 1).
      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('menu-item-1')));
      await tester.pumpAndSettle();
      expect(controller.text, 'Beta');

      // Reopen: should show all options, even though field has text.
      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();
      expect(
        menuRenderer.lastRequest?.items.map((i) => i.primaryText).toList(),
        all,
      );

      controller.dispose();
    });

    testWidgets('user edit clears selection state', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: true,
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('menu-item-1')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), 'Custom');
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('autocomplete-field')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.selectedIndex, isNull);
    });
  });

  group('Options caching', () {
    testWidgets(
        'options with equality-by-id still update UI when label changes for same id',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final controller = TextEditingController(text: 'a');

      Iterable<_EqByIdOption> optionsBuilder(TextEditingValue value) {
        return switch (value.text) {
          'a' => const [_EqByIdOption('x', 'Label A1')],
          'b' => const [_EqByIdOption('x', 'Label A2')],
          _ => const <_EqByIdOption>[],
        };
      }

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<_EqByIdOption>(
          controller: controller,
          source: RAutocompleteLocalSource(options: optionsBuilder),
          itemAdapter: _eqByIdAdapter,
          onSelected: (_) {},
          openOnTap: true,
          openOnInput: true,
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();
      expect(
        menuRenderer.lastRequest?.items.map((i) => i.primaryText).toList(),
        ['Label A1'],
      );

      controller.text = 'b';
      await tester.pumpAndSettle();
      expect(
        menuRenderer.lastRequest?.items.map((i) => i.primaryText).toList(),
        ['Label A2'],
      );

      controller.dispose();
    });
  });

  group('Keyboard', () {
    testWidgets('ArrowDown opens menu and navigates highlight', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta', 'Gamma']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: false,
          openOnFocus: false,
          openOnInput: false,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.isOpen, isTrue);
      expect(menuRenderer.lastRequest?.state.highlightedIndex, 0);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(menuRenderer.lastRequest?.state.highlightedIndex, 1);

      focusNode.dispose();
    });
  });

  group('Open triggers', () {
    testWidgets('openOnTap opens menu when already focused', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: true,
          openOnFocus: false,
          openOnInput: false,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest, isNull);

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.isOpen, isTrue);
      focusNode.dispose();
    });

    testWidgets('optionsBuilder runs only on text changes', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      var callCount = 0;

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          source: RAutocompleteLocalSource(
            options: (value) {
            callCount++;
            if (value.text.isEmpty) return const ['Alpha'];
            return const ['Beta'];
          },
          ),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: true,
        ),
      ));

      expect(callCount, 1);

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();
      expect(callCount, 1);

      await tester.enterText(find.byType(EditableText), 'B');
      await tester.pumpAndSettle();
      expect(callCount, 2);
    });

    testWidgets('openOnFocus opens menu even when options are empty', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const <String>[]),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: false,
          openOnFocus: true,
          openOnInput: false,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.isOpen, isTrue);
      expect(menuRenderer.lastRequest?.items, isEmpty);

      focusNode.dispose();
    });

    testWidgets('ArrowDown opens menu even when options are empty', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const <String>[]),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: false,
          openOnFocus: false,
          openOnInput: false,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.isOpen, isTrue);
      expect(menuRenderer.lastRequest?.items, isEmpty);

      focusNode.dispose();
    });
  });

  group('Overlay + focus policy', () {
    testWidgets('focus stays on input when menu opens and closes via Escape',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: false,
          openOnFocus: false,
          openOnInput: false,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen, isTrue);
      expect(focusNode.hasFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen, isFalse);
      expect(focusNode.hasFocus, isTrue);

      focusNode.dispose();
    });

    testWidgets(
        'dismissed menu does not reopen on focus (until user interacts again)',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: false,
          openOnFocus: true,
          openOnInput: false,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen, isTrue);

      // Tap outside to dismiss (non-programmatic close).
      await tester.tapAt(const Offset(1, 1));
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen, isFalse);

      focusNode.unfocus();
      await tester.pumpAndSettle();
      focusNode.requestFocus();
      await tester.pumpAndSettle();

      // Should NOT reopen because it was dismissed.
      expect(menuRenderer.lastRequest?.state.isOpen, isFalse);

      // User interaction resets dismissed.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen, isTrue);

      focusNode.dispose();
    });

    testWidgets('programmatic close does not mark dismissed', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: false,
          openOnFocus: true,
          openOnInput: false,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen, isTrue);

      // Close programmatically via commands.close() (should NOT mark dismissed).
      menuRenderer.lastRequest?.commands.close();
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen, isFalse);

      focusNode.unfocus();
      await tester.pumpAndSettle();
      focusNode.requestFocus();
      await tester.pumpAndSettle();

      // Should reopen on focus, because it was a programmatic close.
      expect(menuRenderer.lastRequest?.state.isOpen, isTrue);

      focusNode.dispose();
    });
  });

  group('Style sugar', () {
    testWidgets('field style maps into text field overrides', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          style: const RAutocompleteStyle(
            field: RAutocompleteFieldStyle(
              containerPadding: EdgeInsets.all(12),
            ),
          ),
        ),
      ));

      final overrides =
          fieldRenderer.lastRequest?.overrides?.get<RTextFieldOverrides>();
      expect(overrides?.containerPadding, const EdgeInsets.all(12));
    });

    testWidgets('options style maps into menu overrides', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: true,
          style: const RAutocompleteStyle(
            options: RAutocompleteOptionsStyle(
              optionsBackgroundColor: Color(0xFF112233),
            ),
          ),
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      final overrides =
          menuRenderer.lastRequest?.overrides?.get<RDropdownOverrides>();
      expect(overrides?.menuBackgroundColor, const Color(0xFF112233));
    });

    testWidgets('explicit overrides win over style', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          style: const RAutocompleteStyle(
            field: RAutocompleteFieldStyle(
              containerPadding: EdgeInsets.all(4),
            ),
          ),
          fieldOverrides: RenderOverrides.only(
            const RTextFieldOverrides.tokens(
              containerPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ));

      final overrides =
          fieldRenderer.lastRequest?.overrides?.get<RTextFieldOverrides>();
      expect(overrides?.containerPadding, const EdgeInsets.all(16));
    });
  });

  group('Multiple selection', () {
    testWidgets('select toggles value, clears query, and keeps menu open by default',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      var selected = <String>[];

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: StatefulBuilder(
          builder: (context, setState) {
            return RAutocomplete<String>.multiple(
              focusNode: focusNode,
              source: RAutocompleteLocalSource(
                options: (_) => const ['Georgia', 'Florida', 'California'],
              ),
              itemAdapter: _adapter,
              selectedValues: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              openOnTap: true,
            );
          },
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      // Select item 2 (California)
      await tester.tap(find.byKey(const Key('menu-item-2')));
      await tester.pumpAndSettle();

      expect(selected, ['California']);
      expect(menuRenderer.lastRequest?.state.isOpen, isTrue);
      expect(menuRenderer.lastRequest?.state.selectedItemsIndices, contains(2));

      // Query should be cleared after selection in multiple mode.
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.controller.text, '');

      focusNode.dispose();
    });

    testWidgets('clearQueryOnSelection=false keeps query after selection',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      var selected = <String>[];
      final controller = TextEditingController(text: 'ca');

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: StatefulBuilder(
          builder: (context, setState) {
            return RAutocomplete<String>.multiple(
              controller: controller,
              source: RAutocompleteLocalSource(
                options: (_) => const ['Georgia', 'Florida', 'California'],
              ),
              itemAdapter: _adapter,
              selectedValues: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              openOnTap: true,
              clearQueryOnSelection: false,
            );
          },
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('menu-item-2')));
      await tester.pumpAndSettle();

      expect(selected, ['California']);
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.controller.text, 'ca');
    });

    testWidgets('chip remove uses removeById (stable)', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      var selected = <String>['Georgia', 'Florida'];
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: StatefulBuilder(
          builder: (context, setState) {
            return RAutocomplete<String>.multiple(
              focusNode: focusNode,
              source: RAutocompleteLocalSource(
                options: (_) => const ['Georgia', 'Florida', 'California'],
              ),
              itemAdapter: _adapter,
              selectedValues: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              openOnTap: true,
            );
          },
        ),
      ));

      await tester.pumpAndSettle();
      focusNode.requestFocus();
      await tester.pumpAndSettle();

      final req = _TestSelectedValuesRenderer.lastRequest;
      expect(req, isNotNull);
      expect(req!.selectedItems.map((e) => e.primaryText).toList(),
          ['Georgia', 'Florida']);

      req.commands.removeById(ListboxItemId('Georgia'));
      await tester.pumpAndSettle();

      expect(selected, ['Florida']);
      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets(
        'chip removal focuses input but does not open menu via openOnFocus',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      var selected = <String>['Georgia'];
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: StatefulBuilder(
          builder: (context, setState) {
            return RAutocomplete<String>.multiple(
              focusNode: focusNode,
              source: RAutocompleteLocalSource(
                options: (_) => const ['Georgia', 'Florida', 'California'],
              ),
              itemAdapter: _adapter,
              selectedValues: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              openOnFocus: true,
              openOnTap: false,
              openOnInput: false,
            );
          },
        ),
      ));

      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);
      expect(focusNode.hasFocus, isFalse);

      final req = _TestSelectedValuesRenderer.lastRequest;
      expect(req, isNotNull);

      req!.commands.removeById(ListboxItemId('Georgia'));
      await tester.pumpAndSettle();

      expect(selected, isEmpty);
      expect(focusNode.hasFocus, isTrue);
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);

      focusNode.dispose();
    });

    testWidgets('selected values render even when fieldSlots.prefix is set',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      var selected = <String>['Georgia'];
      final userPrefix = Container(key: const Key('user-prefix'));

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: StatefulBuilder(
          builder: (context, setState) {
            return RAutocomplete<String>.multiple(
              source: RAutocompleteLocalSource(
                options: (_) => const ['Georgia', 'Florida', 'California'],
              ),
              itemAdapter: _adapter,
              selectedValues: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              openOnTap: true,
              fieldSlots: RTextFieldSlots(prefix: userPrefix),
            );
          },
        ),
      ));

      await tester.pumpAndSettle();

      // Still should invoke selected values renderer even if user prefix is set.
      expect(_TestSelectedValuesRenderer.lastRequest, isNotNull);
      expect(fieldRenderer.lastRequest?.slots?.prefix, isNot(same(userPrefix)));
    });

    testWidgets(
        'chip removal triggers options refresh (hideSelectedOptions updates menu)',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      var selected = <String>[];

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: StatefulBuilder(
          builder: (context, setState) {
            return RAutocomplete<String>.multiple(
              source: RAutocompleteLocalSource(
                options: (_) => const ['Georgia', 'Florida', 'California'],
              ),
              itemAdapter: _adapter,
              selectedValues: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              openOnTap: true,
              hideSelectedOptions: true,
            );
          },
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      // Select Florida (index 1). It should disappear from menu.
      await tester.tap(find.byKey(const Key('menu-item-1')));
      await tester.pumpAndSettle();
      expect(selected, ['Florida']);
      expect(menuRenderer.lastRequest?.items.map((i) => i.primaryText).toList(),
          ['Georgia', 'California']);

      // Remove via chip command; Florida should reappear without typing/tapping.
      final req = _TestSelectedValuesRenderer.lastRequest;
      expect(req, isNotNull);
      req!.commands.removeById(ListboxItemId('Florida'));
      await tester.pumpAndSettle();

      expect(selected, isEmpty);
      expect(menuRenderer.lastRequest?.items.map((i) => i.primaryText).toList(),
          ['Georgia', 'Florida', 'California']);
    });

    testWidgets(
        'selected value not in current options: no checked indices, removeById works',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      var selected = <_Option>[const _Option('b', 'B-selected')];
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: StatefulBuilder(
          builder: (context, setState) {
            return RAutocomplete<_Option>.multiple(
              focusNode: focusNode,
              source: RAutocompleteLocalSource(
                options: (_) => const [
                _Option('a', 'A'),
                _Option('c', 'C'),
              ],
              ),
              itemAdapter: _optionAdapter,
              selectedValues: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              openOnTap: true,
              hideSelectedOptions: true,
            );
          },
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      // Menu shows only A/C, no checked indices (b isn't in options).
      expect(menuRenderer.lastRequest?.items.map((i) => i.primaryText).toList(),
          ['A', 'C']);
      expect(menuRenderer.lastRequest?.state.selectedItemsIndices ?? const <int>{},
          isEmpty);

      final req = _TestSelectedValuesRenderer.lastRequest;
      expect(req, isNotNull);
      expect(req!.selectedItems.map((e) => e.primaryText).toList(), ['B-selected']);

      req.commands.removeById(const ListboxItemId('b'));
      await tester.pumpAndSettle();

      expect(selected, isEmpty);
      expect(focusNode.hasFocus, isTrue);
      expect(menuRenderer.lastRequest?.items.map((i) => i.primaryText).toList(),
          ['A', 'C']);

      focusNode.dispose();
    });

    testWidgets(
        'duplicate selectedValues ids are normalized (deterministic toggle/remove)',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      var selected = <_Option>[
        const _Option('b', 'B-1'),
        const _Option('b', 'B-2'),
      ];

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: StatefulBuilder(
          builder: (context, setState) {
            return RAutocomplete<_Option>.multiple(
              source: RAutocompleteLocalSource(
                options: (_) => const [
                _Option('a', 'A'),
                _Option('b', 'B'),
                _Option('c', 'C'),
              ],
              ),
              itemAdapter: _optionAdapter,
              selectedValues: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              openOnTap: true,
            );
          },
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.selectedItemsIndices, contains(1));

      final req = _TestSelectedValuesRenderer.lastRequest;
      expect(req, isNotNull);
      expect(req!.selectedItems.map((e) => e.id).toList(),
          [const ListboxItemId('b')]);

      // Toggle off: should remove all values with id=b.
      menuRenderer.lastRequest!.commands.selectIndex(1);
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
    });

    testWidgets(
        'selection is reflected immediately in selectedItemsIndices even without rebuild',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      // Intentionally DO NOT rebuild on selection changes.
      var selected = <String>[];

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>.multiple(
          source: RAutocompleteLocalSource(
            options: (_) => const ['Georgia', 'Florida', 'California'],
          ),
          itemAdapter: _adapter,
          selectedValues: selected,
          onSelectionChanged: (next) => selected = next,
          openOnTap: true,
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      // Select California (index 2).
      menuRenderer.lastRequest!.commands.selectIndex(2);
      await tester.pump();

      // Optimistically reflected in menu state, even though widget didn't rebuild.
      expect(menuRenderer.lastRequest?.state.selectedItemsIndices, contains(2));

      // End-of-frame revert (since parent didn't rebuild).
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.selectedItemsIndices, isEmpty);
    });

    testWidgets('hideSelectedOptions updates immediately without rebuild',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      var selected = <String>[];

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>.multiple(
          source: RAutocompleteLocalSource(
            options: (_) => const ['Georgia', 'Florida', 'California'],
          ),
          itemAdapter: _adapter,
          selectedValues: selected,
          onSelectionChanged: (next) => selected = next,
          openOnTap: true,
          hideSelectedOptions: true,
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.items.map((i) => i.primaryText).toList(),
          ['Georgia', 'Florida', 'California']);

      menuRenderer.lastRequest!.commands.selectIndex(1); // Florida
      await tester.pumpAndSettle();

      // Should hide Florida immediately even without rebuild.
      expect(menuRenderer.lastRequest?.items.map((i) => i.primaryText).toList(),
          ['Georgia', 'California']);
    });

    testWidgets('selection indices stay valid when options list shrinks',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final controller = TextEditingController(text: 'a');

      var selected = <String>[];

      Iterable<String> optionsBuilder(TextEditingValue value) {
        final t = value.text;
        if (t == 'a') return const ['Georgia', 'Florida', 'California'];
        return const ['Georgia'];
      }

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: StatefulBuilder(
          builder: (context, setState) {
            return RAutocomplete<String>.multiple(
              controller: controller,
              source: RAutocompleteLocalSource(options: optionsBuilder),
              itemAdapter: _adapter,
              selectedValues: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              openOnTap: true,
            );
          },
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      // Select California (index 2).
      menuRenderer.lastRequest!.commands.selectIndex(2);
      await tester.pumpAndSettle();
      expect(selected, ['California']);

      // Now shrink options list via query change.
      controller.text = 'g';
      await tester.pumpAndSettle();

      // Selected item is no longer in options; indices must remain safe.
      final indices = menuRenderer.lastRequest?.state.selectedItemsIndices;
      expect(indices == null || indices.isEmpty, isTrue);
      expect(menuRenderer.lastRequest?.state.highlightedIndex, isNot(2));
    });

    testWidgets('selection indices stay valid when maxOptions shrinks',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      var selected = <String>[];
      final maxOptions = ValueNotifier<int>(3);

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: ValueListenableBuilder<int>(
          valueListenable: maxOptions,
          builder: (context, v, _) {
            return StatefulBuilder(
              builder: (context, setState) {
                return RAutocomplete<String>.multiple(
                  source: RAutocompleteLocalSource(
                    options: (_) => const ['Georgia', 'Florida', 'California'],
                  ),
                  itemAdapter: _adapter,
                  selectedValues: selected,
                  onSelectionChanged: (next) => setState(() => selected = next),
                  openOnTap: true,
                  maxOptions: v,
                );
              },
            );
          },
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      // Select California (index 2).
      menuRenderer.lastRequest!.commands.selectIndex(2);
      await tester.pumpAndSettle();
      expect(selected, ['California']);

      // Shrink maxOptions to 1 -> menu becomes just ['Georgia'].
      maxOptions.value = 1;
      await tester.pumpAndSettle();

      final items = menuRenderer.lastRequest?.items.map((i) => i.primaryText).toList();
      expect(items, ['Georgia']);

      final indices = menuRenderer.lastRequest?.state.selectedItemsIndices;
      expect(indices == null || indices.isEmpty, isTrue);
      maxOptions.dispose();
    });

    testWidgets('Backspace on empty query removes last selected', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      var selected = <String>[];

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: StatefulBuilder(
          builder: (context, setState) {
            return RAutocomplete<String>.multiple(
              source: RAutocompleteLocalSource(
                options: (_) => const ['Georgia', 'Florida', 'California'],
              ),
              itemAdapter: _adapter,
              selectedValues: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              openOnTap: true,
            );
          },
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('menu-item-0')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('menu-item-1')));
      await tester.pumpAndSettle();

      expect(selected, ['Georgia', 'Florida']);

      // Query is empty by default; backspace removes last.
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pumpAndSettle();

      expect(selected, ['Georgia']);
    });

    testWidgets('hideSelectedOptions filters selected out of menu', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      var selected = <String>['Florida'];

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: StatefulBuilder(
          builder: (context, setState) {
            return RAutocomplete<String>.multiple(
              source: RAutocompleteLocalSource(
                options: (_) => const ['Georgia', 'Florida', 'California'],
              ),
              itemAdapter: _adapter,
              selectedValues: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              openOnTap: true,
              hideSelectedOptions: true,
            );
          },
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      final items = menuRenderer.lastRequest?.items.map((i) => i.primaryText).toList();
      expect(items, ['Georgia', 'California']);
    });

    testWidgets('pinSelectedOptions moves selected to top (when not hidden)',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      var selected = <String>['Florida'];

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: StatefulBuilder(
          builder: (context, setState) {
            return RAutocomplete<String>.multiple(
              source: RAutocompleteLocalSource(
                options: (_) => const ['Georgia', 'Florida', 'California'],
              ),
              itemAdapter: _adapter,
              selectedValues: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              openOnTap: true,
              pinSelectedOptions: true,
            );
          },
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      final items =
          menuRenderer.lastRequest?.items.map((i) => i.primaryText).toList();
      expect(items?.first, 'Florida');
      expect(menuRenderer.lastRequest?.state.selectedItemsIndices, contains(0));
    });

    testWidgets(
        'optimistic selection post-frame callback does not crash after widget dispose',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      var selected = <String>[];

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: StatefulBuilder(
          builder: (context, setState) {
            return RAutocomplete<String>.multiple(
              source: RAutocompleteLocalSource(
                options: (_) => const ['Georgia', 'Florida', 'California'],
              ),
              itemAdapter: _adapter,
              selectedValues: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              openOnTap: true,
            );
          },
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      // Trigger optimistic selection (schedules a post-frame callback).
      await tester.tap(find.byKey(const Key('menu-item-2')));

      // Dispose the widget tree immediately, before the post-frame callback runs.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  group('Duplicate id safety', () {
    testWidgets('options with duplicate ids are de-duped (no crash)', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          source: RAutocompleteLocalSource(options: (_) => const ['A', 'B', 'C']),
          itemAdapter: _dupIdAdapter,
          onSelected: (_) {},
          openOnTap: true,
          openOnFocus: false,
          openOnInput: false,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      final items = menuRenderer.lastRequest?.items.map((i) => i.primaryText).toList();
      expect(items, ['A']);
    });
  });

  group('Stable ids with new instances', () {
    testWidgets('checked state and hideSelectedOptions survive new instances',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final controller = TextEditingController(text: 'x');

      var selected = <_Option>[];
      var revision = 0;
      var hideSelected = false;
      void Function(VoidCallback fn)? setScenarioState;

      List<_Option> buildOptions() {
        // New instances every call, stable ids.
        return [
          _Option('a', 'A-$revision'),
          _Option('b', 'B-$revision'),
          _Option('c', 'C-$revision'),
        ];
      }

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: StatefulBuilder(
          builder: (context, setState) {
            setScenarioState = setState;
            return Column(
              children: [
                RAutocomplete<_Option>.multiple(
                  controller: controller,
                  source: RAutocompleteLocalSource(options: (_) => buildOptions()),
                  itemAdapter: _optionAdapter,
                  selectedValues: selected,
                  onSelectionChanged: (next) => setState(() => selected = next),
                  openOnTap: true,
                  hideSelectedOptions: hideSelected,
                ),
              ],
            );
          },
        ),
      ));

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      // Select B (index 1).
      menuRenderer.lastRequest!.commands.selectIndex(1);
      await tester.pumpAndSettle();
      expect(selected.map((e) => e.id).toList(), ['b']);

      // Rebuild options with new instances (revision change).
      setScenarioState!.call(() => revision++);
      await tester.pump();
      await tester.pumpAndSettle();

      // Still checked at index 1 (id=b).
      expect(menuRenderer.lastRequest?.state.selectedItemsIndices, contains(1));

      // Now enable hideSelectedOptions and rebuild again.
      setScenarioState!.call(() => hideSelected = true);
      // hideSelectedOptions triggers a scheduled sync + a scheduled menu refresh.
      // Pump a couple of frames to flush both post-frame callbacks deterministically.
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      final items = menuRenderer.lastRequest?.items.map((i) => i.primaryText).toList();
      // B is hidden, even though options are new instances.
      expect(items, ['A-$revision', 'C-$revision']);
    });
  });

  group('IME / composing', () {
    testWidgets('Enter is ignored while composing', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();
      final controller = TextEditingController();
      String? selected;

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          controller: controller,
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (v) => selected = v,
          openOnTap: false,
          openOnFocus: false,
          openOnInput: false,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen, isTrue);

      // Simulate IME composing ("in-progress" text).
      controller.value = const TextEditingValue(
        text: 'al',
        selection: TextSelection.collapsed(offset: 2),
        composing: TextRange(start: 0, end: 2),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selected, isNull);
      expect(menuRenderer.lastRequest?.state.isOpen, isTrue);

      focusNode.dispose();
      controller.dispose();
    });

    testWidgets('ArrowDown does not open menu while composing', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();
      final controller = TextEditingController();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          controller: controller,
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: false,
          openOnFocus: false,
          openOnInput: false,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);

      controller.value = const TextEditingValue(
        text: 'al',
        selection: TextSelection.collapsed(offset: 2),
        composing: TextRange(start: 0, end: 2),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);

      focusNode.dispose();
      controller.dispose();
    });

    testWidgets('ArrowDown does not change highlight while composing',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();
      final controller = TextEditingController();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          controller: controller,
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: false,
          openOnFocus: false,
          openOnInput: false,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      // Open menu (non-composing) and move highlight once.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      final before = menuRenderer.lastRequest?.state.highlightedIndex;

      controller.value = const TextEditingValue(
        text: 'al',
        selection: TextSelection.collapsed(offset: 2),
        composing: TextRange(start: 0, end: 2),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.highlightedIndex, before);

      focusNode.dispose();
      controller.dispose();
    });

    testWidgets('openOnInput does not open menu while composing', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();
      final controller = TextEditingController();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          controller: controller,
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: false,
          openOnFocus: false,
          openOnInput: true,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);

      controller.value = const TextEditingValue(
        text: 'al',
        selection: TextSelection.collapsed(offset: 2),
        composing: TextRange(start: 0, end: 2),
      );
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);

      focusNode.dispose();
      controller.dispose();
    });

    testWidgets('Escape does not close menu while composing', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();
      final controller = TextEditingController();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          controller: controller,
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: false,
          openOnFocus: false,
          openOnInput: false,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isTrue);

      controller.value = const TextEditingValue(
        text: 'al',
        selection: TextSelection.collapsed(offset: 2),
        composing: TextRange(start: 0, end: 2),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isTrue);

      focusNode.dispose();
      controller.dispose();
    });
  });

  group('Dismissed policy (Escape/Tab)', () {
    testWidgets('Escape dismiss prevents openOnFocus on refocus', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnFocus: true,
          openOnTap: false,
          openOnInput: false,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);

      focusNode.unfocus();
      await tester.pumpAndSettle();

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      // Should not auto-open because it was dismissed by the user (Escape).
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);
      focusNode.dispose();
    });

    testWidgets('Tab dismiss prevents openOnFocus on refocus', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnFocus: true,
          openOnTap: false,
          openOnInput: false,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);

      // Blur + refocus: should not reopen due to dismissed policy.
      focusNode.unfocus();
      await tester.pumpAndSettle();
      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);
      focusNode.dispose();
    });

    testWidgets('focus loss dismiss prevents openOnFocus on refocus', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: false,
          openOnFocus: true,
          openOnInput: false,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen, isTrue);

      // Simulate user focus loss (click-away/tab-away).
      focusNode.unfocus();
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen, isFalse);

      // Refocus should NOT reopen because it was dismissed by focus loss.
      focusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen, isFalse);

      focusNode.dispose();
    });
  });

  group('Dismissed reset (tap/input)', () {
    testWidgets('tapContainer resets dismissed and can reopen', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnFocus: false,
          openOnTap: true,
          openOnInput: false,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      // Open -> dismiss by Escape.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);

      // Now a user tap should reset dismissed and reopen.
      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isTrue);

      focusNode.dispose();
    });

    testWidgets('text input resets dismissed and can reopen via openOnInput',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();
      final controller = TextEditingController();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          controller: controller,
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnFocus: false,
          openOnTap: false,
          openOnInput: true,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);

      // Changing text should reset dismissed and open the menu.
      controller.value = const TextEditingValue(
        text: 'a',
        selection: TextSelection.collapsed(offset: 1),
      );
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isTrue);

      focusNode.dispose();
      controller.dispose();
    });
  });

  group('Focus traversal / blur', () {
    testWidgets('menu closes when widget becomes disabled while open', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();
      var disabled = false;
      void Function(VoidCallback fn)? setScenarioState;

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: StatefulBuilder(
          builder: (context, setState) {
            setScenarioState = setState;
            return Column(
              children: [
                RAutocomplete<String>(
                  focusNode: focusNode,
                  source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
                  itemAdapter: _adapter,
                  onSelected: (_) {},
                  openOnTap: false,
                  openOnInput: false,
                  openOnFocus: true,
                  disabled: disabled,
                ),
                TextButton(
                  key: const Key('disable-button'),
                  onPressed: () => setState(() => disabled = true),
                  child: const Text('disable'),
                ),
              ],
            );
          },
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isTrue);

      setScenarioState!.call(() => disabled = true);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);

      focusNode.dispose();
    });

    testWidgets('Shift+Tab closes menu (user dismiss path)', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: false,
          openOnInput: false,
          openOnFocus: true,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isTrue);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);

      // Dismissed-policy: refocus should not auto-open.
      focusNode.unfocus();
      await tester.pumpAndSettle();
      focusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);

      focusNode.dispose();
    });
  });

  group('Keyboard navigation (Home/End/PageUp/PageDown)', () {
    testWidgets('Home/End move highlight to first/last when menu is open',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta', 'Gamma']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: false,
          openOnInput: false,
          openOnFocus: true,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.highlightedIndex, 2);

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.highlightedIndex, 0);

      focusNode.dispose();
    });

    testWidgets('PageUp/PageDown map to first/last when menu is open',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta', 'Gamma']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: false,
          openOnInput: false,
          openOnFocus: true,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.highlightedIndex, 2);

      await tester.sendKeyEvent(LogicalKeyboardKey.pageUp);
      await tester.pumpAndSettle();
      expect(menuRenderer.lastRequest?.state.highlightedIndex, 0);

      focusNode.dispose();
    });
  });

  group('Keyboard / disabled options', () {
    testWidgets('Enter is ignored when all options are disabled (no highlight)',
        (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();
      final focusNode = FocusNode();
      String? selected;

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          focusNode: focusNode,
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _alwaysDisabledAdapter,
          onSelected: (v) => selected = v,
          openOnTap: false,
          openOnInput: false,
          openOnFocus: true,
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isTrue);
      expect(menuRenderer.lastRequest?.state.highlightedIndex, isNull);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selected, isNull);
      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isTrue);

      focusNode.dispose();
    });
  });

  group('Pointer / gesture safety', () {
    testWidgets('drag does not trigger openOnTap', (tester) async {
      final fieldRenderer = _TestTextFieldRenderer();
      final menuRenderer = _TestDropdownRenderer();

      await tester.pumpWidget(_createTestWidget(
        fieldRenderer: fieldRenderer,
        menuRenderer: menuRenderer,
        child: RAutocomplete<String>(
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha', 'Beta']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: true,
          openOnFocus: false,
          openOnInput: false,
        ),
      ));
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);

      await tester.drag(find.byKey(const Key('autocomplete-field')), const Offset(80, 0));
      await tester.pumpAndSettle();

      expect(menuRenderer.lastRequest?.state.isOpen ?? false, isFalse);
    });
  });
}
