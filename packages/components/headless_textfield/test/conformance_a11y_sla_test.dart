import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_test/headless_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';
import 'package:headless_textfield/headless_textfield.dart';

class _TestTextFieldRenderer implements RTextFieldRenderer {
  @override
  Widget render(RTextFieldRenderRequest request) => request.input;
}

class _TestTheme extends HeadlessTheme {
  _TestTheme(this.renderer);

  final _TestTextFieldRenderer renderer;

  @override
  T? capability<T>() {
    if (T == RTextFieldRenderer) return renderer as T;
    return null;
  }
}

Widget _buildTestWidget({required Widget child}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: HeadlessThemeProvider(
      theme: _TestTheme(_TestTextFieldRenderer()),
      child: child,
    ),
  );
}

void main() {
  group('Conformance / A11y SLA', () {
    testWidgets('textField role + enabled/disabled + readOnly', (tester) async {
      await tester.pumpWidget(_buildTestWidget(
        child: RTextField(
          enabled: true,
        ),
      ));

      final node = tester.getSemantics(find.byType(EditableText));
      SemanticsSla.expectTextField(node: node, enabled: true, readOnly: false);

      await tester.pumpWidget(_buildTestWidget(
        child: RTextField(
          enabled: false,
        ),
      ));

      final node2 = tester.getSemantics(find.byType(EditableText));
      SemanticsSla.expectTextField(node: node2, enabled: false, readOnly: false);

      await tester.pumpWidget(_buildTestWidget(
        child: RTextField(
          enabled: true,
          readOnly: true,
        ),
      ));

      final node3 = tester.getSemantics(find.byType(EditableText));
      SemanticsSla.expectTextField(node: node3, enabled: true, readOnly: true);
    });
  });
}

