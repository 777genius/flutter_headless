import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:headless_example/main.dart' show HeadlessExampleApp;

import 'helpers/example_app_helpers.dart';

void main() {
  testWidgets('Phone field gallery and navigator stay overflow-free on desktop',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(900, 1600);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    for (final caption in const [
      'Support number',
      'Airport pickup',
      'Hotfix contact line',
    ]) {
      final target = find.text(caption);
      await tester.scrollUntilVisible(
        target,
        180,
        scrollable: find.byType(Scrollable).first,
      );
      await pumpUi(tester);
      expect(target, findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
