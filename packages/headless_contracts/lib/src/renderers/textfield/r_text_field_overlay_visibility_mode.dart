/// Visibility mode for overlay elements in text fields (prefix, suffix, clear button).
///
/// Controls when certain elements appear based on the text field's state.
/// Mirrors Flutter's `OverlayVisibilityMode` from CupertinoTextField.
enum RTextFieldOverlayVisibilityMode {
  /// Never show the overlay element.
  never,

  /// Show the overlay element only while the field is being edited (has focus).
  whileEditing,

  /// Show the overlay element only when the field is not being edited (no focus).
  notEditing,

  /// Always show the overlay element.
  always,
}
