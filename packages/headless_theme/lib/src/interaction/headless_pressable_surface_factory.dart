import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';

/// Capability interface for creating pressable surface wrappers.
///
/// This factory creates platform-specific interactive surfaces:
/// - Material: `Material` + `InkResponse` for ripple effects
/// - Cupertino: opacity feedback
///
/// Components like `RSwitchListTile` use this capability to wrap
/// their rendered content with platform-appropriate interaction feedback.
abstract interface class HeadlessPressableSurfaceFactory {
  /// Wraps the [child] widget with an interactive pressable surface.
  ///
  /// The surface handles:
  /// - Visual feedback (ripple, opacity, etc.)
  /// - Focus management
  /// - Mouse cursor
  ///
  /// [controller] provides the current interaction state (pressed/hovered/focused).
  /// [enabled] determines if the surface is interactive.
  /// [onActivate] is called when the surface is activated (tap/enter/space).
  Widget wrap({
    required BuildContext context,
    required HeadlessPressableController controller,
    required bool enabled,
    required VoidCallback onActivate,
    required Widget child,
    RenderOverrides? overrides,
    HeadlessPressableVisualEffectsController? visualEffects,
    FocusNode? focusNode,
    bool autofocus = false,
    MouseCursor? cursorWhenEnabled,
    MouseCursor? cursorWhenDisabled,
  });
}
