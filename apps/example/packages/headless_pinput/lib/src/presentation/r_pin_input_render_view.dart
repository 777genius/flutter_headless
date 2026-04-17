import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

import '../contracts/r_pin_input_renderer.dart';
import '../contracts/r_pin_input_token_resolver.dart';
import '../logic/r_pin_input_input_formatters.dart';
import '../render_request/r_pin_input_request_composer.dart';
import 'r_pin_input_hidden_editable_factory.dart';
import 'r_pin_input_view_model.dart';

final class RPinInputRenderView extends StatelessWidget {
  const RPinInputRenderView({
    super.key,
    required this.viewModel,
    required this.controller,
    required this.focusNode,
    required this.focusHover,
    required this.editableTextKey,
    required this.visibleErrorText,
    required this.hiddenEditableFactory,
    required this.requestComposer,
    required this.onChanged,
    required this.onSubmitted,
    required this.onTapField,
    required this.onLongPress,
    required this.onRequestKeyboard,
  });

  final RPinInputViewModel viewModel;
  final TextEditingController controller;
  final FocusNode focusNode;
  final HeadlessFocusHoverController focusHover;
  final GlobalKey<EditableTextState> editableTextKey;
  final String? visibleErrorText;
  final RPinInputHiddenEditableFactory hiddenEditableFactory;
  final RPinInputRequestComposer requestComposer;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onTapField;
  final VoidCallback? onLongPress;
  final VoidCallback onRequestKeyboard;

  @override
  Widget build(BuildContext context) {
    final renderer = HeadlessThemeProvider.maybeCapabilityOf<RPinInputRenderer>(
      context,
      componentName: 'RPinInput',
    );
    if (renderer == null) {
      final hasTheme = HeadlessThemeProvider.of(context) != null;
      final exception = hasTheme
          ? const MissingCapabilityException(
              capabilityType: 'RPinInputRenderer',
              componentName: 'RPinInput',
            )
          : const MissingThemeException();
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: StackTrace.current,
          library: 'headless_pinput',
          context: ErrorDescription('while building RPinInput'),
        ),
      );
      return HeadlessMissingCapabilityWidget(
        componentName: 'RPinInput',
        message: headlessMissingCapabilityWidgetMessage(
          missingCapabilityType: 'RPinInputRenderer',
        ),
      );
    }

    final overrides = mergeStyleIntoOverrides(
      style: viewModel.style,
      overrides: viewModel.overrides,
      toOverride: (style) => style.toOverrides(),
    );
    final spec = requestComposer.createSpec(viewModel);
    final state = requestComposer.createState(
      viewModel: viewModel,
      focusHoverState: focusHover.state,
      text: controller.text,
    );
    final showErrorState = visibleErrorText != null;
    final cells = requestComposer.createCells(
      viewModel: viewModel,
      state: state,
      showErrorState: showErrorState,
      text: controller.text,
    );
    final tokenResolver = HeadlessThemeProvider.themeOf(context)
        .capability<RPinInputTokenResolver>();
    final resolvedTokens = tokenResolver?.resolve(
      context: context,
      spec: spec,
      state: state,
      overrides: overrides,
    );
    final request = RPinInputRenderRequest(
      context: context,
      hiddenInput: hiddenEditableFactory.create(
        editableTextKey: editableTextKey,
        controller: controller,
        focusNode: focusNode,
        autofocus: viewModel.autofocus,
        enabled: viewModel.enabled,
        readOnly: viewModel.readOnly,
        useNativeKeyboard: viewModel.useNativeKeyboard,
        enableIMEPersonalizedLearning: viewModel.enableIMEPersonalizedLearning,
        enableInteractiveSelection: viewModel.enableInteractiveSelection,
        enableSuggestions: viewModel.enableSuggestions,
        toolbarEnabled: viewModel.toolbarEnabled,
        keyboardType: viewModel.keyboardType,
        textCapitalization: viewModel.textCapitalization,
        keyboardAppearance: viewModel.keyboardAppearance,
        textInputAction: viewModel.textInputAction,
        autofillHints: viewModel.autofillHints,
        scrollPadding: viewModel.scrollPadding,
        inputFormatters: buildPinInputFormatters(
          inputFormatters: viewModel.inputFormatters,
          length: viewModel.length,
        ),
        contextMenuBuilder: viewModel.contextMenuBuilder,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onTapOutside: viewModel.onTapOutside,
        onEditingComplete: viewModel.onEditingComplete,
      ),
      spec: spec,
      state: state,
      cells: cells,
      value: controller.text,
      visibleErrorText: visibleErrorText,
      commands: requestComposer.createCommands(
        onTapField: onTapField,
        onRequestKeyboard: onRequestKeyboard,
      ),
      resolvedTokens: resolvedTokens,
      overrides: overrides,
    );
    final rendered = renderer.render(request);
    final content = requestComposer.wrapWithInteraction(
      viewModel: viewModel,
      controller: focusHover,
      onTap: onTapField,
      onLongPress: onLongPress,
      child: rendered,
    );

    return Semantics(
      textField: true,
      enabled: viewModel.enabled,
      readOnly: viewModel.readOnly || !viewModel.useNativeKeyboard,
      label: viewModel.semanticLabel,
      hint: viewModel.semanticHint,
      maxValueLength: viewModel.length,
      currentValueLength: state.currentLength,
      onTap: viewModel.enabled ? onTapField : null,
      child: content,
    );
  }
}
