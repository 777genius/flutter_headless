import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_theme/headless_theme.dart';

abstract interface class TestCapability {
  int get id;
}

final class _TestCapability implements TestCapability {
  _TestCapability(this.id);

  @override
  final int id;
}

final class _BaseTheme extends HeadlessTheme {
  const _BaseTheme(this._capability);
  final TestCapability _capability;

  @override
  T? capability<T>() {
    if (T == TestCapability) return _capability as T;
    return null;
  }
}

void main() {
  testWidgets('override wins over base in subtree', (tester) async {
    final base = _BaseTheme(_TestCapability(1));
    final override = _TestCapability(2);

    late int seenId;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: HeadlessThemeProvider(
          theme: base,
          child: HeadlessThemeOverridesScope.only<TestCapability>(
            capability: override,
            child: Builder(
              builder: (context) {
                final theme = HeadlessThemeProvider.themeOf(context);
                final c = theme.capability<TestCapability>();
                seenId = c!.id;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );

    expect(seenId, 2);
  });

  testWidgets('wrapper theme instance stays stable when inputs are stable',
      (tester) async {
    final base = _BaseTheme(_TestCapability(1));
    final overrides =
        CapabilityOverrides.only<TestCapability>(_TestCapability(2));

    HeadlessTheme? firstTheme;
    HeadlessTheme? secondTheme;
    var buildCount = 0;

    await tester.pumpWidget(
      _Harness(
        childBuilder: (tick) {
          return HeadlessThemeProvider(
            theme: base,
            child: HeadlessThemeOverridesScope(
              key: const ValueKey('scope'),
              overrides: overrides,
              child: Builder(
                key: ValueKey('read-theme-$tick'),
                builder: (context) {
                  final theme = HeadlessThemeProvider.themeOf(context);
                  buildCount++;
                  if (buildCount == 1) {
                    firstTheme = theme;
                  } else {
                    secondTheme = theme;
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        },
      ),
    );

    // Trigger a rebuild above the scope without changing base or overrides.
    await tester.tap(find.byKey(_Harness.rebuildKey));
    await tester.pump();

    expect(firstTheme, isNotNull);
    expect(secondTheme, isNotNull);
    expect(identical(firstTheme, secondTheme), isTrue);
  });
}

class _Harness extends StatefulWidget {
  const _Harness({required this.childBuilder});
  final Widget Function(int tick) childBuilder;

  static const rebuildKey = Key('harness-rebuild');

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  int _tick = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.childBuilder(_tick),
          GestureDetector(
            key: _Harness.rebuildKey,
            onTap: () => setState(() => _tick++),
            child: Text('$_tick'),
          ),
        ],
      ),
    );
  }
}
