import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';

final class RAutocompleteFieldRequestComposer {
  const RAutocompleteFieldRequestComposer();

  RTextFieldSpec createSpec({
    required String? placeholder,
  }) {
    return RTextFieldSpec(
      placeholder: placeholder,
    );
  }

  RTextFieldState createState({
    required HeadlessFocusHoverState focusHoverState,
    required String text,
    required bool isDisabled,
    required bool isReadOnly,
  }) {
    return RTextFieldState(
      isFocused: focusHoverState.isFocused,
      isHovered: focusHoverState.isHovered,
      isDisabled: isDisabled,
      isReadOnly: isReadOnly,
      hasText: text.isNotEmpty,
      isError: false,
      isObscured: false,
    );
  }

  RTextFieldSemantics createSemantics({
    required String? label,
    required String? hint,
    required bool isEnabled,
    required bool isReadOnly,
  }) {
    return RTextFieldSemantics(
      label: label,
      hint: hint,
      isEnabled: isEnabled,
      isReadOnly: isReadOnly,
      isObscured: false,
      errorText: null,
    );
  }

  Widget wrapWithInteraction({
    required bool enabled,
    required bool readOnly,
    required HeadlessFocusHoverController controller,
    required Widget child,
    RTextFieldResolvedTokens? resolvedTokens,
  }) {
    final cursor = !enabled
        ? SystemMouseCursors.forbidden
        : readOnly
            ? SystemMouseCursors.basic
            : SystemMouseCursors.text;

    Widget content = HeadlessHoverRegion(
      controller: controller,
      enabled: enabled,
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

    if (!enabled) {
      content = IgnorePointer(child: content);
    }

    return content;
  }
}
