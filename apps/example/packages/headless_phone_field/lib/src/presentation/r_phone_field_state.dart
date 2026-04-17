import 'package:flutter/material.dart';
import 'package:headless_textfield/headless_textfield.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../contracts/r_phone_field_country_selector_navigator.dart';
import '../logic/r_phone_field_controller.dart';
import '../logic/r_phone_field_country_data_resolver.dart';
import '../logic/r_phone_field_country_length.dart';
import '../logic/r_phone_field_input_formatters.dart';
import 'r_phone_field_country_button_request_factory.dart';
import 'r_phone_field.dart';
import 'r_phone_field_caret_restorer.dart';
import 'r_phone_field_country_button.dart';
import 'r_phone_field_slots_merger.dart';
import 'r_phone_field_style.dart';

void _attachPhoneFieldControllerListener(
  RPhoneFieldController controller,
  VoidCallback listener,
) {
  controller.addListener(listener);
}

void _detachPhoneFieldControllerListener(
  RPhoneFieldController controller,
  VoidCallback listener,
) {
  controller.removeListener(listener);
}

class RPhoneFieldStateImpl extends State<RPhoneField> {
  late RPhoneFieldController _internalController;
  late FocusNode _internalFocusNode;
  final _fieldKey = GlobalKey();
  final _countryButtonKey = GlobalKey();
  final _countryDataResolver = const RPhoneFieldCountryDataResolver();
  final _countryButtonRequestFactory =
      const RPhoneFieldCountryButtonRequestFactory();
  final _caretRestorer = const RPhoneFieldCaretRestorer();
  final _slotsMerger = const RPhoneFieldSlotsMerger();
  bool _hasUserInteraction = false;
  bool _showValidation = false;

  RPhoneFieldController get _controller =>
      widget.controller ?? _internalController;
  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  int? get _maxDigits => widget.shouldLimitLengthByCountry
      ? resolvePhoneFieldCountryMaxLength(_controller.value.isoCode)
      : null;

  @override
  void initState() {
    super.initState();
    _internalController = RPhoneFieldController(
      initialValue: widget.value ??
          widget.initialValue ??
          const PhoneNumber(isoCode: IsoCode.US, nsn: ''),
    );
    _internalFocusNode = FocusNode(debugLabel: 'RPhoneField');
    _attachPhoneFieldControllerListener(_controller, _handleControllerChanged);
  }

