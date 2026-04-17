import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Matcher hasVerticalCenterNear(
  Offset expected, {
  double tolerance = 1.0,
}) {
  return predicate<Rect>(
    (rect) => (rect.center.dy - expected.dy).abs() <= tolerance,
    'has center.dy within $tolerance of ${expected.dy}',
  );
}
