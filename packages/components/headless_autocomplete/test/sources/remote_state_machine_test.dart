import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:headless_autocomplete/src/logic/autocomplete_remote_state_machine.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_policies.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_remote_query.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_remote_state.dart';

void main() {
  group('AutocompleteRemoteStateMachine', () {
    late List<RAutocompleteRemoteState> states;
    late AutocompleteRemoteStateMachine<String> machine;

    setUp(() {
      states = [];
    });

    tearDown(() {
      machine.dispose();
    });

    test('starts in idle state', () {
      machine = AutocompleteRemoteStateMachine<String>(
        load: (_) async => [],
        policy: const RAutocompleteRemotePolicy(),
        onStateChanged: () => states.add(machine.state),
      );

      expect(machine.state.isIdle, isTrue);
      expect(machine.results, isEmpty);
    });

    test('transitions to loading then ready on successful load', () async {
      final completer = Completer<Iterable<String>>();

      machine = AutocompleteRemoteStateMachine<String>(
        load: (_) => completer.future,
        policy: const RAutocompleteRemotePolicy(debounce: null),
        onStateChanged: () => states.add(machine.state),
      );

      machine.load(rawText: 'test', trigger: RAutocompleteRemoteTrigger.input);

      expect(states.length, 1);
      expect(states.first.isLoading, isTrue);
      expect(states.first.queryText, 'test');

      completer.complete(['result1', 'result2']);
      await Future.microtask(() {});

      expect(states.length, 2);
      expect(states.last.isReady, isTrue);
      expect(machine.results, ['result1', 'result2']);
    });

    test('transitions to error on failed load', () async {
      machine = AutocompleteRemoteStateMachine<String>(
        load: (_) => Future.error(Exception('Network error')),
        policy: const RAutocompleteRemotePolicy(debounce: null),
        onStateChanged: () => states.add(machine.state),
      );

      machine.load(rawText: 'test', trigger: RAutocompleteRemoteTrigger.input);
      await Future.microtask(() {});

      expect(states.last.isError, isTrue);
      expect(states.last.error, isNotNull);
      expect(states.last.canRetry, isTrue);
    });

    test('respects minQueryLength', () {
      machine = AutocompleteRemoteStateMachine<String>(
        load: (_) async => ['result'],
        policy: const RAutocompleteRemotePolicy(
          query: RAutocompleteQueryPolicy(minQueryLength: 3),
          debounce: null,
        ),
        onStateChanged: () => states.add(machine.state),
      );

      machine.load(rawText: 'ab', trigger: RAutocompleteRemoteTrigger.input);

      expect(states, isEmpty);
      expect(machine.state.isIdle, isTrue);
    });

    test('debounces requests', () async {
      machine = AutocompleteRemoteStateMachine<String>(
        load: (_) async => ['result'],
        policy: const RAutocompleteRemotePolicy(
          debounce: Duration(milliseconds: 100),
        ),
        onStateChanged: () => states.add(machine.state),
      );

      machine.load(rawText: 'test', trigger: RAutocompleteRemoteTrigger.input);

      expect(states, isEmpty);
      expect(machine.state.isIdle, isTrue);
    });

    test('cancels pending debounce on new load', () async {
      var loadCount = 0;

      machine = AutocompleteRemoteStateMachine<String>(
        load: (_) async {
          loadCount++;
          return ['result'];
        },
        policy: const RAutocompleteRemotePolicy(
          debounce: Duration(milliseconds: 50),
        ),
        onStateChanged: () => states.add(machine.state),
      );

      machine.load(rawText: 'test1', trigger: RAutocompleteRemoteTrigger.input);
      machine.load(rawText: 'test2', trigger: RAutocompleteRemoteTrigger.input);

      await Future.delayed(const Duration(milliseconds: 100));

      expect(loadCount, 1);
    });

    test('ignores stale responses (race handling)', () async {
      final completers = <Completer<Iterable<String>>>[];

      machine = AutocompleteRemoteStateMachine<String>(
        load: (_) {
          final completer = Completer<Iterable<String>>();
          completers.add(completer);
          return completer.future;
        },
        policy: const RAutocompleteRemotePolicy(debounce: null),
        onStateChanged: () => states.add(machine.state),
      );

      machine.load(rawText: 'first', trigger: RAutocompleteRemoteTrigger.input);
      machine.load(
          rawText: 'second', trigger: RAutocompleteRemoteTrigger.input);

      completers[1].complete(['second-result']);
      await Future.microtask(() {});

      completers[0].complete(['first-result']);
      await Future.microtask(() {});

      expect(machine.results, ['second-result']);
    });

    test('retry works after error', () async {
      var attempt = 0;

      machine = AutocompleteRemoteStateMachine<String>(
        load: (_) async {
          attempt++;
          if (attempt == 1) {
            throw Exception('First attempt fails');
          }
          return ['success'];
        },
        policy: const RAutocompleteRemotePolicy(debounce: null),
        onStateChanged: () => states.add(machine.state),
      );

      machine.load(rawText: 'test', trigger: RAutocompleteRemoteTrigger.input);
      await Future.microtask(() {});

      expect(machine.state.isError, isTrue);

      machine.retry();
      await Future.microtask(() {});

      expect(machine.state.isReady, isTrue);
      expect(machine.results, ['success']);
    });

    test('clearError transitions to idle', () async {
      machine = AutocompleteRemoteStateMachine<String>(
        load: (_) => Future.error(Exception('error')),
        policy: const RAutocompleteRemotePolicy(debounce: null),
        onStateChanged: () => states.add(machine.state),
      );

      machine.load(rawText: 'test', trigger: RAutocompleteRemoteTrigger.input);
      await Future.microtask(() {});

      expect(machine.state.isError, isTrue);

      machine.clearError();

      expect(machine.state.isIdle, isTrue);
    });

    test('trims whitespace when policy says so', () async {
      RAutocompleteRemoteQuery? capturedQuery;

      machine = AutocompleteRemoteStateMachine<String>(
        load: (query) async {
          capturedQuery = query;
          return ['result'];
        },
        policy: const RAutocompleteRemotePolicy(
          query: RAutocompleteQueryPolicy(trimWhitespace: true),
          debounce: null,
        ),
        onStateChanged: () => states.add(machine.state),
      );

      machine.load(
          rawText: '  test  ', trigger: RAutocompleteRemoteTrigger.input);
      await Future.microtask(() {});

      expect(capturedQuery?.text, 'test');
      expect(capturedQuery?.rawText, '  test  ');
    });

    test('caches results when cache policy is enabled', () async {
      var loadCount = 0;

      machine = AutocompleteRemoteStateMachine<String>(
        load: (_) async {
          loadCount++;
          return ['result'];
        },
        policy: const RAutocompleteRemotePolicy(
          cache: RAutocompleteRemoteCachePolicy.lastSuccessfulPerQuery(),
          debounce: null,
        ),
        onStateChanged: () => states.add(machine.state),
      );

      machine.load(rawText: 'test', trigger: RAutocompleteRemoteTrigger.input);
      await Future.microtask(() {});

      expect(loadCount, 1);

      machine.load(rawText: 'test', trigger: RAutocompleteRemoteTrigger.input);

      expect(loadCount, 1);
      expect(machine.results, ['result']);
    });

    test('cache policy caches per query and evicts by maxEntries (LRU)',
        () async {
      final seen = <String>[];

      machine = AutocompleteRemoteStateMachine<String>(
        load: (q) async {
          seen.add(q.text);
          return ['${q.text}-result'];
        },
        policy: const RAutocompleteRemotePolicy(
          cache: RAutocompleteRemoteCachePolicy.lastSuccessfulPerQuery(
              maxEntries: 2),
          debounce: null,
        ),
        onStateChanged: () => states.add(machine.state),
      );

      machine.load(rawText: 'a', trigger: RAutocompleteRemoteTrigger.input);
      await Future.microtask(() {});
      machine.load(rawText: 'b', trigger: RAutocompleteRemoteTrigger.input);
      await Future.microtask(() {});
      machine.load(rawText: 'c', trigger: RAutocompleteRemoteTrigger.input);
      await Future.microtask(() {});

      // Now cache should hold only the 2 most recent queries: b, c.
      machine.load(rawText: 'b', trigger: RAutocompleteRemoteTrigger.input);
      expect(seen.where((e) => e == 'b').length, 1);
      expect(machine.results, ['b-result']);

      machine.load(rawText: 'a', trigger: RAutocompleteRemoteTrigger.input);
      await Future.microtask(() {});
      // 'a' was evicted, so it must be loaded again.
      expect(seen.where((e) => e == 'a').length, 2);
      expect(machine.results, ['a-result']);
    });

    test('keepPreviousResultsWhileLoading marks state as stale', () async {
      final completer = Completer<Iterable<String>>();

      machine = AutocompleteRemoteStateMachine<String>(
        load: (_) => completer.future,
        policy: const RAutocompleteRemotePolicy(
          keepPreviousResultsWhileLoading: true,
          debounce: null,
        ),
        onStateChanged: () => states.add(machine.state),
      );

      machine.load(rawText: 'first', trigger: RAutocompleteRemoteTrigger.input);
      completer.complete(['first-result']);
      await Future.microtask(() {});

      final completer2 = Completer<Iterable<String>>();
      machine = AutocompleteRemoteStateMachine<String>(
        load: (_) => completer2.future,
        policy: const RAutocompleteRemotePolicy(
          keepPreviousResultsWhileLoading: true,
          debounce: null,
        ),
        onStateChanged: () => states.add(machine.state),
      );

      expect(machine.results, isEmpty);
    });

    test(
        'minQueryLength clears stale results even with keepPreviousResultsWhileLoading',
        () async {
      final completer = Completer<Iterable<String>>();

      machine = AutocompleteRemoteStateMachine<String>(
        load: (_) => completer.future,
        policy: const RAutocompleteRemotePolicy(
          query: RAutocompleteQueryPolicy(minQueryLength: 3),
          keepPreviousResultsWhileLoading: true,
          debounce: null,
        ),
        onStateChanged: () => states.add(machine.state),
      );

      // First load with valid query
      machine.load(rawText: 'test', trigger: RAutocompleteRemoteTrigger.input);
      completer.complete(['result1', 'result2']);
      await Future.microtask(() {});

      expect(machine.results, ['result1', 'result2']);
      expect(machine.state.isReady, isTrue);

      // Clear states for next assertion
      states.clear();

      // Query below minQueryLength should clear results
      machine.load(rawText: 'ab', trigger: RAutocompleteRemoteTrigger.input);

      // Results should be cleared even with keepPreviousResultsWhileLoading
      expect(machine.results, isEmpty);
      expect(machine.state.isIdle, isTrue);
    });
  });
}
