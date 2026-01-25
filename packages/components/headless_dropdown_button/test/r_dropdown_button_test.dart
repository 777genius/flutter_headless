import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_dropdown_button/headless_dropdown_button.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_test/headless_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

class _TestDropdownTokenResolver implements RDropdownTokenResolver {
  _TestDropdownTokenResolver({
    required this.defaultTriggerBorderColor,
  });

  final Color defaultTriggerBorderColor;
  BoxConstraints? lastConstraints;
  RenderOverrides? lastOverrides;
  Set<WidgetState>? lastTriggerStates;
  ROverlayPhase? lastOverlayPhase;

  @override
  RDropdownResolvedTokens resolve({
    required BuildContext context,
    required RDropdownButtonSpec spec,
    required Set<WidgetState> triggerStates,
    required ROverlayPhase overlayPhase,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    lastConstraints = constraints;
    lastOverrides = overrides;
    lastTriggerStates = triggerStates;
    lastOverlayPhase = overlayPhase;

    final contractOverrides = overrides?.get<RDropdownOverrides>();
    final triggerBorder = contractOverrides?.triggerBorderColor ??
        (overlayPhase == ROverlayPhase.open
            ? const Color(0xFF00AAFF)
            : defaultTriggerBorderColor);

    return RDropdownResolvedTokens(
      trigger: RDropdownTriggerTokens(
        textStyle: const TextStyle(fontSize: 14),
        foregroundColor: const Color(0xFF000000),
        backgroundColor: const Color(0xFFFFFFFF),
        borderColor: triggerBorder,
        padding: const EdgeInsets.all(8),
        minSize: const Size(44, 44),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        iconColor: const Color(0xFF111111),
        pressOverlayColor: const Color(0x11000000),
        pressOpacity: 1.0,
      ),
      menu: const RDropdownMenuTokens(
        backgroundColor: Color(0xFFFFFFFF),
        backgroundOpacity: 1.0,
        borderColor: Color(0xFF222222),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        elevation: 4,
        maxHeight: 240,
        padding: EdgeInsets.all(8),
        backdropBlurSigma: 0,
        shadowColor: Color(0x00000000),
        shadowBlurRadius: 0,
        shadowOffset: Offset.zero,
      ),
      item: const RDropdownItemTokens(
        textStyle: TextStyle(fontSize: 14),
        foregroundColor: Color(0xFF000000),
        backgroundColor: Color(0x00000000),
        highlightBackgroundColor: Color(0xFFE0E0E0),
        selectedBackgroundColor: Color(0x1100AAFF),
        disabledForegroundColor: Color(0xFF999999),
        padding: EdgeInsets.all(8),
        minHeight: 40,
        selectedMarkerColor: Color(0xFF00AAFF),
      ),
    );
  }
}

RDropdownOption<String> _option(
  String value, {
  String? label,
  bool isDisabled = false,
}) {
  final text = label ?? value;
  return RDropdownOption(
    value: value,
    item: HeadlessListItemModel(
      id: ListboxItemId(value),
      primaryText: text,
      typeaheadLabel: HeadlessTypeaheadLabel.normalize(text),
      isDisabled: isDisabled,
    ),
  );
}

// Test renderer that captures requests and renders simple widgets
class _TestDropdownRenderer implements RDropdownButtonRenderer {
  RDropdownRenderRequest? lastRequest;
  int renderCount = 0;
  final List<String> renderLog = [];

  @override
  Widget render(RDropdownRenderRequest request) {
    lastRequest = request;
    renderCount++;
    renderLog.add(
      '#$renderCount: request=${request.runtimeType}, phase=${request.state.overlayPhase}',
    );

    return switch (request) {
      RDropdownTriggerRenderRequest() => _TestTrigger(request: request),
      RDropdownMenuRenderRequest() => _TestMenu(request: request),
    };
  }
}

class _TestTrigger extends StatelessWidget {
  const _TestTrigger({required this.request});

  final RDropdownTriggerRenderRequest request;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = request.state.selectedIndex;
    final selectedLabel =
        (selectedIndex != null && selectedIndex < request.items.length)
            ? request.items[selectedIndex].primaryText
            : null;

