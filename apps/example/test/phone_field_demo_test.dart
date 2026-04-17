import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_example/screens/widgets/phone_field_showcase_text_field_renderer.dart';

import 'package:headless_example/main.dart' show HeadlessExampleApp;

import 'helpers/example_app_helpers.dart';

void main() {
  testWidgets('Phone field demo opens and renders showcase sections',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    expect(find.text('One phone field, multiple UX layers.'), findsOneWidget);
    expect(
      find.text('Make The Same Logic Look Like Different Products'),
      findsOneWidget,
    );
    expect(find.text('Soft Checkout'), findsOneWidget);
    expect(find.text('Editorial Minimal'), findsOneWidget);
    expect(find.text('Ops Console'), findsOneWidget);
    expect(
      find.text('Switch The Country Picker, Keep The Field Logic'),
      findsOneWidget,
    );
    expect(find.text('Brand The Trigger, Keep The Contracts'), findsOneWidget);
    expect(find.text('Drive The Field From A Controller'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Phone field demo menu selector opens inline search',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final sectionTitle =
        find.text('Switch The Country Picker, Keep The Field Logic');
    await tester.scrollUntilVisible(
      sectionTitle,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    await tester
        .tap(find.byKey(const ValueKey('phone-field-country-launcher')));
    await pumpUi(tester);

    final searchField = find.byKey(const ValueKey('phone-country-menu-search'));
    expect(searchField, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Phone field demo keeps custom trigger stable across slots',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final sectionTitle = find.text('Brand The Trigger, Keep The Contracts');
    await tester.scrollUntilVisible(
      sectionTitle,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    await tester.tap(find.text('Trailing'));
    await pumpUi(tester);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Suffix'));
    await pumpUi(tester);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Leading'));
    await pumpUi(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Phone field demo keeps navigator field height stable in menu mode',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final sectionTitle =
        find.text('Switch The Country Picker, Keep The Field Logic');
    final field = find.byKey(const ValueKey('phone-field-navigator-demo'));
    await tester.scrollUntilVisible(
      sectionTitle,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    final pageSegment = find.text('Page').first;
    final menuSegment = find.text('Menu').first;

    await tester.tap(pageSegment);
    await pumpUi(tester);
    final pageSize = tester.getSize(field);

    await tester.tap(menuSegment);
    await pumpUi(tester);
    final menuSize = tester.getSize(field);

    expect(menuSize.height, moreOrLessEquals(pageSize.height, epsilon: 0.1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Phone field demo anchors menu directly to the trigger',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 1200);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final sectionTitle =
        find.text('Switch The Country Picker, Keep The Field Logic');
    await tester.scrollUntilVisible(
      sectionTitle,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    await tester.tap(find.text('Menu').first);
    await pumpUi(tester);
    final launcher = find.byKey(const ValueKey('phone-field-country-launcher'));
    await tester.ensureVisible(launcher);
    await tester.tap(launcher);
    await pumpUi(tester);

    final menuSurface =
        find.byKey(const ValueKey('phone-country-menu-surface'));
    final triggerBottom = tester.getBottomLeft(launcher).dy;
    final menuTop = tester.getTopLeft(menuSurface).dy;

    expect(menuTop, moreOrLessEquals(triggerBottom, epsilon: 1.0));
  });

  testWidgets(
      'Phone field showcase shells stay on the scoped renderer in Cupertino mode',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    expect(
      find.byType(PhoneFieldShowcaseTextFieldSurface),
      findsAtLeastNWidgets(5),
    );

    await tester.tap(
      find.bySemanticsLabel('Switch between Material and Cupertino theme'),
    );
    await pumpUi(tester);

    expect(
      find.byType(PhoneFieldShowcaseTextFieldSurface),
      findsAtLeastNWidgets(5),
    );
    expect(find.text('Editorial Minimal'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Phone field demo country menu rows keep a roomy height',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester);

    await openExampleDemo(tester, 'Phone Field Demo');

    final sectionTitle =
        find.text('Switch The Country Picker, Keep The Field Logic');
    await tester.scrollUntilVisible(
      sectionTitle,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    await tester
        .tap(find.byKey(const ValueKey('phone-field-country-launcher')));
    await pumpUi(tester);

    final option = find
        .byWidgetPredicate(
          (widget) =>
              widget is InkWell &&
              widget.key is ValueKey<String> &&
              (widget.key! as ValueKey<String>)
                  .value
                  .startsWith('phone-country-option-'),
        )
        .first;
    final size = tester.getSize(option);

    expect(size.height, greaterThanOrEqualTo(56));
    expect(tester.takeException(), isNull);
  });
}
