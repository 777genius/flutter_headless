import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_example/main.dart' show HeadlessExampleApp;
import 'package:headless_example/screens/widgets/phone_field_showcase_text_field_renderer.dart';

import 'helpers/example_app_helpers.dart';

void main() {
  testWidgets('Phone field preview trigger keeps a compact hit target',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final trigger =
        find.byKey(const ValueKey('phone-field-preview-country-trigger'));
    final size = tester.getSize(trigger);

    expect(size.width, inInclusiveRange(124, 132));
    expect(size.height, greaterThanOrEqualTo(44));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Phone field preview trigger opens from the right padded edge',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final trigger =
        find.byKey(const ValueKey('phone-field-preview-country-trigger'));
    final rect = tester.getRect(trigger);

    await tester.tapAt(Offset(rect.right - 6, rect.center.dy));
    await pumpUi(tester);

    expect(
      find.byKey(const ValueKey('phone-country-menu-surface')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Phone field preview keeps the prefix shell tight to the field',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final previewField = find.byKey(const ValueKey('phone-field-preview-demo'));
    final shell = find.descendant(
      of: previewField,
      matching: find.byType(PhoneFieldShowcaseTextFieldSurface),
    );
    final trigger =
        find.byKey(const ValueKey('phone-field-preview-country-trigger'));

    final shellRect = tester.getRect(shell);
    final triggerRect = tester.getRect(trigger);

    expect(triggerRect.left - shellRect.left, inInclusiveRange(4, 12));
    expect(triggerRect.top - shellRect.top, inInclusiveRange(2, 10));
    expect(shellRect.bottom - triggerRect.bottom, inInclusiveRange(2, 10));
    expect(triggerRect.width, lessThan(shellRect.width * 0.3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Phone field preview swaps to a formatted sample number',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final previewField = find.byKey(const ValueKey('phone-field-preview-demo'));
    final editable = find.descendant(
      of: previewField,
      matching: find.byType(EditableText),
    );

    expect(tester.widget<EditableText>(editable).readOnly, isFalse);

    await tester.tap(
      find.byKey(const ValueKey('phone-field-preview-country-trigger')),
    );
    await pumpUi(tester);
    await tester.enterText(
      find.byKey(const ValueKey('phone-country-menu-search')),
      'United Arab Emirates',
    );
    await pumpUi(tester);
    await tester.tap(find.byKey(const ValueKey('phone-country-option-AE')));
    await pumpUi(tester);

    expect(
      tester.widget<EditableText>(editable).controller.text,
      '50 123 4567',
    );

    await tester.enterText(editable, '501234567');
    await pumpUi(tester);

    expect(
      tester.widget<EditableText>(editable).controller.text,
      '50 123 4567',
    );
    expect(tester.takeException(), isNull);
  });
}
