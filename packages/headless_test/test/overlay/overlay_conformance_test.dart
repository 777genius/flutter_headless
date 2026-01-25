import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_test/headless_test.dart';

void main() {
  // This test file validates the conformance suite itself against the real
  // headless_foundation overlay primitives.
  overlayFoundationConformance(
    suiteName: 'headless_foundation',
    wrapApp: (child) => Directionality(
      textDirection: TextDirection.ltr,
      child: child,
    ),
  );

  test('smoke: overlay conformance registered', () {
    expect(true, isTrue);
  });
}

