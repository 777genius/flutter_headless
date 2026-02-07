import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/switch_test_app.dart';
import 'helpers/switch_test_helpers.dart';
import 'helpers/switch_test_scenario.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Switch E2E Tests - Basic Interactions (Tap)', () {
    testWidgets('IT-01: Tap toggles switch OFF → ON', (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.iOS,
        child: SwitchTestScenario(initialValue: false),
      ));
      await tester.pumpAndSettle();

      tester.expectSwitchValue(false);
      await tester.tapSwitch();
      tester.expectSwitchValue(true);
    });

    testWidgets('IT-02: Tap toggles switch ON → OFF', (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.iOS,
        child: SwitchTestScenario(initialValue: true),
      ));
      await tester.pumpAndSettle();

      tester.expectSwitchValue(true);
      await tester.tapSwitch();
      tester.expectSwitchValue(false);
    });

    testWidgets('IT-03: Multiple taps toggle correctly', (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.iOS,
        child: SwitchTestScenario(initialValue: false),
      ));
      await tester.pumpAndSettle();

      tester.expectSwitchValue(false);
      await tester.tapSwitch();
      tester.expectSwitchValue(true);
      await tester.tapSwitch();
      tester.expectSwitchValue(false);
      await tester.tapSwitch();
      tester.expectSwitchValue(true);
    });
  });

  group('Switch E2E Tests - Disabled State', () {
    testWidgets('IT-04: Disabled switch does not toggle on tap',
        (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.iOS,
        child: SwitchTestScenario(initialValue: false, disabled: true),
      ));
      await tester.pumpAndSettle();

      tester.expectSwitchValue(false);
      await tester.tapSwitch();
      tester.expectSwitchValue(false);
    });

    testWidgets('IT-05: Disabled switch ON state does not toggle',
        (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.iOS,
        child: SwitchTestScenario(initialValue: true, disabled: true),
      ));
      await tester.pumpAndSettle();

      tester.expectSwitchValue(true);
      await tester.tapSwitch();
      tester.expectSwitchValue(true);
    });

    testWidgets('IT-06: Disabled switch ignores Space key', (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.iOS,
        child: SwitchTestScenario(
          initialValue: false,
          disabled: true,
          autofocus: true,
        ),
      ));
      await tester.pumpAndSettle();

      tester.expectSwitchValue(false);
      await tester.pressSpace();
      tester.expectSwitchValue(false);
    });

    testWidgets('IT-07: Disabled switch ignores Enter key', (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.iOS,
        child: SwitchTestScenario(
          initialValue: false,
          disabled: true,
          autofocus: true,
        ),
      ));
      await tester.pumpAndSettle();

      tester.expectSwitchValue(false);
      await tester.pressEnter();
      tester.expectSwitchValue(false);
    });
  });

  group('Switch E2E Tests - Keyboard Navigation', () {
    testWidgets('IT-08: Space toggles switch OFF → ON', (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.iOS,
        child: SwitchTestScenario(initialValue: false, autofocus: true),
      ));
      await tester.pumpAndSettle();

      tester.expectSwitchValue(false);
      await tester.pressSpace();
      tester.expectSwitchValue(true);
    });

    testWidgets('IT-09: Space toggles switch ON → OFF', (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.iOS,
        child: SwitchTestScenario(initialValue: true, autofocus: true),
      ));
      await tester.pumpAndSettle();

      tester.expectSwitchValue(true);
      await tester.pressSpace();
      tester.expectSwitchValue(false);
    });

    testWidgets('IT-10: Enter toggles switch', (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.iOS,
        child: SwitchTestScenario(initialValue: false, autofocus: true),
      ));
      await tester.pumpAndSettle();

      tester.expectSwitchValue(false);
      await tester.pressEnter();
      tester.expectSwitchValue(true);
    });

    testWidgets('IT-11: Multiple Enter presses toggle correctly',
        (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.iOS,
        child: SwitchTestScenario(initialValue: false, autofocus: true),
      ));
      await tester.pumpAndSettle();

      tester.expectSwitchValue(false);
      await tester.pressEnter();
      tester.expectSwitchValue(true);
      await tester.pressEnter();
      tester.expectSwitchValue(false);
    });
  });

  group('Switch E2E Tests - RSwitchListTile', () {
    testWidgets('IT-12: ListTile tap toggles switch', (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.iOS,
        child: SwitchListTileTestScenario(initialValue: false),
      ));
      await tester.pumpAndSettle();

      tester.expectListTileValue(false);
      await tester.tapListTile();
      tester.expectListTileValue(true);
      await tester.tapListTile();
      tester.expectListTileValue(false);
    });

    testWidgets('IT-13: Disabled ListTile does not toggle', (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.iOS,
        child: SwitchListTileTestScenario(initialValue: false, disabled: true),
      ));
      await tester.pumpAndSettle();

      tester.expectListTileValue(false);
      await tester.tapListTile();
      tester.expectListTileValue(false);
    });

    testWidgets('IT-14: ListTile displays title and subtitle', (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.iOS,
        child: SwitchListTileTestScenario(initialValue: false),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Tile title'), findsOneWidget);
      expect(find.text('Tile subtitle'), findsOneWidget);
    });
  });

  group('Switch E2E Tests - Platform Rendering', () {
    testWidgets('IT-15: iOS platform uses CupertinoApp', (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.iOS,
        child: SwitchTestScenario(initialValue: false),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoApp), findsOneWidget);
      expect(find.byType(MaterialApp), findsNothing);
    });

    testWidgets('IT-16: Android platform uses MaterialApp', (tester) async {
      await tester.pumpWidget(const SwitchTestApp(
        platformOverride: TargetPlatform.android,
        child: SwitchTestScenario(initialValue: false),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(CupertinoApp), findsNothing);
    });
  });
}
