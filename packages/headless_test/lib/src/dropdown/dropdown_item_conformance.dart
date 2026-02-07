import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';

import '../semantics/semantics_utils.dart';

void dropdownItemInvariantsConformance({
  required String presetName,
  required RDropdownButtonRenderer Function() rendererGetter,
  required Widget Function(Widget child) wrapApp,
  required RDropdownResolvedTokens Function() createDefaultTokens,
  required RDropdownCommands Function({
    void Function(int)? onSelectIndex,
  }) createCommands,
}) {
  group('$presetName dropdown item invariants', () {
    testWidgets('disabled item does not call onSelectIndex', (tester) async {
      int? selectedIndex;

      await tester.pumpWidget(
        wrapApp(
          Builder(
            builder: (context) {
              return rendererGetter().render(
                RDropdownMenuRenderRequest(
                  context: context,
                  spec: const RDropdownButtonSpec(),
                  state: const RDropdownButtonState(
                    overlayPhase: ROverlayPhase.open,
                  ),
                  items: [
                    HeadlessListItemModel(
                      id: ListboxItemId('a'),
                      primaryText: 'Option A',
                      typeaheadLabel: 'option a',
                    ),
                    HeadlessListItemModel(
                      id: ListboxItemId('b'),
                      primaryText: 'Option B',
                      typeaheadLabel: 'option b',
                      isDisabled: true,
                    ),
                  ],
                  commands: createCommands(
                    onSelectIndex: (index) => selectedIndex = index,
                  ),
                  resolvedTokens: createDefaultTokens(),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Option B'));
      await tester.pump();

      expect(selectedIndex, isNull);
    });

    testWidgets('selected/enabled semantics are exposed on items',
        (tester) async {
      await tester.pumpWidget(
        wrapApp(
          Builder(
            builder: (context) {
              return rendererGetter().render(
                RDropdownMenuRenderRequest(
                  context: context,
                  spec: const RDropdownButtonSpec(),
                  state: const RDropdownButtonState(
                    overlayPhase: ROverlayPhase.open,
                    selectedIndex: 0,
                  ),
                  items: [
                    HeadlessListItemModel(
                      id: ListboxItemId('a'),
                      primaryText: 'Option A',
                      typeaheadLabel: 'option a',
                    ),
                    HeadlessListItemModel(
                      id: ListboxItemId('b'),
                      primaryText: 'Option B',
                      typeaheadLabel: 'option b',
                      isDisabled: true,
                    ),
                  ],
                  commands: createCommands(),
                  resolvedTokens: createDefaultTokens(),
                ),
              );
            },
          ),
        ),
      );

      final semanticsHandle = tester.ensureSemantics();
      try {
        await tester.pumpAndSettle();

        final selectedFinder = find.ancestor(
          of: find.text('Option A'),
          matching: find.byType(Semantics),
        );
        final disabledFinder = find.ancestor(
          of: find.text('Option B'),
          matching: find.byType(Semantics),
        );

        final selectedNode = tester.getSemantics(selectedFinder.first);
        expect(
          SemanticsUtils.hasFlag(selectedNode, SemanticsFlag.isSelected),
          isTrue,
          reason: 'Expected selected item to expose SemanticsFlag.isSelected',
        );
        expect(
          SemanticsUtils.hasFlag(selectedNode, SemanticsFlag.isEnabled),
          isTrue,
          reason: 'Expected enabled item to expose SemanticsFlag.isEnabled',
        );

        final disabledNode = tester.getSemantics(disabledFinder.first);
        expect(
          SemanticsUtils.hasFlag(disabledNode, SemanticsFlag.isEnabled),
          isFalse,
          reason:
              'Expected disabled item to not expose SemanticsFlag.isEnabled',
        );
      } finally {
        semanticsHandle.dispose();
      }
    });
  });
}
