import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_adaptive/headless_adaptive.dart';

void main() {
  testWidgets('smoke', (tester) async {
    await tester.pumpWidget(
      const HeadlessAdaptiveApp(
        platformOverride: TargetPlatform.android,
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox.shrink(),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(HeadlessAdaptiveApp), findsOneWidget);
  });
}
