import 'package:flutter/widgets.dart';

import 'r_dropdown_request.dart';

// Re-export all dropdown types for convenient single import
export 'r_dropdown_commands.dart';
export 'r_dropdown_request.dart';
export 'r_dropdown_slots.dart';
export 'r_dropdown_spec.dart';
export 'r_dropdown_state.dart';

/// Renderer capability for DropdownButton components.
///
/// This is a capability contract (ISP): components request this interface
/// via [HeadlessTheme.capability<RDropdownButtonRenderer>()].
///
/// Renderers implement this to provide visual representation.
/// Components never know the concrete renderer implementation.
///
/// **Non-generic by design**: The renderer only needs UI data (labels, indices,
/// disabled states). The generic `T` is handled by the component, which maps
/// `value` ↔ `index` internally.
///
/// See `docs/V1_DECISIONS.md` → "4) Renderer contracts + Slots override".
abstract interface class RDropdownButtonRenderer {
  /// Render a dropdown button with the given request.
  Widget render(RDropdownRenderRequest request);
}
