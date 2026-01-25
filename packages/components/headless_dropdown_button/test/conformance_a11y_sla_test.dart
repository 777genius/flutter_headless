import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_dropdown_button/headless_dropdown_button.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';
import 'package:headless_test/headless_test.dart';

class _TestDropdownRenderer implements RDropdownButtonRenderer {
  @override
  Widget render(RDropdownRenderRequest request) {
    return switch (request) {
      RDropdownTriggerRenderRequest() =>
        // Render a non-zero surface so semantics can attach reliably.
        const SizedBox(
          width: 120,
          height: 44,
          child: ColoredBox(
              color: Color(0xFFCCCCCC),
              child: SizedBox.expand(key: Key('dropdown-trigger'))),
        ),
      RDropdownMenuRenderRequest() => const SizedBox.shrink(),
    };
  }
}

class _TestTheme extends HeadlessTheme {
  _TestTheme(this.renderer);

  final _TestDropdownRenderer renderer;

  @override
  T? capability<T>() {
    if (T == RDropdownButtonRenderer) return renderer as T;
    return null;
  }
}

Widget _buildTestWidget({required Widget child}) {
  final overlayController = OverlayController();
  return Directionality(
    textDirection: TextDirection.ltr,
    child: AnchoredOverlayEngineHost(
      controller: overlayController,
      child: HeadlessThemeProvider(
        theme: _TestTheme(_TestDropdownRenderer()),
        child: child,
      ),
    ),
  );
}

void main() {
  group('Conformance / A11y SLA', () {
    testWidgets('dropdown trigger role + expanded state', (tester) async {
      await tester.pumpWidget(_buildTestWidget(
        child: RDropdownButton<String>(
          items: const ['a', 'b'],
          itemAdapter: HeadlessItemAdapter.simple(
            id: (v) => ListboxItemId(v),
            titleText: (v) => v,
          ),
          value: 'a',
          onChanged: (_) {},
        ),
      ));

      final rootNode =
          tester.getSemantics(find.byType(RDropdownButton<String>));
      SemanticsSla.expectButton(node: rootNode, enabled: true);
      SemanticsSla.expectHasExpandedState(node: rootNode, expanded: false);
    });
  });
}
