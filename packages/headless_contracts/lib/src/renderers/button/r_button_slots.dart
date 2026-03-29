import 'package:flutter/widgets.dart';

import '../../slots/slot_override.dart';
import 'r_button_renderer.dart';
import 'r_button_resolved_tokens.dart';

/// Context for the button surface slot.
@immutable
final class RButtonSurfaceContext {
  const RButtonSurfaceContext({
    required this.spec,
    required this.state,
    required this.child,
    this.resolvedTokens,
  });

  final RButtonSpec spec;
  final RButtonState state;
  final Widget child;
  final RButtonResolvedTokens? resolvedTokens;
}

/// Context for the button content slot.
@immutable
final class RButtonContentContext {
  const RButtonContentContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RButtonSpec spec;
  final RButtonState state;
  final Widget child;
}

/// Context for the button icon slots.
@immutable
final class RButtonIconContext {
  const RButtonIconContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RButtonSpec spec;
  final RButtonState state;
  final Widget child;
}

/// Context for the button spinner slot.
@immutable
final class RButtonSpinnerContext {
  const RButtonSpinnerContext({
    required this.spec,
    required this.state,
    required this.child,
  });

  final RButtonSpec spec;
  final RButtonState state;
  final Widget child;
}

/// Button slots for partial customization (Replace/Decorate/Enhance).
@immutable
final class RButtonSlots {
  const RButtonSlots({
    this.surface,
    this.content,
    this.leadingIcon,
    this.trailingIcon,
    this.spinner,
  });

  final SlotOverride<RButtonSurfaceContext>? surface;
  final SlotOverride<RButtonContentContext>? content;
  final SlotOverride<RButtonIconContext>? leadingIcon;
  final SlotOverride<RButtonIconContext>? trailingIcon;
  final SlotOverride<RButtonSpinnerContext>? spinner;
}
