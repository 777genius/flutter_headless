import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../sources/r_autocomplete_item_features.dart';
import '../sources/r_autocomplete_remote_commands.dart';
import '../sources/r_autocomplete_remote_query.dart';
import '../sources/r_autocomplete_remote_state.dart';
import '../sources/r_autocomplete_policies.dart';
import '../sources/r_autocomplete_source.dart';
import 'autocomplete_combiner.dart';
import 'autocomplete_remote_state_machine.dart';

/// Unified controller for local, remote, and hybrid autocomplete sources.
///
/// Provides a consistent interface regardless of source type:
/// - Local: Synchronous filtering.
/// - Remote: Async with state machine.
/// - Hybrid: Combines local and remote results.
final class AutocompleteSourceController<T> implements RAutocompleteRemoteCommands {
  AutocompleteSourceController({
    required RAutocompleteSource<T> source,
    required HeadlessItemAdapter<T> itemAdapter,
    required VoidCallback onStateChanged,
  })  : _source = source,
        _itemAdapter = itemAdapter,
        _onStateChanged = onStateChanged {
    _initializeStateMachine();
  }

  final RAutocompleteSource<T> _source;
  final HeadlessItemAdapter<T> _itemAdapter;
  final VoidCallback _onStateChanged;

  AutocompleteRemoteStateMachine<T>? _remoteStateMachine;
  AutocompleteCombiner<T>? _combiner;
  List<T> _localResults = const [];
  List<T> _combinedResults = const [];
  List<(T, HeadlessItemFeatures?)> _resultsWithFeatures = const [];

  String? _lastLocalQueryText;
  List<T>? _lastLocalQueryResults;

  /// Current results from all sources.
  List<T> get results => _combinedResults;

  /// Current results with source features (local/remote marking).
  ///
  /// Each tuple contains (item, features) where features includes
  /// [rAutocompleteItemSourceKey] to identify the item's origin.
  List<(T, HeadlessItemFeatures?)> get resultsWithFeatures => _resultsWithFeatures;

  /// Whether currently loading remote data.
  bool get isLoading {
    final machine = _remoteStateMachine;
    return machine != null &&
        machine.state.status == RAutocompleteRemoteStatus.loading;
  }

  /// Remote state for UI indicators.
  ///
  /// Returns null for pure local sources.
  RAutocompleteRemoteState? get remoteState => _remoteStateMachine?.state;

  /// Request features containing remote state.
  ///
  /// Used to pass state to renderers through the request pipeline.
  HeadlessRequestFeatures get requestFeatures {
    final state = remoteState;
    if (state == null) return HeadlessRequestFeatures.empty;

    return HeadlessRequestFeatures.build((b) {
      b.set(rAutocompleteRemoteStateKey, state);
      b.set(rAutocompleteRemoteCommandsKey, this);
    });
  }

  /// Resolves options for the given text.
  ///
  /// For local sources, returns synchronously filtered results.
  /// For remote/hybrid sources, triggers async loading.
  void resolve({
    required TextEditingValue text,
    required RAutocompleteRemoteTrigger trigger,
  }) {
    switch (_source) {
      case RAutocompleteLocalSource<T>(:final options, :final policy):
        final normalized = _normalizeLocalQuery(text, policy);
        _localResults = _resolveLocal(
          policy: policy,
          normalized: normalized,
          options: options,
        );
        _combinedResults = _localResults;
        _resultsWithFeatures = _markItems(_localResults, RAutocompleteItemSource.local);
        _onStateChanged();

      case RAutocompleteRemoteSource<T>():
        _triggerRemoteLoad(text: text, trigger: trigger);

      case RAutocompleteHybridSource<T>(:final local):
        // Local is synchronous
        final normalized = _normalizeLocalQuery(text, local.policy);
        _localResults = _resolveLocal(
          policy: local.policy,
          normalized: normalized,
          options: local.options,
        );
        _combinedResults = _localResults;
        _resultsWithFeatures = _markItems(_localResults, RAutocompleteItemSource.local);
        _onStateChanged();

        // Remote is async
        _triggerRemoteLoad(text: text, trigger: trigger);
    }
  }

  @override
  void retry() {
    _remoteStateMachine?.retry();
  }

  @override
  void clearError() {
    _remoteStateMachine?.clearError();
  }

  /// Cancels any pending remote requests.
  void cancel() {
    _remoteStateMachine?.cancel();
  }

  void dispose() {
    _remoteStateMachine?.dispose();
  }

