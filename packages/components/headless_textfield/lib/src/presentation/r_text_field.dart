import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import '../logic/r_text_field_value_sync.dart';
import '../logic/r_text_field_formatters.dart';
import 'render_overrides_debug.dart';
import 'r_text_field_editable_text_factory.dart';
import 'r_text_field_request_composer.dart';
import 'r_text_field_style.dart';

/// Headless text field (controlled or controller-driven).
class RTextField extends StatefulWidget {
  RTextField({
    super.key,
    this.value,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTapOutside,
    this.placeholder,
    this.label,
    this.helperText,
    this.errorText,
    this.variant = RTextFieldVariant.filled,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.maxLengthEnforcement,
    this.showCursor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.inputFormatters,
    this.clearButtonMode = RTextFieldOverlayVisibilityMode.never,
    this.prefixMode = RTextFieldOverlayVisibilityMode.always,
    this.suffixMode = RTextFieldOverlayVisibilityMode.always,
    this.style,
    this.slots,
    this.overrides,
  }) {
    if (value != null && controller != null) {
      throw ArgumentError(
        'Cannot provide both value and controller. '
        'Use either controlled mode (value + onChanged) or '
        'controller-driven mode (controller only).',
      );
    }
  }

  final String? value;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final TapRegionCallback? onTapOutside;
  final String? placeholder;
  final String? label;
  final String? helperText;
  final String? errorText;
  final RTextFieldVariant variant;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final bool? showCursor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final DragStartBehavior dragStartBehavior;
  final bool? enableInteractiveSelection;
  final List<TextInputFormatter>? inputFormatters;
  final RTextFieldOverlayVisibilityMode clearButtonMode;
  final RTextFieldOverlayVisibilityMode prefixMode;
  final RTextFieldOverlayVisibilityMode suffixMode;

  /// Simple, Flutter-like styling sugar.
  ///
  /// Internally converted to `RenderOverrides.only(RTextFieldOverrides.tokens(...))`.
  /// If [overrides] is provided, it takes precedence over this style.
  final RTextFieldStyle? style;
  final RTextFieldSlots? slots;
  final RenderOverrides? overrides;

  /// Whether this is a multiline field.
  bool get isMultiline => maxLines == null || maxLines! > 1;

  /// Whether the field has an error.
  bool get hasError => errorText != null;

  @override
  State<RTextField> createState() => _RTextFieldState();
}

class _RTextFieldState extends State<RTextField> {
  late HeadlessTextEditingControllerOwner _controllerOwner;
  TextEditingController get _controller => _controllerOwner.controller;
  late HeadlessFocusNodeOwner _focusNodeOwner;
  FocusNode get _focusNode => _focusNodeOwner.node;
  late HeadlessFocusHoverController _focusHover;
  final _valueSync = RTextFieldValueSync();
  final _editableFactory = const RTextFieldEditableTextFactory();
  final _requestComposer = const RTextFieldRequestComposer();

  @override
  void initState() {
    super.initState();
    _initController();
    _initFocusNode();
    _focusHover = HeadlessFocusHoverController(isDisabled: !widget.enabled)
      ..addListener(_onFocusHoverChanged);
  }

  void _onFocusHoverChanged() {
    if (mounted) setState(() {});
  }

  void _initFocusNode() {
    _focusNodeOwner = HeadlessFocusNodeOwner(
      external: widget.focusNode,
      debugLabel: 'RTextField',
    );
    _focusNode.addListener(_handleFocusChange);
    _focusNode.canRequestFocus = widget.enabled;
  }

