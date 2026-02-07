import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';

void dropdownRendererMenuMotionConformance({
  required String presetName,
  required RDropdownButtonRenderer Function() rendererGetter,
  required Widget Function(Widget child) wrapApp,
  required RDropdownResolvedTokens Function(Duration exitDuration)
      createTokensForExitDuration,
  required RDropdownCommands Function({
    VoidCallback? onCompleteClose,
  }) createCommands,
}) {
  group('$presetName dropdown menu motion conformance', () {
    testWidgets('exitDuration controls onCompleteClose timing', (tester) async {
      final exitDuration = const Duration(milliseconds: 333);
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
                  resolvedTokens: createTokensForExitDuration(exitDuration),
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

      await tester.pump(exitDuration - const Duration(milliseconds: 1));
      expect(completeCloseCalls, 0);

      await tester.pump(const Duration(milliseconds: 2));
      expect(completeCloseCalls, 1);
    });
  });
}
