import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_checkbox/headless_checkbox.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';
import 'package:headless_foundation/headless_foundation.dart';

class _TestCheckboxRenderer implements RCheckboxRenderer {
  RCheckboxRenderRequest? lastRequest;
  int renderCount = 0;

  @override
  Widget render(RCheckboxRenderRequest request) {
    lastRequest = request;
    renderCount++;
    return const SizedBox(
      key: ValueKey('checkbox-indicator'),
      width: 18,
      height: 18,
    );
  }
}

class _TestListTileRenderer implements RCheckboxListTileRenderer {
  RCheckboxListTileRenderRequest? lastRequest;

  @override
  Widget render(RCheckboxListTileRenderRequest request) {
    lastRequest = request;
    return SizedBox(
      key: const ValueKey('checkbox-list-tile'),
      width: 200,
      height: 48,
      child: Row(
        children: [
          request.checkbox,
          request.title,
        ],
      ),
    );
  }
}

class _TestListTileTokenResolver implements RCheckboxListTileTokenResolver {
  Set<WidgetState>? lastStates;
  RenderOverrides? lastOverrides;

  @override
  RCheckboxListTileResolvedTokens resolve({
    required BuildContext context,
    required RCheckboxListTileSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    lastStates = states;
    lastOverrides = overrides;
    final contractOverrides = overrides?.get<RCheckboxListTileOverrides>();
    final minHeight = contractOverrides?.minHeight ?? 56;
    return RCheckboxListTileResolvedTokens(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minHeight: minHeight,
      horizontalGap: 16,
      verticalGap: 4,
      titleStyle: TextStyle(fontSize: 16),
      subtitleStyle: TextStyle(fontSize: 14),
      disabledOpacity: 1.0,
      pressOverlayColor: Color(0x1F000000),
      pressOpacity: 1.0,
      motion: RCheckboxListTileMotionTokens(
        stateChangeDuration: Duration(milliseconds: 120),
      ),
    );
  }
}

class _TestCheckboxTokenResolver implements RCheckboxTokenResolver {
  Set<WidgetState>? lastStates;

  @override
  RCheckboxResolvedTokens resolve({
    required BuildContext context,
    required RCheckboxSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    lastStates = states;
    return const RCheckboxResolvedTokens(
      boxSize: 18,
      borderRadius: BorderRadius.all(Radius.circular(2)),
      borderWidth: 2,
      borderColor: Colors.black,
      activeColor: Colors.blue,
      inactiveColor: Colors.transparent,
      checkColor: Colors.white,
      indeterminateColor: Colors.white,
      disabledOpacity: 0.38,
      pressOverlayColor: Color(0x1F000000),
      pressOpacity: 1.0,
      minTapTargetSize: Size(48, 48),
      motion: RCheckboxMotionTokens(stateChangeDuration: Duration(milliseconds: 120)),
    );
  }
}

class _TestTheme extends HeadlessTheme {
  _TestTheme({
    required this.checkboxRenderer,
    required this.listTileRenderer,
    this.checkboxTokenResolver,
    this.listTileTokenResolver,
  });

  final _TestCheckboxRenderer checkboxRenderer;
  final _TestListTileRenderer listTileRenderer;
  final _TestCheckboxTokenResolver? checkboxTokenResolver;
  final _TestListTileTokenResolver? listTileTokenResolver;

  @override
  T? capability<T>() {
    if (T == RCheckboxRenderer) return checkboxRenderer as T;
    if (T == RCheckboxListTileRenderer) return listTileRenderer as T;
    if (T == RCheckboxTokenResolver) return checkboxTokenResolver as T?;
    if (T == RCheckboxListTileTokenResolver) return listTileTokenResolver as T?;
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
  group('RCheckboxListTile', () {
    testWidgets('throws MissingCapabilityException when no renderer is provided',
        (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          theme: const _EmptyTheme(),
          child: const RCheckboxListTile(
            value: false,
            onChanged: null,
            title: Text('Title'),
          ),
        ),
      );

      expect(tester.takeException(), isA<MissingCapabilityException>());
    });

    testWidgets('passes spec to renderer', (tester) async {
      final checkboxRenderer = _TestCheckboxRenderer();
      final listTileRenderer = _TestListTileRenderer();

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            checkboxRenderer: checkboxRenderer,
            listTileRenderer: listTileRenderer,
          ),
          child: const RCheckboxListTile(
            value: true,
            onChanged: null,
            tristate: true,
            isError: true,
            isThreeLine: true,
            dense: true,
            selected: true,
            selectedColor: Color(0xFF123456),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            semanticLabel: 'Tile label',
            controlAffinity: RCheckboxControlAffinity.trailing,
            title: Text('Title'),
            subtitle: Text('Subtitle'),
          ),
        ),
      );

