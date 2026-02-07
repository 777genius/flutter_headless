import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'r_text_field.dart';

final class RTextFieldRequestComposer {
  const RTextFieldRequestComposer();

  RTextFieldSpec createSpec(RTextField w) {
    return RTextFieldSpec(
      placeholder: w.placeholder,
      label: w.label,
      helperText: w.helperText,
      errorText: w.errorText,
      variant: w.variant,
      maxLines: w.maxLines,
      minLines: w.minLines,
      clearButtonMode: w.clearButtonMode,
      prefixMode: w.prefixMode,
      suffixMode: w.suffixMode,
    );
  }

  RTextFieldState createState({
    required RTextField widget,
    required HeadlessFocusHoverState focusHoverState,
    required String text,
  }) {
    return RTextFieldState(
      isFocused: focusHoverState.isFocused,
      isHovered: focusHoverState.isHovered,
      isDisabled: !widget.enabled,
      isReadOnly: widget.readOnly,
      hasText: text.isNotEmpty,
      isError: widget.hasError,
      isObscured: widget.obscureText,
    );
  }

  RTextFieldSemantics createSemantics(RTextField w) {
    return RTextFieldSemantics(
      label: w.label,
      hint: w.placeholder,
      isEnabled: w.enabled,
      isReadOnly: w.readOnly,
      isObscured: w.obscureText,
      errorText: w.errorText,
    );
  }

  String? createSemanticsValue({
    required RTextField widget,
    required String text,
  }) {
    if (widget.obscureText) return null;
    if (widget.errorText == null || widget.errorText!.isEmpty) return text;
    return text.isEmpty
        ? 'Error: ${widget.errorText}'
        : '$text, Error: ${widget.errorText}';
  }

  Widget wrapWithInteraction({
    required RTextField widget,
    required HeadlessFocusHoverController controller,
    required Widget child,
    RTextFieldResolvedTokens? resolvedTokens,
  }) {
    final cursor = !widget.enabled
        ? SystemMouseCursors.forbidden
        : widget.readOnly
            ? SystemMouseCursors.basic
            : SystemMouseCursors.text;

    Widget content = HeadlessHoverRegion(
      controller: controller,
      enabled: widget.enabled,
      cursorWhenEnabled: cursor,
      cursorWhenDisabled: SystemMouseCursors.forbidden,
      child: child,
    );

    final minSize = resolvedTokens?.minSize;
    if (minSize != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minSize.width,
          minHeight: minSize.height,
        ),
        child: content,
      );
    }

    if (!widget.enabled) {
      content = IgnorePointer(child: content);
    }

    return content;
  }
}