  void _disposeFocusNode() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNodeOwner.dispose();
  }

  void _initController() {
    _controllerOwner = HeadlessTextEditingControllerOwner(
      external: widget.controller,
      initialText: widget.value ?? '',
    );
    _valueSync.seedLastNotified(_controller.text);
    _controller.addListener(_handleControllerChange);
  }

  void _disposeController() {
    _controller.removeListener(_handleControllerChange);
    _controllerOwner.dispose();
  }

  void _handleControllerChange() {
    final applied = _valueSync.applyPendingIfComposingFinished(_controller);
    if (mounted) setState(() {});
    if (applied) {
      _valueSync.resetLastNotified(_controller.text);
    }
  }

  @override
  void didUpdateWidget(RTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != null && widget.value != null) {
      throw ArgumentError(
        'Cannot provide both controller and value. '
        'Use either controlled mode (value + onChanged) or '
        'controller-driven mode (controller only).',
      );
    }

    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_handleControllerChange);
      _controllerOwner.update(
        external: widget.controller,
        initialText: widget.value ?? '',
      );
      _valueSync.resetLastNotified(_controller.text);
      _valueSync.clearPending();
      _controller.addListener(_handleControllerChange);
    }

    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNodeOwner.update(widget.focusNode);
      _focusNode.addListener(_handleFocusChange);
    }

    if (widget.enabled != oldWidget.enabled) {
      _focusNode.canRequestFocus = widget.enabled;
      if (!widget.enabled && _focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    }

    if (widget.controller == null && widget.value != null) {
      _valueSync.syncControlledValue(
        controller: _controller,
        value: widget.value,
      );
    }
  }

  @override
  void dispose() {
    _disposeFocusNode();
    _disposeController();
    _focusHover.removeListener(_onFocusHoverChanged);
    _focusHover.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    _focusHover.handleFocusChange(_focusNode.hasFocus);
  }

  void _handleTextChanged(String text) {
    _valueSync.notifyIfChanged(text, widget.onChanged);
  }

  void _handleSubmitted(String text) {
    widget.onSubmitted?.call(text);
  }

  void _handleTapContainer() {
    // Disabled: no focus at all
    // ReadOnly: can focus (for selection/copy), just can't edit
    if (!widget.enabled) return;
    _focusNode.requestFocus();
  }

  void _handleClearText() {
    if (!widget.enabled) return;
    _controller.value = const TextEditingValue(
      text: '',
      selection: TextSelection.collapsed(offset: 0),
      composing: TextRange.empty,
    );
    _valueSync.notifyIfChanged('', widget.onChanged);
  }

  @override
  Widget build(BuildContext context) {
    final renderer = HeadlessThemeProvider.maybeCapabilityOf<RTextFieldRenderer>(
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
    final overrides = trackRenderOverrides(mergeStyleIntoOverrides(
      style: widget.style,
      overrides: widget.overrides,
      toOverride: (s) => s.toOverrides(),
    ));

    final spec = _requestComposer.createSpec(widget);
    final state = _requestComposer.createState(
      widget: widget,
      focusHoverState: _focusHover.state,
      text: _controller.text,
    );
    final semantics = _requestComposer.createSemantics(widget);
    final commands = RTextFieldCommands(
      tapContainer: _handleTapContainer,
      clearText: _handleClearText,
    );

    final resolvedTokens = tokenResolver?.resolve(
      context: context,
      spec: spec,
      states: state.toWidgetStates(),
      overrides: overrides,
    );

    final request = RTextFieldRenderRequest(
      context: context,
      input: _createEditableText(context: context, resolvedTokens: resolvedTokens),
      spec: spec,
      state: state,
      semantics: semantics,
      commands: commands,
      slots: widget.slots,
      resolvedTokens: resolvedTokens,
      overrides: overrides,
    );

    final content = _requestComposer.wrapWithInteraction(
      widget: widget,
      controller: _focusHover,
      child: renderer.render(request),
      resolvedTokens: resolvedTokens,
    );
    reportUnconsumedRenderOverrides('RTextField', overrides);

    return Semantics(
      textField: true,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      label: widget.label,
      hint: widget.placeholder,
      value: _requestComposer.createSemanticsValue(
        widget: widget,
        text: _controller.text,
      ),
      child: content,
    );
  }

  Widget _createEditableText({
    required BuildContext context,
    RTextFieldResolvedTokens? resolvedTokens,
  }) {
    final effectiveFormatters = RTextFieldFormatters.build(
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
    );

    return _editableFactory.create(
      context: context,
      controller: _controller,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      isMultiline: widget.isMultiline,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      showCursor: widget.showCursor,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      dragStartBehavior: widget.dragStartBehavior,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      inputFormatters: effectiveFormatters,
      onChanged: _handleTextChanged,
      onSubmitted: _handleSubmitted,
      onEditingComplete: widget.onEditingComplete,
      onTapOutside: widget.onTapOutside,
      resolvedTokens: resolvedTokens,
    );
  }
}

