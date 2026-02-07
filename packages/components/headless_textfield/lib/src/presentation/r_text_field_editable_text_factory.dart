import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

final class RTextFieldEditableTextFactory {
  const RTextFieldEditableTextFactory();

  Widget create({
    required BuildContext context,
    GlobalKey<EditableTextState>? editableTextKey,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool autofocus,
    required bool obscureText,
    required bool readOnly,
    required bool enabled,
    required bool isMultiline,
    required TextInputType? keyboardType,
    required TextInputAction? textInputAction,
    required TextCapitalization textCapitalization,
    required bool autocorrect,
    required bool enableSuggestions,
    required SmartDashesType? smartDashesType,
    required SmartQuotesType? smartQuotesType,
    required int? maxLines,
    required int? minLines,
    required bool? showCursor,
    required Brightness? keyboardAppearance,
    required EdgeInsets scrollPadding,
    required DragStartBehavior dragStartBehavior,
    required bool? enableInteractiveSelection,
    required List<TextInputFormatter>? inputFormatters,
    required ValueChanged<String> onChanged,
    required ValueChanged<String> onSubmitted,
    required VoidCallback? onEditingComplete,
    required TapRegionCallback? onTapOutside,
    RTextFieldResolvedTokens? resolvedTokens,
  }) {
    final selectionStyle = DefaultSelectionStyle.of(context);
    final textStyle = resolvedTokens?.textStyle ??
        DefaultTextStyle.of(context).style;
    final textColor = resolvedTokens?.textColor;
    final cursorColor = resolvedTokens?.cursorColor ??
        selectionStyle.cursorColor ??
        DefaultTextStyle.of(context).style.color ??
        const Color(0xFF000000);
    final selectionColor = resolvedTokens?.selectionColor ??
        selectionStyle.selectionColor;

    final effectiveStyle = textStyle.copyWith(color: textColor);

    return EditableText(
      key: editableTextKey,
      controller: controller,
      focusNode: focusNode,
      style: effectiveStyle,
      cursorColor: cursorColor,
      backgroundCursorColor: cursorColor.withValues(alpha: 0.2),
      selectionColor: selectionColor,
      keyboardType: keyboardType ?? _inferKeyboardType(isMultiline),
      textInputAction: textInputAction ?? _inferTextInputAction(isMultiline),
      textCapitalization: textCapitalization,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      autofocus: autofocus,
      obscureText: obscureText,
      readOnly: readOnly || !enabled,
      showCursor: showCursor,
      maxLines: maxLines,
      minLines: minLines,
      keyboardAppearance:
          keyboardAppearance ?? MediaQuery.platformBrightnessOf(context),
      scrollPadding: scrollPadding,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection:
          enableInteractiveSelection ?? !obscureText,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      onTapOutside: onTapOutside,
      // Match Flutter TextField: gesture handling is external.
      rendererIgnoresPointer: true,
      mouseCursor: MouseCursor.defer,
    );
  }

  TextInputType _inferKeyboardType(bool isMultiline) {
    return isMultiline ? TextInputType.multiline : TextInputType.text;
  }

  TextInputAction _inferTextInputAction(bool isMultiline) {
    return isMultiline ? TextInputAction.newline : TextInputAction.done;
  }
}
