import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

import '../contracts/r_pin_input_types.dart';
import '../logic/r_pin_input_code_retriever.dart';
import 'r_pin_input.dart';
import 'r_pin_input_style.dart';

final class RPinInputViewModel {
  const RPinInputViewModel({
    required this.length,
    required this.variant,
    required this.animationType,
    required this.animationCurve,
    required this.animationDuration,
    required this.slideTransitionBeginOffset,
    required this.enabled,
    required this.readOnly,
    required this.useNativeKeyboard,
    required this.toolbarEnabled,
    required this.autofocus,
    required this.obscureText,
    required this.showCursor,
    required this.enableIMEPersonalizedLearning,
    required this.enableInteractiveSelection,
    required this.enableSuggestions,
    required this.closeKeyboardWhenCompleted,
    required this.keyboardType,
    required this.textCapitalization,
    required this.keyboardAppearance,
    required this.textInputAction,
    required this.autofillHints,
    required this.obscuringCharacter,
    required this.scrollPadding,
    required this.inputFormatters,
    required this.contextMenuBuilder,
    required this.hapticFeedbackType,
    required this.forceErrorState,
    required this.showErrorWhenFocused,
    required this.errorText,
    required this.semanticLabel,
    required this.semanticHint,
    required this.hasError,
    required this.validator,
    required this.autovalidateMode,
    required this.onTapOutside,
    required this.onChanged,
    required this.onSubmitted,
    required this.onEditingComplete,
    required this.onClipboardFound,
    required this.codeRetriever,
    required this.style,
    required this.overrides,
  });

  final int length;
  final RPinInputVariant variant;
  final RPinInputAnimationType animationType;
  final Curve animationCurve;
  final Duration animationDuration;
  final Offset slideTransitionBeginOffset;
  final bool enabled;
  final bool readOnly;
  final bool useNativeKeyboard;
  final bool toolbarEnabled;
  final bool autofocus;
  final bool obscureText;
  final bool showCursor;
  final bool enableIMEPersonalizedLearning;
  final bool? enableInteractiveSelection;
  final bool enableSuggestions;
  final bool closeKeyboardWhenCompleted;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final Brightness? keyboardAppearance;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String obscuringCharacter;
  final EdgeInsets scrollPadding;
  final List<TextInputFormatter> inputFormatters;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final RPinInputHapticFeedbackType hapticFeedbackType;
  final bool forceErrorState;
  final bool showErrorWhenFocused;
  final String? errorText;
  final String? semanticLabel;
  final String? semanticHint;
  final bool hasError;
  final String? Function(String)? validator;
  final RPinInputAutovalidateMode autovalidateMode;
  final TapRegionCallback? onTapOutside;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onClipboardFound;
  final RPinInputCodeRetriever? codeRetriever;
  final RPinInputStyle? style;
  final RenderOverrides? overrides;

  factory RPinInputViewModel.fromWidget(
    RPinInput widget, {
    required String? effectiveErrorText,
    required bool hasError,
  }) {
    return RPinInputViewModel(
      length: widget.length,
      variant: widget.variant,
      animationType: widget.animationType,
      animationCurve: widget.animationCurve,
      animationDuration: widget.animationDuration,
      slideTransitionBeginOffset: widget.slideTransitionBeginOffset,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      useNativeKeyboard: widget.useNativeKeyboard,
      toolbarEnabled: widget.toolbarEnabled,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      showCursor: widget.showCursor,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      enableSuggestions: widget.enableSuggestions,
      closeKeyboardWhenCompleted: widget.closeKeyboardWhenCompleted,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      keyboardAppearance: widget.keyboardAppearance,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      obscuringCharacter: widget.obscuringCharacter,
      scrollPadding: widget.scrollPadding,
      inputFormatters: widget.inputFormatters,
      contextMenuBuilder: widget.contextMenuBuilder,
      hapticFeedbackType: widget.hapticFeedbackType,
      forceErrorState: widget.forceErrorState,
      showErrorWhenFocused: widget.showErrorWhenFocused,
      errorText: effectiveErrorText,
      semanticLabel: widget.semanticLabel,
      semanticHint: widget.semanticHint,
      hasError: hasError,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      onTapOutside: widget.onTapOutside,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      onClipboardFound: widget.onClipboardFound,
      codeRetriever: widget.codeRetriever,
      style: widget.style,
      overrides: widget.overrides,
    );
  }
}
