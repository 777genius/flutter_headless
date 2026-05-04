import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:headless_example/main.dart' show HeadlessExampleApp;

import 'helpers/example_app_helpers.dart';

void main() {
  testWidgets('Material theme presets stay aligned with Flutter native fields',
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

    final pureNative = find.byKey(const Key('dropdown-theme-pure-native'));
    final pureHeadless = find.byKey(
      const Key('dropdown-theme-pure-headless-surface'),
    );
    final richNative = find.byKey(const Key('dropdown-theme-rich-native'));
    final richHeadless = find.byKey(
      const Key('dropdown-theme-rich-headless-surface'),
    );

    expect(pureNative, findsOneWidget);
    expect(pureHeadless, findsOneWidget);
    expect(richNative, findsOneWidget);
    expect(richHeadless, findsOneWidget);

    _expectFieldGeometryMatch(
        tester, pureNative, pureHeadless, 'San Francisco');
    _expectFieldGeometryMatch(
      tester,
      richNative,
      richHeadless,
      'Paris Charles de Gaulle',
    );
  });
}

void _expectFieldGeometryMatch(
  WidgetTester tester,
  Finder nativeField,
  Finder headlessField,
  String label,
) {
  final nativeRect = tester.getRect(nativeField);
  final headlessSurface = find.descendant(
    of: headlessField,
    matching: find.byType(AnimatedContainer),
  );
  expect(headlessSurface, findsOneWidget);
  final headlessRect = tester.getRect(headlessSurface);

  expect((headlessRect.width - nativeRect.width).abs(), lessThan(1));
  expect((headlessRect.height - nativeRect.height).abs(), lessThan(1));

  final nativeText = find.descendant(
    of: nativeField,
    matching: find.text(label),
  );
  final headlessText = find.descendant(
    of: headlessField,
    matching: find.text(label),
  );
  final nativeIcon = find.descendant(
    of: nativeField,
    matching: find.byIcon(Icons.arrow_drop_down),
  );
  final headlessIcon = find.descendant(
    of: headlessField,
    matching: find.byIcon(Icons.arrow_drop_down),
  );

  expect(nativeText, findsOneWidget);
  expect(headlessText, findsOneWidget);
  expect(nativeIcon, findsOneWidget);
  expect(headlessIcon, findsOneWidget);

  final nativeTextRect = tester.getRect(nativeText);
  final headlessTextRect = tester.getRect(headlessText);
  final nativeIconRect = tester.getRect(nativeIcon);
  final headlessIconRect = tester.getRect(headlessIcon);

  expect(
    ((nativeTextRect.left - nativeRect.left) -
            (headlessTextRect.left - headlessRect.left))
        .abs(),
    lessThan(2),
  );
  expect(
    ((nativeRect.right - nativeIconRect.right) -
            (headlessRect.right - headlessIconRect.right))
        .abs(),
    lessThan(2),
  );
  expect((nativeTextRect.center.dy - headlessTextRect.center.dy).abs(),
      lessThan(1));
  expect((nativeIconRect.center.dy - headlessIconRect.center.dy).abs(),
      lessThan(1));
}
