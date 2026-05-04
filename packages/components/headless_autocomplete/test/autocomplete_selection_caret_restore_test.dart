import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_autocomplete/headless_autocomplete.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

final _adapter = HeadlessItemAdapter<String>.simple(
  id: (value) => ListboxItemId(value),
  titleText: (value) => value,
);

void main() {
  testWidgets('single-select restores focus and collapses caret at the end', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();

    await tester.pumpWidget(
      _testApp(
        RAutocomplete<String>(
          controller: controller,
          focusNode: focusNode,
          source: RAutocompleteLocalSource(
            options: (_) => const ['Alpha', 'Beta'],
          ),
          itemAdapter: _adapter,
          onSelected: (_) {},
          openOnTap: true,
          closeOnSelected: true,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('autocomplete-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('menu-item-1')));
    await tester.pumpAndSettle();
    await tester.pump();

    expect(controller.text, 'Beta');
    expect(controller.selection.isCollapsed, isTrue);
    expect(controller.selection.baseOffset, controller.text.length);
    expect(focusNode.hasFocus, isTrue);

    controller.dispose();
    focusNode.dispose();
  });
}

Widget _testApp(Widget child) {
  return MaterialApp(
    home: HeadlessThemeProvider(
      theme: const _TestTheme(),
      child: AnchoredOverlayEngineHost(
        controller: OverlayController(),
        child: Scaffold(body: Center(child: child)),
      ),
    ),
  );
}

final class _FieldRenderer implements RTextFieldRenderer {
  const _FieldRenderer();

  @override
  Widget render(RTextFieldRenderRequest request) {
    return GestureDetector(
      key: const Key('autocomplete-field'),
      behavior: HitTestBehavior.opaque,
      onTap: request.commands?.tapContainer,
      child: request.input,
    );
  }
}

final class _MenuRenderer implements RDropdownButtonRenderer {
  const _MenuRenderer();

  @override
  Widget render(RDropdownRenderRequest request) {
    if (request.state.overlayPhase == ROverlayPhase.closing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        request.commands.completeClose();
      });
    }

    return switch (request) {
      RDropdownTriggerRenderRequest() => const SizedBox.shrink(),
      RDropdownMenuRenderRequest() => Material(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              for (var i = 0; i < request.items.length; i++)
                GestureDetector(
                  key: Key('menu-item-$i'),
                  onTap: () => request.commands.selectIndex(i),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(request.items[i].primaryText),
                  ),
                ),
            ],
          ),
        ),
    };
  }
}

final class _TestTheme extends HeadlessTheme {
  const _TestTheme();

  @override
  T? capability<T>() {
    if (T == RTextFieldRenderer) return const _FieldRenderer() as T;
    if (T == RDropdownButtonRenderer) return const _MenuRenderer() as T;
    return null;
  }
}
