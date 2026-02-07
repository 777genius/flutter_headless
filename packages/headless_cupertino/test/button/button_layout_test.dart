import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_cupertino/headless_cupertino.dart';
import 'package:headless_theme/headless_theme.dart';
import 'package:headless_button/headless_button.dart';

void main() {
  group('Cupertino button layout (tap target vs visual)', () {
    testWidgets(
      'hit area is at least 44x44 (HIG minimum)',
      (tester) async {
        await tester.pumpWidget(
          CupertinoApp(
            home: HeadlessThemeProvider(
              theme: CupertinoHeadlessTheme(),
              child: const CupertinoPageScaffold(
                child: Center(
                  child: RTextButton(
                    onPressed: _noop,
                    variant: RButtonVariant.filled,
                    size: RButtonSize.small,
                    child: Text('S'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final buttonFinder = find.byType(RTextButton);
        final buttonSize = tester.getSize(buttonFinder);

        expect(
          buttonSize.width,
          greaterThanOrEqualTo(44.0),
          reason: 'Overall button width must be >= 44 (HIG)',
        );
        expect(
          buttonSize.height,
          greaterThanOrEqualTo(44.0),
          reason: 'Overall button height must be >= 44 (HIG)',
        );
      },
    );

    testWidgets(
      'small size visual minHeight matches CupertinoButton.small default',
      (tester) async {
        await tester.pumpWidget(
          CupertinoApp(
            home: HeadlessThemeProvider(
              theme: CupertinoHeadlessTheme(),
              child: const CupertinoPageScaffold(
                child: Center(
                  child: RTextButton(
                    onPressed: _noop,
                    variant: RButtonVariant.filled,
                    size: RButtonSize.small,
                    child: Text('S'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find the ShapeDecoration DecoratedBox (the visual shell from parity renderer)
        final shapeFinder = find.byWidgetPredicate(
          (w) =>
              w is DecoratedBox && w.decoration is ShapeDecoration,
        );
        expect(shapeFinder, findsOneWidget);

        final visualSize = tester.getSize(shapeFinder);
        expect(
          visualSize.height,
          greaterThanOrEqualTo(28.0),
          reason: 'Small CupertinoButton visual minHeight should be >= 28dp',
        );
        expect(
          visualSize.height,
          lessThan(44.0),
          reason: 'Small CupertinoButton visual height should be < 44dp '
              '(tap target inflates, not the visual)',
        );
      },
    );

    testWidgets(
      'large size visual minHeight matches CupertinoButton.large default',
      (tester) async {
        await tester.pumpWidget(
          CupertinoApp(
            home: HeadlessThemeProvider(
              theme: CupertinoHeadlessTheme(),
              child: const CupertinoPageScaffold(
                child: Center(
                  child: RTextButton(
                    onPressed: _noop,
                    variant: RButtonVariant.filled,
                    size: RButtonSize.large,
                    child: Text('L'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final shapeFinder = find.byWidgetPredicate(
          (w) =>
              w is DecoratedBox && w.decoration is ShapeDecoration,
        );
        expect(shapeFinder, findsOneWidget);

        final visualSize = tester.getSize(shapeFinder);
        expect(
          visualSize.height,
          greaterThanOrEqualTo(44.0),
          reason: 'Large CupertinoButton visual minHeight should be >= 44dp',
        );
      },
    );
  });
}

void _noop() {}
