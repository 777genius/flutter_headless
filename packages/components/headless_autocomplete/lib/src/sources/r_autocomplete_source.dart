import 'package:flutter/widgets.dart';

import 'r_autocomplete_policies.dart';
import 'r_autocomplete_remote_query.dart';

/// Sealed base class for autocomplete data sources.
///
/// Determines where and how options are fetched:
/// - [RAutocompleteLocalSource]: synchronous, in-memory filtering
/// - [RAutocompleteRemoteSource]: asynchronous API/backend calls
/// - [RAutocompleteHybridSource]: combines local and remote sources
///
/// Example (local):
/// ```dart
/// RAutocomplete<Country>(
///   source: RAutocompleteLocalSource(
///     options: (q) => countries.where((c) => c.name.contains(q.text)),
///   ),
///   itemAdapter: countryAdapter,
///   onSelected: (v) => setState(() => selected = v),
/// )
/// ```
///
/// Example (remote):
/// ```dart
/// RAutocomplete<User>(
///   source: RAutocompleteRemoteSource(
///     load: (q) => api.searchUsers(q.text),
///     policy: RAutocompleteRemotePolicy(
///       query: RAutocompleteQueryPolicy(minQueryLength: 2),
///       debounce: Duration(milliseconds: 250),
///     ),
///   ),
///   itemAdapter: userAdapter,
///   onSelected: selectUser,
/// )
/// ```
sealed class RAutocompleteSource<T> {
  const RAutocompleteSource();
}

/// Local synchronous source for autocomplete options.
///
/// Options are computed synchronously from the [options] callback.
/// Best for small datasets that are already in memory.
///
/// See also:
/// - [RAutocompleteRemoteSource] for async API calls
/// - [RAutocompleteHybridSource] for combining local + remote
final class RAutocompleteLocalSource<T> extends RAutocompleteSource<T> {
  /// Creates a local source with the given options builder.
  const RAutocompleteLocalSource({
    required this.options,
    this.policy = const RAutocompleteLocalPolicy(),
  });

  /// Callback that returns filtered options for the given query.
  ///
  /// Called synchronously whenever the text changes (after applying query policy).
  final Iterable<T> Function(TextEditingValue query) options;

  /// Policy for query normalization and caching.
  final RAutocompleteLocalPolicy policy;
}

/// Remote asynchronous source for autocomplete options.
///
/// Options are fetched asynchronously via the [load] callback.
/// The component handles debouncing, race conditions, and error states.
///
/// See also:
/// - [RAutocompleteLocalSource] for sync in-memory filtering
/// - [RAutocompleteHybridSource] for combining local + remote
final class RAutocompleteRemoteSource<T> extends RAutocompleteSource<T> {
  /// Creates a remote source with the given loader.
  const RAutocompleteRemoteSource({
    required this.load,
    this.policy = const RAutocompleteRemotePolicy(),
  });

  /// Async callback that fetches options from a backend/API.
  ///
  /// The [RAutocompleteRemoteQuery] provides:
  /// - [text]: normalized query text (trimmed, etc.)
  /// - [rawText]: original text for debugging
  /// - [trigger]: what caused this load (input/focus/tap/keyboard)
  /// - [requestId]: for correlating requests/responses
  final Future<Iterable<T>> Function(RAutocompleteRemoteQuery query) load;

  /// Policy for debounce, caching, query normalization, etc.
  final RAutocompleteRemotePolicy policy;
}

/// Hybrid source combining local and remote sources.
///
/// Shows local results immediately while remote results load.
/// Supports deduplication and sectioning for UX differentiation.
///
/// Example:
/// ```dart
/// RAutocompleteHybridSource(
///   local: RAutocompleteLocalSource(
///     options: (q) => recentItems.filter(q.text),
///     policy: RAutocompleteLocalPolicy(
///       query: RAutocompleteQueryPolicy(minQueryLength: 0),
///     ),
///   ),
///   remote: RAutocompleteRemoteSource(
///     load: (q) => api.searchItems(q.text),
///     policy: RAutocompleteRemotePolicy(
///       query: RAutocompleteQueryPolicy(minQueryLength: 2),
///     ),
///   ),
///   combine: RAutocompleteCombinePolicy(
///     showSections: true,
///     dedupeById: true,
///   ),
/// )
/// ```
final class RAutocompleteHybridSource<T> extends RAutocompleteSource<T> {
  /// Creates a hybrid source combining local and remote.
  const RAutocompleteHybridSource({
    required this.local,
    required this.remote,
    this.combine = const RAutocompleteCombinePolicy(),
  });

  /// Local source for immediate results.
  final RAutocompleteLocalSource<T> local;

  /// Remote source for async results.
  final RAutocompleteRemoteSource<T> remote;

  /// Policy for combining/deduplicating results.
  final RAutocompleteCombinePolicy combine;
}
