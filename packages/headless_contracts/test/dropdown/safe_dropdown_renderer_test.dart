import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';

HeadlessListItemModel _item(String value) {
  return HeadlessListItemModel(
    id: ListboxItemId(value),
    primaryText: value,
    typeaheadLabel: HeadlessTypeaheadLabel.normalize(value),
  );
}

void main() {
  testWidgets('SafeDropdownRenderer completes close after exit animation',
      (tester) async {
    var closeCount = 0;
    final phase = ValueNotifier<ROverlayPhase>(ROverlayPhase.open);
    final items = [_item('Paris')];
    final renderer = SafeDropdownRenderer(
      buildTrigger: (context) => context.child,
      buildMenuSurface: (context) => context.child,
      buildItem: (context) => context.child,
    );

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ValueListenableBuilder<ROverlayPhase>(
            valueListenable: phase,
            builder: (context, value, _) {
              return renderer.render(
                RDropdownMenuRenderRequest(
                  context: context,
                  spec: const RDropdownButtonSpec(),
                  state: RDropdownButtonState(overlayPhase: value),
                  items: items,
                  commands: RDropdownCommands(
                    open: () {},
                    close: () {},
                    selectIndex: (_) {},
                    highlight: (_) {},
                    completeClose: () => closeCount++,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 200));
    phase.value = ROverlayPhase.closing;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(closeCount, 1);
  });

  testWidgets('SafeDropdownRenderer triggers selectIndex exactly once on tap',
      (tester) async {
    var selectCount = 0;
    final items = [_item('Paris')];
    final renderer = SafeDropdownRenderer(
      buildTrigger: (context) => context.child,
      buildMenuSurface: (context) => context.child,
      buildItem: (context) => context.child,
    );

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              return renderer.render(
                RDropdownMenuRenderRequest(
                  context: context,
                  spec: const RDropdownButtonSpec(),
                  state: const RDropdownButtonState(overlayPhase: ROverlayPhase.open),
                  items: items,
                  commands: RDropdownCommands(
                    open: () {},
                    close: () {},
                    selectIndex: (_) => selectCount++,
                    highlight: (_) {},
                    completeClose: () {},
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Paris'));
    await tester.pump();

    expect(selectCount, 1);
  });

  testWidgets('SafeDropdownRenderer does not select disabled items', (tester) async {
    var selectCount = 0;
    final items = [
      HeadlessListItemModel(
        id: const ListboxItemId('Paris'),
        primaryText: 'Paris',
        typeaheadLabel: HeadlessTypeaheadLabel.normalize('Paris'),
        isDisabled: true,
      ),
    ];
    final renderer = SafeDropdownRenderer(
      buildTrigger: (context) => context.child,
      buildMenuSurface: (context) => context.child,
      buildItem: (context) => context.child,
    );

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              return renderer.render(
                RDropdownMenuRenderRequest(
                  context: context,
                  spec: const RDropdownButtonSpec(),
                  state: const RDropdownButtonState(overlayPhase: ROverlayPhase.open),
                  items: items,
                  commands: RDropdownCommands(
                    open: () {},
                    close: () {},
                    selectIndex: (_) => selectCount++,
                    highlight: (_) {},
                    completeClose: () {},
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Paris'));
    await tester.pump();

    expect(selectCount, 0);
  });
}
