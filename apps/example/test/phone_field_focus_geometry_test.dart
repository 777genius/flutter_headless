import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_example/main.dart' show HeadlessExampleApp;
import 'package:headless_example/screens/widgets/phone_field_showcase_text_field_renderer.dart';

import 'helpers/example_app_helpers.dart';

void main() {
  testWidgets('Phone field preview keeps the same outer size when focused',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final previewField = find.byKey(const ValueKey('phone-field-preview-demo'));
    final shell = find.descendant(
      of: previewField,
      matching: find.byType(PhoneFieldShowcaseTextFieldSurface),
    );
    final editable = find.descendant(
      of: previewField,
      matching: find.byType(EditableText),
    );

    final beforeRect = tester.getRect(shell);

    await tester.tap(editable);
    await pumpUi(tester);

    final afterRect = tester.getRect(shell);
    expect(tester.widget<EditableText>(editable).focusNode.hasFocus, isTrue);

    expect(afterRect.width, moreOrLessEquals(beforeRect.width, epsilon: 0.01));
    expect(
      afterRect.height,
      moreOrLessEquals(beforeRect.height, epsilon: 0.01),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Soft checkout focus does not resize its field or shift the neighbor card',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final softField = find.byKey(const ValueKey('phone-shell-field-soft'));
    await tester.scrollUntilVisible(
      softField,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    final minimalField =
        find.byKey(const ValueKey('phone-shell-field-minimal'));
    final softShell = find.descendant(
      of: softField,
      matching: find.byType(PhoneFieldShowcaseTextFieldSurface),
    );
    final minimalShell = find.descendant(
      of: minimalField,
      matching: find.byType(PhoneFieldShowcaseTextFieldSurface),
    );
    final softEditable = find.descendant(
      of: softField,
      matching: find.byType(EditableText),
    );
    final beforeSoft = tester.getRect(softShell);
    final beforeMinimal = tester.getRect(minimalShell);

    await tester.tap(softEditable);
    await pumpUi(tester);

    final afterSoft = tester.getRect(softShell);
    final afterMinimal = tester.getRect(minimalShell);
    expect(tester.widget<EditableText>(softEditable).focusNode.hasFocus, isTrue);

    expect(afterSoft.width, moreOrLessEquals(beforeSoft.width, epsilon: 0.01));
    expect(afterSoft.height, moreOrLessEquals(beforeSoft.height, epsilon: 0.01));
    expect(afterSoft.left, moreOrLessEquals(beforeSoft.left, epsilon: 0.01));
    expect(afterSoft.top, moreOrLessEquals(beforeSoft.top, epsilon: 0.01));
    expect(
      afterMinimal.left,
      moreOrLessEquals(beforeMinimal.left, epsilon: 0.01),
    );
    expect(
      afterMinimal.top,
      moreOrLessEquals(beforeMinimal.top, epsilon: 0.01),
    );
    expect(tester.takeException(), isNull);
  });
}
