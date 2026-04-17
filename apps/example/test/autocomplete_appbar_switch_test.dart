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

Future<void> _focusPrimaryAutocomplete(WidgetTester tester) async {
  final fieldHost = find.byKey(const Key('autocomplete-parity-field'));
  await tester.ensureVisible(fieldHost);
  await pumpUi(tester);

  final field = find.descendant(
    of: fieldHost,
    matching: find.byType(EditableText),
  );
  expect(field, findsOneWidget);
  await tester.tap(field);
  await pumpUi(tester);
}

Future<void> _openAutocompleteMenu(WidgetTester tester, String query) async {
  await _focusPrimaryAutocomplete(tester);
  await tester.enterText(
    find.descendant(
      of: find.byKey(const Key('autocomplete-parity-field')),
      matching: find.byType(EditableText),
    ),
    query,
  );
  await pumpUi(tester, duration: const Duration(milliseconds: 400));
}

Future<void> _openShellAutocompleteMenu(
  WidgetTester tester,
  Key key, {
  String query = '',
}) async {
  final shell = find.byKey(key);
  await tester.ensureVisible(shell);
  await pumpUi(tester);

  final field = find.descendant(
    of: shell,
    matching: find.byType(EditableText),
  );
  expect(field, findsOneWidget);

  await tester.tap(field);
  await pumpUi(tester);

  if (query.isEmpty) return;

  await tester.enterText(field, query);
  await pumpUi(tester, duration: const Duration(milliseconds: 400));
}

BoxDecoration _shellFieldDecoration(
  WidgetTester tester,
  Key shellKey,
) {
  final fieldChrome = find.descendant(
    of: find.byKey(shellKey),
    matching: find.byType(AnimatedContainer),
  );
  expect(fieldChrome, findsOneWidget);
  final decoration = tester.widget<AnimatedContainer>(fieldChrome).decoration;
  expect(decoration, isA<BoxDecoration>());
  return decoration! as BoxDecoration;
}

