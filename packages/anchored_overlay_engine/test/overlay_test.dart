import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anchored_overlay_engine/anchored_overlay_engine.dart';

OverlayHandle showOverlay(
  OverlayController controller, {
  required WidgetBuilder builder,
  DismissPolicy dismissPolicy = DismissPolicy.modal,
  FocusPolicy focusPolicy = const NonModalFocusPolicy(),
  FocusNode? restoreFocus,
}) {
  return controller.show(
    OverlayRequest(
      overlayBuilder: builder,
      dismiss: dismissPolicy,
      focus: focusPolicy,
      restoreFocus: restoreFocus,
    ),
  );
}

void main() {
  group('T0 — MissingOverlayHostException message', () {
    test('includes fix-it markers', () {
      const exception = MissingOverlayHostException(
        componentName: 'RTestComponent',
      );
      final message = exception.toString();
      expect(message, contains('OverlayEngine'));
      expect(message, contains('AnchoredOverlayEngineHost'));
    });

    testWidgets('useRootOverlay without Overlay ancestor throws',
        (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnchoredOverlayEngineHost(
            useRootOverlay: true,
            controller: OverlayController(),
            child: const SizedBox(),
          ),
        ),
      );

      final error = tester.takeException();
      expect(error, isFlutterError);
    });
  });

  group('T1 — Basic open/close', () {
    test('show() starts in opening phase', () {
      final controller = OverlayController();
      final handle = showOverlay(
        controller,
        builder: (_) => const SizedBox(),
      );

      expect(handle.phase.value, OverlayPhase.opening);
      expect(handle.isOpen, isTrue);

      // Cleanup
      handle.close();
      handle.completeClose();
      controller.dispose();
    });

    testWidgets('transitions to open after mount', (tester) async {
      final controller = OverlayController();

      late OverlayHandle handle;
      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    handle = showOverlay(
                      controller,
                      builder: (_) => const Text('Overlay'),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      // pump() triggers the post-frame callback that marks as open
      await tester.pump();
      await tester.pump();

      expect(handle.phase.value, OverlayPhase.open);
      expect(handle.isOpen, isTrue);

      // Cleanup
      handle.close();
      handle.completeClose();
      controller.dispose();
    });

    testWidgets('close() transitions to closing, subtree remains',
        (tester) async {
      final controller = OverlayController();

      late OverlayHandle handle;
      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    handle = showOverlay(
                      controller,
                      builder: (_) => const Text('Overlay Content'),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Overlay Content'), findsOneWidget);

      handle.close();
      await tester.pump();

      expect(handle.phase.value, OverlayPhase.closing);
      expect(handle.isOpen, isFalse);
      // Subtree should still be present during closing
      expect(find.text('Overlay Content'), findsOneWidget);

      // Cleanup
      handle.completeClose();
      controller.dispose();
    });

    testWidgets('completeClose() transitions to closed and removes subtree',
        (tester) async {
      final controller = OverlayController();

      late OverlayHandle handle;
      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    handle = showOverlay(
                      controller,
                      builder: (_) => const Text('Overlay Content'),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      handle.close();
      await tester.pump();

      expect(find.text('Overlay Content'), findsOneWidget);

      handle.completeClose();
      await tester.pump();

      expect(handle.phase.value, OverlayPhase.closed);
      expect(find.text('Overlay Content'), findsNothing);

      controller.dispose();
    });
  });

  group('T2 — Idempotency', () {
    test('multiple close() calls do not throw or change phase', () {
      final controller = OverlayController();
      final handle = showOverlay(controller, builder: (_) => const SizedBox());

      handle.close();
      expect(handle.phase.value, OverlayPhase.closing);

      // Multiple close calls should be no-op
      handle.close();
      handle.close();
      handle.close();

      expect(handle.phase.value, OverlayPhase.closing);

      // Cleanup
      handle.completeClose();
      controller.dispose();
    });

    test('multiple completeClose() calls do not throw', () {
      final controller = OverlayController();
      final handle = showOverlay(controller, builder: (_) => const SizedBox());

      handle.close();
      handle.completeClose();

      expect(handle.phase.value, OverlayPhase.closed);

      // Multiple completeClose calls should be no-op
      expect(() => handle.completeClose(), returnsNormally);
      expect(() => handle.completeClose(), returnsNormally);

      expect(handle.phase.value, OverlayPhase.closed);

      controller.dispose();
    });

    test('close() after closed is no-op', () {
      final controller = OverlayController();
      final handle = showOverlay(controller, builder: (_) => const SizedBox());

      handle.close();
      handle.completeClose();

      expect(handle.phase.value, OverlayPhase.closed);

      // close() on closed should be no-op
      handle.close();

      expect(handle.phase.value, OverlayPhase.closed);

      controller.dispose();
    });
  });

  group('T3 — Race: close during opening', () {
    test('close() during opening transitions to closing', () {
      final controller = OverlayController();
      final handle = showOverlay(controller, builder: (_) => const SizedBox());

      expect(handle.phase.value, OverlayPhase.opening);

      // Close immediately (before open)
      handle.close();

      expect(handle.phase.value, OverlayPhase.closing);

      // Cleanup
      handle.completeClose();
      controller.dispose();
    });

    test('completeClose() after close during opening works', () {
      final controller = OverlayController();
      final handle = showOverlay(controller, builder: (_) => const SizedBox());

      handle.close();
      handle.completeClose();

      expect(handle.phase.value, OverlayPhase.closed);

      controller.dispose();
    });
  });

  group('T4 — Fail-safe', () {
    testWidgets('fail-safe timeout closes overlay after timeout',
        (tester) async {
      var failSafeCalled = false;

      final controller = OverlayController(
        failSafeTimeout: const Duration(milliseconds: 100),
        onFailSafeTimeout: (_) => failSafeCalled = true,
      );

      late OverlayHandle handle;
      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    handle = showOverlay(
                      controller,
                      builder: (_) => const Text('Overlay'),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      handle.close();
      await tester.pump();

      expect(handle.phase.value, OverlayPhase.closing);
      expect(failSafeCalled, isFalse);

      // Wait for fail-safe timeout
      await tester.pump(const Duration(milliseconds: 150));

      expect(handle.phase.value, OverlayPhase.closed);
      expect(failSafeCalled, isTrue);

      controller.dispose();
    });

    test('fail-safe does not trigger if completeClose called', () async {
      var failSafeCalled = false;

      final controller = OverlayController(
        failSafeTimeout: const Duration(milliseconds: 50),
        onFailSafeTimeout: (_) => failSafeCalled = true,
      );

      final handle = showOverlay(controller, builder: (_) => const SizedBox());

      handle.close();
      handle.completeClose();

      // Wait longer than timeout
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(failSafeCalled, isFalse);
      expect(handle.phase.value, OverlayPhase.closed);

      controller.dispose();
    });
  });

  group('T5 — Stacking (LIFO)', () {
    testWidgets('overlays stack in LIFO order', (tester) async {
      final controller = OverlayController();

      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: const SizedBox(),
          ),
        ),
      );

      final handleA =
          showOverlay(controller, builder: (_) => const Text('Overlay A'));
      await tester.pumpAndSettle();

      final handleB =
          showOverlay(controller, builder: (_) => const Text('Overlay B'));
      await tester.pumpAndSettle();

      expect(find.text('Overlay A'), findsOneWidget);
      expect(find.text('Overlay B'), findsOneWidget);

      // Close B (topmost)
      handleB.close();
      handleB.completeClose();
      await tester.pump();

      expect(find.text('Overlay A'), findsOneWidget);
      expect(find.text('Overlay B'), findsNothing);

      // A should still be active
      expect(handleA.isOpen, isTrue);

      // Close A
      handleA.close();
      handleA.completeClose();
      await tester.pump();

      expect(find.text('Overlay A'), findsNothing);

      controller.dispose();
    });

    testWidgets('closing topmost does not affect lower overlays',
        (tester) async {
      final controller = OverlayController();

      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: const SizedBox(),
          ),
        ),
      );

      final handleA =
          showOverlay(controller, builder: (_) => const Text('Overlay A'));
      final handleB =
          showOverlay(controller, builder: (_) => const Text('Overlay B'));
      await tester.pumpAndSettle();

      handleB.close();
      handleB.completeClose();
      await tester.pump();

      // A should be unaffected
      expect(handleA.phase.value, OverlayPhase.open);
      expect(find.text('Overlay A'), findsOneWidget);

      // Cleanup
      handleA.close();
      handleA.completeClose();
      controller.dispose();
    });
  });

  group('T6 — Dismiss policies', () {
    testWidgets('Escape key closes topmost overlay', (tester) async {
      final controller = OverlayController();

      late OverlayHandle handle;
      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    handle = showOverlay(
                      controller,
                      builder: (_) => const Text('Overlay'),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(handle.phase.value, OverlayPhase.open);

      // Send Escape key
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      expect(handle.phase.value, OverlayPhase.closing);

      // Cleanup
      handle.completeClose();
      controller.dispose();
    });

    testWidgets('Escape does not close overlay when policy disables it',
        (tester) async {
      final controller = OverlayController();

      late OverlayHandle handle;
      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    handle = showOverlay(
                      controller,
                      dismissPolicy: DismissPolicy.none,
                      builder: (_) => const Text('Overlay'),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(handle.phase.value, OverlayPhase.open);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      // Must remain open because dismissOnEscape is false.
      expect(handle.phase.value, OverlayPhase.open);

      // Cleanup
      handle.close();
      handle.completeClose();
      controller.dispose();
    });

    testWidgets('barrier tap closes overlay', (tester) async {
      final controller = OverlayController();

      late OverlayHandle handle;
      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    handle = showOverlay(
                      controller,
                      focusPolicy: const ModalFocusPolicy(trap: false),
                      builder: (_) => Container(
                        width: 100,
                        height: 100,
                        color: Colors.blue,
                        child: const Text('Overlay'),
                      ),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(handle.phase.value, OverlayPhase.open);
      // Tap outside the overlay content (on barrier)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(handle.phase.value, OverlayPhase.closing);

      // Cleanup
      handle.completeClose();
      controller.dispose();
    });

    testWidgets('barrier tap does not close overlay when policy disables it',
        (tester) async {
      final controller = OverlayController();

      late OverlayHandle handle;
      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    handle = showOverlay(
                      controller,
                      dismissPolicy: DismissPolicy.none,
                      builder: (_) => Container(
                        width: 100,
                        height: 100,
                        color: Colors.blue,
                        child: const Text('Overlay'),
                      ),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(handle.phase.value, OverlayPhase.open);

      // Tap outside the overlay content (on barrier)
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();

      // Must remain open because barrier dismiss is disabled.
      expect(handle.phase.value, OverlayPhase.open);

      // Cleanup
      handle.close();
      handle.completeClose();
      controller.dispose();
    });
  });

  group('OverlayController', () {
    test('show() always returns new handle', () {
      final controller = OverlayController();

      final handle1 = showOverlay(controller, builder: (_) => const SizedBox());
      final handle2 = showOverlay(controller, builder: (_) => const SizedBox());

      expect(handle1, isNot(same(handle2)));

      // Cleanup
      handle1.close();
      handle1.completeClose();
      handle2.close();
      handle2.completeClose();
      controller.dispose();
    });

    test('hasActiveOverlays reflects overlay state', () {
      final controller = OverlayController();

      expect(controller.hasActiveOverlays, isFalse);

      final handle = showOverlay(controller, builder: (_) => const SizedBox());
      expect(controller.hasActiveOverlays, isTrue);

      handle.close();
      handle.completeClose();

      expect(controller.hasActiveOverlays, isFalse);

      controller.dispose();
    });

    test('closeAll closes all overlays', () {
      final controller = OverlayController();

      final handle1 = showOverlay(controller, builder: (_) => const SizedBox());
      final handle2 = showOverlay(controller, builder: (_) => const SizedBox());

      controller.closeAll();

      expect(handle1.phase.value, OverlayPhase.closing);
      expect(handle2.phase.value, OverlayPhase.closing);

      // Cleanup
      handle1.completeClose();
      handle2.completeClose();
      controller.dispose();
    });

    test('closeTop closes only topmost overlay', () {
      final controller = OverlayController();

      final handle1 = showOverlay(controller, builder: (_) => const SizedBox());
      final handle2 = showOverlay(controller, builder: (_) => const SizedBox());

      controller.closeTop();

      expect(handle1.phase.value, isNot(OverlayPhase.closing));
      expect(handle2.phase.value, OverlayPhase.closing);

      // Cleanup
      handle1.close();
      handle1.completeClose();
      handle2.completeClose();
      controller.dispose();
    });
  });

  group('DismissPolicy', () {
    test('default policy enables all dismiss actions', () {
      const policy = DismissPolicy.modal;

      expect(policy.dismissOnOutsideTap, isTrue);
      expect(policy.dismissOnEscape, isTrue);
      expect(policy.barrierDismissible, isTrue);
    });

    test('none policy disables all dismiss actions', () {
      expect(DismissPolicy.none.dismissOnOutsideTap, isFalse);
      expect(DismissPolicy.none.dismissOnEscape, isFalse);
      expect(DismissPolicy.none.barrierDismissible, isFalse);
    });

    test('copyWith creates modified copy', () {
      const policy = DismissPolicy.modal;
      final modified = policy.copyWith(dismissOnEscape: false);

      expect(modified.dismissOnOutsideTap, isTrue);
      expect(modified.dismissOnEscape, isFalse);
      expect(modified.barrierDismissible, isTrue);
    });

    test('equality works correctly', () {
      const policy1 = DismissPolicy.modal;
      const policy2 = DismissPolicy.modal;
      final policy3 = DismissPolicy.byTriggers(<DismissTrigger>{
        DismissTrigger.outsideTap,
      });

      expect(policy1, equals(policy2));
      expect(policy1, isNot(equals(policy3)));
    });
  });

  group('FocusPolicy', () {
    testWidgets('ModalFocusPolicy initialFocus is applied', (tester) async {
      final controller = OverlayController();
      final outsideFocus = FocusNode(debugLabel: 'Outside');
      final inside1 = FocusNode(debugLabel: 'Inside1');

      late OverlayHandle handle;

      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: Column(
              children: [
                Focus(
                  focusNode: outsideFocus,
                  child: const Text('Outside'),
                ),
                ElevatedButton(
                  onPressed: () {
                    handle = showOverlay(
                      controller,
                      dismissPolicy: DismissPolicy.modal,
                      focusPolicy: ModalFocusPolicy(initialFocus: inside1),
                      restoreFocus: outsideFocus,
                      builder: (_) {
                        return Column(
                          children: [
                            Focus(
                              focusNode: inside1,
                              child: const Text('Inside1'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Open'),
                ),
              ],
            ),
          ),
        ),
      );

      outsideFocus.requestFocus();
      await tester.pump();
      expect(outsideFocus.hasFocus, isTrue);

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump();

      expect(handle.phase.value, OverlayPhase.open);
      expect(inside1.hasFocus, isTrue);

      handle.close();
      handle.completeClose();
      controller.dispose();
      outsideFocus.dispose();
      inside1.dispose();
    });

    testWidgets('ModalFocusPolicy trap keeps Tab traversal inside overlay',
        (tester) async {
      final controller = OverlayController();
      final outside = FocusNode(debugLabel: 'Outside');
      final insideA = FocusNode(debugLabel: 'InsideA');
      final insideB = FocusNode(debugLabel: 'InsideB');

      late OverlayHandle handle;

      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: Column(
              children: [
                Focus(
                  focusNode: outside,
                  child: const Text('Outside'),
                ),
                ElevatedButton(
                  onPressed: () {
                    handle = showOverlay(
                      controller,
                      dismissPolicy: DismissPolicy.modal,
                      focusPolicy: const ModalFocusPolicy(trap: true),
                      restoreFocus: outside,
                      builder: (_) {
                        return Column(
                          children: [
                            Focus(
                              focusNode: insideA,
                              child: const Text('InsideA'),
                            ),
                            Focus(
                              focusNode: insideB,
                              child: const Text('InsideB'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Open'),
                ),
              ],
            ),
          ),
        ),
      );

      outside.requestFocus();
      await tester.pump();
      expect(outside.hasFocus, isTrue);

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump();
      expect(handle.phase.value, OverlayPhase.open);

      // Put focus on first inside node.
      insideA.requestFocus();
      await tester.pump();
      expect(insideA.hasFocus, isTrue);

      // Tab cycles to insideB, not outside.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(insideB.hasFocus, isTrue);
      expect(outside.hasFocus, isFalse);

      // Tab cycles back to insideA.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(insideA.hasFocus, isTrue);

      handle.close();
      handle.completeClose();
      controller.dispose();
      outside.dispose();
      insideA.dispose();
      insideB.dispose();
    });

    testWidgets('DismissPolicy.nonModal closes overlay on focus loss',
        (tester) async {
      final controller = OverlayController();
      final outside = FocusNode(debugLabel: 'Outside');
      final inside = FocusNode(debugLabel: 'Inside');

      late OverlayHandle handle;

      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: Column(
              children: [
                Focus(
                  focusNode: outside,
                  child: const Text('Outside'),
                ),
                ElevatedButton(
                  onPressed: () {
                    handle = showOverlay(
                      controller,
                      dismissPolicy: DismissPolicy.nonModal,
                      focusPolicy: const NonModalFocusPolicy(),
                      restoreFocus: outside,
                      builder: (_) {
                        return Focus(
                          focusNode: inside,
                          child: const Text('Inside'),
                        );
                      },
                    );
                  },
                  child: const Text('Open'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump();
      expect(handle.phase.value, OverlayPhase.open);

      inside.requestFocus();
      await tester.pump();
      expect(inside.hasFocus, isTrue);

      // Move focus to outside -> should close due to focusLoss trigger.
      outside.requestFocus();
      await tester.pump();
      await tester.pump();
      expect(
          handle.phase.value, anyOf(OverlayPhase.closing, OverlayPhase.closed));

      // Cleanup (idempotent)
      handle.completeClose();
      controller.dispose();
      outside.dispose();
      inside.dispose();
    });

    testWidgets(
        'NonModal focus policy does not steal focus from trigger (keeps focus on restoreFocus)',
        (tester) async {
      final controller = OverlayController();
      final outside = FocusNode(debugLabel: 'Outside');
      final trigger = FocusNode(debugLabel: 'Trigger');
      late OverlayHandle handle;

      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: Column(
              children: [
                Focus(focusNode: outside, child: const Text('Outside')),
                Focus(
                  focusNode: trigger,
                  child: ElevatedButton(
                    onPressed: () {
                      handle = showOverlay(
                        controller,
                        dismissPolicy: DismissPolicy.modal,
                        focusPolicy: const NonModalFocusPolicy(),
                        restoreFocus: trigger,
                        builder: (_) => const Text('Inside'),
                      );
                    },
                    child: const Text('Open'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      trigger.requestFocus();
      await tester.pump();
      expect(trigger.hasFocus, isTrue);

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump();
      expect(handle.phase.value, OverlayPhase.open);

      // Focus должен остаться на trigger (не уехать в overlay scope).
      expect(trigger.hasFocus, isTrue);

      handle.close();
      handle.completeClose();
      controller.dispose();
      outside.dispose();
      trigger.dispose();
    });

    testWidgets(
        'calling completeClose synchronously during build does not crash (no re-entrant notify)',
        (tester) async {
      final controller = OverlayController();
      late OverlayHandle handle;

      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  handle = showOverlay(
                    controller,
                    dismissPolicy: DismissPolicy.modal,
                    focusPolicy: const ModalFocusPolicy(trap: true),
                    builder: (_) {
                      return ValueListenableBuilder<OverlayPhase>(
                        valueListenable: handle.phase,
                        builder: (context, phase, _) {
                          if (phase == OverlayPhase.closing) {
                            // Worst-case renderer: completes close immediately in build.
                            handle.completeClose();
                          }
                          return const Text('Inside');
                        },
                      );
                    },
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump();

      expect(handle.phase.value, OverlayPhase.open);

      // Close -> build sees closing -> completeClose synchronously.
      handle.close();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(handle.phase.value, OverlayPhase.closed);
      expect(tester.takeException(), isNull);

      controller.dispose();
    });

    testWidgets(
        'outside pointer drag should not dismiss overlay (avoid closing on scroll/drag)',
        (tester) async {
      final controller = OverlayController();
      late OverlayHandle handle;

      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  handle = showOverlay(
                    controller,
                    dismissPolicy: DismissPolicy.modal,
                    focusPolicy: const ModalFocusPolicy(trap: true),
                    builder: (_) => const SizedBox(
                      width: 200,
                      height: 120,
                      child: ColoredBox(color: Color(0xFF00FF00)),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump();
      expect(handle.phase.value, OverlayPhase.open);

      // Start a drag gesture outside the overlay. This should NOT dismiss.
      final gesture = await tester.startGesture(const Offset(10, 10));
      await tester.pump();
      await gesture.moveBy(const Offset(0, 40));
      await tester.pump();
      await gesture.up();
      await tester.pump();

      expect(handle.phase.value, OverlayPhase.open);

      handle.close();
      handle.completeClose();
      controller.dispose();
    });

    testWidgets(
        'opening overlay by tapping trigger does not immediately dismiss via outside tap listener',
        (tester) async {
      final controller = OverlayController();
      late OverlayHandle handle;

      await tester.pumpWidget(
        MaterialApp(
          home: AnchoredOverlayEngineHost(
            controller: controller,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  handle = showOverlay(
                    controller,
                    dismissPolicy: DismissPolicy.modal,
                    focusPolicy: const ModalFocusPolicy(trap: true),
                    builder: (_) => const SizedBox(
                      width: 200,
                      height: 120,
                      child: ColoredBox(color: Color(0xFF00FF00)),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump();

      expect(
          handle.phase.value, anyOf(OverlayPhase.opening, OverlayPhase.open));

      // One more pump to ensure we didn't close immediately on the same click.
      await tester.pump();
      expect(
          handle.phase.value, anyOf(OverlayPhase.opening, OverlayPhase.open));

      handle.close();
      handle.completeClose();
      controller.dispose();
    });
  });
}
