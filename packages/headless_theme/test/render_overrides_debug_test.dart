import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';

final class _TestOverride {
  const _TestOverride();
}

void main() {
  test('debugTrack records consumed types via get<T>()', () {
    final base = RenderOverrides.only(const _TestOverride());
    final tracker = RenderOverridesDebugTracker();
    final tracked = RenderOverrides.debugTrack(base, tracker);

    final value = tracked.get<_TestOverride>();
    expect(value, isNotNull);

    expect(tracker.consumed, contains(_TestOverride));
    expect(tracked.debugProvidedTypes(), contains(_TestOverride));
    expect(tracked.debugConsumedTypes(), contains(_TestOverride));
  });

  test('debugConsumedTypes is empty before any get<T>()', () {
    final base = RenderOverrides.only(const _TestOverride());
    final tracker = RenderOverridesDebugTracker();
    final tracked = RenderOverrides.debugTrack(base, tracker);

    expect(tracked.debugConsumedTypes(), isEmpty);
    expect(tracked.debugProvidedTypes(), contains(_TestOverride));
  });
}
