import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';

void main() {
  group('HeadlessItemFeatures.merge', () {
    const stringKey = HeadlessFeatureKey<String>(#testString);
    const intKey = HeadlessFeatureKey<int>(#testInt);
    const boolKey = HeadlessFeatureKey<bool>(#testBool);

    test('merge empty with non-empty returns non-empty', () {
      final features = HeadlessItemFeatures.build((b) {
        b.set(stringKey, 'hello');
      });

      final result = HeadlessItemFeatures.empty.merge(features);

      expect(result, same(features));
    });

    test('merge non-empty with empty returns non-empty', () {
      final features = HeadlessItemFeatures.build((b) {
        b.set(stringKey, 'hello');
      });

      final result = features.merge(HeadlessItemFeatures.empty);

      expect(result, same(features));
    });

    test('merge combines non-overlapping keys', () {
      final features1 = HeadlessItemFeatures.build((b) {
        b.set(stringKey, 'hello');
      });

      final features2 = HeadlessItemFeatures.build((b) {
        b.set(intKey, 42);
      });

      final result = features1.merge(features2);

      expect(result.get(stringKey), equals('hello'));
      expect(result.get(intKey), equals(42));
    });

    test('merge overwrites with other value on collision', () {
      final features1 = HeadlessItemFeatures.build((b) {
        b.set(stringKey, 'hello');
      });

      final features2 = HeadlessItemFeatures.build((b) {
        b.set(stringKey, 'world');
      });

      final result = features1.merge(features2);

      expect(result.get(stringKey), equals('world'));
    });

    test('merge preserves all keys from both sources', () {
      final features1 = HeadlessItemFeatures.build((b) {
        b.set(stringKey, 'hello');
        b.set(intKey, 1);
      });

      final features2 = HeadlessItemFeatures.build((b) {
        b.set(intKey, 2);
        b.set(boolKey, true);
      });

      final result = features1.merge(features2);

      expect(result.get(stringKey), equals('hello'));
      expect(result.get(intKey), equals(2));
      expect(result.get(boolKey), isTrue);
    });

    test('merge does not modify original instances', () {
      final features1 = HeadlessItemFeatures.build((b) {
        b.set(stringKey, 'hello');
      });

      final features2 = HeadlessItemFeatures.build((b) {
        b.set(intKey, 42);
      });

      features1.merge(features2);

      expect(features1.get(intKey), isNull);
      expect(features2.get(stringKey), isNull);
    });

    test('has method works correctly', () {
      final features = HeadlessItemFeatures.build((b) {
        b.set(stringKey, 'hello');
      });

      expect(features.has(stringKey), isTrue);
      expect(features.has(intKey), isFalse);
    });
  });
}
