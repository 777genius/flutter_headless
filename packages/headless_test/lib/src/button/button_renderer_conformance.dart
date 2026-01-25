import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:headless_contracts/headless_contracts.dart';

/// Conformance suite for button renderers (presets).
///
/// Focus: enforce the v1 invariant "single activation source".
/// Renderers must not attach tap handlers that would bypass/double-trigger
/// component-level activation.
void buttonRendererSingleActivationSourceConformance({
  required String presetName,
  required RButtonRenderer Function() rendererGetter,
  required Widget Function(Widget child) wrapApp,
  required RButtonResolvedTokens Function() createDefaultTokens,
  required void Function(WidgetTester tester) assertSingleActivationSource,
}) {
  group('$presetName button renderer conformance', () {
    testWidgets('single activation source (no tap handler in renderer)',
        (tester) async {
      await tester.pumpWidget(
        wrapApp(
          Builder(
            builder: (context) {
              return rendererGetter().render(
                RButtonRenderRequest(
                  context: context,
                  spec: const RButtonSpec(),
                  state: const RButtonState(),
                  content: const Text('Test'),
                  resolvedTokens: createDefaultTokens(),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      assertSingleActivationSource(tester);
    });

    // Note: In v1, renderers receive no activation callbacks at all.
    // The invariant is enforced by ensuring renderers have no tap handlers
    // on the root surface (see test above).
  });
}

