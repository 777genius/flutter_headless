import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_switch/headless_switch.dart';

Future<void> pumpUi(
  WidgetTester tester, {
  Duration duration = const Duration(milliseconds: 300),
}) async {
  await tester.pumpAndSettle(duration);
}

bool switchValue(WidgetTester tester, String semanticLabel) {
  return tester
      .widget<RSwitch>(
        find.byWidgetPredicate(
          (widget) =>
              widget is RSwitch && widget.semanticLabel == semanticLabel,
        ),
      )
      .value;
}

Future<void> openExampleDemo(WidgetTester tester, String tileLabel) async {
  final tile = find.text(tileLabel);
  await tester.scrollUntilVisible(
    tile,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await pumpUi(tester);
  await tester.tap(tile);
  await pumpUi(tester, duration: const Duration(milliseconds: 400));
}
