import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_example/main.dart' show HeadlessExampleApp;

import 'helpers/example_app_helpers.dart';

void main() {
  testWidgets('Preview country trigger keeps its enlarged hit target invisible',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final trigger =
        find.byKey(const ValueKey('phone-field-preview-country-trigger'));
    final gestureDetector = find.descendant(
      of: trigger,
      matching: find.byType(GestureDetector),
    );
    final inkWell = find.descendant(
      of: trigger,
      matching: find.byType(InkWell),
    );

    expect(trigger, findsOneWidget);
    expect(gestureDetector, findsOneWidget);
    expect(inkWell, findsNothing);
    expect(tester.takeException(), isNull);
  });
}
