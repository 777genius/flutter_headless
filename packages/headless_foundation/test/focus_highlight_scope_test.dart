import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/interaction.dart';

void main() {
  group('HeadlessFocusHighlightScope', () {
    testWidgets('of() returns controller from scope', (tester) async {
      final controller = HeadlessFocusHighlightController(
        policy: const HeadlessAlwaysFocusHighlightPolicy(),
      );
      addTearDown(controller.dispose);

      HeadlessFocusHighlightController? captured;

      await tester.pumpWidget(
        HeadlessFocusHighlightScope(
          controller: controller,
          child: Builder(
            builder: (context) {
              captured = HeadlessFocusHighlightScope.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(captured, same(controller));
    });

    testWidgets('maybeOf() returns null when no scope', (tester) async {
      HeadlessFocusHighlightController? captured;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            captured = HeadlessFocusHighlightScope.maybeOf(context);
            return const SizedBox.shrink();
          },
        ),
      );

      expect(captured, isNull);
    });

    testWidgets('showOf() returns controller value when scope exists',
        (tester) async {
      final controller = HeadlessFocusHighlightController(
        policy: const HeadlessAlwaysFocusHighlightPolicy(),
      );
      addTearDown(controller.dispose);

      bool? showValue;

      await tester.pumpWidget(
        HeadlessFocusHighlightScope(
          controller: controller,
          child: Builder(
            builder: (context) {
              showValue = HeadlessFocusHighlightScope.showOf(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // AlwaysPolicy -> true regardless of mode
      expect(showValue, isTrue);
    });

    testWidgets('showOf() falls back to FocusManager when no scope',
        (tester) async {
      bool? showValue;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            showValue = HeadlessFocusHighlightScope.showOf(context);
            return const SizedBox.shrink();
          },
        ),
      );

      // Falls back to FocusManager.instance.highlightMode == traditional
      final expected =
          FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
      expect(showValue, expected);
    });

    testWidgets('of() asserts when no scope in debug mode', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(
              () => HeadlessFocusHighlightScope.of(context),
              throwsA(isA<FlutterError>().having(
                (e) => e.message,
                'message',
                contains('No HeadlessFocusHighlightScope'),
              )),
            );
            return const SizedBox.shrink();
          },
        ),
      );
    });

    testWidgets('child rebuilds when controller notifies', (tester) async {
      final controller = HeadlessFocusHighlightController(
        policy: const HeadlessAlwaysFocusHighlightPolicy(),
      );
      addTearDown(controller.dispose);

      var buildCount = 0;

      await tester.pumpWidget(
        HeadlessFocusHighlightScope(
          controller: controller,
          child: Builder(
            builder: (context) {
              // Depend on the scope
              HeadlessFocusHighlightScope.of(context);
              buildCount++;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(buildCount, 1);

      // Manually trigger notification (simulates mode change)
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      controller.notifyListeners();
      await tester.pump();

      expect(buildCount, 2);
    });
  });
}
