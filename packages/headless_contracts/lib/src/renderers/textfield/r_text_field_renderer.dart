import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../render_overrides.dart';
import 'r_text_field_commands.dart';
import 'r_text_field_overlay_visibility_mode.dart';
import 'r_text_field_resolved_tokens.dart';
import 'r_text_field_semantics.dart';

/// Renderer capability for TextField components.
///
/// This is a capability contract (ISP): components request this interface
/// via [HeadlessTheme.capability<RTextFieldRenderer>()].
///
/// Key principle: Renderer does NOT create [EditableText].
/// It receives the `input` widget from the component and wraps/positions it.
///
/// See `docs/implementation/I14_headless_textfield_editabletext_v1.md`.
abstract interface class RTextFieldRenderer {
  /// Render a text field with the given request.
  ///
  /// The [RTextFieldRenderRequest.input] contains the [EditableText]
  /// (or wrapped version) created by the component. Renderer must
  /// include it in the widget tree without modification.
  Widget render(RTextFieldRenderRequest request);
}

/// Render request containing everything a text field renderer needs.
///
/// Follows the pattern: context + spec + state + semantics + commands + slots + tokens.
/// The critical difference from Button: [input] is required and contains
/// the pre-built [EditableText] from the component.
///
/// See `docs/V1_DECISIONS.md` → "0.1 Renderer contracts".
@immutable
final class RTextFieldRenderRequest {
  const RTextFieldRenderRequest({
    required this.context,
    required this.input,
    required this.spec,
    required this.state,
    this.semantics,
    this.commands,
    this.slots,
    this.resolvedTokens,
    this.constraints,
    this.overrides,
  });

  /// Build context for theme/media query access.
  final BuildContext context;

  /// The input widget (EditableText or wrapped version).
  ///
  /// Created by the component. Renderer must include this in the tree.
  /// This is the "Variant A" approach: component owns text editing,
  /// renderer owns visual decoration.
  final Widget input;

  /// Static specification (placeholder, label, etc.).
  final RTextFieldSpec spec;

  /// Current interaction state.
  final RTextFieldState state;

  /// Semantic information for accessibility.
  final RTextFieldSemantics? semantics;

  /// Internal component commands for UI wiring.
  ///
  /// Used by renderer for tap-to-focus on container, NOT for text changes.
  final RTextFieldCommands? commands;

  /// Optional slots for partial override (leading/trailing icons, etc.).
  final RTextFieldSlots? slots;

  /// Pre-resolved visual tokens.
  ///
  /// If provided, renderer should use these directly.
  /// If null, renderer may use default theme values.
  final RTextFieldResolvedTokens? resolvedTokens;

  /// Layout constraints (e.g., minimum width).
  final BoxConstraints? constraints;

  /// Per-instance override bag for preset customization.
  ///
  /// Allows "style on this specific field" without API pollution.
  /// See `docs/FLEXIBLE_PRESETS_AND_PER_INSTANCE_OVERRIDES.md`.
  final RenderOverrides? overrides;
}

/// TextField specification (static, from widget props).
///
/// Contains text content metadata and display options.
/// This is the "what" of the field (not the "how" — that's the renderer).
@immutable
final class RTextFieldSpec {
  const RTextFieldSpec({
    this.placeholder,
    this.label,
    this.helperText,
    this.errorText,
    this.variant = RTextFieldVariant.filled,
    this.maxLines = 1,
    this.minLines,
    this.clearButtonMode = RTextFieldOverlayVisibilityMode.never,
    this.prefixMode = RTextFieldOverlayVisibilityMode.always,
    this.suffixMode = RTextFieldOverlayVisibilityMode.always,
  });

  /// Placeholder text shown when field is empty.
  final String? placeholder;

  /// Label text (shown above or floating).
  final String? label;

  /// Helper text (shown below field).
  final String? helperText;

  /// Error text (shown below field, replaces helper when set).
  final String? errorText;

  /// Visual variant of the field.
  ///
  /// This is an intent. Each preset (Material/Cupertino/...) maps it to
  /// platform-specific visuals.
  final RTextFieldVariant variant;