  void _initializeStateMachine() {
    switch (_source) {
      case RAutocompleteLocalSource<T>():
        // No state machine needed for local-only
        break;

      case RAutocompleteRemoteSource<T>(:final load, :final policy):
        _remoteStateMachine = AutocompleteRemoteStateMachine<T>(
          load: load,
          policy: policy,
          onStateChanged: _handleRemoteStateChanged,
        );

      case RAutocompleteHybridSource<T>(:final remote, :final combine):
        _remoteStateMachine = AutocompleteRemoteStateMachine<T>(
          load: remote.load,
          policy: remote.policy,
          onStateChanged: _handleRemoteStateChanged,
        );
        _combiner = AutocompleteCombiner<T>(
          itemAdapter: _itemAdapter,
          policy: combine,
        );
    }
  }

  void _handleRemoteStateChanged() {
    final machine = _remoteStateMachine;
    if (machine == null) return;

    switch (_source) {
      case RAutocompleteLocalSource<T>():
        // Should not happen
        break;

      case RAutocompleteRemoteSource<T>():
        _combinedResults = machine.results;
        // Mark all items as remote source
        _resultsWithFeatures = _markItems(machine.results, RAutocompleteItemSource.remote);
        _onStateChanged();

      case RAutocompleteHybridSource<T>():
        final combiner = _combiner;
        if (combiner == null) {
          // Fallback if combiner not initialized (shouldn't happen)
          _combinedResults = [..._localResults, ...machine.results];
          _resultsWithFeatures = [
            ..._markItems(_localResults, RAutocompleteItemSource.local),
            ..._markItems(machine.results, RAutocompleteItemSource.remote),
          ];
        } else {
          final result = combiner.combineWithFeatures(
            local: _localResults,
            remote: machine.results,
          );
          _combinedResults = result.combined;
          _resultsWithFeatures =
              result.withFeatures.map((r) => (r.$1, r.$2)).toList();
        }
        _onStateChanged();
    }
  }

  TextEditingValue? _normalizeLocalQuery(
    TextEditingValue input,
    RAutocompleteLocalPolicy policy,
  ) {
    final normalizedText = policy.query.normalize(input.text);
    if (normalizedText == null) {
      _lastLocalQueryText = null;
      _lastLocalQueryResults = null;
      return null;
    }
    if (normalizedText == input.text) return input;

    // Keep selection stable as much as possible.
    final newLen = normalizedText.length;
    final base = input.selection.baseOffset.clamp(0, newLen);
    final extent = input.selection.extentOffset.clamp(0, newLen);

    return input.copyWith(
      text: normalizedText,
      selection: TextSelection(baseOffset: base, extentOffset: extent),
      composing: TextRange.empty,
    );
  }

  List<T> _resolveLocal({
    required RAutocompleteLocalPolicy policy,
    required TextEditingValue? normalized,
    required Iterable<T> Function(TextEditingValue query) options,
  }) {
    if (normalized == null) return const [];

    final queryText = normalized.text;
    if (policy.cache &&
        _lastLocalQueryText == queryText &&
        _lastLocalQueryResults != null) {
      return _lastLocalQueryResults!;
    }

    final results = options(normalized).toList();
    if (policy.cache) {
      _lastLocalQueryText = queryText;
      _lastLocalQueryResults = results;
    } else {
      _lastLocalQueryText = null;
      _lastLocalQueryResults = null;
    }
    return results;
  }

  void _triggerRemoteLoad({
    required TextEditingValue text,
    required RAutocompleteRemoteTrigger trigger,
  }) {
    final machine = _remoteStateMachine;
    if (machine == null) return;

    final remotePolicy = switch (_source) {
      RAutocompleteRemoteSource<T>(:final policy) => policy,
      RAutocompleteHybridSource<T>(:final remote) => remote.policy,
      _ => null,
    };
    if (remotePolicy == null) return;

    if (trigger == RAutocompleteRemoteTrigger.focus && !remotePolicy.loadOnFocus) {
      return;
    }
    if (trigger == RAutocompleteRemoteTrigger.input && !remotePolicy.loadOnInput) {
      return;
    }

    machine.load(rawText: text.text, trigger: trigger);
  }

  /// Helper to mark items with source features.
  List<(T, HeadlessItemFeatures?)> _markItems(
    List<T> items,
    RAutocompleteItemSource source,
  ) {
    final features = HeadlessItemFeatures.build((b) {
      b.set(rAutocompleteItemSourceKey, source);
    });
    return items.map((item) => (item, features)).toList();
  }
}
