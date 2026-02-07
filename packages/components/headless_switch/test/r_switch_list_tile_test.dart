import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_switch/headless_switch.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_test/headless_test.dart';
import 'package:headless_theme/headless_theme.dart';

class _TestSwitchRenderer implements RSwitchRenderer {
  RSwitchRenderRequest? lastRequest;
  int renderCount = 0;

  @override
  Widget render(RSwitchRenderRequest request) {
    lastRequest = request;
    renderCount++;
    return const SizedBox(
      key: ValueKey('switch-indicator'),
      width: 52,
      height: 32,
    );
  }
}

class _TestListTileRenderer implements RSwitchListTileRenderer {
  RSwitchListTileRenderRequest? lastRequest;

  @override
  Widget render(RSwitchListTileRenderRequest request) {
    lastRequest = request;
    return SizedBox(
      key: const ValueKey('switch-list-tile'),
      width: 200,
      height: 48,
      child: Row(
        children: [
          request.switchWidget,
          request.title,
        ],
      ),
    );
  }
}

class _TestListTileTokenResolver implements RSwitchListTileTokenResolver {
  Set<WidgetState>? lastStates;
  RenderOverrides? lastOverrides;

  @override
  RSwitchListTileResolvedTokens resolve({
    required BuildContext context,
    required RSwitchListTileSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    lastStates = states;
    lastOverrides = overrides;
    final contractOverrides = overrides?.get<RSwitchListTileOverrides>();
    final minHeight = contractOverrides?.minHeight ?? 56;
    return RSwitchListTileResolvedTokens(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minHeight: minHeight,
      horizontalGap: 16,
      verticalGap: 4,
      titleStyle: const TextStyle(fontSize: 16),
      subtitleStyle: const TextStyle(fontSize: 14),
      disabledOpacity: 1.0,
      pressOverlayColor: const Color(0x1F000000),
      pressOpacity: 1.0,
      motion: const RSwitchListTileMotionTokens(
        stateChangeDuration: Duration(milliseconds: 120),
      ),
    );
  }
}

class _TestSwitchTokenResolver implements RSwitchTokenResolver {
  Set<WidgetState>? lastStates;

  @override
  RSwitchResolvedTokens resolve({
    required BuildContext context,
    required RSwitchSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    lastStates = states;
    return RSwitchResolvedTokens(
      trackSize: const Size(52, 32),
      trackBorderRadius: const BorderRadius.all(Radius.circular(16)),
      trackOutlineColor: Colors.grey,
      trackOutlineWidth: 2,
      activeTrackColor: Colors.green,
      inactiveTrackColor: Colors.grey,
      thumbSizeUnselected: const Size(16, 16),
      thumbSizeSelected: const Size(24, 24),
      thumbSizePressed: const Size(28, 28),
      thumbSizeTransition: const Size(34, 22),
      activeThumbColor: Colors.white,
      inactiveThumbColor: Colors.white,
      thumbPadding: 4.0,
      disabledOpacity: 0.38,
      pressOverlayColor: const Color(0x1F000000),
      pressOpacity: 1.0,
      minTapTargetSize: const Size(48, 48),
      stateLayerRadius: 20.0,
      stateLayerColor: WidgetStateProperty.all(Colors.transparent),
      motion: const RSwitchMotionTokens(
        stateChangeDuration: Duration(milliseconds: 120),
      ),
    );
  }
}

class _TestTheme extends HeadlessTheme {
  _TestTheme({
    required this.switchRenderer,
    required this.listTileRenderer,
    this.switchTokenResolver,
    this.listTileTokenResolver,
  });

  final _TestSwitchRenderer switchRenderer;
  final _TestListTileRenderer listTileRenderer;
  final _TestSwitchTokenResolver? switchTokenResolver;
  final _TestListTileTokenResolver? listTileTokenResolver;

  @override
  T? capability<T>() {
    if (T == RSwitchRenderer) return switchRenderer as T;
    if (T == RSwitchListTileRenderer) return listTileRenderer as T;
    if (T == RSwitchTokenResolver) return switchTokenResolver as T?;
    if (T == RSwitchListTileTokenResolver) return listTileTokenResolver as T?;
    return null;
  }
}

class _EmptyTheme extends HeadlessTheme {
  const _EmptyTheme();

