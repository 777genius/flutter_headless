/// Canonical “dominant” interaction state for visuals.
///
/// v1 precedence (high → low):
/// - disabled
/// - pressed
/// - hovered
/// - focused
/// - none
enum HeadlessInteractionVisualState {
  disabled,
  pressed,
  hovered,
  focused,
  none,
}

