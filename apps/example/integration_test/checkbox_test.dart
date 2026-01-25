import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/checkbox_test_app.dart';
import 'helpers/checkbox_test_helpers.dart';
import 'helpers/checkbox_test_scenario.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Checkbox E2E Tests', () {
    testWidgets('IT-01: Material checkbox toggles value', (tester) async {
      await tester.pumpWidget(const CheckboxTestApp(
        platformOverride: TargetPlatform.android,
        child: CheckboxTestScenario(
          initialValue: false,
        ),
      ));
      await tester.pumpAndSettle();

      tester.expectCheckboxValue('false');
      await tester.tapCheckbox();
      tester.expectCheckboxValue('true');
      await tester.tapCheckbox();
      tester.expectCheckboxValue('false');
    });

    testWidgets('IT-02: ListTile tristate cycles values', (tester) async {
      await tester.pumpWidget(const CheckboxTestApp(
        platformOverride: TargetPlatform.android,
        child: CheckboxListTileTestScenario(
          initialValue: false,
          tristate: true,
        ),
      ));
      await tester.pumpAndSettle();

      tester.expectListTileValue('false');
      await tester.tapListTile();
      tester.expectListTileValue('true');
      await tester.tapListTile();
      tester.expectListTileValue('null');
      await tester.tapListTile();
      tester.expectListTileValue('false');
    });

    testWidgets('IT-03: Adaptive app uses MaterialApp on Android', (tester) async {
      await tester.pumpWidget(const CheckboxTestApp(
        platformOverride: TargetPlatform.android,
        child: CheckboxTestScenario(
          initialValue: false,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(CupertinoApp), findsNothing);
    });

    testWidgets('IT-04: Adaptive app uses CupertinoApp on iOS', (tester) async {
      await tester.pumpWidget(const CheckboxTestApp(
        platformOverride: TargetPlatform.iOS,
        child: CheckboxTestScenario(
          initialValue: false,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoApp), findsOneWidget);
      expect(find.byType(MaterialApp), findsNothing);
    });
  });
}