void main() {
  testWidgets(
    'Theme switch stays tappable while autocomplete menu is open',
    (tester) async {
      await _setLargeSurface(tester);
      await tester.pumpWidget(const HeadlessExampleApp());
      await pumpUi(tester, duration: const Duration(milliseconds: 400));

      await openExampleDemo(tester, 'Autocomplete Demo');
      await _openAutocompleteMenu(tester, 'bo');

      expect(find.text('bobcat'), findsOneWidget);

      const modeLabel = 'Switch between Material and Cupertino theme';
      final themeSwitch = find.bySemanticsLabel(modeLabel);
      expect(themeSwitch, findsOneWidget);

      final beforeToggle = switchValue(tester, modeLabel);
      await tester.tap(themeSwitch);
      await pumpUi(tester);
      final afterToggle = switchValue(tester, modeLabel);

      expect(afterToggle, isNot(equals(beforeToggle)));
      expect(find.text('Autocomplete Demo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Light/dark switch stays tappable after reopening autocomplete menu',
    (tester) async {
      await _setLargeSurface(tester);
      await tester.pumpWidget(const HeadlessExampleApp());
      await pumpUi(tester, duration: const Duration(milliseconds: 400));

      await openExampleDemo(tester, 'Autocomplete Demo');
      await _openAutocompleteMenu(tester, 'fi');

      const brightnessLabel = 'Switch between light and dark theme';
      final brightnessSwitch = find.bySemanticsLabel(brightnessLabel);
      expect(brightnessSwitch, findsOneWidget);

      final beforeFirstToggle = switchValue(tester, brightnessLabel);
      await tester.tap(brightnessSwitch);
      await pumpUi(tester);
      final afterFirstToggle = switchValue(tester, brightnessLabel);
      expect(afterFirstToggle, isNot(equals(beforeFirstToggle)));

      await _openAutocompleteMenu(tester, 'ch');
      expect(find.text('chameleon'), findsOneWidget);

      final beforeSecondToggle = switchValue(tester, brightnessLabel);
      await tester.tap(brightnessSwitch);
      await pumpUi(tester);
      final afterSecondToggle = switchValue(tester, brightnessLabel);

      expect(afterSecondToggle, isNot(equals(beforeSecondToggle)));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Scoped autocomplete shells stay visible after switching headless theme',
    (tester) async {
      await _setLargeSurface(tester);
      await tester.pumpWidget(const HeadlessExampleApp());
      await pumpUi(tester, duration: const Duration(milliseconds: 400));

      await openExampleDemo(tester, 'Autocomplete Demo');

      expect(
        switchValue(tester, 'Switch between Material and Cupertino theme'),
        isFalse,
      );
      expect(find.text('Theme Presets'), findsOneWidget);
      expect(find.text('Material preset active'), findsOneWidget);
      expect(find.text('Flutter Native vs Headless API'), findsOneWidget);

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
      expect(find.text('Cupertino primitives'), findsOneWidget);
      expect(find.text('Travel Desk'), findsOneWidget);
      expect(find.text('Editorial Minimal'), findsOneWidget);
      expect(find.text('Command Palette'), findsOneWidget);
      expect(find.text('Team Filter'), findsOneWidget);
      expect(find.text('Travel Desk'), findsOneWidget);
      expect(find.text('Editorial Minimal'), findsOneWidget);
      expect(find.text('Command Palette'), findsOneWidget);
      expect(find.text('Team Filter'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Material parity shows a concrete query hint and keeps both fields in one row',
    (tester) async {
      await _setLargeSurface(tester);
      await tester.pumpWidget(const HeadlessExampleApp());
      await pumpUi(tester, duration: const Duration(milliseconds: 400));

      await openExampleDemo(tester, 'Autocomplete Demo');

      final sdkColumn = find.byKey(
        const Key('autocomplete-parity-column-Flutter SDK'),
      );
      final headlessColumn = find.byKey(
        const Key('autocomplete-parity-column-Active Headless Preset'),
      );

      await tester.ensureVisible(sdkColumn);
      await pumpUi(tester);

      expect(find.text('Query hint: Try: a, bo, or ch'), findsOneWidget);
      expect(find.text('Flutter Native vs Headless API'), findsOneWidget);
      expect(find.text('Autocomplete<T>'), findsOneWidget);
      expect(find.text('RAutocomplete<T>'), findsOneWidget);
      expect(find.text('Flutter SDK'), findsOneWidget);
      expect(find.text('Headless API'), findsOneWidget);
      expect(sdkColumn, findsOneWidget);
      expect(headlessColumn, findsOneWidget);

      final sdkTopLeft = tester.getTopLeft(sdkColumn);
      final headlessTopLeft = tester.getTopLeft(headlessColumn);

      expect((sdkTopLeft.dy - headlessTopLeft.dy).abs(), lessThan(1));
      expect(headlessTopLeft.dx, greaterThan(sdkTopLeft.dx));
    },
  );

  testWidgets(
    'Command palette menu keeps the shell contrast when opened',
    (tester) async {
      await _setLargeSurface(tester);
      await tester.pumpWidget(const HeadlessExampleApp());
      await pumpUi(tester, duration: const Duration(milliseconds: 400));

      await openExampleDemo(tester, 'Autocomplete Demo');
      await _openShellAutocompleteMenu(
        tester,
        const ValueKey('autocomplete-shell-command'),
      );

      final commandScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF74F08A),
        brightness: Brightness.dark,
      );
      final belgiumText = tester.widget<Text>(find.text('Belgium').last);

      expect(belgiumText.style?.color, commandScheme.onSurface);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Editorial minimal shell does not paint a hairline outline when focused',
    (tester) async {
      await _setLargeSurface(tester);
      await tester.pumpWidget(const HeadlessExampleApp());
      await pumpUi(tester, duration: const Duration(milliseconds: 400));

      await openExampleDemo(tester, 'Autocomplete Demo');
      final editorialShell = find.byKey(
        const ValueKey('autocomplete-shell-editorial'),
      );
      await tester.ensureVisible(editorialShell);
      await pumpUi(tester);

      final field = find.descendant(
        of: editorialShell,
        matching: find.byType(EditableText),
      );
      expect(field, findsOneWidget);

      await tester.tap(field);
      await pumpUi(tester);

      final decoration = _shellFieldDecoration(
        tester,
        const ValueKey('autocomplete-shell-editorial'),
      );

      expect(decoration.border, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Shell gallery keeps slots vertically centered with the input row',
    (tester) async {
      await _setLargeSurface(tester);
      await tester.pumpWidget(const HeadlessExampleApp());
      await pumpUi(tester, duration: const Duration(milliseconds: 400));

      await openExampleDemo(tester, 'Autocomplete Demo');

      final travelShell = find.byKey(const ValueKey('autocomplete-shell-travel'));
      await tester.ensureVisible(travelShell);
      await pumpUi(tester);

      final travelInput = find.descendant(
        of: travelShell,
        matching: find.byType(EditableText),
      );
      final travelInputCenter = tester.getRect(travelInput).center;

      expect(
        tester.getRect(
          find.descendant(
            of: travelShell,
            matching: find.byIcon(Icons.travel_explore_rounded),
          ),
        ),
        hasVerticalCenterNear(travelInputCenter),
      );
      expect(
        tester.getRect(
          find.descendant(
            of: travelShell,
            matching: find.byIcon(Icons.keyboard_arrow_down),
          ),
        ),
        hasVerticalCenterNear(travelInputCenter),
      );

      final editorialShell = find.byKey(
        const ValueKey('autocomplete-shell-editorial'),
      );
      await tester.ensureVisible(editorialShell);
      await pumpUi(tester);

      final editorialInput = find.descendant(
        of: editorialShell,
        matching: find.byType(EditableText),
      );
      final editorialInputCenter = tester.getRect(editorialInput).center;

      expect(
        tester.getRect(
          find.descendant(
            of: editorialShell,
            matching: find.text('FRONT DESK'),
          ),
        ),
        hasVerticalCenterNear(editorialInputCenter),
      );

      final commandShell = find.byKey(
        const ValueKey('autocomplete-shell-command'),
      );
      await tester.ensureVisible(commandShell);
      await pumpUi(tester);

      final commandInput = find.descendant(
        of: commandShell,
        matching: find.byType(EditableText),
      );
      final commandInputCenter = tester.getRect(commandInput).center;

      expect(
        tester.getRect(find.descendant(of: commandShell, matching: find.text('LIVE'))),
        hasVerticalCenterNear(commandInputCenter),
      );
      expect(
        tester.getRect(
          find.descendant(
            of: commandShell,
            matching: find.byIcon(Icons.terminal_rounded),
          ),
        ),
        hasVerticalCenterNear(commandInputCenter),
      );

      final teamShell = find.byKey(
        const ValueKey('autocomplete-shell-team-filter'),
      );
      await tester.ensureVisible(teamShell);
      await pumpUi(tester);

      final teamInput = find.descendant(
        of: teamShell,
        matching: find.byType(EditableText),
      );
      final teamInputCenter = tester.getRect(teamInput).center;

      expect(
        tester.getRect(
          find.descendant(
            of: teamShell,
            matching: find.byIcon(Icons.filter_list_rounded),
          ),
        ),
        hasVerticalCenterNear(teamInputCenter),
      );
    },
  );
}
