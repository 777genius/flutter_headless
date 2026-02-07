import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../sources/r_autocomplete_policies.dart';
import '../sources/r_autocomplete_remote_query.dart';
import '../sources/r_autocomplete_remote_state.dart';

/// Manages remote source state transitions with debounce, race handling, and caching.
///
/// State machine:
/// - idle: Initial state, no pending requests.
/// - loading: Request in flight.
/// - ready: Successful response received.
/// - error: Request failed.
///
/// Features:
/// - Debounce: Delays requests to avoid excessive API calls during typing.
/// - Race handling: Ignores stale responses using request IDs.
/// - Caching: Optionally caches successful results per query.
final class AutocompleteRemoteStateMachine<T> {
  AutocompleteRemoteStateMachine({
    required Future<Iterable<T>> Function(RAutocompleteRemoteQuery) load,
    required RAutocompleteRemotePolicy policy,
    required VoidCallback onStateChanged,
  })  : _load = load,
        _policy = policy,
        _onStateChanged = onStateChanged {
    _initializeCache();
  }

  final Future<Iterable<T>> Function(RAutocompleteRemoteQuery) _load;
  final RAutocompleteRemotePolicy _policy;
  final VoidCallback _onStateChanged;

  RAutocompleteRemoteState _state = RAutocompleteRemoteState.idle;
  List<T> _results = const [];
  Timer? _debounceTimer;
  int _nextRequestId = 0;
  int? _activeRequestId;
  LinkedHashMap<String, List<T>>? _cache;

  /// Current remote state.
  RAutocompleteRemoteState get state => _state;

  /// Current results from the remote source.
  List<T> get results => _results;

  /// Whether the state machine has any cached results.
  bool get hasCachedResults => _cache?.isNotEmpty ?? false;

  /// Triggers a remote load for the given text.
  ///
  /// Applies debounce, minQueryLength, and whitespace trimming according to policy.
  void load({
    required String rawText,
    required RAutocompleteRemoteTrigger trigger,
  }) {
    final queryPolicy = _policy.query;
    final trimmedText = queryPolicy.trimWhitespace ? rawText.trim() : rawText;

    if (trimmedText.length < queryPolicy.minQueryLength) {
      _cancelPending();
      // Always clear results when below minQueryLength, regardless of
      // keepPreviousResultsWhileLoading. Stale results for a longer query
      // should not be shown when the query is too short.
      _results = const [];
      _transitionToIdle();
      return;
    }

    // Check cache
    final cache = _cache;
    final cached = cache?[trimmedText];
    if (cached != null) {
      // LRU touch
      cache!.remove(trimmedText);
      cache[trimmedText] = cached;
      _results = cached;
      _state = RAutocompleteRemoteState(
        status: RAutocompleteRemoteStatus.ready,
        queryText: trimmedText,
      );
      _onStateChanged();
      return;
    }

    // Cancel any pending debounce
    _debounceTimer?.cancel();

    final debounce = _policy.debounce;
    if (debounce != null && debounce > Duration.zero) {
      _debounceTimer = Timer(debounce, () {
        _executeLoad(
            rawText: rawText, trimmedText: trimmedText, trigger: trigger);
      });
    } else {
      _executeLoad(
          rawText: rawText, trimmedText: trimmedText, trigger: trigger);
    }
  }

  /// Retries the last failed request.
  ///
  /// Only meaningful when current state is error.
  void retry() {
    if (_state.status != RAutocompleteRemoteStatus.error) return;

    _executeLoad(
      rawText: _state.queryText,
      trimmedText: _state.queryText,
      trigger: RAutocompleteRemoteTrigger.keyboard,
    );
  }

  /// Clears the current error state.
  ///
  /// Moves state from error back to idle.
  void clearError() {
    if (_state.status != RAutocompleteRemoteStatus.error) return;
    _transitionToIdle();
  }

  /// Cancels any pending requests and resets to idle.
  void cancel() {
    _cancelPending();
    _transitionToIdle();
  }

  /// Disposes the state machine, canceling pending requests.
  void dispose() {
    _cancelPending();
  }

  bool get _isCacheEnabled =>
      _policy.cache is RAutocompleteRemoteCacheLastSuccessfulPerQuery;

  int get _maxCacheEntries => switch (_policy.cache) {
        RAutocompleteRemoteCacheLastSuccessfulPerQuery(:final maxEntries) =>
          maxEntries,
        _ => 0,
      };

  void _initializeCache() {
    if (!_isCacheEnabled) {
      _cache = null;
      return;
    }
    _cache = LinkedHashMap<String, List<T>>();
  }

  void _executeLoad({
    required String rawText,
    required String trimmedText,
    required RAutocompleteRemoteTrigger trigger,
  }) {
    final requestId = _nextRequestId++;
    _activeRequestId = requestId;

    final query = RAutocompleteRemoteQuery(
      rawText: rawText,
      text: trimmedText,
      trigger: trigger,
      requestId: requestId,
    );

    // Transition to loading
    // Keep previous results if policy says so
    final isStale =
        _policy.keepPreviousResultsWhileLoading && _results.isNotEmpty;
    _state = RAutocompleteRemoteState(
      status: RAutocompleteRemoteStatus.loading,
      queryText: trimmedText,
      isStale: isStale,
    );
    _onStateChanged();

    _load(query).then((items) {
      // Race check: ignore if a newer request was started
      if (_activeRequestId != requestId) return;

      final resultList = items.toList();
      _results = resultList;

      // Update cache
      final cache = _cache;
      if (cache != null) {
        cache.remove(trimmedText);
        cache[trimmedText] = resultList;
        final maxEntries = _maxCacheEntries;
        while (cache.length > maxEntries && cache.isNotEmpty) {
          cache.remove(cache.keys.first);
        }
      }

      _state = RAutocompleteRemoteState(
        status: RAutocompleteRemoteStatus.ready,
        queryText: trimmedText,
      );
      _onStateChanged();
    }).catchError((Object error, StackTrace stackTrace) {
      // Race check
      if (_activeRequestId != requestId) return;

      // Classify error
      final kind = _classifyError(error);
      final remoteError = RAutocompleteRemoteError(
        kind: kind,
        message: error.toString(),
      );

      _state = RAutocompleteRemoteState(
        status: RAutocompleteRemoteStatus.error,
        queryText: trimmedText,
        error: remoteError,
        canRetry: true,
      );
      _onStateChanged();
    });
  }

  RAutocompleteRemoteErrorKind _classifyError(Object error) {
    // Basic error classification
    // In production, you might want to check for specific exception types
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('timeout')) {
      return RAutocompleteRemoteErrorKind.timeout;
    }
    if (errorString.contains('socket') ||
        errorString.contains('network') ||
        errorString.contains('connection')) {
      return RAutocompleteRemoteErrorKind.network;
    }
    return RAutocompleteRemoteErrorKind.unknown;
  }

  void _cancelPending() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _activeRequestId = null;
  }

  void _transitionToIdle() {
    if (_state.isIdle) return;

    if (!_policy.keepPreviousResultsWhileLoading) {
      _results = const [];
    }
    _state = RAutocompleteRemoteState.idle;
    _onStateChanged();
  }
}
