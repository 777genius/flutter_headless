import 'package:anchored_overlay_engine/anchored_overlay_engine.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Conformance suite for `anchored_overlay_engine` primitives.
///
/// Goal: make the overlay lifecycle + policies verifiable and stable.
///
/// This suite is intentionally small and focused on MUST behaviors:
/// - lifecycle phases & fail-safe close (no "stuck closing")
/// - dismiss policies (outside tap / escape / focus loss)
/// - focus policies (initialFocus + restoreOnClose)
void overlayFoundationConformance({
  required String suiteName,
  required Widget Function(Widget child) wrapApp,
}) {
  Future<void> pumpOverlayOpen(WidgetTester tester) async {
    await tester.pump(); // show scheduled
    await tester.pump(); // show executed + markOpen scheduled
    await tester.pump(); // markOpen + portal show
  }

  group('$suiteName overlay conformance', () {
    testWidgets('show() → phase becomes open and entry is tracked', (
      tester,
    ) async {
      final controller = OverlayController(
        failSafeTimeout: const Duration(milliseconds: 50),
      );

      late final OverlayHandle handle;

      await tester.pumpWidget(
        wrapApp(
          AnchoredOverlayEngineHost(
            controller: controller,
            child: _OverlayShowOnce(
              controller: controller,
              onHandle: (h) => handle = h,
              builder: (_) => const SizedBox(key: Key('overlay_content')),
            ),
          ),
        ),
      );

      await pumpOverlayOpen(tester);

      expect(controller.hasActiveOverlays, isTrue);
      expect(handle.phase.value, OverlayPhase.open);
      expect(find.byKey(const Key('overlay_content')), findsOneWidget);
    });

    testWidgets('close() without completeClose triggers fail-safe close', (
      tester,
    ) async {
      var failSafeCalls = 0;
      final controller = OverlayController(
        failSafeTimeout: const Duration(milliseconds: 30),
        onFailSafeTimeout: (_) => failSafeCalls++,
      );

      late final OverlayHandle handle;

      await tester.pumpWidget(
        wrapApp(
          AnchoredOverlayEngineHost(
            controller: controller,
            child: _OverlayShowOnce(
              controller: controller,
              onHandle: (h) => handle = h,
              builder: (_) => const SizedBox(key: Key('overlay_content')),
            ),
          ),
        ),
      );
      await pumpOverlayOpen(tester);

      handle.close();
      await tester.pump();
      expect(handle.phase.value, OverlayPhase.closing);

      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();

      expect(failSafeCalls, 1);
      expect(controller.hasActiveOverlays, isFalse);
      expect(find.byKey(const Key('overlay_content')), findsNothing);
    });

    testWidgets('dismiss policy: outside tap closes only when enabled', (
      tester,
    ) async {
      final controller = OverlayController(
        failSafeTimeout: const Duration(milliseconds: 30),
      );

      OverlayHandle? handle;

      await tester.pumpWidget(
        wrapApp(
          AnchoredOverlayEngineHost(
            controller: controller,
            child: _OverlayShowOnce(
              controller: controller,
              onHandle: (h) => handle = h,
              builder: (_) => const SizedBox(key: Key('overlay_content')),
              dismissPolicy: DismissPolicy.none,
            ),
          ),
        ),
      );
      await pumpOverlayOpen(tester);

      await tester.tapAt(const Offset(1, 1));
      await tester.pump();
      expect(handle!.phase.value, OverlayPhase.open);

      // Close the current overlay before rebuilding the tree.
      //
      // Important: do NOT call completeClose() during build, иначе AnchoredOverlayEngineHost
      // получит notifyListeners -> setState() в build-фазе.
      handle!.completeClose();
      await tester.pump();

      // Replace overlay with outside-tap dismiss enabled.
      await tester.pumpWidget(
        wrapApp(
          AnchoredOverlayEngineHost(
            controller: controller,
            child: _OverlayShowOnce(
              controller: controller,
              onHandle: (h) => handle = h,
              builder: (_) => const SizedBox(key: Key('overlay_content')),
              dismissPolicy: DismissPolicy.modal,
            ),
          ),
        ),
      );
      await pumpOverlayOpen(tester);

      await tester.tapAt(const Offset(1, 1));
      await tester.pump();
      expect(
        handle!.phase.value,
        isIn([OverlayPhase.closing, OverlayPhase.closed]),
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();

      expect(controller.hasActiveOverlays, isFalse);
    });

    testWidgets('dismiss policy: Escape closes only when enabled', (
      tester,
    ) async {
      final controller = OverlayController(
        failSafeTimeout: const Duration(milliseconds: 30),
      );

      OverlayHandle? handle;

      await tester.pumpWidget(
        wrapApp(
          AnchoredOverlayEngineHost(
            controller: controller,
            child: _OverlayShowOnce(
              controller: controller,
              onHandle: (h) => handle = h,
              builder: (_) => const SizedBox(key: Key('overlay_content')),
              dismissPolicy: DismissPolicy.none,
            ),
          ),
        ),
      );
      await pumpOverlayOpen(tester);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(handle!.phase.value, OverlayPhase.open);

      // Re-show with escape enabled
      handle!.completeClose();
      await tester.pump();
      handle = controller.show(
        OverlayRequest(
          overlayBuilder: (_) => const SizedBox(key: Key('overlay_content')),
          dismiss: DismissPolicy.modal,
        ),
      );
      await pumpOverlayOpen(tester);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(
        handle!.phase.value,
        isIn([OverlayPhase.closing, OverlayPhase.closed]),
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();

      expect(controller.hasActiveOverlays, isFalse);
    });

    testWidgets('focus policy: initialFocus + restoreOnClose', (tester) async {
      final controller = OverlayController(
        failSafeTimeout: const Duration(milliseconds: 30),
      );

      final triggerFocus = FocusNode(debugLabel: 'trigger');
      final initialFocus = FocusNode(debugLabel: 'initialFocus');

      addTearDown(() {
        triggerFocus.dispose();
        initialFocus.dispose();
      });

      late final OverlayHandle handle;

      await tester.pumpWidget(
        wrapApp(
          AnchoredOverlayEngineHost(
            controller: controller,
            child: Focus(
              focusNode: triggerFocus,
              autofocus: true,
              child: _OverlayShowOnce(
                controller: controller,
                onHandle: (h) => handle = h,
                restoreFocus: triggerFocus,
                focusPolicy: ModalFocusPolicy(
                  trap: true,
                  restoreOnClose: true,
                  initialFocus: initialFocus,
                ),
                builder: (_) => Focus(
                  focusNode: initialFocus,
                  child: const SizedBox(key: Key('overlay_content')),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump(); // overlay inserted + markOpen scheduled
      await tester.pump(); // markOpen applied
      await tester.pump(); // apply initialFocus post-frame

      expect(initialFocus.hasFocus, isTrue);

      // Close "happy path": renderer would call completeClose; we simulate it.
      handle.close();
      await tester.pump();
      handle.completeClose();
      await tester.pump();

      expect(controller.hasActiveOverlays, isFalse);
      expect(triggerFocus.hasFocus, isTrue);
    });
  });
}

final class _OverlayShowOnce extends StatefulWidget {
  const _OverlayShowOnce({
    required this.controller,
    required this.onHandle,
    required this.builder,
    this.dismissPolicy = DismissPolicy.modal,
    this.focusPolicy = const NonModalFocusPolicy(),
    this.restoreFocus,
  });

  final OverlayController controller;
  final ValueChanged<OverlayHandle> onHandle;
  final WidgetBuilder builder;
  final DismissPolicy dismissPolicy;
  final FocusPolicy focusPolicy;
  final FocusNode? restoreFocus;

  @override
  State<_OverlayShowOnce> createState() => _OverlayShowOnceState();
}

class _OverlayShowOnceState extends State<_OverlayShowOnce> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final handle = widget.controller.show(
        OverlayRequest(
          overlayBuilder: widget.builder,
          dismiss: widget.dismissPolicy,
          focus: widget.focusPolicy,
          restoreFocus: widget.restoreFocus,
        ),
      );
      widget.onHandle(handle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