    return Container(
      key: const Key('dropdown-trigger'),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: request.state.isTriggerPressed
            ? const Color(0xFF0000FF)
            : request.state.isTriggerHovered
                ? const Color(0xFF00FF00)
                : const Color(0xFFCCCCCC),
        border: request.state.isTriggerFocused
            ? Border.all(color: const Color(0xFFFF0000), width: 2)
            : null,
      ),
      child: Text(
        selectedLabel ?? request.spec.placeholder ?? 'Select...',
        key: const Key('trigger-text'),
      ),
    );
  }
}

class _TestMenu extends StatelessWidget {
  const _TestMenu({required this.request});

  final RDropdownMenuRenderRequest request;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('dropdown-menu'),
      color: const Color(0xFFFFFFFF),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          for (var i = 0; i < request.items.length; i++)
            GestureDetector(
              key: Key('item-$i'),
              onTap: request.items[i].isDisabled
                  ? null
                  : () => request.commands.selectIndex(i),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: i == request.state.highlightedIndex
                    ? const Color(0xFFE0E0E0)
                    : null,
                child: Text(
                  request.items[i].primaryText,
                  style: TextStyle(
                    color: request.items[i].isDisabled
                        ? const Color(0xFF999999)
                        : const Color(0xFF000000),
                  ),
                ),
              ),
            ),
          // Add completeClose button for testing lifecycle
          TextButton(
            key: const Key('complete-close-btn'),
            onPressed: request.commands.completeClose,
            child: const Text('Complete Close'),
          ),
        ],
      ),
    );
  }
}

// Test theme that provides the test renderer
class _TestTheme extends HeadlessTheme {
  _TestTheme(this._renderer, {this.tokenResolver});

  final _TestDropdownRenderer _renderer;
  final _TestDropdownTokenResolver? tokenResolver;

  @override
  C? capability<C>() {
    if (C == RDropdownButtonRenderer) {
      return _renderer as C;
    }
    if (C == RDropdownTokenResolver) {
      return tokenResolver as C?;
    }
    return null;
  }
}

// Theme without dropdown renderer
class _EmptyTheme extends HeadlessTheme {
  const _EmptyTheme();

  @override
  T? capability<T>() => null;
}

// Helper to build widget tree with theme and overlay host
Widget _buildTestWidget({
  required _TestDropdownRenderer renderer,
  required Widget child,
  OverlayController? overlayController,
  _TestDropdownTokenResolver? tokenResolver,
}) {
  final controller = overlayController ?? OverlayController();
  return MaterialApp(
    home: HeadlessThemeProvider(
      theme: _TestTheme(renderer, tokenResolver: tokenResolver),
      child: AnchoredOverlayEngineHost(
        controller: controller,
        child: Scaffold(body: Center(child: child)),
      ),
    ),
  );
}

