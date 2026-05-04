import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

import '../contracts/r_pin_input_types.dart';
import '../logic/r_pin_input_actions.dart';
import '../logic/r_pin_input_haptics.dart';
import '../logic/r_pin_input_text_units.dart';
import '../logic/r_pin_input_value_sync.dart';
import '../render_request/r_pin_input_request_composer.dart';
import 'r_pin_input.dart';
import 'r_pin_input_hidden_editable_factory.dart';
import 'r_pin_input_render_view.dart';
import 'r_pin_input_view_model.dart';

final class RPinInputStateImpl extends State<RPinInput>
    with WidgetsBindingObserver {
  late final HeadlessTextEditingControllerOwner _controllerOwner;
  late final HeadlessFocusNodeOwner _focusNodeOwner;
  late final HeadlessFocusHoverController _focusHover;
  final _editableTextKey = GlobalKey<EditableTextState>(
    debugLabel: 'RPinInputEditableText',
  );
  final _valueSync = RPinInputValueSync();
  final _hiddenEditableFactory = const RPinInputHiddenEditableFactory();
  final _requestComposer = const RPinInputRequestComposer();
  String? _validatorErrorText;
  String? _lastCompletedValue;
  int _retrieverEpoch = 0;

  TextEditingController get _controller => _controllerOwner.controller;
  FocusNode get _focusNode => _focusNodeOwner.node;
  String? get _effectiveErrorText => widget.errorText ?? _validatorErrorText;
  bool get _hasError => widget.forceErrorState || _validatorErrorText != null;

  @override
  void initState() {
    super.initState();
    _controllerOwner = HeadlessTextEditingControllerOwner(
      external: widget.controller,
      initialText: widget.value ?? '',
    );
    _focusNodeOwner = HeadlessFocusNodeOwner(
      external: widget.focusNode,
      debugLabel: 'RPinInput',
    );
    _focusHover = HeadlessFocusHoverController(isDisabled: !widget.enabled)
      ..addListener(_handleFocusHoverChanged);
    _valueSync.seedLastNotified(_controller.text);
    _controller.addListener(_handleControllerChange);
    _focusNode.addListener(_handleFocusChange);
    _focusNode.canRequestFocus = widget.enabled && widget.useNativeKeyboard;
    WidgetsBinding.instance.addObserver(this);
    _maybeStartCodeRetriever();
    _maybeCheckClipboard();
  }

  @override
  void didUpdateWidget(covariant RPinInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    validatePinInputControlConfig(
      value: widget.value,
      controller: widget.controller,
    );
    _updateController(oldWidget);
    _updateFocusNode(oldWidget);
    _updateFocusAvailability(oldWidget);
    _updateCodeRetriever(oldWidget);
    _syncControlledValueIfNeeded();
    _clampValueToCurrentLengthIfNeeded(oldWidget);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_handleControllerChange);
    _focusNode.removeListener(_handleFocusChange);
    _focusHover.removeListener(_handleFocusHoverChanged);
    _focusHover.dispose();
    _focusNodeOwner.dispose();
    _controllerOwner.dispose();
    widget.codeRetriever?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeCheckClipboard();
    }
  }

  void _updateController(RPinInput oldWidget) {
    if (widget.controller == oldWidget.controller) return;
    _controller.removeListener(_handleControllerChange);
    _controllerOwner.update(
      external: widget.controller,
      initialText: widget.value ?? '',
    );
    _valueSync.resetLastNotified(_controller.text);
    _valueSync.clearPending();
    _controller.addListener(_handleControllerChange);
  }

  void _updateFocusNode(RPinInput oldWidget) {
    if (widget.focusNode == oldWidget.focusNode) return;
    _focusNode.removeListener(_handleFocusChange);
    _focusNodeOwner.update(widget.focusNode);
    _focusNode.addListener(_handleFocusChange);
  }

  void _updateFocusAvailability(RPinInput oldWidget) {
    final availabilityChanged = widget.enabled != oldWidget.enabled ||
        widget.useNativeKeyboard != oldWidget.useNativeKeyboard;
    if (!availabilityChanged) return;
    _focusNode.canRequestFocus = widget.enabled && widget.useNativeKeyboard;
    if (!widget.enabled && _focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  void _updateCodeRetriever(RPinInput oldWidget) {
    if (widget.codeRetriever == oldWidget.codeRetriever) return;
    oldWidget.codeRetriever?.dispose();
    _retrieverEpoch++;
    _maybeStartCodeRetriever();
  }

  void _syncControlledValueIfNeeded() {
    if (widget.controller != null || widget.value == null) return;
    _valueSync.syncControlledValue(
      controller: _controller,
      value: clampPinValue(widget.value!, widget.length),
    );
  }

  void _clampValueToCurrentLengthIfNeeded(RPinInput oldWidget) {
    if (widget.length == oldWidget.length) return;
    final isControlledByValue =
        widget.controller == null && widget.value != null;
    if (isControlledByValue) return;
    _applyControllerValue(_controller.text);
  }

  void _handleFocusHoverChanged() {
    if (mounted) setState(() {});
  }

  void _handleFocusChange() {
    _focusHover.handleFocusChange(_focusNode.hasFocus);
    if (mounted) setState(() {});
  }

  void _handleControllerChange() {
    final applied = _valueSync.applyPendingIfComposingFinished(_controller);
    _applyControllerValue(_controller.text);
    if (applied && mounted) {
      setState(() {});
    }
  }

  void _applyControllerValue(String nextText) {
    final clamped = clampPinValue(nextText, widget.length);
    if (clamped != nextText) {
      _controller.value = TextEditingValue(
        text: clamped,
        selection: TextSelection.collapsed(
          offset: pinTextCodeUnitLength(clamped),
        ),
      );
      return;
    }
    if (mounted) setState(() {});
    _valueSync.notifyIfChanged(clamped, widget.onChanged);
    maybeUsePinInputHaptic(widget.hapticFeedbackType);
    if (pinTextLength(clamped) == widget.length) {
      _handleCompletion(clamped);
      return;
    }
    _lastCompletedValue = null;
  }

  void _handleCompletion(String value) {
    if (_lastCompletedValue != value) {
      _lastCompletedValue = value;
      widget.onCompleted?.call(value);
    }
    _maybeValidate();
    if (widget.closeKeyboardWhenCompleted) {
      _focusNode.unfocus();
    }
  }

  void _maybeValidate() {
    if (widget.autovalidateMode != RPinInputAutovalidateMode.onSubmit) return;
    final error = widget.validator?.call(_controller.text);
    if (error == _validatorErrorText) return;
    setState(() => _validatorErrorText = error);
  }

  Future<void> _maybeCheckClipboard() async {
    if (widget.onClipboardFound == null) return;
    final data = await Clipboard.getData('text/plain');
    final text = data?.text ?? '';
    if (pinTextLength(text) == widget.length) {
      widget.onClipboardFound?.call(text);
    }
  }

  Future<void> _maybeStartCodeRetriever() async {
    final retriever = widget.codeRetriever;
    if (retriever == null) return;
    final epoch = ++_retrieverEpoch;
    while (mounted && epoch == _retrieverEpoch) {
      final code = await retriever.getCode();
      if (!mounted || epoch != _retrieverEpoch) return;
      if (code != null && pinTextLength(code) == widget.length) {
        _controller.value = TextEditingValue(
          text: code,
          selection: TextSelection.collapsed(
            offset: pinTextCodeUnitLength(code),
          ),
        );
      }
      if (!retriever.listenForMultipleCodes) return;
    }
  }

  bool get _showErrorState {
    final hasVisualFocus = _focusNode.hasFocus || !widget.useNativeKeyboard;
    return _hasError &&
        (!hasVisualFocus ||
            widget.showErrorWhenFocused ||
            widget.forceErrorState);
  }

  void _handleTapField() {
    widget.onTap?.call();
    requestPinInputFocusOrKeyboard(
      enabled: widget.enabled,
      useNativeKeyboard: widget.useNativeKeyboard,
      focusNode: _focusNode,
      editableTextState: _editableTextKey.currentState,
    );
  }

  void _handleSubmitted(String value) {
    widget.onSubmitted?.call(value);
    _maybeValidate();
  }

  @override
  Widget build(BuildContext context) {
    return RPinInputRenderView(
      viewModel: RPinInputViewModel.fromWidget(
        widget,
        effectiveErrorText: _effectiveErrorText,
        hasError: _hasError,
      ),
      controller: _controller,
      focusNode: _focusNode,
      focusHover: _focusHover,
      editableTextKey: _editableTextKey,
      visibleErrorText: _showErrorState ? _effectiveErrorText : null,
      hiddenEditableFactory: _hiddenEditableFactory,
      requestComposer: _requestComposer,
      onChanged: _applyControllerValue,
      onSubmitted: _handleSubmitted,
      onTapField: _handleTapField,
      onLongPress: widget.onLongPress,
      onRequestKeyboard: () => _editableTextKey.currentState?.requestKeyboard(),
    );
  }
}
