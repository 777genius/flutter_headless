import 'package:headless_foundation/headless_foundation.dart';

/// Commands for interacting with the remote source.
///
/// Passed to renderer via request features so slots can trigger
/// retry or clear error states.
///
/// Example usage in a slot:
/// ```dart
/// final commands = ctx.features.get(rAutocompleteRemoteCommandsKey);
/// if (commands != null && remoteState?.canRetry == true) {
///   return TextButton(
///     onPressed: commands.retry,
///     child: Text('Retry'),
///   );
/// }
/// ```
abstract interface class RAutocompleteRemoteCommands {
  /// Retry the last failed remote load.
  ///
  /// Only meaningful when remote state is in error status.
  void retry();

  /// Clear the current error state.
  ///
  /// Moves remote state from error back to idle.
  void clearError();
}

/// Feature key for remote commands in request features.
///
/// Use this key to get remote commands in slots/presets:
/// ```dart
/// final commands = ctx.features.get(rAutocompleteRemoteCommandsKey);
/// commands?.retry();
/// ```
const rAutocompleteRemoteCommandsKey =
    HeadlessFeatureKey<RAutocompleteRemoteCommands>(
  #rAutocompleteRemoteCommands,
  debugName: 'rAutocompleteRemoteCommands',
);
