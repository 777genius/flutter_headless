import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:headless_example/main.dart' show HeadlessExampleApp;
import 'package:headless_example/screens/widgets/dropdown_demo/dropdown_demo_sdk_visuals.dart';

import 'helpers/example_app_helpers.dart';

void main() {
  testWidgets('Dropdown demo renders parity and shell gallery', (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester, duration: const Duration(milliseconds: 400));

    await openExampleDemo(tester, 'Dropdown Demo');

    expect(find.text('Theme Presets'), findsOneWidget);
    expect(find.text('Material preset active'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Flutter Parity'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);
    expect(find.text('Flutter Parity'), findsOneWidget);
    expect(find.text('SDK Sample 01'), findsOneWidget);
    expect(find.text('selectedItemBuilder'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Headless Shell Gallery'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    expect(find.text('Headless Shell Gallery'), findsOneWidget);
    expect(find.text('Travel Desk'), findsOneWidget);
    expect(find.text('Editorial Minimal'), findsOneWidget);
    expect(find.text('Command Palette'), findsOneWidget);
    expect(find.text('Team Filter'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Scoped dropdown shells stay visible after theme switch',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester, duration: const Duration(milliseconds: 400));

    await openExampleDemo(tester, 'Dropdown Demo');

    expect(
      switchValue(tester, 'Switch between Material and Cupertino theme'),
      isFalse,
    );

    await tester.tap(
      find.bySemanticsLabel('Switch between Material and Cupertino theme'),
    );
    await pumpUi(tester);

    expect(
      switchValue(tester, 'Switch between Material and Cupertino theme'),
      isTrue,
    );

    expect(find.text('Theme Presets'), findsOneWidget);
    expect(find.text('Cupertino preset active'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Flutter Parity'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);
    expect(find.text('Flutter Parity'), findsOneWidget);
    expect(find.text('Picker popup'), findsOneWidget);
    expect(find.text('Action sheet'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Travel Desk'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    expect(find.text('Travel Desk'), findsOneWidget);
    expect(find.text('Editorial Minimal'), findsOneWidget);
    expect(find.text('Command Palette'), findsOneWidget);
    expect(find.text('Team Filter'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Cupertino theme presets stay close to native trigger width',
      (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 1400);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester, duration: const Duration(milliseconds: 400));

    await openExampleDemo(tester, 'Dropdown Demo');
    await tester.tap(
      find.bySemanticsLabel('Switch between Material and Cupertino theme'),
    );
    await pumpUi(tester);

    final pureNative = find.byKey(const Key('dropdown-theme-pure-native'));
    final pureHeadless =
        find.byKey(const Key('dropdown-theme-pure-headless-surface'));
    final richNative = find.byKey(const Key('dropdown-theme-rich-native'));
    final richHeadless =
        find.byKey(const Key('dropdown-theme-rich-headless-surface'));

    expect(pureNative, findsOneWidget);
    expect(pureHeadless, findsOneWidget);
    expect(richNative, findsOneWidget);
    expect(richHeadless, findsOneWidget);

    final pureNativeRect = tester.getRect(pureNative);
    final pureHeadlessRect = tester.getRect(pureHeadless);
    final richNativeRect = tester.getRect(richNative);
    final richHeadlessRect = tester.getRect(richHeadless);

    expect((pureHeadlessRect.width - pureNativeRect.width).abs(), lessThan(6));
    expect((richHeadlessRect.width - richNativeRect.width).abs(), lessThan(6));
  });

  testWidgets('Cupertino parity triggers match native geometry', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 1800);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester, duration: const Duration(milliseconds: 400));

    await openExampleDemo(tester, 'Dropdown Demo');
    await tester.tap(
      find.bySemanticsLabel('Switch between Material and Cupertino theme'),
    );
    await pumpUi(tester);
    await tester.scrollUntilVisible(
      find.text('Flutter Parity'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    final pickerNative =
        find.byKey(const Key('dropdown-cupertino-picker-native-trigger'));
    final pickerHeadless =
        find.byKey(const Key('dropdown-cupertino-picker-headless-surface'));
    final actionNative =
        find.byKey(const Key('dropdown-cupertino-action-native-trigger'));
    final actionHeadless =
        find.byKey(const Key('dropdown-cupertino-action-headless-surface'));

    expect(pickerNative, findsOneWidget);
    expect(pickerHeadless, findsOneWidget);
    expect(actionNative, findsOneWidget);
    expect(actionHeadless, findsOneWidget);

    final pickerNativeRect = tester.getRect(pickerNative);
    final pickerHeadlessRect = tester.getRect(pickerHeadless);
    final actionNativeRect = tester.getRect(actionNative);
    final actionHeadlessRect = tester.getRect(actionHeadless);

    expect((pickerHeadlessRect.width - pickerNativeRect.width).abs(), lessThan(2.5));
    expect((pickerHeadlessRect.height - pickerNativeRect.height).abs(), lessThan(1));
    expect((actionHeadlessRect.width - actionNativeRect.width).abs(), lessThan(2.5));
    expect((actionHeadlessRect.height - actionNativeRect.height).abs(), lessThan(1));
  });

  testWidgets('Material parity visuals match Flutter SDK geometry',
      (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 2200);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester, duration: const Duration(milliseconds: 400));

    await openExampleDemo(tester, 'Dropdown Demo');
    await tester.scrollUntilVisible(
      find.text('Flutter Parity'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    final sdkUnderline = find.byKey(const Key('dropdown-sdk-underline-visual'));
    final headlessUnderline = find.byType(DropdownDemoUnderlineVisual).last;
    final sdkSelected = find.byKey(
      const Key('dropdown-sdk-selected-item-visual'),
    );
    final headlessSelected = find.byType(DropdownDemoSelectedItemVisual).last;

    expect(sdkUnderline, findsOneWidget);
    expect(headlessUnderline, findsOneWidget);
    expect(sdkSelected, findsOneWidget);
    expect(headlessSelected, findsOneWidget);

    final sdkUnderlineRect = tester.getRect(sdkUnderline);
    final headlessUnderlineRect = tester.getRect(headlessUnderline);
    final sdkSelectedRect = tester.getRect(sdkSelected);
    final headlessSelectedRect = tester.getRect(headlessSelected);

    expect(
      (headlessUnderlineRect.width - sdkUnderlineRect.width).abs(),
      lessThan(0.5),
    );
    expect(
      (headlessUnderlineRect.height - sdkUnderlineRect.height).abs(),
      lessThan(0.5),
    );

    expect(
      (headlessSelectedRect.width - sdkSelectedRect.width).abs(),
      lessThan(0.5),
    );
    expect(
      (headlessSelectedRect.height - sdkSelectedRect.height).abs(),
      lessThan(0.5),
    );
  });

  testWidgets('Headless Material parity menu expands beyond trigger width',
      (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(900, 1400);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester, duration: const Duration(milliseconds: 400));

    await openExampleDemo(tester, 'Dropdown Demo');
    await tester.scrollUntilVisible(
      find.text('Flutter Parity'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    final trigger = find.bySemanticsLabel('Headless parity underline dropdown');
    expect(trigger, findsOneWidget);

    await tester.tap(trigger, warnIfMissed: false);
    await pumpUi(tester);

    final menuSurface = find.byKey(
      const Key('dropdown-headless-underline-menu-surface'),
    );
    expect(menuSurface, findsOneWidget);

    final triggerWidth = tester
        .getSize(find.byType(DropdownDemoUnderlineVisual).last)
        .width;
    final menuWidth = tester.getSize(menuSurface).width;

    expect((menuWidth - (triggerWidth + 40)).abs(), lessThan(1));
  });

  testWidgets('Travel desk menu opens without overflow', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1300, 1200);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HeadlessExampleApp());
    await pumpUi(tester, duration: const Duration(milliseconds: 400));

    await openExampleDemo(tester, 'Dropdown Demo');
    await tester.scrollUntilVisible(
      find.text('Travel Desk'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUi(tester);

    await tester.tap(find.bySemanticsLabel(RegExp('Travel desk dropdown')));
    await pumpUi(tester);

    expect(tester.takeException(), isNull);
  });
}
