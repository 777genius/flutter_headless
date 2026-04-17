import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

import '../contracts/r_pin_input_types.dart';
import '../logic/r_pin_input_actions.dart';
import '../logic/r_pin_input_code_retriever.dart';
import 'r_pin_input_state.dart';
import 'r_pin_input_style.dart';

class RPinInput extends StatefulWidget {
  RPinInput({
    super.key,
    this.length = 6,
    this.value,
    this.controller,
    this.onChanged,
    this.onCompleted,
    this.onSubmitted,
    this.onTap,
    this.onLongPress,
    this.onTapOutside,
    this.onEditingComplete,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.useNativeKeyboard = true,
    this.toolbarEnabled = true,
    this.autofocus = false,
    this.obscureText = false,
    this.showCursor = true,
    this.enableIMEPersonalizedLearning = false,
    this.enableInteractiveSelection,
    this.enableSuggestions = true,
    this.closeKeyboardWhenCompleted = true,
    this.keyboardType = TextInputType.number,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardAppearance,
    this.textInputAction,
    this.autofillHints = const <String>[AutofillHints.oneTimeCode],
    this.obscuringCharacter = '•',
    this.scrollPadding = const EdgeInsets.all(20),
    this.inputFormatters = const <TextInputFormatter>[],
    this.contextMenuBuilder,
    this.hapticFeedbackType = RPinInputHapticFeedbackType.disabled,
    this.onClipboardFound,
    this.codeRetriever,
    this.forceErrorState = false,
    this.showErrorWhenFocused = false,
    this.errorText,
    this.semanticLabel,
    this.semanticHint,
    this.validator,
    this.autovalidateMode = RPinInputAutovalidateMode.onSubmit,
    this.variant = RPinInputVariant.outlined,
    this.animationType = RPinInputAnimationType.scale,
    this.animationCurve = Curves.easeIn,
    this.animationDuration = const Duration(milliseconds: 180),
    this.slideTransitionBeginOffset = const Offset(0.8, 0),
    this.style,
    this.overrides,
  }) {
    validatePinInputControlConfig(value: value, controller: controller);
  }

  final int length;
  final String? value;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
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
  final ValueChanged<String>? onClipboardFound;
  final RPinInputCodeRetriever? codeRetriever;
  final bool forceErrorState;
  final bool showErrorWhenFocused;
  final String? errorText;
  final String? semanticLabel;
  final String? semanticHint;
  final String? Function(String)? validator;
  final RPinInputAutovalidateMode autovalidateMode;
  final RPinInputVariant variant;
  final RPinInputAnimationType animationType;
  final Curve animationCurve;
  final Duration animationDuration;
  final Offset slideTransitionBeginOffset;
  final RPinInputStyle? style;
  final RenderOverrides? overrides;

  @override
  State<RPinInput> createState() => RPinInputStateImpl();
}
