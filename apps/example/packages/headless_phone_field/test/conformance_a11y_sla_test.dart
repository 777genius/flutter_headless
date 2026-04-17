import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_phone_field/headless_phone_field.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_test/headless_test.dart';
import 'package:headless_theme/headless_theme.dart';

Widget _wrapForTest(Widget child) {
  return MaterialApp(
    home: HeadlessThemeProvider(
      theme: MaterialHeadlessTheme(),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('Conformance / A11y SLA', () {
    testWidgets('textField role + enabled/disabled + readOnly', (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(_wrapForTest(
          RPhoneField(
            enabled: true,
            onChanged: (_) {},
          ),
        ));

        final enabledNode = tester.getSemantics(find.byType(RPhoneField));
        SemanticsSla.expectTextField(
          node: enabledNode,
          enabled: true,
          readOnly: false,
        );

        await tester.pumpWidget(_wrapForTest(
          RPhoneField(
            enabled: false,
            onChanged: (_) {},
          ),
        ));

        final disabledNode = tester.getSemantics(find.byType(RPhoneField));
        SemanticsSla.expectTextField(
          node: disabledNode,
          enabled: false,
          readOnly: false,
        );

        await tester.pumpWidget(_wrapForTest(
          RPhoneField(
            readOnly: true,
            onChanged: (_) {},
          ),
        ));

        final readOnlyNode = tester.getSemantics(find.byType(RPhoneField));
        SemanticsSla.expectTextField(
          node: readOnlyNode,
          enabled: true,
          readOnly: true,
        );
      } finally {
        semantics.dispose();
      }
    });

    testWidgets('semantic label and hint are exposed', (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(_wrapForTest(
          RPhoneField(
            semanticLabel: 'Phone input',
            semanticHint: 'Enter your mobile number',
            onChanged: (_) {},
          ),
        ));

        final node = tester.getSemantics(find.byType(RPhoneField));
        final data = node.getSemanticsData();

        expect(data.label, 'Phone input');
        expect(data.hint, 'Enter your mobile number');
      } finally {
        semantics.dispose();
      }
    });
  });
}
