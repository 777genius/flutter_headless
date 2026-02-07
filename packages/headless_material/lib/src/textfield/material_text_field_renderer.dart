import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'material_text_field_decoration_factory.dart';
import 'material_text_field_input_decorator.dart';
import 'material_text_field_state_adapter.dart';

/// Material 3 renderer for TextField components.
///
/// Delegates visual decoration to Flutter's [InputDecorator] for pixel-perfect
/// parity with Material 3 `TextField`.
///
/// CRITICAL INVARIANT:
/// - Renderer does NOT create [EditableText].
/// - It receives the `input` widget from the component and wraps it.
/// - All text editing behavior is handled by the component.
///
/// Material 3 only — throws [StateError] when `useMaterial3 == false`.
///
/// In parity mode [InputDecorator] obtains all styles from M3 defaults.
/// No `baseStyle` is forwarded — identical to Flutter `TextField(style: null)`.
class MaterialTextFieldRenderer implements RTextFieldRenderer {
  const MaterialTextFieldRenderer();

  @override
  Widget render(RTextFieldRenderRequest request) {
    _assertMaterial3(request.context);

    final spec = request.spec;
    final state = request.state;
    final slots = request.slots;
    final commands = request.commands;

    final decoration = MaterialTextFieldDecorationFactory.create(
      spec: spec,
      state: state,
      slots: slots,
      overrides: request.overrides,
    );

    final decorator = MaterialTextFieldInputDecorator(
      decoration: decoration,
      isFocused: MaterialTextFieldStateAdapter.isFocused(state),
      isHovering: MaterialTextFieldStateAdapter.isHovering(state),
      isEmpty: MaterialTextFieldStateAdapter.isEmpty(state),
      expands: MaterialTextFieldStateAdapter.expands(state),
      child: request.input,
    );

    // GestureDetector делегирует tap на контейнере в фокус-логику компонента.
    // Flutter TextField делает то же через _TextFieldState._handleTap.
    // Здесь FocusNode принадлежит компоненту; tapContainer — его команда.
    //
    // When tapContainer is null, GestureDetector(onTap: null, behavior: opaque)
    // silently blocks taps — so we skip the wrapper entirely.
    if (commands?.tapContainer != null) {
      return GestureDetector(
        onTap: commands!.tapContainer,
        behavior: HitTestBehavior.opaque,
        child: decorator,
      );
    }
    return decorator;
  }

  static void _assertMaterial3(BuildContext context) {
    final theme = Theme.of(context);
    if (!theme.useMaterial3) {
      throw StateError(
        '[Headless] MaterialTextFieldRenderer requires Material 3.\n'
        'Set useMaterial3: true in your ThemeData.',
      );
    }
  }
}
