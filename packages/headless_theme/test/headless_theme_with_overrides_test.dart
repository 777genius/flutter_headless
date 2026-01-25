import 'package:flutter_test/flutter_test.dart';
import 'package:headless_theme/headless_theme.dart';

abstract interface class TestCapability {
  String value();
}

final class _TestCapabilityA implements TestCapability {
  _TestCapabilityA(this._value);
  final String _value;

  @override
  String value() => _value;
}

final class _EmptyTheme extends HeadlessTheme {
  const _EmptyTheme();

  @override
  T? capability<T>() => null;
}

final class _ThemeWithCapability extends HeadlessTheme {
  const _ThemeWithCapability(this._capability);
  final TestCapability _capability;

  @override
  T? capability<T>() {
    if (T == TestCapability) return _capability as T;
    return null;
  }
}

void main() {
  group('HeadlessThemeWithOverrides', () {
    test('fallbacks to base when override is missing', () {
      final base = _ThemeWithCapability(_TestCapabilityA('base'));
      final theme = HeadlessThemeWithOverrides(base: base);

      final c = theme.capability<TestCapability>();
      expect(c?.value(), 'base');
    });

    test('override wins over base', () {
      final base = _ThemeWithCapability(_TestCapabilityA('base'));
      final theme = HeadlessThemeWithOverrides(
        base: base,
        overrides: CapabilityOverrides.only<TestCapability>(_TestCapabilityA('override')),
      );

      final c = theme.capability<TestCapability>();
      expect(c?.value(), 'override');
    });

    test('returns null when neither override nor base provides capability', () {
      const base = _EmptyTheme();
      final theme = HeadlessThemeWithOverrides(base: base);

      expect(theme.capability<TestCapability>(), isNull);
    });

    test('merge: other wins (last write wins)', () {
      final a = CapabilityOverrides.only<TestCapability>(_TestCapabilityA('a'));
      final b = CapabilityOverrides.only<TestCapability>(_TestCapabilityA('b'));

      final merged = a.merge(b);
      expect(merged.get<TestCapability>()?.value(), 'b');
    });
  });
}

