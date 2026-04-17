import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_example/main.dart' show HeadlessExampleApp;
import 'package:headless_example/screens/widgets/phone_country_menu_button.dart';

import 'helpers/example_app_helpers.dart';

double _verticalCenterDelta(WidgetTester tester, Finder field, Finder target) {
  return (tester.getRect(field).center.dy - tester.getRect(target).center.dy)
      .abs();
}

void main() {
  testWidgets('Phone field demo custom trigger field keeps a compact height',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final sectionTitle = find.text('Brand The Trigger, Keep The Contracts');
    final field = find.byKey(const ValueKey('phone-field-custom-trigger-demo'));
    await tester.scrollUntilVisible(
      sectionTitle,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    expect(tester.getSize(field).height, lessThanOrEqualTo(52));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Phone field demo keeps prefix and suffix triggers compact',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final sectionTitle = find.text('Brand The Trigger, Keep The Contracts');
    final field = find.byKey(const ValueKey('phone-field-custom-trigger-demo'));
    await tester.scrollUntilVisible(
      sectionTitle,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    final fieldWidth = tester.getSize(field).width;
    final trigger = find.descendant(
      of: field,
      matching: find.byType(PhoneCountryMenuButton),
    );

    expect(tester.getSize(trigger).width, lessThan(fieldWidth * 0.5));

    await tester.tap(find.text('Suffix'));
    await pumpUi(tester);

    expect(tester.getSize(trigger).width, lessThan(fieldWidth * 0.5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Phone field demo vertically centers the branded trigger',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final sectionTitle = find.text('Brand The Trigger, Keep The Contracts');
    final field = find.byKey(const ValueKey('phone-field-custom-trigger-demo'));
    await tester.scrollUntilVisible(
      sectionTitle,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    Finder trigger() => find.descendant(
          of: field,
          matching: find.byType(PhoneCountryMenuButton),
        );

    expect(
        _verticalCenterDelta(tester, field, trigger()), lessThanOrEqualTo(2));

    for (final segment in ['Suffix', 'Leading', 'Trailing']) {
      await tester.tap(find.text(segment));
      await pumpUi(tester);
      expect(
        _verticalCenterDelta(tester, field, trigger()),
        lessThanOrEqualTo(2),
      );
    }
  });
}
