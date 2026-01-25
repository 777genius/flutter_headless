import 'package:flutter/widgets.dart';

/// Commands for TextField renderer (v1).
///
/// These are NOT "user callbacks". They are internal component commands that
/// a renderer may invoke to delegate behavior back to the component.
///
/// Example: tap-to-focus on container decoration/padding area.
@immutable
final class RTextFieldCommands {
  const RTextFieldCommands({
    this.tapContainer,
    this.tapLeading,
    this.tapTrailing,
    this.clearText,
  });

  /// Request focus when the container is tapped.
  final VoidCallback? tapContainer;

  /// Handle leading slot tap (if wired by component).
  final VoidCallback? tapLeading;

  /// Handle trailing slot tap (if wired by component).
  final VoidCallback? tapTrailing;

  /// Clear the text field content.
  ///
  /// Called by clear button in renderers (e.g., Cupertino clear button).
  /// Clears text while preserving focus.
  final VoidCallback? clearText;
}

