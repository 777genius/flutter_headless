import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';

void main() {
  group('HeadlessRequestFeatures', () {
    const stringKey = HeadlessFeatureKey<String>(#testString);
    const intKey = HeadlessFeatureKey<int>(#testInt);
    const boolKey = HeadlessFeatureKey<bool>(#testBool);

    test('empty returns empty instance', () {
      expect(HeadlessRequestFeatures.empty.isEmpty, isTrue);
      expect(HeadlessRequestFeatures.empty.isNotEmpty, isFalse);
    });

    test('build creates features with values', () {
      final features = HeadlessRequestFeatures.build((b) {
        b.set(stringKey, 'hello');
        b.set(intKey, 42);
      });

      expect(features.isEmpty, isFalse);
      expect(features.isNotEmpty, isTrue);
    });

    test('get returns value for existing key', () {
      final features = HeadlessRequestFeatures.build((b) {
        b.set(stringKey, 'hello');
        b.set(intKey, 42);
      });

      expect(features.get(stringKey), equals('hello'));
      expect(features.get(intKey), equals(42));
    });

    test('get returns null for non-existent key', () {
      final features = HeadlessRequestFeatures.build((b) {
        b.set(stringKey, 'hello');
      });

      expect(features.get(intKey), isNull);
      expect(features.get(boolKey), isNull);
    });

    test('has returns true for existing key', () {
      final features = HeadlessRequestFeatures.build((b) {
        b.set(stringKey, 'hello');
      });

      expect(features.has(stringKey), isTrue);
      expect(features.has(intKey), isFalse);
    });

    test('build with no values returns empty', () {
      final features = HeadlessRequestFeatures.build((b) {});

      expect(features, same(HeadlessRequestFeatures.empty));
    });

    test('equality works correctly', () {
      final features1 = HeadlessRequestFeatures.build((b) {
        b.set(stringKey, 'hello');
        b.set(intKey, 42);
      });

      final features2 = HeadlessRequestFeatures.build((b) {
        b.set(stringKey, 'hello');
        b.set(intKey, 42);
      });

      final features3 = HeadlessRequestFeatures.build((b) {
        b.set(stringKey, 'world');
        b.set(intKey, 42);
      });

      expect(features1, equals(features2));
      expect(features1.hashCode, equals(features2.hashCode));
      expect(features1, isNot(equals(features3)));
    });

    test('empty instances are equal', () {
      final empty1 = HeadlessRequestFeatures.empty;
      final empty2 = HeadlessRequestFeatures.build((b) {});

      expect(empty1, equals(empty2));
    });

    test('toString provides readable output', () {
      expect(
        HeadlessRequestFeatures.empty.toString(),
        equals('HeadlessRequestFeatures.empty'),
      );

      final features = HeadlessRequestFeatures.build((b) {
        b.set(stringKey, 'test');
      });
      expect(features.toString(), contains('HeadlessRequestFeatures'));
    });
  });

  group('HeadlessFeatureKey', () {
    test('keys with same id are equal', () {
      const key1 = HeadlessFeatureKey<String>(#myKey);
      const key2 = HeadlessFeatureKey<String>(#myKey);

      expect(key1, equals(key2));
      expect(key1.hashCode, equals(key2.hashCode));
    });

    test('keys with different ids are not equal', () {
      const key1 = HeadlessFeatureKey<String>(#keyA);
      const key2 = HeadlessFeatureKey<String>(#keyB);

      expect(key1, isNot(equals(key2)));
    });

    test('toString uses debugName when provided', () {
      const keyWithName = HeadlessFeatureKey<String>(#test, debugName: 'TestKey');
      const keyWithoutName = HeadlessFeatureKey<String>(#test);

      expect(keyWithName.toString(), equals('TestKey'));
      expect(keyWithoutName.toString(), equals('Symbol("test")'));
    });
  });
}
