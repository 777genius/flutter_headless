import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';

import '../logic/r_text_field_value_sync.dart';
import 'r_text_field_actions.dart';
import 'r_text_field_editable_text_factory.dart';
import 'r_text_field_request_composer.dart';
import 'r_text_field_render_view.dart';
import 'r_text_field_style.dart';
import 'r_text_field_view_model.dart';

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
    validateTextFieldControlConfig(value: value, controller: controller);
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

  bool get isMultiline => maxLines == null || maxLines! > 1;
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
  bool _keyboardRefreshScheduled = false;
  final GlobalKey<EditableTextState> _editableTextKey =
      GlobalKey<EditableTextState>(debugLabel: 'RTextFieldEditableText');
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

    validateTextFieldControlConfig(
      value: widget.value,
      controller: widget.controller,
    );

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

    // Web stability: if the field stays focused through a rebuild (theme switch,
    // parent layout changes, etc.) refresh the editing session geometry.
    if (_focusNode.hasFocus) {
      _scheduleKeyboardRefresh();
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
    if (_focusNode.hasFocus) {
      _scheduleKeyboardRefresh();
    }
  }

  void _scheduleKeyboardRefresh() {
    // Web stability: DOM-backed text input can occasionally desync its geometry
    // after rebuilds while remaining focused, leaving an invisible element that
    // blocks pointer events elsewhere (e.g. AppBar actions).
    //
    // Calling requestKeyboard() post-frame nudges the engine to ensure the
    // editing session + geometry are up to date.
    if (_keyboardRefreshScheduled) return;
    _keyboardRefreshScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _keyboardRefreshScheduled = false;
      if (!mounted) return;
      if (!_focusNode.hasFocus) return;
      _editableTextKey.currentState?.requestKeyboard();
    });
  }

  void _handleTextChanged(String text) {
    _valueSync.notifyIfChanged(text, widget.onChanged);
  }

  void _handleSubmitted(String text) {
    widget.onSubmitted?.call(text);
  }

  void _handleTapContainer() {
    requestTextFieldFocusOrKeyboard(
      enabled: widget.enabled,
      focusNode: _focusNode,
      editableTextState: _editableTextKey.currentState,
    );
  }

  void _handleClearText() {
    clearTextFieldValue(
      enabled: widget.enabled,
      controller: _controller,
      valueSync: _valueSync,
      onChanged: widget.onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RTextFieldRenderView(
      viewModel: RTextFieldViewModel.fromWidget(widget),
      controller: _controller,
      focusNode: _focusNode,
      focusHover: _focusHover,
      editableTextKey: _editableTextKey,
      editableFactory: _editableFactory,
      requestComposer: _requestComposer,
      onTextChanged: _handleTextChanged,
      onSubmitted: _handleSubmitted,
      onTapContainer: _handleTapContainer,
      onClearText: _handleClearText,
    );
  }
}
