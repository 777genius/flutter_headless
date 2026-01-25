import 'package:flutter/widgets.dart';
import 'package:headless_foundation/headless_foundation.dart';

final class AutocompleteInputOwner {
  AutocompleteInputOwner({
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required TextEditingValue? initialValue,
    required bool isDisabled,
    required VoidCallback onTextChanged,
    required ValueChanged<bool> onFocusChanged,
  })  : _onTextChanged = onTextChanged,
        _onFocusChanged = onFocusChanged,
        _externalController = controller,
        _externalFocusNode = focusNode,
        _controllerOwner = HeadlessTextEditingControllerOwner(
          external: controller,
          initialText: initialValue?.text ?? '',
        ),
        _focusNodeOwner = HeadlessFocusNodeOwner(
          external: focusNode,
          debugLabel: 'RAutocomplete',
        ),
        _focusHover = HeadlessFocusHoverController(isDisabled: isDisabled) {
    if (controller == null && initialValue != null) {
      _controllerOwner.controller.value = initialValue;
    }
    _controllerOwner.controller.addListener(_onTextChanged);
    _focusNodeOwner.node.addListener(_handleFocusChange);
    _focusNodeOwner.node.canRequestFocus = !isDisabled;
  }

  final VoidCallback _onTextChanged;
  final ValueChanged<bool> _onFocusChanged;
  TextEditingController? _externalController;
  FocusNode? _externalFocusNode;

  final HeadlessTextEditingControllerOwner _controllerOwner;
  final HeadlessFocusNodeOwner _focusNodeOwner;
  final HeadlessFocusHoverController _focusHover;

  TextEditingController get controller => _controllerOwner.controller;
  FocusNode get focusNode => _focusNodeOwner.node;
  HeadlessFocusHoverController get focusHover => _focusHover;

  void update({
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required TextEditingValue? initialValue,
    required bool isDisabled,
  }) {
    if (!identical(controller, _externalController)) {
      _controllerOwner.controller.removeListener(_onTextChanged);
      _externalController = controller;
      _controllerOwner.update(
        external: controller,
        initialText: initialValue?.text ?? '',
      );
      if (controller == null && initialValue != null) {
        _controllerOwner.controller.value = initialValue;
      }
      _controllerOwner.controller.addListener(_onTextChanged);
    }

    if (!identical(focusNode, _externalFocusNode)) {
      _focusNodeOwner.node.removeListener(_handleFocusChange);
      _externalFocusNode = focusNode;
      _focusNodeOwner.update(focusNode);
      _focusNodeOwner.node.addListener(_handleFocusChange);
    }

    _focusHover.setDisabled(isDisabled);
    _focusNodeOwner.node.canRequestFocus = !isDisabled;
    if (isDisabled && _focusNodeOwner.node.hasFocus) {
      _focusNodeOwner.node.unfocus();
    }
  }

  void dispose() {
    _controllerOwner.controller.removeListener(_onTextChanged);
    _focusNodeOwner.node.removeListener(_handleFocusChange);
    _focusHover.dispose();
    _controllerOwner.dispose();
    _focusNodeOwner.dispose();
  }

  void _handleFocusChange() {
    final focused = _focusNodeOwner.node.hasFocus;
    _focusHover.handleFocusChange(focused);
    _onFocusChanged(focused);
  }
}
