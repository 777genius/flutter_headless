import 'package:flutter_test/flutter_test.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_policies.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_source.dart';

void main() {
  group('RAutocompleteLocalSource', () {
    test('creates with options builder', () {
      final source = RAutocompleteLocalSource<String>(
        options: (text) => ['a', 'b', 'c'].where((s) => s.contains(text.text)),
      );

      expect(source, isA<RAutocompleteSource<String>>());
      expect(source.policy, isNotNull);
    });

    test('creates with custom policy', () {
      const customPolicy = RAutocompleteLocalPolicy(
        query: RAutocompleteQueryPolicy(minQueryLength: 2),
        cache: false,
      );

      final source = RAutocompleteLocalSource<String>(
        options: (_) => [],
        policy: customPolicy,
      );

      expect(source.policy.query.minQueryLength, 2);
      expect(source.policy.cache, isFalse);
    });

    test('options builder receives TextEditingValue', () {
      TextEditingValue? receivedValue;

      final source = RAutocompleteLocalSource<String>(
        options: (text) {
          receivedValue = text;
          return ['result'];
        },
      );

      const testValue = TextEditingValue(text: 'test');
      final results = source.options(testValue).toList();

      expect(receivedValue, testValue);
      expect(results, ['result']);
    });

    test('filters options based on text', () {
      final fruits = ['apple', 'apricot', 'banana', 'blueberry'];

      final source = RAutocompleteLocalSource<String>(
        options: (text) => fruits.where((f) => f.startsWith(text.text)),
      );

      final aResults = source.options(const TextEditingValue(text: 'a')).toList();
      expect(aResults, ['apple', 'apricot']);

      final bResults = source.options(const TextEditingValue(text: 'b')).toList();
      expect(bResults, ['banana', 'blueberry']);
    });
  });

  group('RAutocompleteRemoteSource', () {
    test('creates with load function and default policy', () {
      final source = RAutocompleteRemoteSource<String>(
        load: (_) async => ['result'],
      );

      expect(source, isA<RAutocompleteSource<String>>());
      expect(source.policy, isNotNull);
      expect(source.policy.debounce, const Duration(milliseconds: 200));
    });

    test('creates with custom policy', () {
      final source = RAutocompleteRemoteSource<String>(
        load: (_) async => [],
        policy: const RAutocompleteRemotePolicy(
          query: RAutocompleteQueryPolicy(minQueryLength: 3),
          debounce: Duration(milliseconds: 500),
          loadOnFocus: true,
        ),
      );

      expect(source.policy.query.minQueryLength, 3);
      expect(source.policy.debounce, const Duration(milliseconds: 500));
      expect(source.policy.loadOnFocus, isTrue);
    });
  });

  group('RAutocompleteHybridSource', () {
    test('creates with local and remote sources', () {
      final local = RAutocompleteLocalSource<String>(
        options: (_) => ['local'],
      );

      final remote = RAutocompleteRemoteSource<String>(
        load: (_) async => ['remote'],
      );

      final source = RAutocompleteHybridSource<String>(
        local: local,
        remote: remote,
      );

      expect(source, isA<RAutocompleteSource<String>>());
      expect(source.local, local);
      expect(source.remote, remote);
    });

    test('creates with custom combine policy', () {
      const combinePolicy = RAutocompleteCombinePolicy(
        showSections: false,
        dedupeById: false,
        remoteOnlyWhenLocalEmpty: true,
      );

      final source = RAutocompleteHybridSource<String>(
        local: RAutocompleteLocalSource<String>(options: (_) => []),
        remote: RAutocompleteRemoteSource<String>(load: (_) async => []),
        combine: combinePolicy,
      );

      expect(source.combine.showSections, isFalse);
      expect(source.combine.dedupeById, isFalse);
      expect(source.combine.remoteOnlyWhenLocalEmpty, isTrue);
    });
  });

  group('RAutocompleteQueryPolicy', () {
    test('normalize trims whitespace by default', () {
      const policy = RAutocompleteQueryPolicy();

      expect(policy.normalize('  test  '), 'test');
    });

    test('normalize does not trim when disabled', () {
      const policy = RAutocompleteQueryPolicy(trimWhitespace: false);

      expect(policy.normalize('  test  '), '  test  ');
    });

    test('normalize returns null when below minQueryLength', () {
      const policy = RAutocompleteQueryPolicy(minQueryLength: 3);

      expect(policy.normalize('ab'), isNull);
      expect(policy.normalize('abc'), 'abc');
    });

    test('normalize considers trimmed length for minQueryLength', () {
      const policy = RAutocompleteQueryPolicy(
        minQueryLength: 3,
        trimWhitespace: true,
      );

      expect(policy.normalize('  ab  '), isNull);
      expect(policy.normalize('  abc  '), 'abc');
    });
  });

  group('RAutocompleteRemoteCachePolicy', () {
    test('none factory creates RAutocompleteRemoteCacheNone', () {
      const policy = RAutocompleteRemoteCachePolicy.none();

      expect(policy, isA<RAutocompleteRemoteCacheNone>());
    });

    test('lastSuccessfulPerQuery factory creates cache policy', () {
      const policy = RAutocompleteRemoteCachePolicy.lastSuccessfulPerQuery();

      expect(policy, isA<RAutocompleteRemoteCacheLastSuccessfulPerQuery>());
    });

    test('lastSuccessfulPerQuery has configurable maxEntries', () {
      const policy = RAutocompleteRemoteCachePolicy.lastSuccessfulPerQuery(
        maxEntries: 100,
      );

      expect(
        (policy as RAutocompleteRemoteCacheLastSuccessfulPerQuery).maxEntries,
        100,
      );
    });
  });
}
