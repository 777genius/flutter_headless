import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:headless_example/main.dart' show HeadlessExampleApp;

import 'helpers/example_app_helpers.dart';

void main() {
  testWidgets('Command shell local heading uses scoped dark theme',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester, duration: const Duration(milliseconds: 400));

    await openExampleDemo(tester, 'Dropdown Demo');
    await tester.scrollUntilVisible(
      find.text('Command Palette'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    final runtimeTarget = tester.widget<Text>(find.text('Runtime target'));
    final color = runtimeTarget.style?.color;
    expect(color, isNotNull);
    expect(color!.computeLuminance(), greaterThan(0.7));
  });
}
