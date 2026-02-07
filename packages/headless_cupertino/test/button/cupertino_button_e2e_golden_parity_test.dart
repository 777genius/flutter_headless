@Tags(['golden'])
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'helpers/parity_test_harness.dart';

/// E2E golden parity tests: [RTextButton] (left) vs native [CupertinoButton] (right).
///
/// Update goldens with:
/// ```bash
/// cd packages/headless_cupertino && flutter test --update-goldens
/// ```
void main() {
  group('E2E golden parity', () {
    for (final variant in const [
      RButtonVariant.filled,
      RButtonVariant.tonal,
      RButtonVariant.text,
    ]) {
      final variantName = variant.name;

      testWidgets('$variantName — enabled (medium)', (tester) async {
        await tester.pumpWidget(
          buildE2eParityHarness(
            headlessButton: buildHeadlessButton(
              variant: variant,
              size: RButtonSize.medium,
              enabled: true,
              child: const Text('Label'),
            ),
            nativeButton: Center(
              child: buildNativeCupertinoButton(
                key: const Key('native'),
                variant: variant,
                size: RButtonSize.medium,
                enabled: true,
                child: const Text('Label'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(CupertinoPageScaffold),
          matchesGoldenFile('goldens/e2e_${variantName}_enabled.png'),
        );
      });

      testWidgets('$variantName — disabled (medium)', (tester) async {
        await tester.pumpWidget(
          buildE2eParityHarness(
            headlessButton: buildHeadlessButton(
              variant: variant,
              size: RButtonSize.medium,
              enabled: false,
              child: const Text('Label'),
            ),
            nativeButton: Center(
              child: buildNativeCupertinoButton(
                key: const Key('native'),
                variant: variant,
                size: RButtonSize.medium,
                enabled: false,
                child: const Text('Label'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(CupertinoPageScaffold),
          matchesGoldenFile('goldens/e2e_${variantName}_disabled.png'),
        );
      });
    }

    testWidgets('filled — size mapping (small)', (tester) async {
      await tester.pumpWidget(
        buildE2eParityHarness(
          headlessButton: buildHeadlessButton(
            variant: RButtonVariant.filled,
            size: RButtonSize.small,
            enabled: true,
            child: const Text('Label'),
          ),
          nativeButton: Center(
            child: buildNativeCupertinoButton(
              key: const Key('native'),
              variant: RButtonVariant.filled,
              size: RButtonSize.small,
              enabled: true,
              child: const Text('Label'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CupertinoPageScaffold),
        matchesGoldenFile('goldens/e2e_filled_size_small.png'),
      );
    });

    testWidgets('filled — size mapping (large)', (tester) async {
      await tester.pumpWidget(
        buildE2eParityHarness(
          headlessButton: buildHeadlessButton(
            variant: RButtonVariant.filled,
            size: RButtonSize.large,
            enabled: true,
            child: const Text('Label'),
          ),
          nativeButton: Center(
            child: buildNativeCupertinoButton(
              key: const Key('native'),
              variant: RButtonVariant.filled,
              size: RButtonSize.large,
              enabled: true,
              child: const Text('Label'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CupertinoPageScaffold),
        matchesGoldenFile('goldens/e2e_filled_size_large.png'),
      );
    });

    testWidgets('text — size mapping (small)', (tester) async {
      await tester.pumpWidget(
        buildE2eParityHarness(
          headlessButton: buildHeadlessButton(
            variant: RButtonVariant.text,
            size: RButtonSize.small,
            enabled: true,
            child: const Text('Label'),
          ),
          nativeButton: Center(
            child: buildNativeCupertinoButton(
              key: const Key('native'),
              variant: RButtonVariant.text,
              size: RButtonSize.small,
              enabled: true,
              child: const Text('Label'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CupertinoPageScaffold),
        matchesGoldenFile('goldens/e2e_text_size_small.png'),
      );
    });

    testWidgets('text — size mapping (large)', (tester) async {
      await tester.pumpWidget(
        buildE2eParityHarness(
          headlessButton: buildHeadlessButton(
            variant: RButtonVariant.text,
            size: RButtonSize.large,
            enabled: true,
            child: const Text('Label'),
          ),
          nativeButton: Center(
            child: buildNativeCupertinoButton(
              key: const Key('native'),
              variant: RButtonVariant.text,
              size: RButtonSize.large,
              enabled: true,
              child: const Text('Label'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CupertinoPageScaffold),
        matchesGoldenFile('goldens/e2e_text_size_large.png'),
      );
    });
  });
}
