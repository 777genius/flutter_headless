import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_cupertino/headless_cupertino.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_test/headless_test.dart';
import 'package:headless_contracts/headless_contracts.dart';

void main() {
  group('CupertinoDropdownRenderer', () {
    late CupertinoDropdownRenderer renderer;

    setUp(() {
      renderer = const CupertinoDropdownRenderer();
    });

    RDropdownResolvedTokens createDefaultTokens() {
      return const RDropdownResolvedTokens(
        trigger: RDropdownTriggerTokens(
          textStyle: TextStyle(fontSize: 17, fontFamily: '.SF Pro Text'),
          foregroundColor: CupertinoColors.black,
          backgroundColor: CupertinoColors.white,
          borderColor: CupertinoColors.systemGrey3,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          minSize: Size(44, 44),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          iconColor: CupertinoColors.black,
          pressOverlayColor: CupertinoColors.transparent,
          pressOpacity: 0.6,
        ),
        menu: RDropdownMenuTokens(
          backgroundColor: CupertinoColors.white,
          backgroundOpacity: 0.85,
          borderColor: CupertinoColors.systemGrey4,
          borderRadius: BorderRadius.all(Radius.circular(14)),
          elevation: 0,
          maxHeight: 300,
          padding: EdgeInsets.symmetric(vertical: 6),
          backdropBlurSigma: 20,
          shadowColor: Color(0x26000000),
          shadowBlurRadius: 20,
          shadowOffset: Offset(0, 10),
        ),
        item: RDropdownItemTokens(
          textStyle: TextStyle(fontSize: 17, fontFamily: '.SF Pro Text'),
          foregroundColor: CupertinoColors.black,
          backgroundColor: CupertinoColors.transparent,
          highlightBackgroundColor: CupertinoColors.systemGrey5,
          selectedBackgroundColor: Color(0x1A007AFF),
          disabledForegroundColor: CupertinoColors.inactiveGray,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          minHeight: 44,
          selectedMarkerColor: CupertinoColors.activeBlue,
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
          CupertinoApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
                  RDropdownTriggerRenderRequest(
                    context: context,
                    spec:
                        const RDropdownButtonSpec(placeholder: 'Select option'),
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
        // iOS uses chevron_down
        expect(find.byIcon(CupertinoIcons.chevron_down), findsOneWidget);
      });

      testWidgets('renders trigger with selected value', (tester) async {
        await tester.pumpWidget(
          CupertinoApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
                  RDropdownTriggerRenderRequest(
                    context: context,
                    spec:
                        const RDropdownButtonSpec(placeholder: 'Select option'),
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

      testWidgets('rotates chevron icon when open', (tester) async {
        await tester.pumpWidget(
          CupertinoApp(
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

        // Chevron should be present
        expect(find.byIcon(CupertinoIcons.chevron_down), findsOneWidget);
        // AnimatedRotation should be wrapping it
        expect(find.byType(AnimatedRotation), findsOneWidget);
      });

      testWidgets('chevron slot can replace default icon', (tester) async {
        await tester.pumpWidget(
          CupertinoApp(
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
                          CupertinoIcons.clear,
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

      testWidgets('shows thicker border when focused', (tester) async {
        await tester.pumpWidget(
          CupertinoApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
                  RDropdownTriggerRenderRequest(
                    context: context,
                    spec: const RDropdownButtonSpec(placeholder: 'Select'),
                    state: const RDropdownButtonState(
                      overlayPhase: ROverlayPhase.closed,
                      isTriggerFocused: true,
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

        expect(find.byType(AnimatedContainer), findsOneWidget);
      });
    });

    group('menu rendering', () {
      testWidgets('renders menu with items', (tester) async {
        await tester.pumpWidget(
          CupertinoApp(
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
          CupertinoApp(
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

        // Should show iOS checkmark for selected item
        expect(find.byIcon(CupertinoIcons.checkmark), findsOneWidget);
      });

      testWidgets('calls onSelectIndex when item is tapped', (tester) async {
        int? selectedIndex;

        await tester.pumpWidget(
          CupertinoApp(
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
          CupertinoApp(
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

      testWidgets('emptyState slot renders when items are empty',
          (tester) async {
        await tester.pumpWidget(
          CupertinoApp(
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

      testWidgets('applies blur effect to menu (iOS popover style)',
          (tester) async {
        await tester.pumpWidget(
          CupertinoApp(
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

        // Should have BackdropFilter for blur
        expect(find.byType(BackdropFilter), findsOneWidget);
      });
    });

    dropdownRendererCloseContractConformance(
      presetName: 'Cupertino',
      rendererGetter: () => renderer,
      wrapApp: (child) => CupertinoApp(home: child),
      createDefaultTokens: createDefaultTokens,
      createCommands: ({onCompleteClose}) => createCommands(
        onCompleteClose: onCompleteClose,
      ),
    );

    group('a11y semantics', () {
      testWidgets('trigger has button semantics', (tester) async {
        await tester.pumpWidget(
          CupertinoApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
                  RDropdownTriggerRenderRequest(
                    context: context,
                    spec: const RDropdownButtonSpec(
                      semanticLabel: 'Select color',
                    ),
                    state: const RDropdownButtonState(
                      overlayPhase: ROverlayPhase.closed,
                    ),
                    items: [
                      HeadlessListItemModel(
                        id: ListboxItemId('red'),
                        primaryText: 'Red',
                        typeaheadLabel: 'red',
                      ),
                      HeadlessListItemModel(
                        id: ListboxItemId('blue'),
                        primaryText: 'Blue',
                        typeaheadLabel: 'blue',
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

        expect(find.byType(Semantics), findsWidgets);
      });

      testWidgets('items have correct selected semantics', (tester) async {
        await tester.pumpWidget(
          CupertinoApp(
            home: Builder(
              builder: (context) {
                return renderer.render(
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
                  ),
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(Semantics), findsWidgets);
      });
    });

    dropdownRendererSlotConformance(
      presetName: 'Cupertino',
      rendererGetter: () => renderer,
      wrapApp: (child) => CupertinoApp(home: child),
      createDefaultTokens: createDefaultTokens,
      createCommands: ({onCompleteClose}) => createCommands(
        onCompleteClose: onCompleteClose,
      ),
      selectedMarkerFinder: find.byIcon(CupertinoIcons.checkmark),
    );

    dropdownItemInvariantsConformance(
      presetName: 'Cupertino',
      rendererGetter: () => renderer,
      wrapApp: (child) => CupertinoApp(home: child),
      createDefaultTokens: createDefaultTokens,
      createCommands: ({onSelectIndex}) => createCommands(
        onSelectIndex: onSelectIndex,
      ),
    );

    dropdownRendererMenuMotionConformance(
      presetName: 'Cupertino',
      rendererGetter: () => renderer,
      wrapApp: (child) => CupertinoApp(home: child),
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
              enterDuration: const Duration(milliseconds: 200),
              exitDuration: exitDuration,
              enterCurve: Curves.easeOut,
              exitCurve: Curves.easeOutCubic,
              scaleBegin: 0.9,
            ),
          ),
          item: base.item,
        );
      },
    );

    dropdownRendererMustNotRequireThemeProviderConformance(
      presetName: 'Cupertino',
      rendererGetter: () => renderer,
      wrapApp: (child) => CupertinoApp(home: child),
    );
  });
}
