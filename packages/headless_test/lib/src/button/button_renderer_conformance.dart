import 'package:flutter/material.dart';
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
  });
}

/// V2 conformance suite for parity renderers.
///
/// Parity renderers may use Flutter buttons internally (which have their own
/// GestureDetectors). The invariant is satisfied if the renderer wraps its
/// output in an inert guard: `ExcludeSemantics` + `AbsorbPointer(absorbing: true)`.
///
/// Alternatively, a renderer may still satisfy the invariant by having *no*
/// interactive handlers in its subtree (pure visual tree).
void buttonRendererSingleActivationSourceConformanceV2({
  required String presetName,
  required RButtonRenderer Function() rendererGetter,
  required Widget Function(Widget child) wrapApp,
}) {
  group('$presetName button renderer conformance v2 (inert guard)', () {
    testWidgets(
        'renderer output is wrapped in ExcludeSemantics + AbsorbPointer',
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
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final hasInertGuard =
          find.byType(ExcludeSemantics).evaluate().isNotEmpty &&
              find
                  .byWidgetPredicate((w) => w is AbsorbPointer && w.absorbing)
                  .evaluate()
                  .isNotEmpty;

      if (hasInertGuard) {
        expect(find.byType(ExcludeSemantics), findsAtLeastNWidgets(1));
        expect(
          find.byWidgetPredicate((w) => w is AbsorbPointer && w.absorbing),
          findsAtLeastNWidgets(1),
        );
        return;
      }

      bool hasInteractiveHandlers = false;

      for (final e in find.byType(GestureDetector).evaluate()) {
        final w = e.widget;
        if (w is! GestureDetector) continue;
        if (w.onTap != null ||
            w.onTapDown != null ||
            w.onTapUp != null ||
            w.onTapCancel != null ||
            w.onDoubleTap != null ||
            w.onLongPress != null ||
            w.onLongPressDown != null ||
            w.onLongPressUp != null ||
            w.onLongPressCancel != null ||
            w.onLongPressStart != null ||
            w.onLongPressMoveUpdate != null ||
            w.onLongPressEnd != null) {
          hasInteractiveHandlers = true;
          break;
        }
      }

      for (final e in find.byType(InkWell).evaluate()) {
        final w = e.widget;
        if (w is! InkWell) continue;
        if (w.onTap != null ||
            w.onTapDown != null ||
            w.onTapUp != null ||
            w.onTapCancel != null ||
            w.onDoubleTap != null ||
            w.onLongPress != null) {
          hasInteractiveHandlers = true;
          break;
        }
      }

      for (final e in find.byType(InkResponse).evaluate()) {
        final w = e.widget;
        if (w is! InkResponse) continue;
        if (w.onTap != null ||
            w.onTapDown != null ||
            w.onTapUp != null ||
            w.onTapCancel != null ||
            w.onDoubleTap != null ||
            w.onLongPress != null) {
          hasInteractiveHandlers = true;
          break;
        }
      }

      expect(
        hasInteractiveHandlers,
        isFalse,
        reason:
            'Renderer must be visual-only: either wrap output in inert guard '
            '(ExcludeSemantics + AbsorbPointer(absorbing: true)) or do not '
            'attach any interactive handlers in the renderer subtree.',
      );
    });
  });
}