      final spec = listTileRenderer.lastRequest?.spec;
      expect(spec, isNotNull);
      expect(spec!.value, isTrue);
      expect(spec.tristate, isTrue);
      expect(spec.isError, isTrue);
      expect(spec.isThreeLine, isTrue);
      expect(spec.dense, isTrue);
      expect(spec.selected, isTrue);
      expect(spec.selectedColor, const Color(0xFF123456));
      expect(spec.contentPadding, const EdgeInsets.symmetric(horizontal: 20));
      expect(spec.hasSubtitle, isTrue);
      expect(spec.semanticLabel, 'Tile label');
      expect(spec.controlAffinity, RCheckboxControlAffinity.trailing);
    });

    testWidgets('tap calls onChanged with next value', (tester) async {
      final checkboxRenderer = _TestCheckboxRenderer();
      final listTileRenderer = _TestListTileRenderer();
      bool? changedTo;

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            checkboxRenderer: checkboxRenderer,
            listTileRenderer: listTileRenderer,
          ),
          child: RCheckboxListTile(
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

    testWidgets('checkbox indicator renderer is used', (tester) async {
      final checkboxRenderer = _TestCheckboxRenderer();
      final listTileRenderer = _TestListTileRenderer();

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            checkboxRenderer: checkboxRenderer,
            listTileRenderer: listTileRenderer,
          ),
          child: const RCheckboxListTile(
            value: false,
            onChanged: null,
            title: Text('Title'),
          ),
        ),
      );

      expect(checkboxRenderer.renderCount, 1);
      expect(find.byKey(const ValueKey('checkbox-indicator')), findsOneWidget);
    });

    testWidgets('token resolver receives WidgetState.selected/error', (tester) async {
      final checkboxRenderer = _TestCheckboxRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final checkboxResolver = _TestCheckboxTokenResolver();
      final listTileResolver = _TestListTileTokenResolver();

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            checkboxRenderer: checkboxRenderer,
            listTileRenderer: listTileRenderer,
            checkboxTokenResolver: checkboxResolver,
            listTileTokenResolver: listTileResolver,
          ),
          child: const RCheckboxListTile(
            value: true,
            selected: true,
            isError: true,
            onChanged: null,
            title: Text('Title'),
          ),
        ),
      );

      expect(listTileResolver.lastStates, isNotNull);
      expect(listTileResolver.lastStates!.contains(WidgetState.selected), isTrue);
      expect(listTileResolver.lastStates!.contains(WidgetState.error), isTrue);

      expect(checkboxResolver.lastStates, isNotNull);
      expect(checkboxResolver.lastStates!.contains(WidgetState.selected), isTrue);
      expect(checkboxResolver.lastStates!.contains(WidgetState.error), isTrue);
    });

    testWidgets('style sugar flows into resolver and affects resolvedTokens',
        (tester) async {
      final checkboxRenderer = _TestCheckboxRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final listTileResolver = _TestListTileTokenResolver();

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            checkboxRenderer: checkboxRenderer,
            listTileRenderer: listTileRenderer,
            listTileTokenResolver: listTileResolver,
          ),
          child: const RCheckboxListTile(
            value: false,
            onChanged: null,
            style: RCheckboxListTileStyle(
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

    testWidgets('explicit overrides win over style sugar (POLA)', (tester) async {
      final checkboxRenderer = _TestCheckboxRenderer();
      final listTileRenderer = _TestListTileRenderer();
      final listTileResolver = _TestListTileTokenResolver();

      await tester.pumpWidget(
        _buildTestWidget(
          theme: _TestTheme(
            checkboxRenderer: checkboxRenderer,
            listTileRenderer: listTileRenderer,
            listTileTokenResolver: listTileResolver,
          ),
          child: const RCheckboxListTile(
            value: false,
            onChanged: null,
            style: RCheckboxListTileStyle(
              minHeight: 72,
            ),
            overrides: RenderOverrides({
              RCheckboxListTileOverrides: RCheckboxListTileOverrides.tokens(
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
  });
}

