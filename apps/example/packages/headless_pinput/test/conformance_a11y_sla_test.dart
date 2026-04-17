import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_pinput/headless_pinput.dart';
import 'package:headless_theme/headless_theme.dart';

class _TestPinInputRenderer implements RPinInputRenderer {
  @override
  Widget render(RPinInputRenderRequest request) {
    return SizedBox(
      width: 320,
      child: request.hiddenInput,
    );
  }
}

class _TestTheme extends HeadlessTheme {
  const _TestTheme(this.renderer);

  final _TestPinInputRenderer renderer;

  @override
  T? capability<T>() {
    if (T == RPinInputRenderer) return renderer as T;
    return null;
  }
}

Widget _wrapForTest(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: HeadlessThemeProvider(
      theme: _TestTheme(_TestPinInputRenderer()),
      child: Material(
        child: child,
      ),
    ),
  );
}

void main() {
  group('Conformance / A11y SLA', () {
    testWidgets('textField role + enabled/disabled + readOnly', (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(_wrapForTest(
          RPinInput(
            enabled: true,
            onChanged: (_) {},
          ),
        ));

        final enabledNode = tester.getSemantics(find.byType(RPinInput));
        _expectTextField(
          node: enabledNode,
          enabled: true,
          readOnly: false,
        );

        await tester.pumpWidget(_wrapForTest(
          RPinInput(
            enabled: false,
            onChanged: (_) {},
          ),
        ));

        final disabledNode = tester.getSemantics(find.byType(RPinInput));
        _expectTextField(
          node: disabledNode,
          enabled: false,
          readOnly: false,
        );

        await tester.pumpWidget(_wrapForTest(
          RPinInput(
            readOnly: true,
            onChanged: (_) {},
          ),
        ));

        final readOnlyNode = tester.getSemantics(find.byType(RPinInput));
        _expectTextField(
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
          RPinInput(
            semanticLabel: 'Verification code',
            semanticHint: 'Enter the 6 digit code',
            onChanged: (_) {},
          ),
        ));

        final node = tester.getSemantics(find.byType(RPinInput));
        final data = node.getSemanticsData();

        expect(data.label, 'Verification code');
        expect(data.hint, 'Enter the 6 digit code');
      } finally {
        semantics.dispose();
      }
    });
  });
}

void _expectTextField({
  required SemanticsNode node,
  required bool enabled,
  required bool readOnly,
}) {
  expect(node.flagsCollection.isTextField, isTrue);
  expect(_semanticBoolValue(node.flagsCollection.isEnabled), enabled);
  expect(_semanticBoolValue(node.flagsCollection.isReadOnly), readOnly);
}

bool _semanticBoolValue(Object? value) {
  if (value is bool) return value;
  if (value is Enum) return value.name == 'isTrue';
  return value?.toString().endsWith('.isTrue') ?? false;
}
