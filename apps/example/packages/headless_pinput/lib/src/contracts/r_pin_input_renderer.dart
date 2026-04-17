import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'r_pin_input_commands.dart';
import 'r_pin_input_resolved_tokens.dart';
import 'r_pin_input_types.dart';

abstract interface class RPinInputRenderer {
  Widget render(RPinInputRenderRequest request);
}

@immutable
final class RPinInputRenderRequest {
  const RPinInputRenderRequest({
    required this.context,
    required this.hiddenInput,
    required this.spec,
    required this.state,
    required this.cells,
    required this.value,
    this.visibleErrorText,
    this.commands,
    this.resolvedTokens,
    this.overrides,
  });

  final BuildContext context;
  final Widget hiddenInput;
  final RPinInputSpec spec;
  final RPinInputState state;
  final List<RPinInputCell> cells;
  final String value;
  final String? visibleErrorText;
  final RPinInputCommands? commands;
  final RPinInputResolvedTokens? resolvedTokens;
  final RenderOverrides? overrides;
}

@immutable
final class RPinInputSpec {
  const RPinInputSpec({
    required this.length,
    required this.variant,
    required this.animationType,
    required this.animationCurve,
    required this.animationDuration,
    required this.slideTransitionBeginOffset,
    required this.obscureText,
    required this.obscuringCharacter,
    required this.showCursor,
  });

  final int length;
  final RPinInputVariant variant;
  final RPinInputAnimationType animationType;
  final Curve animationCurve;
  final Duration animationDuration;
  final Offset slideTransitionBeginOffset;
  final bool obscureText;
  final String obscuringCharacter;
  final bool showCursor;
}

@immutable
final class RPinInputState {
  const RPinInputState({
    required this.isFocused,
    required this.isHovered,
    required this.isDisabled,
    required this.isReadOnly,
    required this.hasError,
    required this.isCompleted,
    required this.useNativeKeyboard,
    required this.currentLength,
  });

  final bool isFocused;
  final bool isHovered;
  final bool isDisabled;
  final bool isReadOnly;
  final bool hasError;
  final bool isCompleted;
  final bool useNativeKeyboard;
  final int currentLength;
}
