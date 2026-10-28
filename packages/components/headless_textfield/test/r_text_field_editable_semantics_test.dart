import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_test/headless_test.dart';
import 'package:headless_textfield/headless_textfield.dart';
import 'package:headless_theme/headless_theme.dart';

// Real InputDecorator boundaries reproduce the browser duplicate-input bug;
// returning request.input directly does not exercise those boundaries.
class _DecoratedRenderer implements RTextFieldRenderer {
  @override
  Widget render(RTextFieldRenderRequest request) => InputDecorator(
        decoration: InputDecoration(
          labelText: request.spec.label,
          hintText: request.spec.placeholder,
          enabled: !request.state.isDisabled,
        ),
        isFocused: request.state.isFocused,
        isEmpty: !request.state.hasText,
        child: request.input,
      );
}

class _Theme extends HeadlessTheme {
  @override
  T? capability<T>() =>
      T == RTextFieldRenderer ? _DecoratedRenderer() as T : null;
}

Widget _app(Widget field) => MaterialApp(
      home: Scaffold(
        body: HeadlessThemeProvider(theme: _Theme(), child: field),
      ),
    );

List<SemanticsNode> _editableNodes(SemanticsNode root) {
  final result = <SemanticsNode>[];
  void visit(SemanticsNode node) {
    if (SemanticsUtils.hasFlag(node, SemanticsFlag.isTextField)) {
      result.add(node);
    }
    node.visitChildren((child) {
      visit(child);
      return true;
    });
  }

  visit(root);
  return result;
}

void main() {
  testWidgets('one decorated editor owns focus and setText callback',
      (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      final controller = TextEditingController();
      final focus = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focus.dispose);
      final changes = <String>[];
      await tester.pumpWidget(_app(RTextField(
        controller: controller,
        focusNode: focus,
        label: 'Email',
        placeholder: 'Enter email',
        onChanged: changes.add,
      )));

      final fields =
          _editableNodes(tester.getSemantics(find.byType(RTextField)));
      expect(fields, hasLength(1));
      var field = fields.single;
      expect(field.label, contains('Email'));
      expect(field.getSemanticsData().hasAction(SemanticsAction.focus), isTrue);
      final owner = tester.binding.renderViews.single.owner!.semanticsOwner!;
      owner.performAction(field.id, SemanticsAction.focus);
      await tester.pump();
      expect(focus.hasFocus, isTrue);
      field =
          _editableNodes(tester.getSemantics(find.byType(RTextField))).single;
      expect(
          field.getSemanticsData().hasAction(SemanticsAction.setText), isTrue);
      owner.performAction(
          field.id, SemanticsAction.setText, 'person@example.test');
      await tester.pump();
      expect(controller.text, 'person@example.test');
      expect(changes, ['person@example.test']);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      semantics.dispose();
    }
  });

  testWidgets('native read-only, disabled and password semantics stay intact',
      (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      for (final mode in ['read-only', 'disabled', 'password']) {
        await tester.pumpWidget(_app(RTextField(
          key: ValueKey(mode),
          label: 'Account',
          value: 'secret123',
          readOnly: mode == 'read-only',
          enabled: mode != 'disabled',
          obscureText: mode == 'password',
        )));
        final fields =
            _editableNodes(tester.getSemantics(find.byType(RTextField)));
        expect(fields, hasLength(1), reason: mode);
        final field = fields.single;
        expect(SemanticsUtils.hasFlag(field, SemanticsFlag.isEnabled),
            mode != 'disabled');
        expect(SemanticsUtils.hasFlag(field, SemanticsFlag.isReadOnly),
            mode != 'password');
        if (mode == 'password') {
          expect(field.getSemanticsData().flagsCollection.isObscured, isTrue);
          expect(field.value, isNot(contains('secret123')));
        }
      }
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      semantics.dispose();
    }
  });
}
