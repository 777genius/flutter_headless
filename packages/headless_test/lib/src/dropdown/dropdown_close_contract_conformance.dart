import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';

void dropdownRendererCloseContractConformance({
  required String presetName,
  required RDropdownButtonRenderer Function() rendererGetter,
  required Widget Function(Widget child) wrapApp,
  required RDropdownResolvedTokens Function() createDefaultTokens,
  required RDropdownCommands Function({
    VoidCallback? onCompleteClose,
  }) createCommands,
}) {
  group('$presetName dropdown close contract conformance', () {
    testWidgets('calls onCompleteClose after closing animation', (tester) async {
      final phase = ValueNotifier<ROverlayPhase>(ROverlayPhase.open);
      var completeCloseCalls = 0;

      await tester.pumpWidget(
        wrapApp(
          ValueListenableBuilder(
            valueListenable: phase,
            builder: (context, value, _) {
              return rendererGetter().render(
                RDropdownMenuRenderRequest(
                  context: context,
                  spec: const RDropdownButtonSpec(),
                  state: RDropdownButtonState(overlayPhase: value),
                  items: [
                    HeadlessListItemModel(
                      id: ListboxItemId('a'),
                      primaryText: 'Option A',
                      typeaheadLabel: 'option a',
                    ),
                  ],
                  commands: createCommands(
                    onCompleteClose: () => completeCloseCalls++,
                  ),
                  resolvedTokens: createDefaultTokens(),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(completeCloseCalls, 0);

      phase.value = ROverlayPhase.closing;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(completeCloseCalls, 1);
    });

    testWidgets('does not call onCompleteClose when close is cancelled by reopen',
        (tester) async {
      final phase = ValueNotifier<ROverlayPhase>(ROverlayPhase.open);
      var completeCloseCalls = 0;

      await tester.pumpWidget(
        wrapApp(
          ValueListenableBuilder(
            valueListenable: phase,
            builder: (context, value, _) {
              return rendererGetter().render(
                RDropdownMenuRenderRequest(
                  context: context,
                  spec: const RDropdownButtonSpec(),
                  state: RDropdownButtonState(overlayPhase: value),
                  items: [
                    HeadlessListItemModel(
                      id: ListboxItemId('a'),
                      primaryText: 'Option A',
                      typeaheadLabel: 'option a',
                    ),
                  ],
                  commands: createCommands(
                    onCompleteClose: () => completeCloseCalls++,
                  ),
                  resolvedTokens: createDefaultTokens(),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(completeCloseCalls, 0);

      phase.value = ROverlayPhase.closing;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));

      phase.value = ROverlayPhase.open;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(completeCloseCalls, 0);
    });

    testWidgets('calls onCompleteClose if disposed while closing', (tester) async {
      final phase = ValueNotifier<ROverlayPhase>(ROverlayPhase.open);
      var completeCloseCalls = 0;

      await tester.pumpWidget(
        wrapApp(
          ValueListenableBuilder(
            valueListenable: phase,
            builder: (context, value, _) {
              return rendererGetter().render(
                RDropdownMenuRenderRequest(
                  context: context,
                  spec: const RDropdownButtonSpec(),
                  state: RDropdownButtonState(overlayPhase: value),
                  items: [
                    HeadlessListItemModel(
                      id: ListboxItemId('a'),
                      primaryText: 'Option A',
                      typeaheadLabel: 'option a',
                    ),
                  ],
                  commands: createCommands(
                    onCompleteClose: () => completeCloseCalls++,
                  ),
                  resolvedTokens: createDefaultTokens(),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(completeCloseCalls, 0);

      phase.value = ROverlayPhase.closing;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();

      expect(completeCloseCalls, 1);
    });
  });
}

