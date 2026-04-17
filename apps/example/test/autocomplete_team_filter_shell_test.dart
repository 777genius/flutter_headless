import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:headless_example/main.dart' show HeadlessExampleApp;

import 'helpers/example_app_helpers.dart';
import 'helpers/rect_matchers.dart';

Future<void> _setLargeSurface(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(1400, 2200);
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Future<void> _openTeamFilterMenu(WidgetTester tester) async {
  final shell = find.byKey(const ValueKey('autocomplete-shell-team-filter'));
  await tester.ensureVisible(shell);
  await pumpUi(tester);

  final field = find.descendant(of: shell, matching: find.byType(EditableText));
  expect(field, findsOneWidget);

  await tester.tap(field);
  await pumpUi(tester, duration: const Duration(milliseconds: 400));
}

BoxDecoration _itemDecoration(WidgetTester tester, String id) {
  final item = find.byKey(ValueKey('autocomplete-team-item-$id'));
  expect(item, findsOneWidget);
  final decoration = tester.widget<Container>(item).decoration;
  expect(decoration, isA<BoxDecoration>());
  return decoration! as BoxDecoration;
}

void main() {
  testWidgets(
    'Team filter menu keeps row geometry consistent in light theme',
    (tester) async {
      await _setLargeSurface(tester);
      await tester.pumpWidget(const HeadlessExampleApp());
      await pumpUi(tester, duration: const Duration(milliseconds: 400));

      await openExampleDemo(tester, 'Autocomplete Demo');
      await _openTeamFilterMenu(tester);

      final finlandRow = find.byKey(const ValueKey('autocomplete-team-item-FI'));
      final germanyRow = find.byKey(const ValueKey('autocomplete-team-item-DE'));
      final finlandIndicator = find.byKey(
        const ValueKey('autocomplete-team-indicator-FI'),
      );
      final germanyIndicator = find.byKey(
        const ValueKey('autocomplete-team-indicator-DE'),
      );

      expect(find.byType(Checkbox), findsNothing);
      expect(finlandRow, findsOneWidget);
      expect(germanyRow, findsOneWidget);

      final finlandDecoration = _itemDecoration(tester, 'FI');
      final germanyDecoration = _itemDecoration(tester, 'DE');

      expect(finlandDecoration.color, const Color(0xFFF0E8FF));
      expect(germanyDecoration.color, const Color(0xFFFFFDFF));
      expect(
        (finlandDecoration.borderRadius! as BorderRadius).topLeft.x,
        equals(18),
      );
      expect(
        (germanyDecoration.borderRadius! as BorderRadius).topLeft.x,
        equals(18),
      );
      final finlandHeight = tester.getSize(finlandRow).height;
      final germanyHeight = tester.getSize(germanyRow).height;

      expect(finlandHeight, inInclusiveRange(60.0, 64.0));
      expect(germanyHeight, equals(finlandHeight));
      expect(tester.getSize(finlandIndicator), const Size(28, 28));
      expect(tester.getSize(germanyIndicator), const Size(28, 28));

      final finlandCenter = tester.getRect(finlandRow).center;
      expect(tester.getRect(finlandIndicator), hasVerticalCenterNear(finlandCenter));
    },
  );
}