  @override
  T? capability<T>() => null;
}

Widget _buildTestWidget({
  required HeadlessTheme theme,
  required Widget child,
}) {
  return MaterialApp(
    home: HeadlessThemeProvider(
      theme: theme,
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  _runDragTests();

  group('RSwitchListTile', () {
    testWidgets(
        'throws MissingCapabilityException when no renderer is provided',
        (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          theme: const _EmptyTheme(),
          child: const RSwitchListTile(
            value: false,
            onChanged: null,
            title: Text('Title'),
          ),
        ),
      );

      expect(tester.takeException(), isA<MissingCapabilityException>());
    });

    testWidgets('passes spec to renderer', (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
          ),
          child: const RSwitchListTile(
            value: true,
            onChanged: null,
            isThreeLine: true,
            dense: true,
            selected: true,
            selectedColor: Color(0xFF123456),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            semanticLabel: 'Tile label',
            controlAffinity: RSwitchControlAffinity.trailing,
            title: Text('Title'),
            subtitle: Text('Subtitle'),
          ),
        ),
      );

      final spec = listTileRenderer.lastRequest?.spec;
      expect(spec, isNotNull);
      expect(spec!.value, isTrue);
      expect(spec.isThreeLine, isTrue);
      expect(spec.dense, isTrue);
      expect(spec.selected, isTrue);
      expect(spec.selectedColor, const Color(0xFF123456));
      expect(spec.contentPadding, const EdgeInsets.symmetric(horizontal: 20));
      expect(spec.hasSubtitle, isTrue);
      expect(spec.semanticLabel, 'Tile label');
      expect(spec.controlAffinity, RSwitchControlAffinity.trailing);
    });

    testWidgets(
        'autofocus requests focus and list tile resolver receives focused',
        (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final listTileResolver = _TestListTileTokenResolver();
      final focusNode = FocusNode(debugLabel: 'test-switch-tile-focus');

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestThemeWithResolvers(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
            listTileTokenResolver: listTileResolver,
          ),
          child: RSwitchListTile(
            value: false,
            onChanged: (_) {},
            focusNode: focusNode,
            autofocus: true,
            title: const Text('Title'),
          ),
        ),
      );
      await tester.pump();

