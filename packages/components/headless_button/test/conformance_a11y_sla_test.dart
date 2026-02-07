import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_button/headless_button.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';
import 'package:headless_test/headless_test.dart';

class _TestButtonRenderer implements RButtonRenderer {
  @override
  Widget render(RButtonRenderRequest request) {
    return Container(child: request.content);
  }
}

class _TestTheme extends HeadlessTheme {
  _TestTheme(this.renderer);

  final _TestButtonRenderer renderer;

  @override
  T? capability<T>() {
    if (T == RButtonRenderer) return renderer as T;
    return null;
  }
}

Widget _buildTestWidget({required Widget child}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: HeadlessThemeProvider(
      theme: _TestTheme(_TestButtonRenderer()),
      child: child,
    ),
  );
}

void main() {
  group('Conformance / A11y SLA', () {
    testWidgets('button role + enabled/disabled + label', (tester) async {
      await tester.pumpWidget(_buildTestWidget(
        child: RTextButton(
          onPressed: () {},
          semanticLabel: 'Custom label',
          child: const Text('Hello'),
        ),
      ));

      final node = tester.getSemantics(find.byType(RTextButton));
      SemanticsSla.expectButton(
          node: node, enabled: true, labelContains: 'Custom label');

      await tester.pumpWidget(_buildTestWidget(
        child: const RTextButton(
          onPressed: null,
          child: Text('Disabled'),
        ),
      ));

      final node2 = tester.getSemantics(find.byType(RTextButton));
      SemanticsSla.expectButton(node: node2, enabled: false);
    });
  });
}