void main() {
  group('Semantics / Accessibility', () {
    testWidgets('dropdown has button semantic role', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          value: 'a',
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
            _option('b', label: 'Option B'),
          ],
        ),
      ));

      final semantics =
          tester.getSemantics(find.byType(RDropdownButton<String>));
      expect(SemanticsUtils.hasFlag(semantics, SemanticsFlag.isButton), isTrue);
    });

    testWidgets('disabled dropdown shows disabled state in semantics',
        (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          value: null,
          onChanged: null,
          options: [
            _option('a', label: 'Option A'),
          ],
        ),
      ));

      final semantics =
          tester.getSemantics(find.byType(RDropdownButton<String>));
      expect(SemanticsUtils.hasFlag(semantics, SemanticsFlag.isButton), isTrue);
      expect(
          SemanticsUtils.hasFlag(semantics, SemanticsFlag.isEnabled), isFalse);
    });

    testWidgets('semantic label is applied when provided', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          value: null,
          onChanged: (v) {},
          semanticLabel: 'Choose city',
          options: [
            _option('a', label: 'Option A'),
          ],
        ),
      ));

      final semantics =
          tester.getSemantics(find.byType(RDropdownButton<String>));
      expect(semantics.label, contains('Choose city'));
    });

    testWidgets('expanded state is reflected when menu opens', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
          ],
        ),
      ));

      // Pump to activate autofocus
      await tester.pump();

      // Open menu by tapping
      await tester.tap(find.byKey(const Key('dropdown-trigger')));
      await tester.pumpAndSettle();

      // Verify menu opened correctly via renderer state
      expect(renderer.lastRequest?.state.isOpen, isTrue);

      final rootNode =
          tester.getSemantics(find.byType(RDropdownButton<String>));
      SemanticsSla.expectHasExpandedState(node: rootNode, expanded: true);
    });

    testWidgets('SemanticsAction.tap opens menu exactly once', (tester) async {
      final renderer = _TestDropdownRenderer();
      var changeCount = 0;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          value: null,
          onChanged: (_) => changeCount++,
          options: [
            _option('a', label: 'Option A'),
          ],
        ),
      ));

      final semanticsHandle = tester.ensureSemantics();
      try {
        await tester.pumpAndSettle();

        final semanticsFinder = find
            .descendant(
              of: find.byType(RDropdownButton<String>),
              matching: find.byType(Semantics),
            )
            .first;
        final node = tester.getSemantics(semanticsFinder);
        expect(SemanticsUtils.hasAction(node, SemanticsAction.tap), isTrue);

        // ignore: deprecated_member_use
        final owner = tester.binding.pipelineOwner.semanticsOwner!;
        owner.performAction(node.id, SemanticsAction.tap);
        await tester.pumpAndSettle();

        // Should open menu, not select (selection requires explicit item activation).
        expect(renderer.lastRequest?.state.isOpen, isTrue);
        expect(changeCount, 0);
      } finally {
        semanticsHandle.dispose();
      }
    });
  });

  group('Keyboard - Trigger', () {
    testWidgets('Space opens menu on key up', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
            _option('b', label: 'Option B'),
          ],
        ),
      ));

      await tester.pump();

      // Space down - not open yet
      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(renderer.lastRequest?.state.isOpen, isFalse);

      // Space up - opens (isOpen = opening or open)
      await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.isOpen, isTrue);
    });

    testWidgets('Enter opens menu immediately', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
          ],
        ),
      ));

      await tester.pump();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.isOpen, isTrue);
    });

    testWidgets('ArrowDown opens menu', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
          ],
        ),
      ));

      await tester.pump();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.isOpen, isTrue);
    });

    testWidgets('disabled dropdown ignores keyboard', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: null,
          onChanged: null, // disabled
          options: [
            _option('a', label: 'Option A'),
          ],
        ),
      ));

      await tester.pump();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.isOpen, isFalse);
    });
  });

  group('Keyboard - Menu Navigation', () {
    testWidgets('ArrowDown navigates through items', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
            _option('b', label: 'Option B'),
            _option('c', label: 'Option C'),
          ],
        ),
      ));

      await tester.pump();

      // Open menu
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // Initial highlight is first item (index 0)
      expect(renderer.lastRequest?.state.highlightedIndex, 0);

      // Navigate down
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(renderer.lastRequest?.state.highlightedIndex, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(renderer.lastRequest?.state.highlightedIndex, 2);
    });

    testWidgets('ArrowUp navigates backwards', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: 'c', // start with last selected
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
            _option('b', label: 'Option B'),
            _option('c', label: 'Option C'),
          ],
        ),
      ));

      await tester.pump();

      // Open menu
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // Initial highlight is selected item (index 2)
      expect(renderer.lastRequest?.state.highlightedIndex, 2);

      // Navigate up
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(renderer.lastRequest?.state.highlightedIndex, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(renderer.lastRequest?.state.highlightedIndex, 0);
    });

    testWidgets('disabled items are skipped during navigation', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
            _option('b', label: 'Option B', isDisabled: true),
            _option('c', label: 'Option C'),
          ],
        ),
      ));

      await tester.pump();

      // Open menu
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.highlightedIndex, 0);

      // Navigate down - should skip disabled item (index 1)
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(renderer.lastRequest?.state.highlightedIndex, 2);
    });

    testWidgets('selected disabled item falls back to first enabled',
        (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: 'b', // selected item is disabled!
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
            _option('b', label: 'Option B', isDisabled: true),
            _option('c', label: 'Option C'),
          ],
        ),
      ));

      await tester.pump();

      // Open menu - should highlight first enabled, not selected disabled
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // highlightedIndex should be 0 (first enabled), not 1 (selected but disabled)
      expect(renderer.lastRequest?.state.highlightedIndex, 0);
    });

    testWidgets('Enter selects highlighted item and closes', (tester) async {
      final renderer = _TestDropdownRenderer();
      String? selectedValue;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: null,
          onChanged: (v) => selectedValue = v,
          options: [
            _option('a', label: 'Option A'),
            _option('b', label: 'Option B'),
          ],
        ),
      ));

      await tester.pump();

      // Open menu
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // Navigate to second item
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();

      // Select
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(selectedValue, 'b');
      // Menu closes (enters closing phase or closed)
      expect(
        renderer.lastRequest?.state.overlayPhase,
        isIn([ROverlayPhase.closing, ROverlayPhase.closed]),
      );
    });

    testWidgets('Home/End jumps to first/last item', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
            _option('b', label: 'Option B'),
            _option('c', label: 'Option C'),
          ],
        ),
      ));

      await tester.pump();

      // Open menu
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // Jump to end
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(renderer.lastRequest?.state.highlightedIndex, 2);

      // Jump to home
      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pump();
      expect(renderer.lastRequest?.state.highlightedIndex, 0);
    });
  });

  group('Escape behavior', () {
    testWidgets('Escape closes without changing selection', (tester) async {
      final renderer = _TestDropdownRenderer();
      String? selectedValue = 'a';
      var changeCount = 0;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: selectedValue,
          onChanged: (v) {
            selectedValue = v;
            changeCount++;
          },
          options: [
            _option('a', label: 'Option A'),
            _option('b', label: 'Option B'),
          ],
        ),
      ));

      await tester.pump();

      // Open menu
      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // Navigate to different item
      await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();

      // Escape to close (handled locally in menu key handler)
      await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      // Selection unchanged
      expect(selectedValue, 'a');
      expect(changeCount, 0);
    });
  });

  group('Focus restore', () {
    testWidgets('focus returns to trigger after close', (tester) async {
      final renderer = _TestDropdownRenderer();
      final focusNode = FocusNode();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          focusNode: focusNode,
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
          ],
        ),
      ));

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      // Open menu
      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // Select item (closes menu)
      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // Trigger completeClose via the test button
      final completeCloseButton = find.byKey(const Key('complete-close-btn'));
      await tester.ensureVisible(completeCloseButton);
      await tester.tap(completeCloseButton);
      await tester.pumpAndSettle();

      // Focus should be back on trigger
      expect(focusNode.hasFocus, isTrue);
    });
  });

  group('Overlay lifecycle', () {
    testWidgets('close() transitions to closing phase', (tester) async {
      final renderer = _TestDropdownRenderer();
      final overlayController = OverlayController();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        overlayController: overlayController,
        child: RDropdownButton<String>(
          autofocus: true,
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
          ],
        ),
      ));

      await tester.pump();

      // Open menu
      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(renderer.lastRequest?.state.isOpen, isTrue);

      // Close via controller
      overlayController.closeTop();
      await tester.pump();
      expect(renderer.lastRequest?.state.overlayPhase, ROverlayPhase.closing);
    });

    testWidgets('completeClose() transitions to closed phase', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
          ],
        ),
      ));

      await tester.pump();

      // Open menu
      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // Tap completeClose button (simulates renderer calling it after exit animation)
      final completeCloseButton = find.byKey(const Key('complete-close-btn'));
      await tester.ensureVisible(completeCloseButton);
      await tester.tap(completeCloseButton);
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.overlayPhase, ROverlayPhase.closed);
    });
  });

  group('Pointer interaction', () {
    testWidgets('tap opens menu', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          key:
              const ValueKey('test-dropdown'), // Add key for state preservation
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
          ],
        ),
      ));

      await tester.tap(find.byKey(const Key('dropdown-trigger')));
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.isOpen, isTrue);
    });

    testWidgets('tap on item selects and closes', (tester) async {
      final renderer = _TestDropdownRenderer();
      String? selectedValue;

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          value: null,
          onChanged: (v) => selectedValue = v,
          options: [
            _option('a', label: 'Option A'),
            _option('b', label: 'Option B'),
          ],
        ),
      ));

      // Open menu
      await tester.tap(find.byKey(const Key('dropdown-trigger')));
      await tester.pumpAndSettle();

      // Tap on second item
      final secondItem = find.byKey(const Key('item-1'));
      // In constrained overlays the menu can become scrollable; make sure the item is reachable.
      await tester.drag(
          find.byKey(const Key('dropdown-menu')), const Offset(0, -200));
      await tester.pumpAndSettle();
      await tester.tap(secondItem);
      await tester.pump();

      expect(selectedValue, 'b');
    });

    testWidgets('hover updates trigger state', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
          ],
        ),
      ));

      expect(renderer.lastRequest?.state.isTriggerHovered, isFalse);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);

      await gesture.addPointer(
        location: tester.getCenter(find.byKey(const Key('dropdown-trigger'))),
      );
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.isTriggerHovered, isTrue);
    });
  });

  group('Controlled state', () {
    testWidgets('value is reflected in render request', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          value: 'b',
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
            _option('b', label: 'Option B'),
          ],
        ),
      ));

      // 'b' is at index 1
      expect(renderer.lastRequest?.state.selectedIndex, 1);
    });

    testWidgets('changing disabled closes menu', (tester) async {
      final renderer = _TestDropdownRenderer();
      var disabled = false;

      late StateSetter setter;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            setter = setState;
            return _buildTestWidget(
              renderer: renderer,
              child: RDropdownButton<String>(
                value: null,
                disabled: disabled,
                onChanged: (v) {},
                options: [
                  _option('a', label: 'Option A'),
                ],
              ),
            );
          },
        ),
      );

      // Open menu
      await tester.tap(find.byKey(const Key('dropdown-trigger')));
      await tester.pumpAndSettle();
      expect(renderer.lastRequest?.state.isOpen, isTrue);

      // Disable
      setter(() => disabled = true);
      await tester.pumpAndSettle();

      // Menu should be closed or closing
      expect(
        renderer.lastRequest?.state.overlayPhase,
        isIn([ROverlayPhase.closing, ROverlayPhase.closed]),
      );
    });
  });

  group('Missing capability', () {
    testWidgets('throws MissingCapabilityException when renderer not available',
        (tester) async {
      final overlayController = OverlayController();

      await tester.pumpWidget(MaterialApp(
        home: HeadlessThemeProvider(
          theme: const _EmptyTheme(),
          child: AnchoredOverlayEngineHost(
            controller: overlayController,
            child: Scaffold(
              body: RDropdownButton<String>(
                value: null,
                onChanged: (v) {},
                options: [
                  _option('a', label: 'A'),
                ],
              ),
            ),
          ),
        ),
      ));

      final exception = tester.takeException();
      expect(exception, isA<MissingCapabilityException>());

      final message = exception.toString();
      expect(message, startsWith('[Headless] Missing required capability:'));
      expect(message, contains('RDropdownButtonRenderer'));
      expect(message, contains('Component: RDropdownButton'));
    });
  });

  group('Typeahead', () {
    testWidgets('typing character highlights matching item', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Apple'),
            _option('b', label: 'Banana'),
            _option('c', label: 'Cherry'),
          ],
        ),
      ));

      await tester.pump();

      // Open menu
      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(renderer.lastRequest?.state.highlightedIndex, 0); // Apple

      // Type 'c' for Cherry - use simulateKeyDownEvent to send character
      await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
      await tester.pump();

      expect(renderer.lastRequest?.state.highlightedIndex, 2); // Cherry
    });
  });

  group('Wrap-around navigation (listbox spec)', () {
    testWidgets('ArrowDown on last item wraps to first enabled',
        (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
            _option('b', label: 'Option B'),
            _option('c', label: 'Option C'),
          ],
        ),
      ));

      await tester.pump();

      // Open menu
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // Navigate to last item
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(renderer.lastRequest?.state.highlightedIndex, 2); // Last

      // ArrowDown should wrap to first
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(
          renderer.lastRequest?.state.highlightedIndex, 0); // Wrapped to first
    });

    testWidgets('ArrowUp on first item wraps to last enabled', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
            _option('b', label: 'Option B'),
            _option('c', label: 'Option C'),
          ],
        ),
      ));

      await tester.pump();

      // Open menu
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // Should highlight first item (index 0)
      expect(renderer.lastRequest?.state.highlightedIndex, 0);

      // ArrowUp should wrap to last
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(
          renderer.lastRequest?.state.highlightedIndex, 2); // Wrapped to last
    });

    testWidgets('wrap-around skips disabled items', (tester) async {
      final renderer = _TestDropdownRenderer();

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        child: RDropdownButton<String>(
          autofocus: true,
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'Option A'),
            _option('b', label: 'Option B', isDisabled: true),
            _option('c', label: 'Option C'),
          ],
        ),
      ));

      await tester.pump();

      // Open menu
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // Navigate to last enabled item (index 2)
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(renderer.lastRequest?.state.highlightedIndex, 2);

      // ArrowDown should wrap to first enabled (index 0), skipping disabled
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(renderer.lastRequest?.state.highlightedIndex, 0);

      // ArrowUp should wrap to last enabled (index 2), skipping disabled
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(renderer.lastRequest?.state.highlightedIndex, 2);
    });
  });

  group('Token resolution (I08 flow)', () {
    testWidgets(
        'resolvedTokens are passed to renderer when token resolver is provided',
        (tester) async {
      final renderer = _TestDropdownRenderer();
      final resolver = _TestDropdownTokenResolver(
        defaultTriggerBorderColor: const Color(0xFF333333),
      );

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        tokenResolver: resolver,
        child: RDropdownButton<String>(
          value: null,
          onChanged: (v) {},
          options: [
            _option('a', label: 'A'),
          ],
        ),
      ));

      expect(renderer.lastRequest?.resolvedTokens, isNotNull);
      expect(resolver.lastConstraints, isNotNull);
      expect(renderer.lastRequest?.constraints, isNotNull);
    });

    testWidgets(
        'per-instance overrides flow into resolver and affect resolvedTokens',
        (tester) async {
      final renderer = _TestDropdownRenderer();
      final resolver = _TestDropdownTokenResolver(
        defaultTriggerBorderColor: const Color(0xFF333333),
      );

      const overrideBorder = Color(0xFF00FF99);

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        tokenResolver: resolver,
        child: RDropdownButton<String>(
          value: null,
          onChanged: (v) {},
          overrides: const RenderOverrides({
            RDropdownOverrides: RDropdownOverrides.tokens(
              triggerBorderColor: overrideBorder,
            ),
          }),
          options: [
            _option('a', label: 'A'),
          ],
        ),
      ));

      expect(resolver.lastOverrides?.get<RDropdownOverrides>(), isNotNull);
      expect(
        renderer.lastRequest?.resolvedTokens?.trigger.borderColor,
        overrideBorder,
      );
    });

    testWidgets('style sugar flows into resolver and affects resolvedTokens',
        (tester) async {
      final renderer = _TestDropdownRenderer();
      final resolver = _TestDropdownTokenResolver(
        defaultTriggerBorderColor: const Color(0xFF333333),
      );

      const styleBorder = Color(0xFF00FF99);

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        tokenResolver: resolver,
        child: RDropdownButton<String>(
          value: null,
          onChanged: (v) {},
          style: const RDropdownStyle(
            triggerBorderColor: styleBorder,
          ),
          options: [
            _option('a', label: 'A'),
          ],
        ),
      ));

      expect(resolver.lastOverrides?.get<RDropdownOverrides>(), isNotNull);
      expect(
        renderer.lastRequest?.resolvedTokens?.trigger.borderColor,
        styleBorder,
      );
    });

    testWidgets('explicit overrides win over style sugar (POLA)',
        (tester) async {
      final renderer = _TestDropdownRenderer();
      final resolver = _TestDropdownTokenResolver(
        defaultTriggerBorderColor: const Color(0xFF333333),
      );

      const styleBorder = Color(0xFF00FF99);
      const overrideBorder = Color(0xFFFF0099);

      await tester.pumpWidget(_buildTestWidget(
        renderer: renderer,
        tokenResolver: resolver,
        child: RDropdownButton<String>(
          value: null,
          onChanged: (v) {},
          style: const RDropdownStyle(
            triggerBorderColor: styleBorder,
          ),
          overrides: const RenderOverrides({
            RDropdownOverrides: RDropdownOverrides.tokens(
              triggerBorderColor: overrideBorder,
            ),
          }),
          options: [
            _option('a', label: 'A'),
          ],
        ),
      ));

      expect(
        renderer.lastRequest?.resolvedTokens?.trigger.borderColor,
        overrideBorder,
      );
    });
  });
}
