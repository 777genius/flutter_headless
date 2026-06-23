import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_adaptive/headless_adaptive.dart';

void main() {
  testWidgets('AdaptiveBuilder measures parent constraints', (tester) async {
    await tester.pumpWidget(
      _TestFrame(
        width: 390,
        child: AdaptiveBuilder(
          builder: (context, adaptive) {
            return Text(adaptive.decision.screenClass.name);
          },
        ),
      ),
    );

    expect(find.text('compact'), findsOneWidget);

    await tester.pumpWidget(
      _TestFrame(
        width: 1200,
        child: AdaptiveBuilder(
          builder: (context, adaptive) {
            return Text(adaptive.decision.screenClass.name);
          },
        ),
      ),
    );

    expect(find.text('wide'), findsOneWidget);
  });

  testWidgets('AdaptiveBuilder inherits policy from AdaptiveScope', (
    tester,
  ) async {
    const scopedPolicy = AdaptivePolicy(
      breakpoints: AdaptiveBreakpointSet([
        AdaptiveBreakpoint(
          screenClass: AdaptiveScreenClass.compact,
          minWidth: 0,
        ),
        AdaptiveBreakpoint(
          screenClass: AdaptiveScreenClass.medium,
          minWidth: 1000,
        ),
      ]),
    );

    await tester.pumpWidget(
      _TestFrame(
        width: 840,
        child: AdaptiveScope(
          policy: scopedPolicy,
          child: AdaptiveBuilder(
            builder: (context, adaptive) {
              return Text(adaptive.decision.screenClass.name);
            },
          ),
        ),
      ),
    );

    expect(find.text('compact'), findsOneWidget);
  });

  testWidgets('environment reader maps all Flutter display feature states', (
    tester,
  ) async {
    final mappedStates = <AdaptiveDisplayFeatureState>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(
            size: const Size(800, 600),
            displayFeatures: [
              for (final state in ui.DisplayFeatureState.values)
                ui.DisplayFeature(
                  bounds: ui.Rect.fromLTWH(
                    state.index.toDouble(),
                    0,
                    1,
                    600,
                  ),
                  type: ui.DisplayFeatureType.fold,
                  state: state,
                ),
            ],
          ),
          child: Builder(
            builder: (context) {
              mappedStates.addAll(
                FlutterAdaptiveEnvironmentReader.fromContext(
                  context,
                ).displayFeatures.map((feature) => feature.state),
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    expect(mappedStates, hasLength(ui.DisplayFeatureState.values.length));
    expect(mappedStates, everyElement(isA<AdaptiveDisplayFeatureState>()));
  });

  testWidgets('AdaptiveBuilder exposes state through AdaptiveScope', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestFrame(
        width: 1200,
        child: AdaptiveBuilder(
          builder: (context, adaptive) {
            final scoped = AdaptiveScope.stateOf(context);
            return Text(scoped.decision.screenClass.name);
          },
        ),
      ),
    );

    expect(find.text('wide'), findsOneWidget);
  });

  testWidgets('AdaptiveSlotLayout renders a single pane on compact widths', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestFrame(
        width: 390,
        child: AdaptiveSlotLayout(
          slots: AdaptiveSlots(
            primary: _slotText('primary'),
            detail: _slotText('detail'),
            supporting: _slotText('supporting'),
          ),
        ),
      ),
    );

    expect(find.text('primary:single:true'), findsOneWidget);
    expect(find.textContaining('detail'), findsNothing);
    expect(find.textContaining('supporting'), findsNothing);
  });

  testWidgets('AdaptiveSlotLayout honors policy fallback in single-pane mode', (
    tester,
  ) async {
    const policy = AdaptivePolicy(
      panes: AdaptivePanePolicy(singlePaneFallback: AdaptivePaneRole.detail),
    );

    await tester.pumpWidget(
      _TestFrame(
        width: 390,
        child: AdaptiveSlotLayout(
          policy: policy,
          slots: AdaptiveSlots(
            primary: _slotText('primary'),
            detail: _slotText('detail'),
          ),
        ),
      ),
    );

    expect(find.text('detail:single:true'), findsOneWidget);
    expect(find.textContaining('primary'), findsNothing);
  });

  testWidgets('AdaptiveSlotLayout inherits fallback policy from scope', (
    tester,
  ) async {
    const scopedPolicy = AdaptivePolicy(
      panes: AdaptivePanePolicy(singlePaneFallback: AdaptivePaneRole.detail),
    );

    await tester.pumpWidget(
      _TestFrame(
        width: 390,
        child: AdaptiveScope(
          policy: scopedPolicy,
          child: AdaptiveSlotLayout(
            slots: AdaptiveSlots(
              primary: _slotText('primary'),
              detail: _slotText('detail'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('detail:single:true'), findsOneWidget);
    expect(find.textContaining('primary'), findsNothing);
  });

  testWidgets('AdaptiveSlotLayout lets controller override scoped fallback', (
    tester,
  ) async {
    const scopedPolicy = AdaptivePolicy(
      panes: AdaptivePanePolicy(singlePaneFallback: AdaptivePaneRole.detail),
    );
    final controller = AdaptivePaneController();

    await tester.pumpWidget(
      _TestFrame(
        width: 390,
        child: AdaptiveScope(
          policy: scopedPolicy,
          child: AdaptiveSlotLayout(
            controller: controller,
            slots: AdaptiveSlots(
              primary: _slotText('primary'),
              detail: _slotText('detail'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('primary:single:true'), findsOneWidget);
    expect(find.textContaining('detail'), findsNothing);
  });

  testWidgets(
    'AdaptiveSlotLayout falls back to primary when policy fallback has no slot',
    (tester) async {
      const policy = AdaptivePolicy(
        panes: AdaptivePanePolicy(
          singlePaneFallback: AdaptivePaneRole.supporting,
        ),
      );

      await tester.pumpWidget(
        _TestFrame(
          width: 390,
          child: AdaptiveSlotLayout(
            policy: policy,
            slots: AdaptiveSlots(primary: _slotText('primary')),
          ),
        ),
      );

      expect(find.text('primary:single:true'), findsOneWidget);
    },
  );

  testWidgets('AdaptiveSlotLayout allows controlled detail pane on compact', (
    tester,
  ) async {
    final controller = AdaptivePaneController();

    await tester.pumpWidget(
      _TestFrame(
        width: 390,
        child: AdaptiveSlotLayout(
          controller: controller,
          slots: AdaptiveSlots(
            primary: _slotText('primary'),
            detail: _slotText('detail'),
          ),
        ),
      ),
    );

    controller.selectPane(AdaptivePaneRole.detail);
    await tester.pump();

    expect(find.text('detail:single:true'), findsOneWidget);
    expect(find.textContaining('primary'), findsNothing);
  });

  testWidgets('AdaptiveSlotLayout renders list/detail/supporting on wide', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestFrame(
        width: 1200,
        child: AdaptiveSlotLayout(
          slots: AdaptiveSlots(
            primary: _slotText('primary'),
            detail: _slotText('detail'),
            supporting: _slotText('supporting'),
          ),
        ),
      ),
    );

    expect(find.text('primary:inline:true'), findsOneWidget);
    expect(find.text('detail:inline:false'), findsOneWidget);
    expect(find.text('supporting:inline:false'), findsOneWidget);
  });

  testWidgets('AdaptiveSlots reports missing builders explicitly', (
    tester,
  ) async {
    final slots = AdaptiveSlots(primary: _slotText('primary'));

    expect(slots.maybeBuilderFor(AdaptivePaneRole.detail), isNull);
    expect(() => slots.builderFor(AdaptivePaneRole.detail), throwsStateError);
  });

  testWidgets(
    'AdaptiveNavigationShell exposes route-neutral navigation state',
    (tester) async {
      await tester.pumpWidget(
        _TestFrame(
          width: 390,
          child: AdaptiveNavigationShell(
            body: const Text('body'),
            builder: (context, state, body) {
              return Column(children: [Text(state.pattern.name), body]);
            },
          ),
        ),
      );

      expect(find.text('drawer'), findsOneWidget);
      expect(find.text('body'), findsOneWidget);
    },
  );

  testWidgets('AdaptiveMaxWidth constrains wide content from decision', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestFrame(
        width: 2000,
        child: AdaptiveMaxWidth(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Text(constraints.maxWidth.toStringAsFixed(0));
            },
          ),
        ),
      ),
    );

    expect(find.text('1600'), findsOneWidget);
  });

  testWidgets('AdaptiveMaxWidth accepts adaptive value overrides', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestFrame(
        width: 1200,
        child: AdaptiveMaxWidth(
          maxWidth: const AdaptiveValue<double>(compact: 320, wide: 900),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Text(constraints.maxWidth.toStringAsFixed(0));
            },
          ),
        ),
      ),
    );

    expect(find.text('900'), findsOneWidget);
  });
}

AdaptiveSlotBuilder _slotText(String label) {
  return (context, state) {
    return Text('$label:${state.visibility.name}:${state.isSelected}');
  };
}

class _TestFrame extends StatelessWidget {
  const _TestFrame({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: OverflowBox(
        minWidth: width,
        maxWidth: width,
        minHeight: 800,
        maxHeight: 800,
        child: SizedBox(width: width, height: 800, child: child),
      ),
    );
  }
}
