import 'package:flutter/foundation.dart';
import 'package:headless_foundation/headless_foundation.dart';

/// Status of the remote source.
enum RAutocompleteRemoteStatus {
  /// No remote load has been triggered yet.
  ///
  /// This is the initial state, or when query is below minQueryLength.
  idle,

  /// A remote load is in progress.
  loading,

  /// Remote load completed successfully.
  ready,

  /// Remote load failed with an error.
  error,
}

/// Kind of remote error for UI display.
enum RAutocompleteRemoteErrorKind {
  /// Network connectivity issue.
  network,

  /// Request timed out.
  timeout,

  /// Server returned an error response.
  server,

  /// Unknown or unclassified error.
  unknown,
}

/// Remote error information for UI display.
///
/// Provides a stable, serializable representation of errors
/// suitable for showing in UI (no stack traces, no raw exceptions).
@immutable
final class RAutocompleteRemoteError {
  /// Creates a remote error with the given parameters.
  const RAutocompleteRemoteError({
    required this.kind,
    this.message,
    this.debugId,
  });

  /// The kind of error that occurred.
  final RAutocompleteRemoteErrorKind kind;

  /// Human-readable error message (optional).
  final String? message;

  /// Debug/correlation ID for logs (optional).
  final String? debugId;

  @override
  String toString() => 'RAutocompleteRemoteError($kind'
      '${message != null ? ', message: "$message"' : ''}'
      '${debugId != null ? ', debugId: $debugId' : ''}'
      ')';
}

/// Current state of the remote source.
///
/// Passed to renderer via request features so slots can display
/// appropriate UI (loading indicator, error message, retry button, etc.).
///
/// Example usage in a slot:
/// ```dart
/// final remoteState = ctx.features.get(rAutocompleteRemoteStateKey);
/// if (remoteState?.isLoading == true) {
///   return CircularProgressIndicator();
/// }
/// if (remoteState?.isError == true) {
///   return Column(
///     children: [
///       Text(remoteState.error?.message ?? 'Error'),
///       TextButton(onPressed: onRetry, child: Text('Retry')),
///     ],
///   );
/// }
/// ```
@immutable
final class RAutocompleteRemoteState {
  /// Creates a remote state with the given parameters.
  const RAutocompleteRemoteState({
    required this.status,
    this.queryText = '',
    this.error,
    this.isStale = false,
    this.canRetry = false,
  });

  /// Idle state constant (no remote load yet).
  static const idle = RAutocompleteRemoteState(
    status: RAutocompleteRemoteStatus.idle,
  );

  /// Current status of the remote source.
  final RAutocompleteRemoteStatus status;

  /// The query text that was used for the current/last load.
  final String queryText;

  /// Error information if [status] is [RAutocompleteRemoteStatus.error].
  final RAutocompleteRemoteError? error;

  /// Whether the current results are stale (from a previous query).
  ///
  /// True when showing cached results while a new load is in progress.
  final bool isStale;

  /// Whether retry is available (only meaningful when [status] is error).
  final bool canRetry;

  /// Whether the remote source is currently loading.
  bool get isLoading => status == RAutocompleteRemoteStatus.loading;

  /// Whether the remote source has an error.
  bool get isError => status == RAutocompleteRemoteStatus.error;

  /// Whether the remote source has successfully loaded results.
  bool get isReady => status == RAutocompleteRemoteStatus.ready;

  /// Whether the remote source is idle (not started or below minQueryLength).
  bool get isIdle => status == RAutocompleteRemoteStatus.idle;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RAutocompleteRemoteState &&
        other.status == status &&
        other.queryText == queryText &&
        other.error == error &&
        other.isStale == isStale &&
        other.canRetry == canRetry;
  }

  @override
  int get hashCode => Object.hash(status, queryText, error, isStale, canRetry);

  @override
  String toString() => 'RAutocompleteRemoteState('
      'status: $status'
      '${queryText.isNotEmpty ? ', query: "$queryText"' : ''}'
      '${error != null ? ', error: $error' : ''}'
      '${isStale ? ', stale' : ''}'
      '${canRetry ? ', canRetry' : ''}'
      ')';
}

/// Feature key for remote state in request features.
///
/// Use this key to read remote state in slots/presets:
/// ```dart
/// final remoteState = ctx.features.get(rAutocompleteRemoteStateKey);
/// ```
const rAutocompleteRemoteStateKey = HeadlessFeatureKey<RAutocompleteRemoteState>(
  #rAutocompleteRemoteState,
  debugName: 'rAutocompleteRemoteState',
);
