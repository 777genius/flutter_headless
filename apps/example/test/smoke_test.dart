import 'package:flutter_test/flutter_test.dart';

import 'package:headless_example/main.dart' show HeadlessExampleApp;

void main() {
  testWidgets('Theme toggle: Cupertino mode does not crash Autocomplete demo',
      (tester) async {
    await tester.pumpWidget(const HeadlessExampleApp());
    await tester.pumpAndSettle();

    await tester.tap(
      find.bySemanticsLabel('Switch between Material and Cupertino theme'),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Autocomplete Demo'));
    await tester.pumpAndSettle();

    expect(find.text('D1 - Default Autocomplete'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