  /// Maximum number of lines.
  ///
  /// Defaults to 1 (single-line). Set to null for unlimited.
  final int? maxLines;

  /// Minimum number of lines.
  ///
  /// Only meaningful for multiline fields.
  final int? minLines;

  /// Visibility mode for the clear button.
  ///
  /// Defaults to [RTextFieldOverlayVisibilityMode.never].
  /// Cupertino typically uses [RTextFieldOverlayVisibilityMode.whileEditing].
  final RTextFieldOverlayVisibilityMode clearButtonMode;

  /// Visibility mode for the prefix widget.
  ///
  /// Defaults to [RTextFieldOverlayVisibilityMode.always].
  final RTextFieldOverlayVisibilityMode prefixMode;

  /// Visibility mode for the suffix widget.
  ///
  /// Defaults to [RTextFieldOverlayVisibilityMode.always].
  final RTextFieldOverlayVisibilityMode suffixMode;

  /// Whether this is a multiline field.
  bool get isMultiline => maxLines == null || maxLines! > 1;
}

/// TextField visual variants.
///
/// This is a cross-preset intent that renderers interpret.
enum RTextFieldVariant {
  /// Filled container style (default).
  filled,

  /// Outlined container style.
  outlined,

  /// Underlined style.
  ///
  /// This intent is commonly used in Material (bottom border only).
  /// Presets may map it to the nearest native equivalent.
  underlined,
}

/// TextField interaction state.
///
/// Derived from component's internal state, exposed as simple flags
/// for renderer convenience.
@immutable
final class RTextFieldState {
  const RTextFieldState({
    this.isFocused = false,
    this.isHovered = false,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.hasText = false,
    this.isError = false,
    this.isObscured = false,
  });

  /// Whether the field has keyboard focus.
  final bool isFocused;

  /// Whether the pointer is hovering over the field.
  final bool isHovered;

  /// Whether the field is disabled.
  final bool isDisabled;

  /// Whether the field is read-only.
  final bool isReadOnly;

  /// Whether the field contains text.
  ///
  /// Used for floating label behavior.
  final bool hasText;

  /// Whether the field has an error.
  ///
  /// Derived from errorText presence in spec.
  final bool isError;

  /// Whether the text is obscured (password mode).
  final bool isObscured;

  /// Create state from Flutter's WidgetState set + text field specifics.
  factory RTextFieldState.fromWidgetStates(
    Set<WidgetState> states, {
    bool hasText = false,
    bool isError = false,
    bool isObscured = false,
    bool isReadOnly = false,
  }) {
    final decoded = WidgetStateHelper.fromWidgetStates(states);
    return RTextFieldState(
      isFocused: decoded.isFocused,
      isHovered: decoded.isHovered,
      isDisabled: decoded.isDisabled,
      isReadOnly: isReadOnly,
      hasText: hasText,
      isError: isError,
      isObscured: isObscured,
    );
  }

  /// Convert to Flutter's WidgetState set.
  Set<WidgetState> toWidgetStates() {
    return WidgetStateHelper.toWidgetStates(
      isFocused: isFocused,
      isHovered: isHovered,
      isDisabled: isDisabled,
      isError: isError,
    );
  }
}

/// TextField slots for partial customization (Replace/Decorate pattern).
///
/// Allows overriding specific visual parts without reimplementing
/// the entire renderer.
///
/// See `docs/V1_DECISIONS.md` → "4) Renderer contracts + Slots override".
@immutable
final class RTextFieldSlots {
  const RTextFieldSlots({
    this.leading,
    this.trailing,
    this.prefix,
    this.suffix,
  });

  /// Widget to display before the input (e.g., search icon).
  ///
  /// Placed outside the input area.
  final Widget? leading;

  /// Widget to display after the input (e.g., clear button).
  ///
  /// Placed outside the input area.
  final Widget? trailing;

  /// Widget to display before text inside the input (e.g., "$").
  ///
  /// Placed inline with text.
  final Widget? prefix;

  /// Widget to display after text inside the input (e.g., "USD").
  ///
  /// Placed inline with text.
  final Widget? suffix;
}
