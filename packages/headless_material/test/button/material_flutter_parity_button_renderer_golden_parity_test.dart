@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_material/headless_material.dart';

import 'helpers/parity_test_harness.dart';

/// Golden parity tests: [MaterialFlutterParityButtonRenderer] vs Flutter buttons.
///
/// Renderer output is visual-only (tap target is handled by the component),
/// so native buttons are also rendered with `MaterialTapTargetSize.shrinkWrap`.
void main() {
  group('Golden parity: MaterialFlutterParityButtonRenderer', () {
    const renderer = MaterialFlutterParityButtonRenderer();

    Widget buildRendererButton(
      BuildContext context, {
      required RButtonVariant variant,
      required RButtonState state,
    }) {
      return renderer.render(
        RButtonRenderRequest(
          context: context,
          spec: RButtonSpec(variant: variant, size: RButtonSize.medium),
          state: state,
          content: const Text('Label'),
          resolvedTokens: null,
        ),
      );
    }

    Future<void> pumpGolden(
      WidgetTester tester, {
      required RButtonVariant variant,
      required Set<WidgetState> nativeStates,
      required RButtonState rendererState,
      required String goldenName,
      required bool enabled,
    }) async {
      final controller = WidgetStatesController(nativeStates);
      final focusNode = FocusNode(canRequestFocus: false, skipTraversal: true);
      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        buildRendererParityHarness(
          rendererBuilder: (context) => Center(
            child: buildRendererButton(
              context,
              variant: variant,
              state: rendererState,
            ),
          ),
          nativeButton: Center(
            child: buildNativeMaterialButton(
              variant: variant,
              enabled: enabled,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              statesController: controller,
              focusNode: focusNode,
              child: const Text('Label'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/$goldenName.png'),
      );
    }

    for (final variant in RButtonVariant.values) {
      final variantName = variant.name;

      testWidgets('$variantName — pressed', (tester) async {
        await pumpGolden(
          tester,
          variant: variant,
          enabled: true,
          nativeStates: const {WidgetState.pressed},
          rendererState: const RButtonState(isPressed: true),
          goldenName: 'renderer_${variantName}_pressed',
        );
      });

      testWidgets('$variantName — hovered', (tester) async {
        await pumpGolden(
          tester,
          variant: variant,
          enabled: true,
          nativeStates: const {WidgetState.hovered},
          rendererState: const RButtonState(isHovered: true),
          goldenName: 'renderer_${variantName}_hovered',
        );
      });

      testWidgets('$variantName — focused', (tester) async {
        await pumpGolden(
          tester,
          variant: variant,
          enabled: true,
          nativeStates: const {WidgetState.focused},
          rendererState: const RButtonState(isFocused: true),
          goldenName: 'renderer_${variantName}_focused',
        );
      });

      testWidgets('$variantName — disabled', (tester) async {
        await pumpGolden(
          tester,
          variant: variant,
          enabled: false,
          nativeStates: const {WidgetState.disabled},
          rendererState: const RButtonState(isDisabled: true),
          goldenName: 'renderer_${variantName}_disabled',
        );
      });
    }
  });
}
