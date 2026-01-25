import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_switch/headless_switch.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_test/headless_test.dart';
import 'package:headless_theme/headless_theme.dart';

class _TestSwitchTokenResolver implements RSwitchTokenResolver {
  Set<WidgetState>? lastStates;
  RSwitchSpec? lastSpec;
  RenderOverrides? lastOverrides;

  @override
  RSwitchResolvedTokens resolve({
    required BuildContext context,
    required RSwitchSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    lastStates = states;
    lastSpec = spec;
    lastOverrides = overrides;
    final contractOverrides = overrides?.get<RSwitchOverrides>();
    final activeTrackColor =
        contractOverrides?.activeTrackColor ?? Colors.green;
    return RSwitchResolvedTokens(
      trackSize: const Size(52, 32),
      trackBorderRadius: const BorderRadius.all(Radius.circular(16)),
      trackOutlineColor: Colors.grey,
      trackOutlineWidth: 2,
      activeTrackColor: activeTrackColor,
      inactiveTrackColor: Colors.grey.shade300,
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

class _TestSwitchRenderer implements RSwitchRenderer {
  RSwitchRenderRequest? lastRequest;

  @override
  Widget render(RSwitchRenderRequest request) {
    lastRequest = request;
    return Container(
      key: const ValueKey('switch-render'),
      width: 52,
      height: 32,
      color: request.spec.value ? Colors.green : Colors.grey,
    );
  }
}

class _TestTheme extends HeadlessTheme {
  _TestTheme(this._renderer, {this.tokenResolver});

  final _TestSwitchRenderer _renderer;
  final _TestSwitchTokenResolver? tokenResolver;

  @override
  T? capability<T>() {
    if (T == RSwitchRenderer) return _renderer as T;
    if (T == RSwitchTokenResolver) return tokenResolver as T?;
    return null;
  }
}

class _EmptyTheme extends HeadlessTheme {
  const _EmptyTheme();

  @override
  T? capability<T>() => null;
}

Widget _buildTestWidget({
  required _TestSwitchRenderer renderer,
  required Widget child,
  _TestSwitchTokenResolver? tokenResolver,
}) {
  return MaterialApp(
    home: HeadlessThemeProvider(
      theme: _TestTheme(renderer, tokenResolver: tokenResolver),
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('RSwitch', () {
    testWidgets('throws MissingCapabilityException when no renderer is provided',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HeadlessThemeProvider(
            theme: _EmptyTheme(),
            child: Scaffold(
              body: Center(
                child: RSwitch(
                  value: false,
                  onChanged: null,
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isA<MissingCapabilityException>());
    });

    testWidgets('passes spec to renderer', (tester) async {
      final renderer = _TestSwitchRenderer();

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: const RSwitch(
            value: true,
            semanticLabel: 'Test label',
            onChanged: null,
          ),
        ),
      );

      final spec = renderer.lastRequest?.spec;
      expect(spec, isNotNull);
      expect(spec!.value, isTrue);
      expect(spec.semanticLabel, 'Test label');
    });

    testWidgets('passes slots to renderer', (tester) async {
      final renderer = _TestSwitchRenderer();
      final slots = RSwitchSlots(
        track: Replace((ctx) => const SizedBox(key: ValueKey('slot-track'))),
      );

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: RSwitch(
            value: false,
            onChanged: (_) {},
            slots: slots,
          ),
        ),
      );

      expect(renderer.lastRequest?.slots, same(slots));
    });

    testWidgets('tap calls onChanged with toggled value', (tester) async {
      final renderer = _TestSwitchRenderer();
      bool? changedTo;

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: RSwitch(
            value: false,
            onChanged: (v) => changedTo = v,
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey('switch-render')));
      await tester.pump();

      expect(changedTo, isTrue);
    });

    testWidgets('toggling switches between true and false', (tester) async {
      final renderer = _TestSwitchRenderer();
      bool value = false;

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: StatefulBuilder(
            builder: (context, setState) {
              return RSwitch(
                value: value,
                onChanged: (v) => setState(() => value = v),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey('switch-render')));
      await tester.pump();
      expect(value, isTrue);

      await tester.tap(find.byKey(const ValueKey('switch-render')));
      await tester.pump();
      expect(value, isFalse);
    });

    testWidgets('does nothing when disabled (onChanged == null)', (tester) async {
      final renderer = _TestSwitchRenderer();
      var called = false;

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: RSwitch(
            value: false,
            onChanged: (_) => called = true,
          ),
        ),
      );

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: const RSwitch(
            value: false,
            onChanged: null,
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey('switch-render')));
      await tester.pump();

      expect(called, isFalse);
    });

    testWidgets('token resolver receives WidgetState.selected', (tester) async {
      final renderer = _TestSwitchRenderer();
      final resolver = _TestSwitchTokenResolver();

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          tokenResolver: resolver,
          child: const RSwitch(
            value: true,
            onChanged: null,
          ),
        ),
      );

      expect(resolver.lastStates, isNotNull);
      expect(resolver.lastStates!.contains(WidgetState.selected), isTrue);
    });

    testWidgets('autofocus requests focus and resolver receives WidgetState.focused',
        (tester) async {
      final renderer = _TestSwitchRenderer();
      final resolver = _TestSwitchTokenResolver();
      final focusNode = FocusNode(debugLabel: 'test-switch-focus');

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          tokenResolver: resolver,
          child: RSwitch(
            value: false,
            onChanged: (_) {},
            focusNode: focusNode,
            autofocus: true,
          ),
        ),
      );
      await tester.pump();

      expect(focusNode.hasFocus, isTrue);
      expect(resolver.lastStates!.contains(WidgetState.focused), isTrue);
    });

    testWidgets('Tab traversal requests focus when enabled', (tester) async {
      final renderer = _TestSwitchRenderer();
      final resolver = _TestSwitchTokenResolver();
      final focusNode = FocusNode(debugLabel: 'test-switch-focus');

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          tokenResolver: resolver,
          child: RSwitch(
            value: false,
            onChanged: (_) {},
            focusNode: focusNode,
          ),
        ),
      );

      expect(focusNode.hasFocus, isFalse);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isTrue);
      expect(resolver.lastStates!.contains(WidgetState.focused), isTrue);
    });

    testWidgets('Tab traversal skips switch when disabled', (tester) async {
      final renderer = _TestSwitchRenderer();
      final focusNode = FocusNode(debugLabel: 'test-switch-focus');

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: RSwitch(
            value: false,
            onChanged: null,
            focusNode: focusNode,
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isFalse);
    });

    testWidgets('style sugar flows into resolver and affects resolvedTokens',
        (tester) async {
      final renderer = _TestSwitchRenderer();
      final resolver = _TestSwitchTokenResolver();

      const styleColor = Color(0xFF00FF99);

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          tokenResolver: resolver,
          child: const RSwitch(
            value: false,
            onChanged: null,
            style: RSwitchStyle(
              activeTrackColor: styleColor,
            ),
          ),
        ),
      );

      expect(resolver.lastOverrides?.get<RSwitchOverrides>(), isNotNull);
      expect(
          renderer.lastRequest?.resolvedTokens?.activeTrackColor, styleColor);
    });

    testWidgets('explicit overrides win over style sugar (POLA)', (tester) async {
      final renderer = _TestSwitchRenderer();
      final resolver = _TestSwitchTokenResolver();

      const styleColor = Color(0xFF00FF99);
      const overrideColor = Color(0xFFFF0099);

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          tokenResolver: resolver,
          child: const RSwitch(
            value: false,
            onChanged: null,
            style: RSwitchStyle(
              activeTrackColor: styleColor,
            ),
            overrides: RenderOverrides({
              RSwitchOverrides: RSwitchOverrides.tokens(
                activeTrackColor: overrideColor,
              ),
            }),
          ),
        ),
      );

      expect(
          renderer.lastRequest?.resolvedTokens?.activeTrackColor, overrideColor);
    });

    testWidgets('semantics shows toggled state correctly', (tester) async {
      final renderer = _TestSwitchRenderer();

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: const RSwitch(
            value: true,
            semanticLabel: 'Dark mode',
            onChanged: null,
          ),
        ),
      );

      final semantics = tester.getSemantics(find.bySemanticsLabel('Dark mode'));
      expect(SemanticsUtils.hasFlag(semantics, SemanticsFlag.isToggled), isTrue);
    });

    testWidgets('thumbIcon param flows to overrides and wins over style.thumbIcon',
        (tester) async {
      final renderer = _TestSwitchRenderer();
      final resolver = _TestSwitchTokenResolver();

      final paramIcon = WidgetStateProperty.all(const Icon(Icons.check));
      final styleIcon = WidgetStateProperty.all(const Icon(Icons.close));

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          tokenResolver: resolver,
          child: RSwitch(
            value: true,
            onChanged: (_) {},
            thumbIcon: paramIcon,
            style: RSwitchStyle(thumbIcon: styleIcon),
          ),
        ),
      );

      final overrides = resolver.lastOverrides?.get<RSwitchOverrides>();
      expect(overrides?.thumbIcon, same(paramIcon));
    });

    testWidgets('Space key activates switch on key up', (tester) async {
      final renderer = _TestSwitchRenderer();
      bool? changedTo;

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: RSwitch(
            value: false,
            autofocus: true,
            onChanged: (v) => changedTo = v,
          ),
        ),
      );

      await tester.pump();

      // Space key down - should not activate yet
      await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(changedTo, isNull);

      // Space key up - now should activate
      await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(changedTo, isTrue);
    });

    testWidgets('Enter key activates switch immediately', (tester) async {
      final renderer = _TestSwitchRenderer();
      bool? changedTo;

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: RSwitch(
            value: false,
            autofocus: true,
            onChanged: (v) => changedTo = v,
          ),
        ),
      );

      await tester.pump();

      // Enter key down - should activate immediately
      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(changedTo, isTrue);
    });

    testWidgets('semanticLabel set → excludeSemantics is true', (tester) async {
      final renderer = _TestSwitchRenderer();

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: RSwitch(
            value: true,
            onChanged: (_) {},
            semanticLabel: 'Toggle setting',
          ),
        ),
      );

      // Find the Semantics widget with our label
      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Toggle setting',
        ),
      );

      expect(semanticsWidget.excludeSemantics, isTrue);
    });

    testWidgets('semanticLabel null → excludeSemantics is false', (tester) async {
      final renderer = _TestSwitchRenderer();

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: RSwitch(
            value: true,
            onChanged: (_) {},
            // semanticLabel is null
          ),
        ),
      );

      // Find the Semantics widget with toggled property (from RSwitch)
      final semanticsWidget = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.toggled == true,
        ),
      );

      expect(semanticsWidget.excludeSemantics, isFalse);
      expect(semanticsWidget.properties.label, isNull);
    });

    group('drag behavior', () {
      testWidgets('tap toggles switch (coexists with drag)', (tester) async {
        final renderer = _TestSwitchRenderer();
        final resolver = _TestSwitchTokenResolver();
        bool value = false;

        await tester.pumpWidget(
          _buildTestWidget(
            renderer: renderer,
            tokenResolver: resolver,
            child: StatefulBuilder(
              builder: (context, setState) {
                return RSwitch(
                  value: value,
                  onChanged: (v) => setState(() => value = v),
                );
              },
            ),
          ),
        );

        // Tap should still work even with drag support
        await tester.tap(find.byKey(const ValueKey('switch-render')));
        await tester.pumpAndSettle();

        expect(value, isTrue);
      });

      testWidgets('horizontal fling toggles switch from off to on',
          (tester) async {
        final renderer = _TestSwitchRenderer();
        final resolver = _TestSwitchTokenResolver();
        bool value = false;

        await tester.pumpWidget(
          _buildTestWidget(
            renderer: renderer,
            tokenResolver: resolver,
            child: StatefulBuilder(
              builder: (context, setState) {
                return RSwitch(
                  value: value,
                  onChanged: (v) => setState(() => value = v),
                );
              },
            ),
          ),
        );

        // Fling to the right with high velocity
        await tester.fling(
          find.byKey(const ValueKey('switch-render')),
          const Offset(50, 0),
          500,
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(value, isTrue);
      });

      testWidgets('horizontal fling toggles switch from on to off',
          (tester) async {
        final renderer = _TestSwitchRenderer();
        final resolver = _TestSwitchTokenResolver();
        bool value = true;

        await tester.pumpWidget(
          _buildTestWidget(
            renderer: renderer,
            tokenResolver: resolver,
            child: StatefulBuilder(
              builder: (context, setState) {
                return RSwitch(
                  value: value,
                  onChanged: (v) => setState(() => value = v),
                );
              },
            ),
          ),
        );

        // Fling to the left with high velocity
        await tester.fling(
          find.byKey(const ValueKey('switch-render')),
          const Offset(-50, 0),
          500,
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(value, isFalse);
      });

      testWidgets('drag does not work when disabled', (tester) async {
        final renderer = _TestSwitchRenderer();
        final resolver = _TestSwitchTokenResolver();

        await tester.pumpWidget(
          _buildTestWidget(
            renderer: renderer,
            tokenResolver: resolver,
            child: const RSwitch(
              value: false,
              onChanged: null,
            ),
          ),
        );

        await tester.fling(
          find.byKey(const ValueKey('switch-render')),
          const Offset(50, 0),
          500,
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        // Value should not change, switch remains disabled
        expect(renderer.lastRequest?.state.isDisabled, isTrue);
        // Drag state should NOT be set when disabled
        expect(renderer.lastRequest?.state.isDragging, isFalse);
      });

      testWidgets('high velocity fling toggles regardless of position',
          (tester) async {
        final renderer = _TestSwitchRenderer();
        final resolver = _TestSwitchTokenResolver();
        bool value = false;

        await tester.pumpWidget(
          _buildTestWidget(
            renderer: renderer,
            tokenResolver: resolver,
            child: StatefulBuilder(
              builder: (context, setState) {
                return RSwitch(
                  value: value,
                  onChanged: (v) => setState(() => value = v),
                );
              },
            ),
          ),
        );

        // Fast fling to the right (high velocity) even with small distance
        await tester.fling(
          find.byKey(const ValueKey('switch-render')),
          const Offset(30, 0),
          1000,
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(value, isTrue);
      });

      testWidgets('fling in RTL direction works correctly', (tester) async {
        final renderer = _TestSwitchRenderer();
        final resolver = _TestSwitchTokenResolver();
        bool value = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: HeadlessThemeProvider(
                theme: _TestTheme(renderer, tokenResolver: resolver),
                child: Scaffold(
                  body: Center(
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return RSwitch(
                          value: value,
                          onChanged: (v) => setState(() => value = v),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        // In RTL, fling left turns switch on
        await tester.fling(
          find.byKey(const ValueKey('switch-render')),
          const Offset(-50, 0),
          500,
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(value, isTrue);
      });

      testWidgets('spec includes dragStartBehavior', (tester) async {
        final renderer = _TestSwitchRenderer();
        final resolver = _TestSwitchTokenResolver();

        await tester.pumpWidget(
          _buildTestWidget(
            renderer: renderer,
            tokenResolver: resolver,
            child: RSwitch(
              value: false,
              onChanged: (_) {},
              dragStartBehavior: DragStartBehavior.down,
            ),
          ),
        );

        expect(
          renderer.lastRequest?.spec.dragStartBehavior,
          DragStartBehavior.down,
        );
      });
    });
  });
}
