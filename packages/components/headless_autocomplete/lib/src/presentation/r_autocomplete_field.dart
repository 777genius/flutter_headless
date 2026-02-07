import 'package:flutter/widgets.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_theme/headless_theme.dart';

import 'r_autocomplete_editable_text_factory.dart';
import 'r_autocomplete_field_request_composer.dart';
import 'autocomplete_pointer_tap_handler.dart';
import 'render_overrides_debug.dart';

final class RAutocompleteField extends StatelessWidget {
  const RAutocompleteField({
    required this.controller,
    required this.focusNode,
    required this.autofocus,
    required this.enabled,
    required this.readOnly,
    required this.placeholder,
    required this.semanticLabel,
    required this.focusHover,
    required this.slots,
    required this.overrides,
    required this.onChanged,
    required this.onSubmitted,
    required this.onKeyEvent,
    required this.onTapContainer,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool autofocus;
  final bool enabled;
  final bool readOnly;
  final String? placeholder;
  final String? semanticLabel;
  final HeadlessFocusHoverController focusHover;
  final RTextFieldSlots? slots;
  final RenderOverrides? overrides;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final KeyEventResult Function(FocusNode, KeyEvent) onKeyEvent;
  final VoidCallback onTapContainer;

  @override
  Widget build(BuildContext context) {
    final renderer =
        HeadlessThemeProvider.maybeCapabilityOf<RTextFieldRenderer>(
      context,
      componentName: 'RAutocomplete',
    );
    if (renderer == null) {
      final hasTheme = HeadlessThemeProvider.of(context) != null;
      final exception = hasTheme
          ? const MissingCapabilityException(
              capabilityType: 'RTextFieldRenderer',
              componentName: 'RAutocomplete',
            )
          : const MissingThemeException();
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: StackTrace.current,
          library: 'headless_autocomplete',
          context: ErrorDescription('while building RAutocompleteField'),
        ),
      );
      return HeadlessMissingCapabilityWidget(
        componentName: 'RAutocomplete',
        message: headlessMissingCapabilityWidgetMessage(
          missingCapabilityType: 'RTextFieldRenderer',
        ),
      );
    }
    final trackedOverrides = trackRenderOverrides(overrides);
    final request = _createRequest(
      context: context,
      trackedOverrides: trackedOverrides,
    );
    final content = _wrapWithInteraction(
      request: request,
      renderer: renderer,
      trackedOverrides: trackedOverrides,
    );
    reportUnconsumedRenderOverrides('RAutocomplete', trackedOverrides);
    return _wrapWithPointerListener(content);
  }

  RTextFieldRenderRequest _createRequest({
    required BuildContext context,
    required RenderOverrides? trackedOverrides,
  }) {
    final composer = const RAutocompleteFieldRequestComposer();
    final spec = composer.createSpec(placeholder: placeholder);
    final state = composer.createState(
      focusHoverState: focusHover.state,
      text: controller.text,
      isDisabled: !enabled,
      isReadOnly: readOnly,
    );
    final semantics = composer.createSemantics(
      label: semanticLabel,
      hint: placeholder,
      isEnabled: enabled,
      isReadOnly: readOnly,
    );
    final resolvedTokens = _resolveTokens(
      context: context,
      spec: spec,
      state: state,
      trackedOverrides: trackedOverrides,
    );
    return RTextFieldRenderRequest(
      context: context,
      input: _createInput(context, resolvedTokens),
      spec: spec,
      state: state,
      semantics: semantics,
      // IMPORTANT:
      // RAutocomplete manages pointer taps itself via AutocompletePointerTapHandler
      // (see _wrapWithPointerListener). Passing tapContainer here would cause
      // some renderers (Material) to wrap the whole field in a GestureDetector
      // and block EditableText tap handling (caret placement / collapsing selection).
      commands: const RTextFieldCommands(),
      slots: slots,
      resolvedTokens: resolvedTokens,
      overrides: trackedOverrides,
    );
  }

  RTextFieldResolvedTokens? _resolveTokens({
    required BuildContext context,
    required RTextFieldSpec spec,
    required RTextFieldState state,
    required RenderOverrides? trackedOverrides,
  }) {
    final theme = HeadlessThemeProvider.themeOf(context);
    final tokenResolver = theme.capability<RTextFieldTokenResolver>();
    return tokenResolver?.resolve(
      context: context,
      spec: spec,
      states: state.toWidgetStates(),
      overrides: trackedOverrides,
    );
  }

  Widget _createInput(
    BuildContext context,
    RTextFieldResolvedTokens? resolvedTokens,
  ) {
    return const RAutocompleteEditableTextFactory().create(
      context: context,
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      readOnly: readOnly,
      enabled: enabled,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onKeyEvent: onKeyEvent,
      resolvedTokens: resolvedTokens,
    );
  }

  Widget _wrapWithInteraction({
    required RTextFieldRenderRequest request,
    required RTextFieldRenderer renderer,
    required RenderOverrides? trackedOverrides,
  }) {
    final composer = const RAutocompleteFieldRequestComposer();
    return composer.wrapWithInteraction(
      enabled: enabled,
      readOnly: readOnly,
      controller: focusHover,
      child: renderer.render(request),
      resolvedTokens: request.resolvedTokens,
    );
  }

  Widget _wrapWithPointerListener(Widget child) {
    if (!enabled) return child;
    return AutocompletePointerTapHandler(
      focusNode: focusNode,
      onTap: onTapContainer,
      child: child,
    );
  }
}
