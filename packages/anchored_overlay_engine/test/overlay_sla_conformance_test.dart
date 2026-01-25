import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anchored_overlay_engine/anchored_overlay_engine.dart';

void main() {
  group('Overlay SLA conformance (v1.1)', () {
    testWidgets('SLA-T1: scroll triggers flip recomputation', (tester) async {
      final view = tester.view;
      view.physicalSize = const Size(400, 600);
      view.devicePixelRatio = 1.0;
      addTearDown(view.resetPhysicalSize);
      addTearDown(view.resetDevicePixelRatio);

      final controller = OverlayController();
      final anchorKey = GlobalKey();
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery.fromView(
            view: view,
            child: AnchoredOverlayEngineHost(
              controller: controller,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 1200),
                    Container(
                      key: anchorKey,
                      width: 200,
                      height: 40,
                      color: const Color(0xFF00FF00),
                    ),
                    const SizedBox(height: 1200),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Scroll to bring anchor near bottom of viewport.
      scrollController.jumpTo(1200 - 520);
      await tester.pumpAndSettle();

      Rect? lastAnchorRect;
      Rect anchorRectGetter() {
        final ctx = anchorKey.currentContext;
        if (ctx == null) return lastAnchorRect ?? Rect.zero;
        final rb = ctx.findRenderObject() as RenderBox?;
        if (rb == null || !rb.hasSize) return lastAnchorRect ?? Rect.zero;
        final topLeft = rb.localToGlobal(Offset.zero);
        lastAnchorRect = topLeft & rb.size;
        return lastAnchorRect!;
      }

      controller.show(
        OverlayRequest(
          overlayBuilder: (_) => Container(
            key: const Key('overlay-surface'),
            height: 1000,
            color: const Color(0xFFFF0000),
          ),
          anchor: OverlayAnchor(rect: anchorRectGetter),
        ),
      );
      await tester.pumpAndSettle();

      final anchorRect1 = tester.getRect(find.byKey(anchorKey));
      final overlayRect1 =
          tester.getRect(find.byKey(const Key('overlay-surface')));
      expect(
        overlayRect1.bottom,
        lessThanOrEqualTo(anchorRect1.top + 1),
        reason: 'Expected overlay to flip above when anchor is near bottom',
      );

      // Scroll so anchor goes near top -> should flip back below.
      scrollController.jumpTo(1200 - 40);
      await tester.pumpAndSettle();

      final anchorRect2 = tester.getRect(find.byKey(anchorKey));
      final overlayRect2 =
          tester.getRect(find.byKey(const Key('overlay-surface')));
      expect(
        overlayRect2.top,
        greaterThanOrEqualTo(anchorRect2.bottom - 1),
        reason: 'Expected overlay to flip below when anchor has space below',
      );
    });

    testWidgets('SLA-T2: metrics/keyboard triggers maxHeight recomputation',
        (tester) async {
      final view = tester.view;
      view.physicalSize = const Size(400, 600);
      view.devicePixelRatio = 1.0;
      addTearDown(view.resetPhysicalSize);
      addTearDown(view.resetDevicePixelRatio);
      addTearDown(view.resetViewInsets);

      final controller = OverlayController();
      final anchorKey = GlobalKey();

      Rect? lastAnchorRect;
      Rect anchorRectGetter() {
        final ctx = anchorKey.currentContext;
        if (ctx == null) return lastAnchorRect ?? Rect.zero;
        final rb = ctx.findRenderObject() as RenderBox?;
        if (rb == null || !rb.hasSize) return lastAnchorRect ?? Rect.zero;
        final topLeft = rb.localToGlobal(Offset.zero);
        lastAnchorRect = topLeft & rb.size;
        return lastAnchorRect!;
      }

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery.fromView(
            view: view,
            child: AnchoredOverlayEngineHost(
              controller: controller,
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  key: anchorKey,
                  width: 200,
                  height: 40,
                  color: const Color(0xFF00FF00),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      controller.show(
        OverlayRequest(
          overlayBuilder: (_) => Container(
            key: const Key('overlay-surface'),
            height: 1000,
            color: const Color(0xFFFF0000),
          ),
          anchor: OverlayAnchor(rect: anchorRectGetter),
        ),
      );
      await tester.pumpAndSettle();

      final overlayRect1 =
          tester.getRect(find.byKey(const Key('overlay-surface')));

      // Simulate keyboard: reduce available height.
      view.viewInsets = FakeViewPadding(bottom: 300);
      await tester.pump();

      final overlayRect2 =
          tester.getRect(find.byKey(const Key('overlay-surface')));
      expect(
        overlayRect2.height,
        lessThan(overlayRect1.height),
        reason: 'Expected overlay to be constrained when keyboard is visible',
      );
    });

    testWidgets(
        'SLA-T3: optional ticker updates overlay even without scroll/metrics',
        (tester) async {
      final view = tester.view;
      view.physicalSize = const Size(400, 600);
      view.devicePixelRatio = 1.0;
      addTearDown(view.resetPhysicalSize);
      addTearDown(view.resetDevicePixelRatio);

      final controller = OverlayController();
      final anchorKey = GlobalKey();

      // This widget animates the anchor downwards without any scroll notifications.
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery.fromView(
            view: view,
            child: AnchoredOverlayEngineHost(
              controller: controller,
              enableAutoRepositionTicker: true,
              child: _AnimatedAnchor(anchorKey: anchorKey),
            ),
          ),
        ),
      );
      await tester.pump();

      Rect? lastAnchorRect;
      Rect anchorRectGetter() {
        final ctx = anchorKey.currentContext;
        if (ctx == null) return lastAnchorRect ?? Rect.zero;
        final rb = ctx.findRenderObject() as RenderBox?;
        if (rb == null || !rb.hasSize) return lastAnchorRect ?? Rect.zero;
        final topLeft = rb.localToGlobal(Offset.zero);
        lastAnchorRect = topLeft & rb.size;
        return lastAnchorRect!;
      }

      controller.show(
        OverlayRequest(
          overlayBuilder: (_) => Container(
            key: const Key('overlay-surface'),
            height: 1000,
            color: const Color(0xFFFF0000),
          ),
          anchor: OverlayAnchor(rect: anchorRectGetter),
        ),
      );

      // Let the anchor animate down near bottom; ticker should force overlay recompute -> flip above.
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump();

      final anchorRect = tester.getRect(find.byKey(anchorKey));
      final overlayRect =
          tester.getRect(find.byKey(const Key('overlay-surface')));
      expect(
        overlayRect.bottom,
        lessThanOrEqualTo(anchorRect.top + 1),
        reason:
            'Expected overlay to flip above as anchor moves down, without scroll/metrics',
      );
    });
  });
}

class _AnimatedAnchor extends StatefulWidget {
  const _AnimatedAnchor({
    required this.anchorKey,
  });

  final GlobalKey anchorKey;

  @override
  State<_AnimatedAnchor> createState() => _AnimatedAnchorState();
}

class _AnimatedAnchorState extends State<_AnimatedAnchor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _top;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
    _top = Tween<double>(begin: 20, end: 520).animate(_c);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Stack(
          children: [
            Positioned(
              left: 20,
              top: _top.value,
              child: Container(
                key: widget.anchorKey,
                width: 200,
                height: 40,
                color: const Color(0xFF00FF00),
              ),
            ),
          ],
        );
      },
    );
  }
}
