import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:headless_autocomplete/src/logic/autocomplete_source_controller.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_item_features.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_policies.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_remote_query.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_remote_state.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_source.dart';
import 'package:headless_foundation/headless_foundation.dart';

void main() {
  group('AutocompleteSourceController', () {
    late HeadlessItemAdapter<String> adapter;

    setUp(() {
      adapter = HeadlessItemAdapter<String>(
        id: (item) => ListboxItemId(item),
        primaryText: (item) => item,
      );
    });

    group('local source', () {
      test('marks items with local source feature', () {
        var stateChangedCount = 0;

        final controller = AutocompleteSourceController<String>(
          source: RAutocompleteLocalSource<String>(
            options: (text) => ['apple', 'apricot'].where(
              (item) => item.contains(text.text),
            ),
          ),
          itemAdapter: adapter,
          onStateChanged: () => stateChangedCount++,
        );

        controller.resolve(
          text: const TextEditingValue(text: 'ap'),
          trigger: RAutocompleteRemoteTrigger.input,
        );

        expect(controller.results, ['apple', 'apricot']);
        expect(controller.resultsWithFeatures.length, 2);

        // Verify items are marked with local source
        for (final (item, features) in controller.resultsWithFeatures) {
          expect(item, isIn(['apple', 'apricot']));
          expect(features, isNotNull);
          expect(
            features!.get(rAutocompleteItemSourceKey),
            RAutocompleteItemSource.local,
          );
        }

        controller.dispose();
      });
    });

    group('remote source', () {
      test('marks items with remote source feature', () async {
        final completer = Completer<Iterable<String>>();
        var stateChangedCount = 0;

        final controller = AutocompleteSourceController<String>(
          source: RAutocompleteRemoteSource<String>(
            load: (_) => completer.future,
            policy: const RAutocompleteRemotePolicy(debounce: null),
          ),
          itemAdapter: adapter,
          onStateChanged: () => stateChangedCount++,
        );

        controller.resolve(
          text: const TextEditingValue(text: 'test'),
          trigger: RAutocompleteRemoteTrigger.input,
        );

        completer.complete(['remote1', 'remote2']);
        await Future.microtask(() {});

        expect(controller.results, ['remote1', 'remote2']);
        expect(controller.resultsWithFeatures.length, 2);

        // Verify items are marked with remote source
        for (final (item, features) in controller.resultsWithFeatures) {
          expect(item, isIn(['remote1', 'remote2']));
          expect(features, isNotNull);
          expect(
            features!.get(rAutocompleteItemSourceKey),
            RAutocompleteItemSource.remote,
          );
        }

        controller.dispose();
      });
    });

    group('hybrid source', () {
      test('marks local items as local and remote items as remote', () async {
        final remoteCompleter = Completer<Iterable<String>>();
        var stateChangedCount = 0;

        final controller = AutocompleteSourceController<String>(
          source: RAutocompleteHybridSource<String>(
            local: RAutocompleteLocalSource<String>(
              options: (text) => ['local1', 'local2'],
            ),
            remote: RAutocompleteRemoteSource<String>(
              load: (_) => remoteCompleter.future,
              policy: const RAutocompleteRemotePolicy(debounce: null),
            ),
          ),
          itemAdapter: adapter,
          onStateChanged: () => stateChangedCount++,
        );

        controller.resolve(
          text: const TextEditingValue(text: 'test'),
          trigger: RAutocompleteRemoteTrigger.input,
        );

        // Local results should be available immediately
        expect(controller.results, ['local1', 'local2']);

        // Complete remote
        remoteCompleter.complete(['remote1', 'remote2']);
        await Future.microtask(() {});

        // Should have both local and remote
        expect(controller.results,
            containsAll(['local1', 'local2', 'remote1', 'remote2']));
        expect(controller.resultsWithFeatures.length, 4);

        // Verify source marking
        final localItems = controller.resultsWithFeatures.where(
          (r) =>
              r.$2?.get(rAutocompleteItemSourceKey) ==
              RAutocompleteItemSource.local,
        );
        final remoteItems = controller.resultsWithFeatures.where(
          (r) =>
              r.$2?.get(rAutocompleteItemSourceKey) ==
              RAutocompleteItemSource.remote,
        );

        expect(localItems.map((r) => r.$1), containsAll(['local1', 'local2']));
        expect(
            remoteItems.map((r) => r.$1), containsAll(['remote1', 'remote2']));

        controller.dispose();
      });
    });

    group('remote state', () {
      test('isLoading reflects loading state', () async {
        final completer = Completer<Iterable<String>>();

        final controller = AutocompleteSourceController<String>(
          source: RAutocompleteRemoteSource<String>(
            load: (_) => completer.future,
            policy: const RAutocompleteRemotePolicy(debounce: null),
          ),
          itemAdapter: adapter,
          onStateChanged: () {},
        );

        expect(controller.isLoading, isFalse);

        controller.resolve(
          text: const TextEditingValue(text: 'test'),
          trigger: RAutocompleteRemoteTrigger.input,
        );

        expect(controller.isLoading, isTrue);

        completer.complete(['result']);
        await Future.microtask(() {});

        expect(controller.isLoading, isFalse);

        controller.dispose();
      });

      test('remoteState is null for local source', () {
        final controller = AutocompleteSourceController<String>(
          source: RAutocompleteLocalSource<String>(
            options: (_) => ['a', 'b'],
          ),
          itemAdapter: adapter,
          onStateChanged: () {},
        );

        expect(controller.remoteState, isNull);

        controller.dispose();
      });

      test('requestFeatures contains remote state', () async {
        final completer = Completer<Iterable<String>>();

        final controller = AutocompleteSourceController<String>(
          source: RAutocompleteRemoteSource<String>(
            load: (_) => completer.future,
            policy: const RAutocompleteRemotePolicy(debounce: null),
          ),
          itemAdapter: adapter,
          onStateChanged: () {},
        );

        controller.resolve(
          text: const TextEditingValue(text: 'test'),
          trigger: RAutocompleteRemoteTrigger.input,
        );

        final features = controller.requestFeatures;
        expect(features.get(rAutocompleteRemoteStateKey), isNotNull);
        expect(features.get(rAutocompleteRemoteStateKey)?.isLoading, isTrue);

        controller.dispose();
      });
    });
  });
}
