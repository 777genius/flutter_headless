import 'package:headless_foundation/headless_foundation.dart';

import '../sources/r_autocomplete_item_features.dart';
import '../sources/r_autocomplete_policies.dart';

/// Result of combining local and remote options.
final class AutocompleteCombineResult<T> {
  const AutocompleteCombineResult({
    required this.combined,
    required this.withFeatures,
    required this.localCount,
    required this.remoteCount,
  });

  /// Combined and possibly deduplicated options.
  final List<T> combined;

  /// Combined options with per-item features aligned 1:1 with [combined].
  ///
  /// This is the authoritative list to use for building menu items, because
  /// it preserves the exact order and dedupe decisions.
  final List<(T, HeadlessItemFeatures)> withFeatures;

  /// Number of local options in the result.
  final int localCount;

  /// Number of remote options in the result.
  final int remoteCount;
}

/// Combines local and remote autocomplete results with deduplication.
///
/// Features:
/// - Deduplication by item ID (configurable preference for local or remote).
/// - Section markers for visual separation.
/// - Option to show remote only when local is empty.
final class AutocompleteCombiner<T> {
  const AutocompleteCombiner({
    required HeadlessItemAdapter<T> itemAdapter,
    required RAutocompleteCombinePolicy policy,
  })  : _itemAdapter = itemAdapter,
        _policy = policy;

  final HeadlessItemAdapter<T> _itemAdapter;
  final RAutocompleteCombinePolicy _policy;

  /// Combines local and remote results according to the policy.
  ///
  /// Returns a [AutocompleteCombineResult] with combined items and counts.
  AutocompleteCombineResult<T> combine({
    required List<T> local,
    required List<T> remote,
  }) {
    return combineWithFeatures(local: local, remote: remote);
  }

  /// Combines local and remote results and also returns aligned per-item features.
  AutocompleteCombineResult<T> combineWithFeatures({
    required List<T> local,
    required List<T> remote,
  }) {
    final showSections = _policy.showSections;
    final localSection = showSections ? RAutocompleteSectionId.local : null;
    final remoteSection = showSections ? RAutocompleteSectionId.remote : null;

    HeadlessItemFeatures localFeatures() => createItemFeatures(
        source: RAutocompleteItemSource.local, sectionId: localSection);
    HeadlessItemFeatures remoteFeatures() => createItemFeatures(
        source: RAutocompleteItemSource.remote, sectionId: remoteSection);

    if (_policy.remoteOnlyWhenLocalEmpty && local.isNotEmpty) {
      final lf = localFeatures();
      final withFeatures = local.map((v) => (v, lf)).toList();
      return AutocompleteCombineResult(
        combined: local,
        withFeatures: withFeatures,
        localCount: local.length,
        remoteCount: 0,
      );
    }

    if (!_policy.dedupeById) {
      final lf = localFeatures();
      final rf = remoteFeatures();
      final withFeatures = <(T, HeadlessItemFeatures)>[
        ...local.map((v) => (v, lf)),
        ...remote.map((v) => (v, rf)),
      ];
      return AutocompleteCombineResult(
        combined: [...local, ...remote],
        withFeatures: withFeatures,
        localCount: local.length,
        remoteCount: remote.length,
      );
    }

    final seenIds = <ListboxItemId>{};
    final withFeatures = <(T, HeadlessItemFeatures)>[];

    final preferLocal =
        _policy.dedupePreference == RAutocompleteDedupePreference.preferLocal;
    final first = preferLocal ? local : remote;
    final second = preferLocal ? remote : local;
    final firstFeatures = preferLocal ? localFeatures() : remoteFeatures();
    final secondFeatures = preferLocal ? remoteFeatures() : localFeatures();

    var firstCount = 0;
    for (final item in first) {
      final id = _itemAdapter.id(item);
      if (seenIds.add(id)) {
        withFeatures.add((item, firstFeatures));
        firstCount++;
      }
    }

    var secondCount = 0;
    for (final item in second) {
      final id = _itemAdapter.id(item);
      if (seenIds.add(id)) {
        withFeatures.add((item, secondFeatures));
        secondCount++;
      }
    }

    final (localCount, remoteCount) =
        preferLocal ? (firstCount, secondCount) : (secondCount, firstCount);

    return AutocompleteCombineResult(
      combined: withFeatures.map((r) => r.$1).toList(),
      withFeatures: withFeatures,
      localCount: localCount,
      remoteCount: remoteCount,
    );
  }

  /// Creates item features for marking the source of an item.
  ///
  /// Returns features with [RAutocompleteItemSource] and optionally section ID.
  HeadlessItemFeatures createItemFeatures({
    required RAutocompleteItemSource source,
    RAutocompleteSectionId? sectionId,
  }) {
    return HeadlessItemFeatures.build((b) {
      b.set(rAutocompleteItemSourceKey, source);
      if (sectionId != null) {
        b.set(rAutocompleteSectionIdKey, sectionId);
      }
    });
  }

  /// Marks a list of items with source features.
  ///
  /// Returns a list of (item, features) pairs.
  List<(T, HeadlessItemFeatures)> markWithSource({
    required List<T> items,
    required RAutocompleteItemSource source,
    RAutocompleteSectionId? sectionId,
  }) {
    final features = createItemFeatures(source: source, sectionId: sectionId);
    return items.map((item) => (item, features)).toList();
  }
}
