import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'r_text_field_view_model.dart';

final class RTextFieldRequestComposer {
  const RTextFieldRequestComposer();

  RTextFieldSpec createSpec(RTextFieldViewModel w) {
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
    required RTextFieldViewModel viewModel,
    required HeadlessFocusHoverState focusHoverState,
    required String text,
  }) {
    return RTextFieldState(
      isFocused: focusHoverState.isFocused,
      isHovered: focusHoverState.isHovered,
      isDisabled: !viewModel.enabled,
      isReadOnly: viewModel.readOnly,
      hasText: text.isNotEmpty,
      isError: viewModel.hasError,
      isObscured: viewModel.obscureText,
    );
  }

  RTextFieldSemantics createSemantics(RTextFieldViewModel w) {
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
    required RTextFieldViewModel viewModel,
    required String text,
  }) {
    if (viewModel.obscureText) return null;
    if (viewModel.errorText == null || viewModel.errorText!.isEmpty) {
      return text;
    }
    return text.isEmpty
        ? 'Error: ${viewModel.errorText}'
        : '$text, Error: ${viewModel.errorText}';
  }

  Widget wrapWithInteraction({
    required RTextFieldViewModel viewModel,
    required HeadlessFocusHoverController controller,
    required Widget child,
    RTextFieldResolvedTokens? resolvedTokens,
  }) {
    final cursor = !viewModel.enabled
        ? SystemMouseCursors.forbidden
        : viewModel.readOnly
            ? SystemMouseCursors.basic
            : SystemMouseCursors.text;

    Widget content = HeadlessHoverRegion(
      controller: controller,
      enabled: viewModel.enabled,
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

    if (!viewModel.enabled) {
      content = IgnorePointer(child: content);
    }

    return content;
  }
}
