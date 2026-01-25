import 'package:flutter_test/flutter_test.dart';
import 'package:headless_autocomplete/src/logic/autocomplete_combiner.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_item_features.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_policies.dart';
import 'package:headless_foundation/headless_foundation.dart';

void main() {
  group('AutocompleteCombiner', () {
    late HeadlessItemAdapter<String> adapter;

    setUp(() {
      adapter = HeadlessItemAdapter<String>(
        id: (item) => ListboxItemId(item),
        primaryText: (item) => item,
      );
    });

    test('concatenates without deduplication when dedupeById is false', () {
      final combiner = AutocompleteCombiner<String>(
        itemAdapter: adapter,
        policy: const RAutocompleteCombinePolicy(dedupeById: false),
      );

      final result = combiner.combine(
        local: ['a', 'b'],
        remote: ['b', 'c'],
      );

      expect(result.combined, ['a', 'b', 'b', 'c']);
      expect(result.withFeatures.length, 4);
      expect(
        result.withFeatures[0].$2.get(rAutocompleteItemSourceKey),
        RAutocompleteItemSource.local,
      );
      expect(
        result.withFeatures[3].$2.get(rAutocompleteItemSourceKey),
        RAutocompleteItemSource.remote,
      );
      expect(result.localCount, 2);
      expect(result.remoteCount, 2);
    });

    test('deduplicates by ID preferring local', () {
      final combiner = AutocompleteCombiner<String>(
        itemAdapter: adapter,
        policy: const RAutocompleteCombinePolicy(
          dedupeById: true,
          dedupePreference: RAutocompleteDedupePreference.preferLocal,
        ),
      );

      final result = combiner.combine(
        local: ['a', 'b'],
        remote: ['b', 'c'],
      );

      expect(result.combined, ['a', 'b', 'c']);
      expect(result.withFeatures.length, 3);
      expect(
        result.withFeatures[1].$2.get(rAutocompleteItemSourceKey),
        RAutocompleteItemSource.local,
      );
      expect(result.localCount, 2);
      expect(result.remoteCount, 1);
    });

    test('deduplicates by ID preferring remote', () {
      final combiner = AutocompleteCombiner<String>(
        itemAdapter: adapter,
        policy: const RAutocompleteCombinePolicy(
          dedupeById: true,
          dedupePreference: RAutocompleteDedupePreference.preferRemote,
        ),
      );

      final result = combiner.combine(
        local: ['a', 'b'],
        remote: ['b', 'c'],
      );

      expect(result.combined, ['b', 'c', 'a']);
      expect(result.withFeatures.length, 3);
      expect(
        result.withFeatures.first.$2.get(rAutocompleteItemSourceKey),
        RAutocompleteItemSource.remote,
      );
      expect(result.localCount, 1);
      expect(result.remoteCount, 2);
    });

    test('returns only local when remoteOnlyWhenLocalEmpty and local not empty', () {
      final combiner = AutocompleteCombiner<String>(
        itemAdapter: adapter,
        policy: const RAutocompleteCombinePolicy(
          remoteOnlyWhenLocalEmpty: true,
        ),
      );

      final result = combiner.combine(
        local: ['a', 'b'],
        remote: ['c', 'd'],
      );

      expect(result.combined, ['a', 'b']);
      expect(result.withFeatures.length, 2);
      expect(result.localCount, 2);
      expect(result.remoteCount, 0);
    });

    test('returns remote when remoteOnlyWhenLocalEmpty and local is empty', () {
      final combiner = AutocompleteCombiner<String>(
        itemAdapter: adapter,
        policy: const RAutocompleteCombinePolicy(
          remoteOnlyWhenLocalEmpty: true,
          dedupeById: false,
        ),
      );

      final result = combiner.combine(
        local: [],
        remote: ['c', 'd'],
      );

      expect(result.combined, ['c', 'd']);
      expect(result.withFeatures.length, 2);
      expect(result.localCount, 0);
      expect(result.remoteCount, 2);
    });

    test('showSections marks section IDs for local and remote', () {
      final combiner = AutocompleteCombiner<String>(
        itemAdapter: adapter,
        policy: const RAutocompleteCombinePolicy(
          showSections: true,
          dedupeById: false,
        ),
      );

      final result = combiner.combine(
        local: ['a'],
        remote: ['b'],
      );

      expect(result.withFeatures.length, 2);
      expect(
        result.withFeatures.first.$2.get(rAutocompleteSectionIdKey),
        RAutocompleteSectionId.local,
      );
      expect(
        result.withFeatures.last.$2.get(rAutocompleteSectionIdKey),
        RAutocompleteSectionId.remote,
      );
    });

    test('createItemFeatures creates features with source', () {
      final combiner = AutocompleteCombiner<String>(
        itemAdapter: adapter,
        policy: const RAutocompleteCombinePolicy(),
      );

      final features = combiner.createItemFeatures(
        source: RAutocompleteItemSource.local,
      );

      expect(
        features.get(rAutocompleteItemSourceKey),
        RAutocompleteItemSource.local,
      );
    });

    test('createItemFeatures includes section ID when provided', () {
      final combiner = AutocompleteCombiner<String>(
        itemAdapter: adapter,
        policy: const RAutocompleteCombinePolicy(),
      );

      const sectionId = RAutocompleteSectionId('test-section');
      final features = combiner.createItemFeatures(
        source: RAutocompleteItemSource.remote,
        sectionId: sectionId,
      );

      expect(
        features.get(rAutocompleteItemSourceKey),
        RAutocompleteItemSource.remote,
      );
      expect(
        features.get(rAutocompleteSectionIdKey),
        sectionId,
      );
    });

    test('markWithSource returns items with features', () {
      final combiner = AutocompleteCombiner<String>(
        itemAdapter: adapter,
        policy: const RAutocompleteCombinePolicy(),
      );

      final marked = combiner.markWithSource(
        items: ['a', 'b'],
        source: RAutocompleteItemSource.local,
      );

      expect(marked.length, 2);
      expect(marked[0].$1, 'a');
      expect(
        marked[0].$2.get(rAutocompleteItemSourceKey),
        RAutocompleteItemSource.local,
      );
    });
  });
}
