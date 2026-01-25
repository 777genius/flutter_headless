import 'package:flutter_test/flutter_test.dart';
import 'package:headless_autocomplete/src/logic/autocomplete_source_controller.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_policies.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_remote_query.dart';
import 'package:headless_autocomplete/src/sources/r_autocomplete_source.dart';
import 'package:headless_foundation/headless_foundation.dart';

void main() {
  group('AutocompleteSourceController: keyboard trigger ignores loadOnInput', () {
    test('remote load is not called for input when loadOnInput=false', () async {
      var loadCount = 0;
      RAutocompleteRemoteQuery? capturedQuery;

      final source = RAutocompleteRemoteSource<String>(
        load: (q) async {
          loadCount++;
          capturedQuery = q;
          return const ['ok'];
        },
        policy: const RAutocompleteRemotePolicy(
          debounce: null,
          loadOnInput: false,
          loadOnFocus: false,
        ),
      );

      final controller = AutocompleteSourceController<String>(
        source: source,
        itemAdapter: HeadlessItemAdapter<String>(
          id: (v) => ListboxItemId(v),
          primaryText: (v) => v,
        ),
        onStateChanged: () {},
      );

      controller.resolve(
        text: const TextEditingValue(text: 'abc'),
        trigger: RAutocompleteRemoteTrigger.input,
      );

      // Give microtasks a chance (though load shouldn't fire here).
      await Future.microtask(() {});

      expect(loadCount, 0);
      expect(capturedQuery, isNull);
    });

    test('remote load is called for keyboard even when loadOnInput=false', () async {
      var loadCount = 0;
      RAutocompleteRemoteQuery? capturedQuery;

      final source = RAutocompleteRemoteSource<String>(
        load: (q) async {
          loadCount++;
          capturedQuery = q;
          return const ['ok'];
        },
        policy: const RAutocompleteRemotePolicy(
          debounce: null,
          loadOnInput: false,
          loadOnFocus: false,
        ),
      );

      final controller = AutocompleteSourceController<String>(
        source: source,
        itemAdapter: HeadlessItemAdapter<String>(
          id: (v) => ListboxItemId(v),
          primaryText: (v) => v,
        ),
        onStateChanged: () {},
      );

      controller.resolve(
        text: const TextEditingValue(text: 'abc'),
        trigger: RAutocompleteRemoteTrigger.keyboard,
      );

      await Future.microtask(() {});

      expect(loadCount, 1);
      expect(capturedQuery, isNotNull);
      expect(capturedQuery!.trigger, RAutocompleteRemoteTrigger.keyboard);
      expect(capturedQuery!.text, 'abc');
    });
  });
}

