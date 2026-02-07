import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';

import '../primitives/textfield/cupertino_text_field_affix.dart';
import '../primitives/textfield/cupertino_text_field_clear_button.dart';
import '../primitives/textfield/cupertino_text_field_surface.dart';

/// Cupertino renderer for TextField components.
///
/// Implements [RTextFieldRenderer] with iOS styling.
///
/// Layout structure:
/// ```
/// CupertinoTextFieldSurface
///   └─ Row
///        ├─ leading (outside)
///        ├─ CupertinoTextFieldAffix(prefix)
///        ├─ Expanded
///        │    └─ Stack
///        │         ├─ placeholder (if !hasText)
///        │         └─ request.input
///        ├─ CupertinoTextFieldAffix(suffix)
///        ├─ trailing (outside)
///        └─ CupertinoTextFieldClearButton
/// ```
class CupertinoTextFieldRenderer implements RTextFieldRenderer {
  const CupertinoTextFieldRenderer();

  @override
  Widget render(RTextFieldRenderRequest request) {
    final tokens = request.resolvedTokens;
    final state = request.state;
    final spec = request.spec;
    final slots = request.slots;

    // Get effective values from tokens or use defaults
    final backgroundColor =
        tokens?.containerBackgroundColor ?? CupertinoColors.white;
    final borderColor = tokens?.containerBorderColor ?? const Color(0xFFC6C6C8);
    final borderRadius = tokens?.containerBorderRadius ??
        const BorderRadius.all(Radius.circular(5));
    final borderWidth = tokens?.containerBorderWidth ?? 0.5;
    final padding = tokens?.containerPadding ?? const EdgeInsets.all(7);
    final animationDuration =
        tokens?.containerAnimationDuration ?? const Duration(milliseconds: 200);
    final placeholderStyle = tokens?.placeholderStyle ?? const TextStyle();
    final placeholderColor =
        tokens?.placeholderColor ?? CupertinoColors.placeholderText;
    final iconColor = tokens?.iconColor ?? CupertinoColors.placeholderText;
    final disabledOpacity = tokens?.disabledOpacity ?? 0.38;

    // Build placeholder
    Widget? placeholder;
    if (spec.placeholder != null && !state.hasText) {
      placeholder = Text(
        spec.placeholder!,
        style: placeholderStyle.copyWith(color: placeholderColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    // Build input area with placeholder
    Widget inputArea = Stack(
      alignment: Alignment.centerLeft,
      children: [
        if (placeholder != null)
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: placeholder,
            ),
          ),
        request.input,
      ],
    );

    // Build row with leading, prefix, input, suffix, trailing, clear button
    final rowChildren = <Widget>[];

    // Leading (outside, before field)
    if (slots?.leading != null) {
      rowChildren.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconTheme(
            data: IconThemeData(color: iconColor, size: 18),
            child: slots!.leading!,
          ),
        ),
      );
    }

    // Prefix
    if (slots?.prefix != null) {
      rowChildren.add(
        CupertinoTextFieldAffix(
          mode: spec.prefixMode,
          isFocused: state.isFocused,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconTheme(
              data: IconThemeData(color: iconColor, size: 18),
              child: slots!.prefix!,
            ),
          ),
        ),
      );
    }

    // Input area (expanded)
    rowChildren.add(Expanded(child: inputArea));

    // Suffix
    if (slots?.suffix != null) {
      rowChildren.add(
        CupertinoTextFieldAffix(
          mode: spec.suffixMode,
          isFocused: state.isFocused,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: IconTheme(
              data: IconThemeData(color: iconColor, size: 18),
              child: slots!.suffix!,
            ),
          ),
        ),
      );
    }

    // Trailing (outside, after field)
    if (slots?.trailing != null) {
      rowChildren.add(
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconTheme(
            data: IconThemeData(color: iconColor, size: 18),
            child: slots!.trailing!,
          ),
        ),
      );
    }

    // Clear button
    if (spec.clearButtonMode != RTextFieldOverlayVisibilityMode.never) {
      rowChildren.add(
        CupertinoTextFieldClearButton(
          mode: spec.clearButtonMode,
          hasText: state.hasText,
          isFocused: state.isFocused,
          isDisabled: state.isDisabled,
          isReadOnly: state.isReadOnly,
          onClear: request.commands?.clearText,
          iconColor: iconColor,
        ),
      );
    }

    Widget row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rowChildren,
    );

    // Wrap in surface
    Widget field = CupertinoTextFieldSurface(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      padding: padding,
      animationDuration: animationDuration,
      onTap: request.commands?.tapContainer,
      child: row,
    );

    // Apply disabled opacity
    if (state.isDisabled) {
      field = Opacity(
        opacity: disabledOpacity,
        child: field,
      );
    }

    return field;
  }
}
