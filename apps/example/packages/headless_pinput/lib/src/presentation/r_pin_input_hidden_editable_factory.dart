import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

final class RPinInputHiddenEditableFactory {
  const RPinInputHiddenEditableFactory();

  static const TextStyle _hiddenTextStyle = TextStyle(
    color: Color(0x00000000),
    fontSize: 1,
    height: 1,
  );

  Widget create({
    required GlobalKey<EditableTextState> editableTextKey,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool autofocus,
    required bool enabled,
    required bool readOnly,
    required bool useNativeKeyboard,
    required bool enableIMEPersonalizedLearning,
    required bool? enableInteractiveSelection,
    required bool enableSuggestions,
    required bool toolbarEnabled,
    required TextInputType keyboardType,
    required TextCapitalization textCapitalization,
    required Brightness? keyboardAppearance,
    required TextInputAction? textInputAction,
    required Iterable<String>? autofillHints,
    required EdgeInsets scrollPadding,
    required List<TextInputFormatter> inputFormatters,
    required EditableTextContextMenuBuilder? contextMenuBuilder,
    required ValueChanged<String> onChanged,
    required ValueChanged<String> onSubmitted,
    required TapRegionCallback? onTapOutside,
    required VoidCallback? onEditingComplete,
  }) {
    final resolvedContextMenuBuilder = toolbarEnabled
        ? contextMenuBuilder
        : (_, __) => const SizedBox.shrink();

    return RepaintBoundary(
      child: EditableText(
        key: editableTextKey,
        controller: controller,
        focusNode: focusNode,
        style: _hiddenTextStyle,
        cursorColor: const Color(0x00000000),
        backgroundCursorColor: const Color(0x00000000),
        selectionColor: const Color(0x00000000),
        maxLines: 1,
        autofocus: autofocus,
        clipBehavior: Clip.hardEdge,
        rendererIgnoresPointer: true,
        readOnly: readOnly || !enabled || !useNativeKeyboard,
        showCursor: false,
        showSelectionHandles: false,
        enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
        enableInteractiveSelection:
            enableInteractiveSelection ?? toolbarEnabled,
        autocorrect: false,
        enableSuggestions: enableSuggestions,
        smartDashesType: SmartDashesType.disabled,
        smartQuotesType: SmartQuotesType.disabled,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        scrollPadding: scrollPadding,
        inputFormatters: inputFormatters,
        keyboardAppearance: keyboardAppearance ?? Brightness.light,
        mouseCursor: MouseCursor.defer,
        textAlign: TextAlign.center,
        contextMenuBuilder: resolvedContextMenuBuilder,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onTapOutside: onTapOutside,
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}
