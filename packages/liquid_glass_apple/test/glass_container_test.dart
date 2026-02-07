import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_apple/liquid_glass_apple.dart';

void main() {
  group('GlassStyle', () {
    test('all styles have valid params', () {
      for (final style in GlassStyle.values) {
        final params = style.params;
        expect(params.blurSigma, greaterThan(0));
        expect(params.tintOpacity, inInclusiveRange(0.0, 1.0));
        expect(params.highlightOpacity, inInclusiveRange(0.0, 1.0));
        expect(params.shadowOpacity, inInclusiveRange(0.0, 1.0));
        expect(params.saturation, greaterThan(0));
      }
    });

    test('ultraThin has smallest blur', () {
      final ultraThin = GlassStyle.ultraThin.params;
      final chrome = GlassStyle.chrome.params;

      expect(ultraThin.blurSigma, lessThan(chrome.blurSigma));
    });

    test('chrome has highest blur', () {
      final chrome = GlassStyle.chrome.params;

      for (final style in GlassStyle.values) {
        if (style != GlassStyle.chrome) {
          expect(style.params.blurSigma, lessThanOrEqualTo(chrome.blurSigma));
        }
      }
    });
  });

  group('GlassContainer', () {
    testWidgets('renders child widget', (tester) async {
      const testKey = Key('test-child');

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: GlassContainer(child: SizedBox(key: testKey)),
        ),
      );

      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets('contains BackdropFilter', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: GlassContainer(child: SizedBox()),
        ),
      );

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('contains ClipRRect', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: GlassContainer(child: SizedBox()),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('contains RepaintBoundary for performance', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: GlassContainer(child: SizedBox()),
        ),
      );

      expect(find.byType(RepaintBoundary), findsOneWidget);
    });

    testWidgets('applies custom borderRadius', (tester) async {
      const customRadius = BorderRadius.all(Radius.circular(32));

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: GlassContainer(borderRadius: customRadius, child: SizedBox()),
        ),
      );

      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, customRadius);
    });

    testWidgets('applies custom blurSigma', (tester) async {
      const customSigma = 25.0;

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: GlassContainer(blurSigma: customSigma, child: SizedBox()),
        ),
      );

      final backdrop = tester.widget<BackdropFilter>(
        find.byType(BackdropFilter),
      );
      final filter = backdrop.filter;
      expect(filter.toString(), contains('$customSigma'));
    });

    testWidgets('applies padding when provided', (tester) async {
      const testPadding = EdgeInsets.all(16);

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: GlassContainer(padding: testPadding, child: SizedBox()),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, testPadding);
    });

    testWidgets('does not add Padding when padding is null', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: GlassContainer(child: SizedBox()),
        ),
      );

      expect(find.byType(Padding), findsNothing);
    });

    testWidgets('uses different styles', (tester) async {
      for (final style in GlassStyle.values) {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: GlassContainer(style: style, child: const SizedBox()),
          ),
        );

        expect(find.byType(GlassContainer), findsOneWidget);
      }
    });
  });

  group('GlassStyleParams', () {
    test('all params are positive', () {
      for (final style in GlassStyle.values) {
        final params = style.params;
        expect(params.blurSigma, isPositive);
        expect(params.tintOpacity, isNonNegative);
        expect(params.highlightOpacity, isNonNegative);
        expect(params.shadowOpacity, isNonNegative);
        expect(params.saturation, isPositive);
      }
    });

    test('blur sigma is in reasonable range', () {
      for (final style in GlassStyle.values) {
        final params = style.params;
        expect(params.blurSigma, inInclusiveRange(1.0, 50.0));
      }
    });
  });
}
