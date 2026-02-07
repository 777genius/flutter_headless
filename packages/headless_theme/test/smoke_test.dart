import 'package:flutter_test/flutter_test.dart';
import 'package:headless_theme/headless_theme.dart';

class _TestTheme extends HeadlessTheme {
  const _TestTheme();

  @override
  T? capability<T>() => null;
}

void main() {
  test('smoke', () {
    expect(const _TestTheme().capability<Object>(), isNull);
  });
}
