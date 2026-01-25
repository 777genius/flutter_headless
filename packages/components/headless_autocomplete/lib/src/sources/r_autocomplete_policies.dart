import 'package:flutter/foundation.dart';

/// Query normalization policy shared between local and remote sources.
///
/// Controls how raw text input is processed before being used for filtering.
@immutable
final class RAutocompleteQueryPolicy {
  /// Creates a query policy with the given settings.
  const RAutocompleteQueryPolicy({
    this.minQueryLength = 0,
    this.trimWhitespace = true,
  });

  /// Minimum number of characters required before options are computed/fetched.
  ///
  /// For local sources, this controls when [options] is called.
  /// For remote sources, this controls when [load] is called.
  ///
  /// Default: 0 (no minimum).
  final int minQueryLength;

  /// Whether to trim whitespace from the query before processing.
  ///
  /// Default: true.
  final bool trimWhitespace;

  /// Normalizes the given text according to this policy.
  ///
  /// Returns null if the query doesn't meet the minimum length requirement.
  String? normalize(String text) {
    final normalized = trimWhitespace ? text.trim() : text;
    if (normalized.length < minQueryLength) return null;
    return normalized;
  }
}

/// Policy for local source behavior.
@immutable
final class RAutocompleteLocalPolicy {
  /// Creates a local policy with the given settings.
  const RAutocompleteLocalPolicy({
    this.query = const RAutocompleteQueryPolicy(),
    this.cache = true,
  });

  /// Query normalization policy.
  final RAutocompleteQueryPolicy query;

  /// Whether to cache results for the same query text.
  ///
  /// Default: true.
  final bool cache;
}

/// Policy for remote source behavior.
@immutable
final class RAutocompleteRemotePolicy {
  /// Creates a remote policy with the given settings.
  const RAutocompleteRemotePolicy({
    this.query = const RAutocompleteQueryPolicy(),
    this.debounce = const Duration(milliseconds: 200),
    this.keepPreviousResultsWhileLoading = true,
    this.cache = const RAutocompleteRemoteCachePolicy.none(),
    this.loadOnFocus = false,
    this.loadOnInput = true,
  });

  /// Query normalization policy.
  final RAutocompleteQueryPolicy query;

  /// Debounce duration before starting a remote load.
  ///
  /// Prevents excessive API calls during rapid typing.
  /// Set to null to disable debouncing.
  ///
  /// Default: 200ms.
  final Duration? debounce;

  /// Whether to keep previous results visible while loading new ones.
  ///
  /// When true, stale results are shown until new results arrive.
  /// When false, results are cleared immediately when a new load starts.
  ///
  /// Default: true.
  final bool keepPreviousResultsWhileLoading;

  /// Cache policy for remote results.
  ///
  /// Default: no caching.
  final RAutocompleteRemoteCachePolicy cache;

  /// Whether to trigger a load when the field gains focus.
  ///
  /// Default: false (only load on input changes).
  final bool loadOnFocus;

  /// Whether to trigger a load when the user types.
  ///
  /// Default: true.
  final bool loadOnInput;
}

/// Cache policy for remote source results.
sealed class RAutocompleteRemoteCachePolicy {
  const RAutocompleteRemoteCachePolicy();

  /// No caching - every request goes to the backend.
  const factory RAutocompleteRemoteCachePolicy.none() =
      RAutocompleteRemoteCacheNone;

  /// Cache the last successful result per unique query text.
  const factory RAutocompleteRemoteCachePolicy.lastSuccessfulPerQuery({
    int maxEntries,
  }) = RAutocompleteRemoteCacheLastSuccessfulPerQuery;
}

/// No caching policy.
final class RAutocompleteRemoteCacheNone
    extends RAutocompleteRemoteCachePolicy {
  const RAutocompleteRemoteCacheNone();
}

/// Cache last successful result per query text.
final class RAutocompleteRemoteCacheLastSuccessfulPerQuery
    extends RAutocompleteRemoteCachePolicy {
  /// Creates a per-query cache policy.
  const RAutocompleteRemoteCacheLastSuccessfulPerQuery({
    this.maxEntries = 32,
  });

  /// Maximum number of cached entries.
  ///
  /// When exceeded, least recently used entries are evicted.
  final int maxEntries;
}

/// How to prefer items when deduplicating in hybrid mode.
enum RAutocompleteDedupePreference {
  /// Keep local items when duplicates are found.
  preferLocal,

  /// Keep remote items when duplicates are found.
  preferRemote,
}

/// Policy for combining local and remote results in hybrid mode.
@immutable
final class RAutocompleteCombinePolicy {
  /// Creates a combine policy with the given settings.
  const RAutocompleteCombinePolicy({
    this.showSections = true,
    this.dedupeById = true,
    this.dedupePreference = RAutocompleteDedupePreference.preferLocal,
    this.remoteOnlyWhenLocalEmpty = false,
  });

  /// Whether to mark items with section identifiers (local/remote).
  ///
  /// When true, renderer can show visual separation between sources.
  ///
  /// Default: true.
  final bool showSections;

  /// Whether to remove duplicate items based on their ID.
  ///
  /// Default: true.
  final bool dedupeById;

  /// Which source to prefer when deduplicating.
  ///
  /// Default: preferLocal.
  final RAutocompleteDedupePreference dedupePreference;

  /// Whether to show remote results only when local results are empty.
  ///
  /// When true, remote results are hidden while local results exist.
  /// When false, both are always shown (subject to deduplication).
  ///
  /// Default: false.
  final bool remoteOnlyWhenLocalEmpty;
}
