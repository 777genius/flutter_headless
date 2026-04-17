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

final class _FieldRenderer implements RTextFieldRenderer {
  @override
  Widget render(RTextFieldRenderRequest request) {
    final label = request.semantics?.label ?? 'field';
    return GestureDetector(
      key: Key('field-$label'),
      behavior: HitTestBehavior.opaque,
      onTap: request.commands?.tapContainer,
      child: request.input,
    );
  }
}

final class _MenuRenderer implements RDropdownButtonRenderer {
  @override
  Widget render(RDropdownRenderRequest request) {
    if (request is RDropdownTriggerRenderRequest) {
      return const SizedBox.shrink();
    }
    if (request.state.overlayPhase == ROverlayPhase.closing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        request.commands.completeClose();
      });
    }

    final label = request.semantics?.label ?? 'menu';
    return Material(
      child: Container(
        key: Key('menu-$label'),
        height: 120,
        width: 220,
        color: const Color(0xFFFFFFFF),
      ),
    );
  }
}

final class _TestTheme extends HeadlessTheme {
  const _TestTheme();

  @override
  T? capability<T>() {
    if (T == RTextFieldRenderer) return _FieldRenderer() as T;
    if (T == RDropdownButtonRenderer) return _MenuRenderer() as T;
    return null;
  }
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

void main() {
  testWidgets('moving to another field closes multi-select menu', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RAutocomplete<String>.multiple(
              semanticLabel: 'first',
              source: RAutocompleteLocalSource(
                options: (_) => const ['Belgium', 'Finland'],
              ),
              itemAdapter: _adapter,
              selectedValues: const [],
              onSelectionChanged: (_) {},
              openOnTap: true,
            ),
            const SizedBox(height: 180),
            RAutocomplete<String>(
              semanticLabel: 'second',
              source: RAutocompleteLocalSource(
                options: (_) => const ['France', 'Germany'],
              ),
              itemAdapter: _adapter,
              onSelected: (_) {},
              openOnTap: true,
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('field-first')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('menu-first')), findsOneWidget);

    await tester.tap(find.byKey(const Key('field-second')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('menu-first')), findsNothing);
  });
}
