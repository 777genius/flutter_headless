import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';

void dropdownRendererSlotConformance({
  required String presetName,
  required RDropdownButtonRenderer Function() rendererGetter,
  required Widget Function(Widget child) wrapApp,
  required RDropdownResolvedTokens Function() createDefaultTokens,
  required RDropdownCommands Function({
    VoidCallback? onCompleteClose,
  }) createCommands,
  required Finder selectedMarkerFinder,
}) {
  group('$presetName dropdown slot conformance', () {
    testWidgets('menu slot is applied and can use itemBuilder', (tester) async {
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
                    ),
                  ],
                  commands: createCommands(),
                  resolvedTokens: createDefaultTokens(),
                  slots: RDropdownButtonSlots(
                    menu: Replace(
                      (ctx) => Column(
                        key: const Key('menu_slot'),
                        children: List.generate(
                          ctx.items.length,
                          (i) => ctx.itemBuilder(i),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byKey(const Key('menu_slot')), findsOneWidget);
      expect(find.text('Option A'), findsOneWidget);
      expect(selectedMarkerFinder, findsOneWidget);
    });

    testWidgets('chevron slot replaces default icon in trigger', (tester) async {
      await tester.pumpWidget(
        wrapApp(
          Builder(
            builder: (context) {
              return rendererGetter().render(
                RDropdownTriggerRenderRequest(
                  context: context,
                  spec: const RDropdownButtonSpec(placeholder: 'Select'),
                  state: const RDropdownButtonState(
                    overlayPhase: ROverlayPhase.closed,
                  ),
                  items: [
                    HeadlessListItemModel(
                      id: ListboxItemId('a'),
                      primaryText: 'Option A',
                      typeaheadLabel: 'option a',
                    ),
                  ],
                  commands: createCommands(),
                  resolvedTokens: createDefaultTokens(),
                  slots: RDropdownButtonSlots(
                    chevron: Replace(
                      (_) => const SizedBox(key: Key('chevron_slot')),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byKey(const Key('chevron_slot')), findsOneWidget);
    });

    testWidgets('itemContent slot wraps default item content', (tester) async {
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
                    ),
                  ],
                  commands: createCommands(),
                  resolvedTokens: createDefaultTokens(),
                  slots: RDropdownButtonSlots(
                    itemContent: Decorate(
                      (ctx, child) => Container(
                        key: const Key('item_content_slot'),
                        child: child,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byKey(const Key('item_content_slot')), findsWidgets);
    });

    testWidgets('emptyState slot renders when items are empty', (tester) async {
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
                  items: const [],
                  commands: createCommands(),
                  resolvedTokens: createDefaultTokens(),
                  slots: RDropdownButtonSlots(
                    emptyState: Replace(
                      (_) => const SizedBox(key: Key('empty_state_slot')),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byKey(const Key('empty_state_slot')), findsOneWidget);
    });

    testWidgets('menuSurface slot does not bypass close contract', (tester) async {
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
                  state: RDropdownButtonState(
                    overlayPhase: value,
                  ),
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
                  slots: RDropdownButtonSlots(
                    menuSurface: Decorate(
                      (ctx, child) => Container(
                        key: const Key('surface_slot'),
                        child: child,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byKey(const Key('surface_slot')), findsOneWidget);
      expect(completeCloseCalls, 0);

      phase.value = ROverlayPhase.closing;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(completeCloseCalls, 1);
    });
  });
}
