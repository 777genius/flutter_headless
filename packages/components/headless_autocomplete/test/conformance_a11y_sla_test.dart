import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_autocomplete/headless_autocomplete.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_test/headless_test.dart';
import 'package:headless_theme/headless_theme.dart';

final _adapter = HeadlessItemAdapter<String>.simple(
  id: (v) => ListboxItemId(v),
  titleText: (v) => v,
);

class _TestTextFieldRenderer implements RTextFieldRenderer {
  @override
  Widget render(RTextFieldRenderRequest request) {
    return GestureDetector(
      key: const Key('autocomplete-field'),
      behavior: HitTestBehavior.opaque,
      onTap: request.commands?.tapContainer,
      child: request.input,
    );
  }
}

class _TestDropdownRenderer implements RDropdownButtonRenderer {
  @override
  Widget render(RDropdownRenderRequest request) {
    if (request.state.overlayPhase == ROverlayPhase.closing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        request.commands.completeClose();
      });
    }
    return switch (request) {
      RDropdownTriggerRenderRequest() => const SizedBox.shrink(),
      RDropdownMenuRenderRequest() => const SizedBox(
          key: Key('autocomplete-menu'),
          width: 10,
          height: 10,
        ),
    };
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
    return null;
  }
}

Widget _createTestWidget({
  required Widget child,
}) {
  return MaterialApp(
    home: HeadlessThemeProvider(
      theme: _TestTheme(_TestTextFieldRenderer(), _TestDropdownRenderer()),
      child: AnchoredOverlayEngineHost(
        controller: OverlayController(),
        child: Scaffold(body: Center(child: child)),
      ),
    ),
  );
}

void main() {
  group('Conformance / A11y SLA', () {
    testWidgets('textField role + enabled/disabled + readOnly', (tester) async {
      await tester.pumpWidget(_createTestWidget(
        child: RAutocomplete<String>(
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: false,
          openOnFocus: false,
          openOnInput: false,
        ),
      ));

      final rootNode = tester.getSemantics(find.byType(RAutocomplete<String>));
      SemanticsSla.expectTextField(
          node: rootNode, enabled: true, readOnly: false);

      await tester.pumpWidget(_createTestWidget(
        child: RAutocomplete<String>(
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          disabled: true,
        ),
      ));

      final disabledNode =
          tester.getSemantics(find.byType(RAutocomplete<String>));
      SemanticsSla.expectTextField(
        node: disabledNode,
        enabled: false,
        readOnly: false,
      );

      await tester.pumpWidget(_createTestWidget(
        child: RAutocomplete<String>(
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          readOnly: true,
        ),
      ));

      final roNode = tester.getSemantics(find.byType(RAutocomplete<String>));
      SemanticsSla.expectTextField(node: roNode, enabled: true, readOnly: true);
    });

    testWidgets('expanded state is reflected when menu opens', (tester) async {
      await tester.pumpWidget(_createTestWidget(
        child: RAutocomplete<String>(
          source: RAutocompleteLocalSource(options: (_) => const ['Alpha']),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: true,
          openOnFocus: false,
          openOnInput: false,
        ),
      ));

      final before = tester.getSemantics(find.byType(RAutocomplete<String>));
      SemanticsSla.expectHasExpandedState(node: before, expanded: false);

      await tester.tap(find.byKey(const Key('autocomplete-field')));
      await tester.pumpAndSettle();

      final after = tester.getSemantics(find.byType(RAutocomplete<String>));
      SemanticsSla.expectHasExpandedState(node: after, expanded: true);

      // Rich semantics: highlighted option is exposed via a live region
      // (combobox active-descendant style announcement).
      expect(find.bySemanticsLabel('Alpha'), findsOneWidget);
    });
  });
}