      expect(focusNode.hasFocus, isTrue);
      expect(listTileResolver.lastStates, isNotNull);
      expect(
          listTileResolver.lastStates!.contains(WidgetState.focused), isTrue);
    });

    testWidgets('Tab traversal requests focus when enabled', (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final listTileResolver = _TestListTileTokenResolver();
      final focusNode = FocusNode(debugLabel: 'test-switch-tile-focus');

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestThemeWithResolvers(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
            listTileTokenResolver: listTileResolver,
          ),
          child: RSwitchListTile(
            value: false,
            onChanged: (_) {},
            focusNode: focusNode,
            title: const Text('Title'),
          ),
        ),
      );

      expect(focusNode.hasFocus, isFalse);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isTrue);
      expect(
          listTileResolver.lastStates!.contains(WidgetState.focused), isTrue);
    });

    testWidgets('Tab traversal skips tile when disabled', (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final focusNode = FocusNode(debugLabel: 'test-switch-tile-focus');

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
          ),
          child: RSwitchListTile(
            value: false,
            onChanged: null,
            focusNode: focusNode,
            title: const Text('Title'),
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isFalse);
    });

    testWidgets('tap calls onChanged with toggled value', (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      bool? changedTo;

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
          ),
          child: RSwitchListTile(
            value: false,
            onChanged: (v) => changedTo = v,
            title: const Text('Title'),
          ),
        ),
      );

      await tester.tap(find.byType(HeadlessPressableRegion));
      await tester.pump();

      expect(changedTo, isTrue);
    });

    testWidgets('switch indicator renderer is used', (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
          ),
          child: const RSwitchListTile(
            value: false,
            onChanged: null,
            title: Text('Title'),
          ),
        ),
      );

      expect(switchRenderer.renderCount, 1);
      expect(find.byKey(const ValueKey('switch-indicator')), findsOneWidget);
    });

    testWidgets('token resolver receives WidgetState.selected', (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final switchResolver = _TestSwitchTokenResolver();
      final listTileResolver = _TestListTileTokenResolver();

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
            switchTokenResolver: switchResolver,
            listTileTokenResolver: listTileResolver,
          ),
          child: const RSwitchListTile(
            value: true,
            selected: true,
            onChanged: null,
            title: Text('Title'),
          ),
        ),
      );

      expect(listTileResolver.lastStates, isNotNull);
      expect(
          listTileResolver.lastStates!.contains(WidgetState.selected), isTrue);

      expect(switchResolver.lastStates, isNotNull);
      expect(switchResolver.lastStates!.contains(WidgetState.selected), isTrue);
    });

    testWidgets('style sugar flows into resolver and affects resolvedTokens',
        (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final listTileResolver = _TestListTileTokenResolver();

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
            listTileTokenResolver: listTileResolver,
          ),
          child: const RSwitchListTile(
            value: false,
            onChanged: null,
            style: RSwitchListTileStyle(
              minHeight: 72,
            ),
            title: Text('Title'),
          ),
        ),
      );

      expect(
        listTileRenderer.lastRequest?.resolvedTokens?.minHeight,
        72,
      );
    });

    testWidgets('explicit overrides win over style sugar (POLA)',
        (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final listTileResolver = _TestListTileTokenResolver();

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
            listTileTokenResolver: listTileResolver,
          ),
          child: const RSwitchListTile(
            value: false,
            onChanged: null,
            style: RSwitchListTileStyle(
              minHeight: 72,
            ),
            overrides: RenderOverrides({
              RSwitchListTileOverrides: RSwitchListTileOverrides.tokens(
                minHeight: 88,
              ),
            }),
            title: Text('Title'),
          ),
        ),
      );

      expect(
        listTileRenderer.lastRequest?.resolvedTokens?.minHeight,
        88,
      );
    });

    testWidgets('semantics shows toggled state correctly', (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
          ),
          child: const RSwitchListTile(
            value: true,
            semanticLabel: 'Dark mode',
            onChanged: null,
            title: Text('Title'),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(RSwitchListTile));
      expect(
          SemanticsUtils.hasFlag(semantics, SemanticsFlag.isToggled), isTrue);
    });

    testWidgets('passes slots to renderer', (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final slots = RSwitchListTileSlots(
        tile: Decorate((ctx, child) => child),
      );

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
          ),
          child: RSwitchListTile(
            value: false,
            onChanged: (_) {},
            title: const Text('Title'),
            slots: slots,
          ),
        ),
      );

      expect(listTileRenderer.lastRequest?.slots, same(slots));
    });

    testWidgets('Space key activates list tile on key up', (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      bool? changedTo;

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
          ),
          child: RSwitchListTile(
            value: false,
            autofocus: true,
            onChanged: (v) => changedTo = v,
            title: const Text('Title'),
          ),
        ),
      );

      await tester.pump();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(changedTo, isNull);

      await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(changedTo, isTrue);
    });

    testWidgets('Enter key activates list tile immediately', (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      bool? changedTo;

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
          ),
          child: RSwitchListTile(
            value: false,
            autofocus: true,
            onChanged: (v) => changedTo = v,
            title: const Text('Title'),
          ),
        ),
      );

      await tester.pump();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(changedTo, isTrue);
    });

    group('pressable surface capability', () {
      testWidgets('uses HeadlessPressableRegion when capability not present',
          (tester) async {
        final switchRenderer = _TestSwitchRenderer();
        final listTileRenderer = _TestListTileRenderer();

        await tester.pumpWidget(
          _buildTestWidget(
            theme: _TestTheme(
              switchRenderer: switchRenderer,
              listTileRenderer: listTileRenderer,
            ),
            child: RSwitchListTile(
              value: false,
              onChanged: (_) {},
              title: const Text('Title'),
            ),
          ),
        );

        // Without capability, HeadlessPressableRegion should be used
        expect(find.byType(HeadlessPressableRegion), findsOneWidget);
      });

      testWidgets('uses capability wrapper when present', (tester) async {
        final switchRenderer = _TestSwitchRenderer();
        final listTileRenderer = _TestListTileRenderer();
        final pressableSurfaceFactory = _TestPressableSurfaceFactory();

        await tester.pumpWidget(
          _buildTestWidget(
            theme: _TestThemeWithPressableSurface(
              switchRenderer: switchRenderer,
              listTileRenderer: listTileRenderer,
              pressableSurfaceFactory: pressableSurfaceFactory,
            ),
            child: RSwitchListTile(
              value: false,
              onChanged: (_) {},
              title: const Text('Title'),
            ),
          ),
        );

        // With capability, HeadlessPressableRegion should NOT be used directly
        // Our custom wrapper widget should be present
        expect(find.byKey(const ValueKey('custom-pressable-wrapper')),
            findsOneWidget);
        expect(pressableSurfaceFactory.wrapCalled, isTrue);
      });

      testWidgets('capability wrapper receives correct parameters',
          (tester) async {
        final switchRenderer = _TestSwitchRenderer();
        final listTileRenderer = _TestListTileRenderer();
        final pressableSurfaceFactory = _TestPressableSurfaceFactory();

        await tester.pumpWidget(
          _buildTestWidget(
            theme: _TestThemeWithPressableSurface(
              switchRenderer: switchRenderer,
              listTileRenderer: listTileRenderer,
              pressableSurfaceFactory: pressableSurfaceFactory,
            ),
            child: RSwitchListTile(
              value: false,
              onChanged: (_) {},
              title: const Text('Title'),
              autofocus: true,
            ),
          ),
        );

        expect(pressableSurfaceFactory.lastEnabled, isTrue);
        expect(pressableSurfaceFactory.lastAutofocus, isTrue);
      });

      testWidgets('capability wrapper is disabled when onChanged is null',
          (tester) async {
        final switchRenderer = _TestSwitchRenderer();
        final listTileRenderer = _TestListTileRenderer();
        final pressableSurfaceFactory = _TestPressableSurfaceFactory();

        await tester.pumpWidget(
          _buildTestWidget(
            theme: _TestThemeWithPressableSurface(
              switchRenderer: switchRenderer,
              listTileRenderer: listTileRenderer,
              pressableSurfaceFactory: pressableSurfaceFactory,
            ),
            child: const RSwitchListTile(
              value: false,
              onChanged: null,
              title: Text('Title'),
            ),
          ),
        );

        expect(pressableSurfaceFactory.lastEnabled, isFalse);
      });

      testWidgets('tap on capability wrapper toggles switch', (tester) async {
        final switchRenderer = _TestSwitchRenderer();
        final listTileRenderer = _TestListTileRenderer();
        final pressableSurfaceFactory = _TestPressableSurfaceFactory();
        bool? changedTo;

        await tester.pumpWidget(
          _buildTestWidget(
            theme: _TestThemeWithPressableSurface(
              switchRenderer: switchRenderer,
              listTileRenderer: listTileRenderer,
              pressableSurfaceFactory: pressableSurfaceFactory,
            ),
            child: RSwitchListTile(
              value: false,
              onChanged: (v) => changedTo = v,
              title: const Text('Title'),
            ),
          ),
        );

        // Tap the wrapper
        await tester
            .tap(find.byKey(const ValueKey('custom-pressable-wrapper')));
        await tester.pump();

        expect(changedTo, isTrue);
      });
    });
  });
}

