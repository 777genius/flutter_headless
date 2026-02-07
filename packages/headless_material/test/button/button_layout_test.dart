import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_theme/headless_theme.dart';
import 'package:headless_button/headless_button.dart';

void main() {
  group('Material button layout (tap target vs visual)', () {
    testWidgets(
      'visual height matches M3 FilledButton default (not inflated to tap target)',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HeadlessThemeProvider(
              theme: MaterialHeadlessTheme(),
              child: const Scaffold(
                body: Center(
                  child: RTextButton(
                    onPressed: _noop,
                    variant: RButtonVariant.filled,
                    child: Text('Test'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final filledButton = find.byType(FilledButton);
        expect(filledButton, findsOneWidget);

        final filledButtonSize = tester.getSize(filledButton);
        expect(
          filledButtonSize.height,
          lessThan(48.0),
          reason:
              'FilledButton visual height should be < 48 (M3 default is ~40dp). '
              'Tap target inflation is handled by the component, not the renderer.',
        );
      },
    );

    testWidgets(
      'hit area is at least MaterialTapTargetPolicy.minTapTargetSize',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HeadlessThemeProvider(
              theme: MaterialHeadlessTheme(),
              child: const Scaffold(
                body: Center(
                  child: RTextButton(
                    onPressed: _noop,
                    variant: RButtonVariant.filled,
                    child: Text('Test'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final expectedMinSize = MaterialTapTargetPolicy.computeMinTapTargetSize(
          tapTargetSize: MaterialTapTargetSize.padded,
        );

        final buttonFinder = find.byType(RTextButton);
        final buttonSize = tester.getSize(buttonFinder);

        expect(
          buttonSize.width,
          greaterThanOrEqualTo(expectedMinSize.width),
          reason: 'Overall button width must be >= tap target width',
        );
        expect(
          buttonSize.height,
          greaterThanOrEqualTo(expectedMinSize.height),
          reason: 'Overall button height must be >= tap target height',
        );
      },
    );
  });
}

void _noop() {}
