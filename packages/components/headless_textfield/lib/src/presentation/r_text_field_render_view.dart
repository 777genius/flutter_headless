import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

import '../logic/r_text_field_formatters.dart';
import 'render_overrides_debug.dart';
import 'r_text_field_editable_text_factory.dart';
import 'r_text_field_request_composer.dart';
import 'r_text_field_selection_gesture_wrapper.dart';
import 'r_text_field_view_model.dart';

final class RTextFieldRenderView extends StatelessWidget {
  const RTextFieldRenderView({
    super.key,
    required this.viewModel,
    required this.controller,
    required this.focusNode,
    required this.focusHover,
    required this.editableTextKey,
    required this.editableFactory,
    required this.requestComposer,
    required this.onTextChanged,
    required this.onSubmitted,
    required this.onTapContainer,
    required this.onClearText,
  });

  final RTextFieldViewModel viewModel;
  final TextEditingController controller;
  final FocusNode focusNode;
  final HeadlessFocusHoverController focusHover;
  final GlobalKey<EditableTextState> editableTextKey;
  final RTextFieldEditableTextFactory editableFactory;
  final RTextFieldRequestComposer requestComposer;
  final ValueChanged<String> onTextChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onTapContainer;
  final VoidCallback onClearText;

  @override
  Widget build(BuildContext context) {
    final renderer =
        HeadlessThemeProvider.maybeCapabilityOf<RTextFieldRenderer>(
      context,
      componentName: 'RTextField',
    );
    if (renderer == null) {
      final hasTheme = HeadlessThemeProvider.of(context) != null;
      final exception = hasTheme
          ? const MissingCapabilityException(
              capabilityType: 'RTextFieldRenderer',
              componentName: 'RTextField',
            )
          : const MissingThemeException();
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: StackTrace.current,
          library: 'headless_textfield',
          context: ErrorDescription('while building RTextField'),
        ),
      );
      return HeadlessMissingCapabilityWidget(
        componentName: 'RTextField',
        message: headlessMissingCapabilityWidgetMessage(
          missingCapabilityType: 'RTextFieldRenderer',
        ),
      );
    }

    final theme = HeadlessThemeProvider.themeOf(context);
    final tokenResolver = theme.capability<RTextFieldTokenResolver>();
    final overrides = trackRenderOverrides(
      mergeStyleIntoOverrides(
        style: viewModel.style,
        overrides: viewModel.overrides,
        toOverride: (s) => s.toOverrides(),
      ),
    );
    final spec = requestComposer.createSpec(viewModel);
    final state = requestComposer.createState(
      viewModel: viewModel,
      focusHoverState: focusHover.state,
      text: controller.text,
    );
    final semantics = requestComposer.createSemantics(viewModel);
    final commands = RTextFieldCommands(
      tapContainer: onTapContainer,
      clearText: onClearText,
    );
    final resolvedTokens = tokenResolver?.resolve(
      context: context,
      spec: spec,
      states: state.toWidgetStates(),
      overrides: overrides,
    );
    final request = RTextFieldRenderRequest(
      context: context,
      input: _createEditableText(context, resolvedTokens),
      spec: spec,
      state: state,
      semantics: semantics,
      commands: commands,
      slots: viewModel.slots,
      resolvedTokens: resolvedTokens,
      overrides: overrides,
    );
    final selectionEnabled =
        (viewModel.enableInteractiveSelection ?? !viewModel.obscureText) &&
            viewModel.enabled;
    final rendered = RTextFieldSelectionGestureWrapper(
      editableTextKey: editableTextKey,
      selectionEnabled: selectionEnabled,
      child: renderer.render(request),
    );
    final content = requestComposer.wrapWithInteraction(
      viewModel: viewModel,
      controller: focusHover,
      child: rendered,
      resolvedTokens: resolvedTokens,
    );
    reportUnconsumedRenderOverrides('RTextField', overrides);

    return Semantics(
      textField: true,
      enabled: viewModel.enabled,
      readOnly: viewModel.readOnly,
      label: viewModel.label,
      hint: viewModel.placeholder,
      value: requestComposer.createSemanticsValue(
        viewModel: viewModel,
        text: controller.text,
      ),
      child: content,
    );
  }

  Widget _createEditableText(
    BuildContext context,
    RTextFieldResolvedTokens? resolvedTokens,
  ) {
    final effectiveFormatters = RTextFieldFormatters.build(
      inputFormatters: viewModel.inputFormatters,
      maxLength: viewModel.maxLength,
      maxLengthEnforcement: viewModel.maxLengthEnforcement,
    );
    return editableFactory.create(
      context: context,
      editableTextKey: editableTextKey,
      controller: controller,
      focusNode: focusNode,
      autofocus: viewModel.autofocus,
      obscureText: viewModel.obscureText,
      readOnly: viewModel.readOnly,
      enabled: viewModel.enabled,
      isMultiline: viewModel.isMultiline,
      keyboardType: viewModel.keyboardType,
      textInputAction: viewModel.textInputAction,
      textCapitalization: viewModel.textCapitalization,
      autocorrect: viewModel.autocorrect,
      enableSuggestions: viewModel.enableSuggestions,
      smartDashesType: viewModel.smartDashesType,
      smartQuotesType: viewModel.smartQuotesType,
      maxLines: viewModel.maxLines,
      minLines: viewModel.minLines,
      showCursor: viewModel.showCursor,
      keyboardAppearance: viewModel.keyboardAppearance,
      scrollPadding: viewModel.scrollPadding,
      dragStartBehavior: viewModel.dragStartBehavior,
      enableInteractiveSelection: viewModel.enableInteractiveSelection,
      inputFormatters: effectiveFormatters,
      onChanged: onTextChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: viewModel.onEditingComplete,
      onTapOutside: viewModel.onTapOutside,
      resolvedTokens: resolvedTokens,
    );
  }
}