  @override
  void didUpdateWidget(RPhoneField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _detachPhoneFieldControllerListener(
        oldWidget.controller ?? _internalController,
        _handleControllerChanged,
      );
      _attachPhoneFieldControllerListener(
          _controller, _handleControllerChanged);
    }
    if (widget.controller == null &&
        widget.value != null &&
        widget.value != _controller.value) {
      _controller.value = widget.value!;
    }
  }

  @override
  void dispose() {
    _detachPhoneFieldControllerListener(_controller, _handleControllerChanged);
    if (widget.controller == null) {
      _internalController.dispose();
    }
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  void _handleControllerChanged() {
    if (mounted) setState(() {});
  }

  void _markUserInteraction() {
    if (_hasUserInteraction) return;
    setState(() => _hasUserInteraction = true);
  }

  void _handleTextChanged(String text) {
    _markUserInteraction();
    _controller.changeNationalNumber(text, maxDigits: _maxDigits);
    widget.onChanged?.call(_controller.value);
  }

  void _handleSubmitted(String _) {
    setState(() => _showValidation = true);
    widget.onSubmitted?.call(_controller.value);
  }

  Future<void> _handleSelectCountry() async {
    if (!widget.enabled || !widget.isCountrySelectionEnabled) return;
    final selected = await widget.countrySelectorNavigator.show(
      context,
      RPhoneFieldCountrySelectorRequest(
        countries: widget.countries,
        favoriteCountries: widget.favoriteCountries,
        selectedCountry: _controller.value.isoCode,
        showDialCode: widget.showDialCodeInSelector,
        noResultMessage: widget.countrySelectorNoResultMessage,
        searchAutofocus: widget.countrySelectorNavigator.searchAutofocus,
        subtitleStyle: widget.countrySelectorSubtitleStyle,
        titleStyle: widget.countrySelectorTitleStyle,
        searchBoxDecoration: widget.countrySelectorSearchBoxDecoration,
        searchBoxTextStyle: widget.countrySelectorSearchBoxTextStyle,
        searchBoxIconColor: widget.countrySelectorSearchBoxIconColor,
        scrollPhysics: widget.countrySelectorScrollPhysics,
        backgroundColor: widget.countrySelectorNavigator.backgroundColor,
        flagSize: widget.countrySelectorFlagSize,
        anchorRectGetter: _anchorRect,
        fieldRectGetter: _fieldRect,
        triggerRectGetter: _triggerRect,
        restoreFocusNode: _focusNode,
        useRootNavigator: widget.countrySelectorNavigator.useRootNavigator,
      ),
    );
    _handleCountrySelected(selected);
  }

  Rect? _anchorRect() {
    return _triggerRect() ?? _fieldRect();
  }

  Rect? _fieldRect() => _renderRectFor(_fieldKey);

  Rect? _triggerRect() => _renderRectFor(_countryButtonKey);

  Rect? _renderRectFor(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return null;
    return renderBox.localToGlobal(Offset.zero) & renderBox.size;
  }

  void _handleCountrySelected(IsoCode? selected) {
    if (!mounted || selected == null || selected == _controller.value.isoCode) {
      _caretRestorer.restoreFocus(
        isMounted: () => mounted,
        focusNode: _focusNode,
      );
      return;
    }
    _markUserInteraction();
    _controller.changeCountry(selected, maxDigits: _maxDigits);
    widget.onCountryChanged?.call(selected);
    widget.onChanged?.call(_controller.value);
    _caretRestorer.restoreSelectionAfterCountryChange(
      isMounted: () => mounted,
      focusNode: _focusNode,
      controller: _controller,
    );
  }

  String? _visibleErrorText() {
    if (widget.errorText != null) {
      return widget.errorText;
    }
    final validator = widget.validator;
    if (validator == null) return null;

    final shouldShow = switch (widget.autovalidateMode) {
      AutovalidateMode.always => true,
      AutovalidateMode.onUserInteraction =>
        _hasUserInteraction || _showValidation,
      AutovalidateMode.onUnfocus =>
        (!_focusNode.hasFocus && _hasUserInteraction) || _showValidation,
      AutovalidateMode.disabled => _showValidation,
    };
    if (!shouldShow) return null;
    return validator(_controller.value);
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? const RPhoneFieldStyle();
    final country =
        _countryDataResolver.resolve(context, _controller.value.isoCode);
    final buttonRequest = _countryButtonRequestFactory.create(
      context: context,
      resolver: _countryDataResolver,
      country: country,
      countries: widget.countries,
      favoriteCountries: widget.favoriteCountries,
      enabled: widget.enabled && widget.isCountrySelectionEnabled,
      style: style.countryButtonStyle,
      noResultMessage: widget.countrySelectorNoResultMessage,
      searchAutofocus: widget.countrySelectorNavigator.searchAutofocus,
      onPressed: _handleSelectCountry,
      onCountrySelected: _handleCountrySelected,
    );
    final countryButton =
        widget.countryButtonBuilder?.call(context, buttonRequest) ??
            DefaultRPhoneFieldCountryButton(request: buttonRequest);
    final anchoredCountryButton = SizedBox(
      key: _countryButtonKey,
      child: countryButton,
    );
    final slots = _slotsMerger.merge(
      baseSlots: widget.fieldSlots,
      countryButton: anchoredCountryButton,
      placement: style.countryButtonPlacement,
    );

    return Semantics(
      textField: true,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      label: widget.semanticLabel,
      hint: widget.semanticHint,
      child: KeyedSubtree(
        key: _fieldKey,
        child: RTextField(
          key: ValueKey(style.countryButtonPlacement),
          controller: _controller.textController,
          focusNode: _focusNode,
          onChanged: _handleTextChanged,
          onSubmitted: _handleSubmitted,
          onEditingComplete: widget.onEditingComplete,
          onTapOutside: widget.onTapOutside,
          placeholder: widget.placeholder,
          label: widget.label,
          helperText: widget.helperText,
          errorText: _visibleErrorText(),
          variant: widget.variant,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autocorrect: widget.autocorrect,
          enableSuggestions: widget.enableSuggestions,
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
          keyboardAppearance: Theme.of(context).brightness,
          scrollPadding: widget.scrollPadding,
          autofillHints: widget.autofillHints,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          inputFormatters:
              buildPhoneFieldInputFormatters(widget.inputFormatters),
          style: style.fieldStyle,
          slots: slots,
          overrides: widget.fieldOverrides,
        ),
      ),
    );
  }
}
