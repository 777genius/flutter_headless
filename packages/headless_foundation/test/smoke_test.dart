import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';

void main() {
  test('smoke', () {
    expect(OverlayPhase.open, OverlayPhase.open);
  });
}
