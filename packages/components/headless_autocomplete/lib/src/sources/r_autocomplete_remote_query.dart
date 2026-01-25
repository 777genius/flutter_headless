import 'package:flutter/foundation.dart';

/// What triggered a remote load request.
enum RAutocompleteRemoteTrigger {
  /// User typed or edited text.
  input,

  /// Field gained focus.
  focus,

  /// User tapped the trigger/field.
  tap,

  /// Keyboard navigation (arrow keys).
  keyboard,
}

/// Query information passed to remote load callbacks.
///
/// Contains normalized query text and metadata for the remote loader.
/// The [requestId] can be used for correlating requests with responses
/// and for telemetry/debugging.
///
/// Example:
/// ```dart
/// RAutocompleteRemoteSource<User>(
///   load: (query) async {
///     // Use normalized text for API call
///     final results = await api.search(query.text);
///
///     // Use rawText for analytics
///     analytics.logSearch(query.rawText, query.trigger);
///
///     return results;
///   },
/// )
/// ```
@immutable
final class RAutocompleteRemoteQuery {
  /// Creates a remote query with the given parameters.
  const RAutocompleteRemoteQuery({
    required this.rawText,
    required this.text,
    required this.trigger,
    required this.requestId,
  });

  /// The original text before normalization (for debugging/telemetry).
  final String rawText;

  /// The normalized query text (trimmed, etc. per policy).
  ///
  /// Use this for actual API calls.
  final String text;

  /// What triggered this load request.
  final RAutocompleteRemoteTrigger trigger;

  /// Unique ID for this request.
  ///
  /// Monotonically increasing per component instance.
  /// Used internally for race condition handling.
  final int requestId;

  @override
  String toString() => 'RAutocompleteRemoteQuery('
      'text: "$text", '
      'trigger: $trigger, '
      'requestId: $requestId)';
}
