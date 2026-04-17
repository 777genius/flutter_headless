import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_example/screens/widgets/phone_field_showcase_text_field_renderer.dart';

import 'package:headless_example/main.dart' show HeadlessExampleApp;

import 'helpers/example_app_helpers.dart';

void main() {
  testWidgets('Soft checkout stays overflow-free on a narrow desktop viewport',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(996, 1200);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final softCaption = find.text('Priority callback');
    await tester.scrollUntilVisible(
      softCaption,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    expect(softCaption, findsOneWidget);
    final softField = find.byKey(const ValueKey('phone-shell-field-soft'));
    final softSurface = find.descendant(
      of: softField,
      matching: find.byType(PhoneFieldShowcaseTextFieldSurface),
    );
    expect(tester.getSize(softSurface).height, lessThanOrEqualTo(60));
    expect(tester.takeException(), isNull);
  });
}
