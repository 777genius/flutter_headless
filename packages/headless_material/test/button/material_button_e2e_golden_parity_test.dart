@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'helpers/parity_test_harness.dart';

/// E2E golden parity tests: [RTextButton] (left) vs Flutter Material buttons (right).
///
/// Update goldens with:
/// ```bash
/// cd packages/headless_material && flutter test --update-goldens
/// ```
void main() {
  group('E2E golden parity', () {
    for (final variant in RButtonVariant.values) {
      final variantName = variant.name;

      testWidgets('$variantName — enabled', (tester) async {
        await tester.pumpWidget(
          buildE2eParityHarness(
            headlessButton: buildHeadlessButton(
              variant: variant,
              enabled: true,
              child: const Text('Label'),
            ),
            nativeButton: Center(
              child: buildNativeMaterialButton(
                variant: variant,
                enabled: true,
                child: const Text('Label'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/e2e_${variantName}_enabled.png'),
        );
      });

      testWidgets('$variantName — disabled', (tester) async {
        await tester.pumpWidget(
          buildE2eParityHarness(
            headlessButton: buildHeadlessButton(
              variant: variant,
              enabled: false,
              child: const Text('Label'),
            ),
            nativeButton: Center(
              child: buildNativeMaterialButton(
                variant: variant,
                enabled: false,
                child: const Text('Label'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/e2e_${variantName}_disabled.png'),
        );
      });
    }
  });
}
