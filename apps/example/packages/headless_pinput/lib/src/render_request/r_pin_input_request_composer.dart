import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../contracts/r_pin_input_commands.dart';
import '../contracts/r_pin_input_renderer.dart';
import '../contracts/r_pin_input_types.dart';
import '../logic/r_pin_input_state_mapper.dart';
import '../logic/r_pin_input_text_units.dart';
import '../presentation/r_pin_input_view_model.dart';

final class RPinInputRequestComposer {
  const RPinInputRequestComposer({
    RPinInputStateMapper stateMapper = const RPinInputStateMapper(),
  }) : _stateMapper = stateMapper;

  final RPinInputStateMapper _stateMapper;

  RPinInputSpec createSpec(RPinInputViewModel viewModel) {
    return RPinInputSpec(
      length: viewModel.length,
      variant: viewModel.variant,
      animationType: viewModel.animationType,
      animationCurve: viewModel.animationCurve,
      animationDuration: viewModel.animationDuration,
      slideTransitionBeginOffset: viewModel.slideTransitionBeginOffset,
      obscureText: viewModel.obscureText,
      obscuringCharacter: viewModel.obscuringCharacter,
      showCursor: viewModel.showCursor,
    );
  }

  RPinInputState createState({
    required RPinInputViewModel viewModel,
    required HeadlessFocusHoverState focusHoverState,
    required String text,
  }) {
    final currentLength = pinTextLength(text).clamp(0, viewModel.length);
    final hasVisualFocus = _stateMapper.hasVisualFocus(
      useNativeKeyboard: viewModel.useNativeKeyboard,
      focusNodeHasFocus: focusHoverState.isFocused,
      currentLength: currentLength,
      length: viewModel.length,
    );
    return RPinInputState(
      isFocused: hasVisualFocus,
      isHovered: focusHoverState.isHovered,
      isDisabled: !viewModel.enabled,
      isReadOnly: viewModel.readOnly,
      hasError: viewModel.hasError,
      isCompleted: currentLength == viewModel.length,
      useNativeKeyboard: viewModel.useNativeKeyboard,
      currentLength: currentLength,
    );
  }

  List<RPinInputCell> createCells({
    required RPinInputViewModel viewModel,
    required RPinInputState state,
    required bool showErrorState,
    required String text,
  }) {
    final currentLength = pinTextLength(text);
    return List<RPinInputCell>.generate(viewModel.length, (index) {
      final activeIndex = state.currentLength.clamp(0, viewModel.length - 1);
      final isActive = index == activeIndex;
      final rawValue = index < currentLength ? pinCharacterAt(text, index) : '';
      return RPinInputCell(
        index: index,
        state: _stateMapper.cellStateFor(
          index: index,
          length: viewModel.length,
          currentLength: state.currentLength,
          enabled: viewModel.enabled,
          showErrorState: showErrorState,
          hasVisualFocus: state.isFocused,
        ),
        rawValue: rawValue,
        displayText: rawValue.isEmpty
            ? ''
            : (viewModel.obscureText ? viewModel.obscuringCharacter : rawValue),
        isActive: isActive,
        showCursor: _stateMapper.shouldShowCursor(
          showCursor: viewModel.showCursor,
          enabled: viewModel.enabled,
          hasVisualFocus: state.isFocused,
          isActive: isActive,
        ),
      );
    });
  }

  RPinInputCommands createCommands({
    required VoidCallback onTapField,
    required VoidCallback onRequestKeyboard,
  }) {
    return RPinInputCommands(
      tapField: onTapField,
      requestKeyboard: onRequestKeyboard,
    );
  }

  Widget wrapWithInteraction({
    required RPinInputViewModel viewModel,
    required HeadlessFocusHoverController controller,
    required VoidCallback onTap,
    required VoidCallback? onLongPress,
    required Widget child,
  }) {
    final mouseCursor = !viewModel.enabled
        ? SystemMouseCursors.forbidden
        : viewModel.readOnly
            ? SystemMouseCursors.basic
            : SystemMouseCursors.text;
    Widget content = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: viewModel.enabled ? onTap : null,
      onLongPress: viewModel.enabled ? onLongPress : null,
      child: HeadlessHoverRegion(
        controller: controller,
        enabled: viewModel.enabled,
        cursorWhenEnabled: mouseCursor,
        cursorWhenDisabled: SystemMouseCursors.forbidden,
        child: child,
      ),
    );
    if (!viewModel.enabled) {
      content = IgnorePointer(child: content);
    }
    return TextFieldTapRegion(child: content);
  }
}
