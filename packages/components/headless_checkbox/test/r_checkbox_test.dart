import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_checkbox/headless_checkbox.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

class _TestCheckboxTokenResolver implements RCheckboxTokenResolver {
  Set<WidgetState>? lastStates;
  RCheckboxSpec? lastSpec;
  RenderOverrides? lastOverrides;

  @override
  RCheckboxResolvedTokens resolve({
    required BuildContext context,
    required RCheckboxSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    lastStates = states;
    lastSpec = spec;
    lastOverrides = overrides;
    final contractOverrides = overrides?.get<RCheckboxOverrides>();
    final activeColor = contractOverrides?.activeColor ?? Colors.blue;
    return RCheckboxResolvedTokens(
      boxSize: 18,
      borderRadius: BorderRadius.all(Radius.circular(2)),
      borderWidth: 2,
      borderColor: Colors.black,
      activeColor: activeColor,
      inactiveColor: Colors.transparent,
      checkColor: Colors.white,
      indeterminateColor: Colors.white,
      disabledOpacity: 0.38,
      pressOverlayColor: Color(0x1F000000),
      pressOpacity: 1.0,
      minTapTargetSize: Size(48, 48),
      motion: RCheckboxMotionTokens(
          stateChangeDuration: Duration(milliseconds: 120)),
    );
  }
}

class _TestCheckboxRenderer implements RCheckboxRenderer {
  RCheckboxRenderRequest? lastRequest;

  @override
  Widget render(RCheckboxRenderRequest request) {
    lastRequest = request;
    // Render something tappable and easy to find
    return Container(
      key: const ValueKey('checkbox-render'),
      width: 48,
      height: 48,
      color: request.spec.value == true
          ? Colors.green
          : request.spec.value == null
              ? Colors.orange
              : Colors.red,
    );
  }
}

class _TestTheme extends HeadlessTheme {
  _TestTheme(this._renderer, {this.tokenResolver});

  final _TestCheckboxRenderer _renderer;
  final _TestCheckboxTokenResolver? tokenResolver;

  @override
  T? capability<T>() {
    if (T == RCheckboxRenderer) return _renderer as T;
    if (T == RCheckboxTokenResolver) return tokenResolver as T?;
    return null;
  }
}

class _EmptyTheme extends HeadlessTheme {
  const _EmptyTheme();

  @override
  T? capability<T>() => null;
}

Widget _buildTestWidget({
  required _TestCheckboxRenderer renderer,
  required Widget child,
  _TestCheckboxTokenResolver? tokenResolver,
}) {
  return MaterialApp(
    home: HeadlessThemeProvider(
      theme: _TestTheme(renderer, tokenResolver: tokenResolver),
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('RCheckbox', () {
    testWidgets(
        'throws MissingCapabilityException when no renderer is provided',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HeadlessThemeProvider(
            theme: _EmptyTheme(),
            child: Scaffold(
              body: Center(
                child: RCheckbox(
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
      final renderer = _TestCheckboxRenderer();

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: const RCheckbox(
            value: true,
            tristate: true,
            isError: true,
            semanticLabel: 'Test label',
            onChanged: null,
          ),
        ),
      );

      final spec = renderer.lastRequest?.spec;
      expect(spec, isNotNull);
      expect(spec!.value, isTrue);
      expect(spec.tristate, isTrue);
      expect(spec.isError, isTrue);
      expect(spec.semanticLabel, 'Test label');
    });

    testWidgets('passes slots to renderer', (tester) async {
      final renderer = _TestCheckboxRenderer();
      final slots = RCheckboxSlots(
        box: Replace((ctx) => const SizedBox(key: ValueKey('slot-box'))),
      );

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: RCheckbox(
            value: false,
            onChanged: (_) {},
            slots: slots,
          ),
        ),
      );

      expect(renderer.lastRequest?.slots, same(slots));
    });

    testWidgets('tap calls onChanged with next value (non-tristate)',
        (tester) async {
      final renderer = _TestCheckboxRenderer();
      bool? changedTo;

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: RCheckbox(
            value: false,
            onChanged: (v) => changedTo = v,
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey('checkbox-render')));
      await tester.pump();

      expect(changedTo, isTrue);
    });

    testWidgets('tristate cycles false -> true -> null -> false',
        (tester) async {
      final renderer = _TestCheckboxRenderer();
      bool? value = false;

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: StatefulBuilder(
            builder: (context, setState) {
              return RCheckbox(
                value: value,
                tristate: true,
                onChanged: (v) => setState(() => value = v),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey('checkbox-render')));
      await tester.pump();
      expect(value, isTrue);

      await tester.tap(find.byKey(const ValueKey('checkbox-render')));
      await tester.pump();
      expect(value, isNull);

      await tester.tap(find.byKey(const ValueKey('checkbox-render')));
      await tester.pump();
      expect(value, isFalse);
    });

    testWidgets('does nothing when disabled (onChanged == null)',
        (tester) async {
      final renderer = _TestCheckboxRenderer();
      var called = false;

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: RCheckbox(
            value: false,
            onChanged: (_) => called = true,
          ),
        ),
      );

      // Disable by rebuilding with onChanged null
      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          child: const RCheckbox(
            value: false,
            onChanged: null,
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey('checkbox-render')));
      await tester.pump();

      expect(called, isFalse);
    });

    testWidgets('token resolver receives WidgetState.selected/error',
        (tester) async {
      final renderer = _TestCheckboxRenderer();
      final resolver = _TestCheckboxTokenResolver();

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          tokenResolver: resolver,
          child: const RCheckbox(
            value: true,
            isError: true,
            onChanged: null,
          ),
        ),
      );

      expect(resolver.lastStates, isNotNull);
      expect(resolver.lastStates!.contains(WidgetState.selected), isTrue);
      expect(resolver.lastStates!.contains(WidgetState.error), isTrue);
    });

    testWidgets('style sugar flows into resolver and affects resolvedTokens',
        (tester) async {
      final renderer = _TestCheckboxRenderer();
      final resolver = _TestCheckboxTokenResolver();

      const styleColor = Color(0xFF00FF99);

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          tokenResolver: resolver,
          child: const RCheckbox(
            value: false,
            onChanged: null,
            style: RCheckboxStyle(
              activeColor: styleColor,
            ),
          ),
        ),
      );

      expect(resolver.lastOverrides?.get<RCheckboxOverrides>(), isNotNull);
      expect(renderer.lastRequest?.resolvedTokens?.activeColor, styleColor);
    });

    testWidgets('explicit overrides win over style sugar (POLA)',
        (tester) async {
      final renderer = _TestCheckboxRenderer();
      final resolver = _TestCheckboxTokenResolver();

      const styleColor = Color(0xFF00FF99);
      const overrideColor = Color(0xFFFF0099);

      await tester.pumpWidget(
        _buildTestWidget(
          renderer: renderer,
          tokenResolver: resolver,
          child: const RCheckbox(
            value: false,
            onChanged: null,
            style: RCheckboxStyle(
              activeColor: styleColor,
            ),
            overrides: RenderOverrides({
              RCheckboxOverrides: RCheckboxOverrides.tokens(
                activeColor: overrideColor,
              ),
            }),
          ),
        ),
      );

      expect(renderer.lastRequest?.resolvedTokens?.activeColor, overrideColor);
    });
  });
}
