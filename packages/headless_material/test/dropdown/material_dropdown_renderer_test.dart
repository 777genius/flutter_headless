import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_test/headless_test.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

void main() {
  group('MaterialDropdownRenderer', () {
    late MaterialDropdownRenderer renderer;

    setUp(() {
      renderer = const MaterialDropdownRenderer();
    });

    RDropdownResolvedTokens createDefaultTokens() {
      return RDropdownResolvedTokens(
        trigger: RDropdownTriggerTokens(
          textStyle: TextStyle(fontSize: 14),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          borderColor: Colors.grey,
          padding: EdgeInsets.all(12),
          minSize: Size(48, 48),
          borderRadius: BorderRadius.all(Radius.circular(4)),
          iconColor: Colors.black,
          pressOverlayColor: Colors.black.withValues(alpha: 0.12),
          pressOpacity: 1.0,
        ),
        menu: RDropdownMenuTokens(
          backgroundColor: Colors.white,
          backgroundOpacity: 1.0,
          borderColor: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          elevation: 3,
          maxHeight: 300,
          padding: EdgeInsets.symmetric(vertical: 8),
          backdropBlurSigma: 0,
          shadowColor: Colors.transparent,
          shadowBlurRadius: 0,
          shadowOffset: Offset.zero,
          motion: HeadlessMotionTheme.material.dropdownMenu,
        ),
        item: RDropdownItemTokens(
          textStyle: TextStyle(fontSize: 14),
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          highlightBackgroundColor: Color(0xFFEEEEEE),
          selectedBackgroundColor: Color(0xFFE3F2FD),
          disabledForegroundColor: Colors.grey,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          minHeight: 48,
          selectedMarkerColor: Colors.blue,
        ),
      );
    }

    RDropdownCommands createCommands({
      VoidCallback? onOpen,
      VoidCallback? onClose,
      void Function(int)? onSelectIndex,
      void Function(int)? onHighlight,
      VoidCallback? onCompleteClose,
    }) {
      return RDropdownCommands(
        open: onOpen ?? () {},
        close: onClose ?? () {},
        selectIndex: onSelectIndex ?? (_) {},
        highlight: onHighlight ?? (_) {},
        completeClose: onCompleteClose ?? () {},
      );
    }

    group('trigger rendering', () {
      testWidgets('renders trigger with placeholder', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
                  RDropdownTriggerRenderRequest(
                    context: context,
                    spec: const RDropdownButtonSpec(placeholder: 'Select option'),
                    state: const RDropdownButtonState(
                      overlayPhase: ROverlayPhase.closed,
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
                  ),
                );
              },
            ),
          ),
        );

        expect(find.text('Select option'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      });

      testWidgets('renders trigger with selected value', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
                  RDropdownTriggerRenderRequest(
                    context: context,
                    spec: const RDropdownButtonSpec(placeholder: 'Select option'),
                    state: const RDropdownButtonState(
                      overlayPhase: ROverlayPhase.closed,
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
                  ),
                );
              },
            ),
          ),
        );

        expect(find.text('Option A'), findsOneWidget);
      });

      testWidgets('rotates arrow icon when open', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
                  RDropdownTriggerRenderRequest(
                    context: context,
                    spec: const RDropdownButtonSpec(placeholder: 'Select'),
                    state: const RDropdownButtonState(
                      overlayPhase: ROverlayPhase.open,
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
                  ),
                );
              },
            ),
          ),
        );

        // Arrow should be present
        expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
        // AnimatedRotation should be wrapping it
        expect(find.byType(AnimatedRotation), findsOneWidget);
      });

      testWidgets('chevron slot can replace default icon', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
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
                        (_) => const Icon(
                          Icons.close,
                          key: Key('chevron_slot'),
                        ),
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
    });

    group('menu rendering', () {
      testWidgets('renders menu with items', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
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
                      HeadlessListItemModel(
                        id: ListboxItemId('c'),
                        primaryText: 'Option C',
                        typeaheadLabel: 'option c',
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

        await tester.pumpAndSettle();

        expect(find.text('Option A'), findsOneWidget);
        expect(find.text('Option B'), findsOneWidget);
        expect(find.text('Option C'), findsOneWidget);
      });

      testWidgets('shows checkmark for selected item', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
                  RDropdownMenuRenderRequest(
                    context: context,
                    spec: const RDropdownButtonSpec(),
                    state: const RDropdownButtonState(
                      overlayPhase: ROverlayPhase.open,
                      selectedIndex: 1,
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
                  ),
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should show checkmark for selected item
        expect(find.byIcon(Icons.check), findsOneWidget);
      });

      testWidgets('calls onSelectIndex when item is tapped', (tester) async {
        int? selectedIndex;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
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
                    commands: createCommands(
                      onSelectIndex: (index) {
                        selectedIndex = index;
                      },
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

        expect(selectedIndex, 1);
      });

      testWidgets('itemContent slot wraps default content', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
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
          MaterialApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
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
    });

    dropdownRendererCloseContractConformance(
      presetName: 'Material',
      rendererGetter: () => renderer,
      wrapApp: (child) => MaterialApp(home: child),
      createDefaultTokens: createDefaultTokens,
      createCommands: ({onCompleteClose}) => createCommands(
        onCompleteClose: onCompleteClose,
      ),
    );

    dropdownRendererSlotConformance(
      presetName: 'Material',
      rendererGetter: () => renderer,
      wrapApp: (child) => MaterialApp(home: child),
      createDefaultTokens: createDefaultTokens,
      createCommands: ({onCompleteClose}) => createCommands(
        onCompleteClose: onCompleteClose,
      ),
      selectedMarkerFinder: find.byIcon(Icons.check),
    );

    dropdownItemInvariantsConformance(
      presetName: 'Material',
      rendererGetter: () => renderer,
      wrapApp: (child) => MaterialApp(home: child),
      createDefaultTokens: createDefaultTokens,
      createCommands: ({onSelectIndex}) => createCommands(
        onSelectIndex: onSelectIndex,
      ),
    );

    dropdownRendererMenuMotionConformance(
      presetName: 'Material',
      rendererGetter: () => renderer,
      wrapApp: (child) => MaterialApp(home: child),
      createCommands: ({onCompleteClose}) => createCommands(
        onCompleteClose: onCompleteClose,
      ),
      createTokensForExitDuration: (exitDuration) {
        final base = createDefaultTokens();
        return RDropdownResolvedTokens(
          trigger: base.trigger,
          menu: RDropdownMenuTokens(
            backgroundColor: base.menu.backgroundColor,
            backgroundOpacity: base.menu.backgroundOpacity,
            borderColor: base.menu.borderColor,
            borderRadius: base.menu.borderRadius,
            elevation: base.menu.elevation,
            maxHeight: base.menu.maxHeight,
            padding: base.menu.padding,
            backdropBlurSigma: base.menu.backdropBlurSigma,
            shadowColor: base.menu.shadowColor,
            shadowBlurRadius: base.menu.shadowBlurRadius,
            shadowOffset: base.menu.shadowOffset,
            motion: RDropdownMenuMotionTokens(
              enterDuration: const Duration(milliseconds: 150),
              exitDuration: exitDuration,
              enterCurve: Curves.easeOut,
              exitCurve: Curves.easeOut,
              scaleBegin: 0.95,
            ),
          ),
          item: base.item,
        );
      },
    );

    dropdownRendererMustNotRequireThemeProviderConformance(
      presetName: 'Material',
      rendererGetter: () => renderer,
      wrapApp: (child) => MaterialApp(home: child),
    );
  });
}
