import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import 'package:headless_material/primitives.dart';
import 'material_text_field_token_resolver.dart';
import 'dart:math' as math;

/// Material 3 renderer for TextField components.
///
/// Implements [RTextFieldRenderer] with Material Design 3 visuals.
///
/// CRITICAL INVARIANT:
/// - Renderer does NOT create [EditableText].
/// - It receives the `input` widget from the component and wraps it.
/// - All text editing behavior is handled by the component.
///
/// This renderer provides:
/// - Material 3 container decoration (outlined/filled variants)
/// - Floating label animation
/// - Helper/error text display
/// - Leading/trailing icon slots
///
/// See `docs/implementation/I14_headless_textfield_editabletext_v1.md`.
class MaterialTextFieldRenderer implements RTextFieldRenderer {
  const MaterialTextFieldRenderer();

  @override
  Widget render(RTextFieldRenderRequest request) {
    final state = request.state;
    final spec = request.spec;
    final slots = request.slots;
    final commands = request.commands;
    final tokens = _resolveTokens(request);

    final containerPadding = tokens.containerPadding;
    final backgroundColor = tokens.containerBackgroundColor;
    final borderColor = tokens.containerBorderColor;
    final borderRadius = tokens.containerBorderRadius;
    final borderWidth = tokens.containerBorderWidth;
    final animationDuration = tokens.containerAnimationDuration;

    final labelStyle = tokens.labelStyle;
    final labelColor = tokens.labelColor;
    final helperStyle = tokens.helperStyle;
    final helperColor = tokens.helperColor;
    final errorStyle = tokens.errorStyle;
    final errorColor = tokens.errorColor;
    final placeholderStyle = tokens.placeholderStyle;
    final placeholderColor = tokens.placeholderColor;
    final iconColor = tokens.iconColor;
    final iconSpacing = tokens.iconSpacing;
    final messageSpacing = tokens.messageSpacing;

    final disabledOpacity = tokens.disabledOpacity;

    // Build the input row with leading/trailing.
    //
    // Important: prefix/suffix must NOT share flex with the input. Otherwise
    // they get ~50% width and start clipping even when the input has plenty
    // of unused space (common with multi-select chips).
    Widget inputRow = LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final minInputWidth = math.min(
          maxWidth,
          (maxWidth * 0.35).clamp(120.0, 240.0), // always leave typing space
        );

        final affixCount = (slots?.prefix != null ? 1 : 0) +
            (slots?.suffix != null ? 1 : 0);
        final maxAffixWidth = affixCount == 0
            ? 0.0
            : math.max(0.0, maxWidth - minInputWidth) / affixCount;

        final prefix = slots?.prefix == null
            ? null
            : ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxAffixWidth),
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: 1,
                  child: slots!.prefix!,
                ),
              );

        final suffix = slots?.suffix == null
            ? null
            : ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxAffixWidth),
                child: Align(
                  alignment: Alignment.centerRight,
                  widthFactor: 1,
                  child: slots!.suffix!,
                ),
              );

        return Row(
          children: [
            if (slots?.leading != null) ...[
              IconTheme(
                data: IconThemeData(color: iconColor, size: 24),
                child: slots!.leading!,
              ),
              SizedBox(width: iconSpacing),
            ],
            if (prefix != null) prefix,
            Expanded(
              child: Stack(
                children: [
                  // Placeholder (shown when empty and not focused with label)
                  if (!state.hasText && spec.placeholder != null)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            spec.placeholder!,
                            style: placeholderStyle.copyWith(
                              color: placeholderColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  // The actual input widget
                  request.input,
                ],
              ),
            ),
            if (suffix != null) suffix,
            if (slots?.trailing != null) ...[
              SizedBox(width: iconSpacing),
              IconTheme(
                data: IconThemeData(color: iconColor, size: 24),
                child: slots!.trailing!,
              ),
            ],
          ],
        );
      },
    );

    // Build container border based on variant.
    final containerBorder = switch (spec.variant) {
      RTextFieldVariant.underlined => Border(
          bottom: BorderSide(color: borderColor, width: borderWidth),
        ),
      RTextFieldVariant.filled || RTextFieldVariant.outlined => Border.all(
          color: borderColor,
          width: borderWidth,
        ),
    };
    Widget container = GestureDetector(
      onTap: commands?.tapContainer,
      behavior: HitTestBehavior.opaque,
      child: MaterialSurface(
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        border: containerBorder,
        padding: containerPadding,
        animationDuration: animationDuration,
        child: inputRow,
      ),
    );

    // Apply disabled opacity
    if (state.isDisabled) {
      container = Opacity(
        opacity: disabledOpacity,
        child: container,
      );
    }

    // Build full field with label and helper/error
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (spec.label != null) ...[
          Text(
            spec.label!,
            style: labelStyle.copyWith(
              color: state.isError ? errorColor : labelColor,
            ),
          ),
          SizedBox(height: messageSpacing),
        ],
        // Container
        container,
        // Helper or Error text
        if (spec.errorText != null || spec.helperText != null) ...[
          SizedBox(height: messageSpacing),
          Text(
            spec.errorText ?? spec.helperText!,
            style: spec.errorText != null
                ? errorStyle.copyWith(color: errorColor)
                : helperStyle.copyWith(color: helperColor),
          ),
        ],
      ],
    );
  }

  RTextFieldResolvedTokens _resolveTokens(RTextFieldRenderRequest request) {
    final policy = HeadlessThemeProvider.of(request.context)
        ?.capability<HeadlessRendererPolicy>();
    final requireTokens = policy?.requireResolvedTokens == true;
    final resolved = request.resolvedTokens;
    if (requireTokens && resolved == null) {
      throw StateError(
        '[Headless] MaterialTextFieldRenderer требует resolvedTokens.\n'
        'Как исправить:\n'
        '- Используй preset: HeadlessMaterialApp(...)\n'
        '- Или предоставь RTextFieldTokenResolver в HeadlessTheme\n'
        '- Или отключи strict: HeadlessMaterialApp(requireResolvedTokens: false, ...)',
      );
    }
    assert(
      !requireTokens || resolved != null,
      'MaterialTextFieldRenderer requires resolvedTokens when '
      'HeadlessRendererPolicy.requireResolvedTokens is enabled.',
    );
    if (resolved != null) return resolved;

    return const MaterialTextFieldTokenResolver().resolve(
      context: request.context,
      spec: request.spec,
      states: request.state.toWidgetStates(),
      constraints: request.constraints,
      overrides: request.overrides,
    );
  }
}
