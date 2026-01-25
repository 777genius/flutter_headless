import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

final class RAutocompleteEditableTextFactory {
  const RAutocompleteEditableTextFactory();

  Widget create({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool autofocus,
    required bool readOnly,
    required bool enabled,
    required ValueChanged<String> onChanged,
    required ValueChanged<String> onSubmitted,
    required KeyEventResult Function(FocusNode, KeyEvent) onKeyEvent,
    RTextFieldResolvedTokens? resolvedTokens,
  }) {
    final textStyle = resolvedTokens?.textStyle ?? const TextStyle();
    final textColor = resolvedTokens?.textColor;
    final cursorColor = resolvedTokens?.cursorColor ??
        DefaultTextStyle.of(context).style.color ??
        const Color(0xFF000000);
    final selectionColor = resolvedTokens?.selectionColor;
    final effectiveStyle = textStyle.copyWith(color: textColor);

    final editableText = EditableText(
      controller: controller,
      focusNode: focusNode,
      style: effectiveStyle,
      cursorColor: cursorColor,
      backgroundCursorColor: cursorColor.withValues(alpha: 0.2),
      selectionColor: selectionColor,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      autofocus: autofocus,
      obscureText: false,
      readOnly: readOnly || !enabled,
      maxLines: 1,
      minLines: 1,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );

    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: onKeyEvent,
      child: TextFieldTapRegion(
        groupId: focusNode,
        child: editableText,
      ),
    );
  }
}
