import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_textfield/headless_textfield.dart';

import 'helpers/parity_test_harness.dart';

/// E2E golden parity tests: [RTextField] (left) vs Flutter [TextField] (right).
///
/// Each golden captures both fields side-by-side for visual diff.
/// 3 variants × 3 states = 9 goldens.
void main() {
  group('E2E golden parity', () {
    for (final variant in RTextFieldVariant.values) {
      final variantName = variant.name;

      testWidgets('$variantName — empty unfocused', (tester) async {
        await tester.pumpWidget(
          buildE2eParityHarness(
            headlessField: RTextField(
              variant: variant,
              label: 'Label',
              showCursor: false,
            ),
            nativeField: buildNativeTextField(
              variant: variant,
              label: 'Label',
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/e2e_${variantName}_empty.png'),
        );
      });

      testWidgets('$variantName — error', (tester) async {
        await tester.pumpWidget(
          buildE2eParityHarness(
            headlessField: RTextField(
              variant: variant,
              label: 'Label',
              errorText: 'Required',
              showCursor: false,
            ),
            nativeField: buildNativeTextField(
              variant: variant,
              label: 'Label',
              errorText: 'Required',
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/e2e_${variantName}_error.png'),
        );
      });

      testWidgets('$variantName — disabled', (tester) async {
        await tester.pumpWidget(
          buildE2eParityHarness(
            headlessField: RTextField(
              variant: variant,
              label: 'Label',
              enabled: false,
              showCursor: false,
            ),
            nativeField: buildNativeTextField(
              variant: variant,
              label: 'Label',
              enabled: false,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/e2e_${variantName}_disabled.png'),
        );
      });
    }
  });
}