class _TestPressableSurfaceFactory implements HeadlessPressableSurfaceFactory {
  bool wrapCalled = false;
  bool? lastEnabled;
  bool? lastAutofocus;
  VoidCallback? lastOnActivate;

  @override
  Widget wrap({
    required BuildContext context,
    required HeadlessPressableController controller,
    required bool enabled,
    required VoidCallback onActivate,
    required Widget child,
    RenderOverrides? overrides,
    HeadlessPressableVisualEffectsController? visualEffects,
    FocusNode? focusNode,
    bool autofocus = false,
    MouseCursor? cursorWhenEnabled,
    MouseCursor? cursorWhenDisabled,
  }) {
    wrapCalled = true;
    lastEnabled = enabled;
    lastAutofocus = autofocus;
    lastOnActivate = onActivate;

    return GestureDetector(
      key: const ValueKey('custom-pressable-wrapper'),
      onTap: enabled ? onActivate : null,
      child: child,
    );
  }
}

class _TestThemeWithPressableSurface extends HeadlessTheme {
  _TestThemeWithPressableSurface({
    required this.switchRenderer,
    required this.listTileRenderer,
    required this.pressableSurfaceFactory,
  });

  final _TestSwitchRenderer switchRenderer;
  final _TestListTileRenderer listTileRenderer;
  final _TestPressableSurfaceFactory pressableSurfaceFactory;

  @override
  T? capability<T>() {
    if (T == RSwitchRenderer) return switchRenderer as T;
    if (T == RSwitchListTileRenderer) return listTileRenderer as T;
    if (T == HeadlessPressableSurfaceFactory)
      return pressableSurfaceFactory as T;
    return null;
  }
}

class _TestThemeWithResolvers extends HeadlessTheme {
  _TestThemeWithResolvers({
    required this.switchRenderer,
    required this.listTileRenderer,
    this.switchTokenResolver,
    this.listTileTokenResolver,
  });

  final _TestSwitchRenderer switchRenderer;
  final _TestListTileRenderer listTileRenderer;
  final _TestSwitchTokenResolver? switchTokenResolver;
  final _TestListTileTokenResolver? listTileTokenResolver;

