import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_example/main.dart' show HeadlessExampleApp;
import 'helpers/example_app_helpers.dart';

void main() {
  testWidgets('Phone field support and travel triggers stay compact on desktop',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1180, 1400);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final supportCaption = find.text('Support number');
    await tester.scrollUntilVisible(
      supportCaption,
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    final supportField =
        find.byKey(const ValueKey('phone-field-navigator-demo'));
    await tester.tap(supportField);
    await pumpUi(tester);
    expect(tester.takeException(), isNull);

    final travelCaption = find.text('Airport pickup');
    await tester.scrollUntilVisible(
      travelCaption,
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    final travelField = find.byKey(const ValueKey('phone-shell-field-travel'));
    await tester.tap(travelField);
    await pumpUi(tester);
    expect(tester.takeException(), isNull);
  });
}