  @override
  T? capability<T>() {
    if (T == RSwitchRenderer) return switchRenderer as T;
    if (T == RSwitchListTileRenderer) return listTileRenderer as T;
    if (T == RSwitchTokenResolver) return switchTokenResolver as T?;
    if (T == RSwitchListTileTokenResolver) return listTileTokenResolver as T?;
    return null;
  }
}

void _runDragTests() {
  group('drag behavior', () {
    testWidgets('T30: drag thumb from OFF to ON toggles switch',
        (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final switchResolver = _TestSwitchTokenResolver();
      final listTileResolver = _TestListTileTokenResolver();
      bool value = false;

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestThemeWithResolvers(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
            switchTokenResolver: switchResolver,
            listTileTokenResolver: listTileResolver,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return RSwitchListTile(
                value: value,
                onChanged: (v) => setState(() => value = v),
                title: const Text('Title'),
              );
            },
          ),
        ),
      );

      await tester.fling(
        find.byKey(const ValueKey('switch-indicator')),
        const Offset(50, 0),
        500,
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(value, isTrue);
    });

    testWidgets('T31: drag thumb from ON to OFF toggles switch',
        (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final switchResolver = _TestSwitchTokenResolver();
      final listTileResolver = _TestListTileTokenResolver();
      bool value = true;

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestThemeWithResolvers(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
            switchTokenResolver: switchResolver,
            listTileTokenResolver: listTileResolver,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return RSwitchListTile(
                value: value,
                onChanged: (v) => setState(() => value = v),
                title: const Text('Title'),
              );
            },
          ),
        ),
      );

      await tester.fling(
        find.byKey(const ValueKey('switch-indicator')),
        const Offset(-50, 0),
        500,
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(value, isFalse);
    });

    testWidgets('T32: fling with velocity > 300 toggles switch',
        (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final switchResolver = _TestSwitchTokenResolver();
      final listTileResolver = _TestListTileTokenResolver();
      bool value = false;

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestThemeWithResolvers(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
            switchTokenResolver: switchResolver,
            listTileTokenResolver: listTileResolver,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return RSwitchListTile(
                value: value,
                onChanged: (v) => setState(() => value = v),
                title: const Text('Title'),
              );
            },
          ),
        ),
      );

      await tester.fling(
        find.byKey(const ValueKey('switch-indicator')),
        const Offset(30, 0),
        400,
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(value, isTrue);
    });

    testWidgets('T33: drag does not work when disabled', (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final switchResolver = _TestSwitchTokenResolver();
      final listTileResolver = _TestListTileTokenResolver();

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestThemeWithResolvers(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
            switchTokenResolver: switchResolver,
            listTileTokenResolver: listTileResolver,
          ),
          child: const RSwitchListTile(
            value: false,
            onChanged: null,
            title: Text('Title'),
          ),
        ),
      );

      await tester.fling(
        find.byKey(const ValueKey('switch-indicator')),
        const Offset(50, 0),
        500,
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(switchRenderer.lastRequest?.state.isDisabled, isTrue);
      expect(switchRenderer.lastRequest?.state.isDragging, isFalse);
    });

    testWidgets('tap on tile still works alongside drag on switch',
        (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final switchResolver = _TestSwitchTokenResolver();
      final listTileResolver = _TestListTileTokenResolver();
      bool value = false;

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestThemeWithResolvers(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
            switchTokenResolver: switchResolver,
            listTileTokenResolver: listTileResolver,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return RSwitchListTile(
                value: value,
                onChanged: (v) => setState(() => value = v),
                title: const Text('Title'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(HeadlessPressableRegion));
      await tester.pumpAndSettle();

      expect(value, isTrue);
    });

    testWidgets('drag passes dragT and dragVisualValue to switch state',
        (tester) async {
      final switchRenderer = _TestSwitchRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final switchResolver = _TestSwitchTokenResolver();
      final listTileResolver = _TestListTileTokenResolver();

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestThemeWithResolvers(
            switchRenderer: switchRenderer,
            listTileRenderer: listTileRenderer,
            switchTokenResolver: switchResolver,
            listTileTokenResolver: listTileResolver,
          ),
          child: RSwitchListTile(
            value: false,
            onChanged: (_) {},
            title: const Text('Title'),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const ValueKey('switch-indicator'))),
      );
      await tester.pump();

      await gesture.moveBy(const Offset(20, 0));
      await tester.pump();

      expect(switchRenderer.lastRequest?.state.dragT, isNotNull);

      await gesture.up();
      await tester.pumpAndSettle();

      expect(switchRenderer.lastRequest?.state.dragT, isNull);
    });
  });
}
