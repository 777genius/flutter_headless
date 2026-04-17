import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../contracts/r_phone_field_country_selector_navigator.dart';
import '../contracts/r_phone_field_types.dart';
import '../logic/r_phone_field_control_config.dart';
import '../logic/r_phone_field_controller.dart';
import 'r_phone_field_state.dart';
import 'r_phone_field_style.dart';

class RPhoneField extends StatefulWidget {
  RPhoneField({
    super.key,
    this.value,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.onCountryChanged,
    this.onEditingComplete,
    this.onTapOutside,
    this.focusNode,
    this.placeholder,
    this.label,
    this.helperText,
    this.errorText,
    this.semanticLabel,
    this.semanticHint,
    this.variant = RTextFieldVariant.outlined,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType = TextInputType.phone,
    this.textInputAction,
    this.autofillHints = const [AutofillHints.telephoneNumberNational],
    this.inputFormatters,
    this.scrollPadding = const EdgeInsets.all(20),
    this.enableIMEPersonalizedLearning = false,
    this.enableSuggestions = false,
    this.autocorrect = false,
    this.smartDashesType = SmartDashesType.disabled,
    this.smartQuotesType = SmartQuotesType.disabled,
    this.countries,
    this.favoriteCountries,
    this.showDialCodeInSelector = true,
    this.countrySelectorNoResultMessage,
    this.countrySelectorTitleStyle,
    this.countrySelectorSubtitleStyle,
    this.countrySelectorSearchBoxDecoration,
    this.countrySelectorSearchBoxTextStyle,
    this.countrySelectorSearchBoxIconColor,
    this.countrySelectorScrollPhysics,
    this.countrySelectorFlagSize = 40,
    this.countrySelectorNavigator =
        const RPhoneFieldCountrySelectorNavigator.page(),
    this.isCountrySelectionEnabled = true,
    this.countryButtonBuilder,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.shouldLimitLengthByCountry = false,
    this.style,
    this.fieldSlots,
    this.fieldOverrides,
  }) {
    validatePhoneFieldControlConfig(
      value: value,
      controller: controller,
      initialValue: initialValue,
    );
  }

  final PhoneNumber? value;
  final RPhoneFieldController? controller;
  final PhoneNumber? initialValue;
  final ValueChanged<PhoneNumber>? onChanged;
  final ValueChanged<PhoneNumber>? onSubmitted;
  final ValueChanged<IsoCode>? onCountryChanged;
  final VoidCallback? onEditingComplete;
  final TapRegionCallback? onTapOutside;
  final FocusNode? focusNode;
  final String? placeholder;
  final String? label;
  final String? helperText;
  final String? errorText;
  final String? semanticLabel;
  final String? semanticHint;
  final RTextFieldVariant variant;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsets scrollPadding;
  final bool enableIMEPersonalizedLearning;
  final bool enableSuggestions;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final List<IsoCode>? countries;
  final List<IsoCode>? favoriteCountries;
  final bool showDialCodeInSelector;
  final String? countrySelectorNoResultMessage;
  final TextStyle? countrySelectorTitleStyle;
  final TextStyle? countrySelectorSubtitleStyle;
  final InputDecoration? countrySelectorSearchBoxDecoration;
  final TextStyle? countrySelectorSearchBoxTextStyle;
  final Color? countrySelectorSearchBoxIconColor;
  final ScrollPhysics? countrySelectorScrollPhysics;
  final double countrySelectorFlagSize;
  final RPhoneFieldCountrySelectorNavigator countrySelectorNavigator;
  final bool isCountrySelectionEnabled;
  final RPhoneFieldCountryButtonBuilder? countryButtonBuilder;
  final RPhoneNumberValidator? validator;
  final AutovalidateMode autovalidateMode;
  final bool shouldLimitLengthByCountry;
  final RPhoneFieldStyle? style;
  final RTextFieldSlots? fieldSlots;
  final RenderOverrides? fieldOverrides;

  @override
  State<RPhoneField> createState() => RPhoneFieldStateImpl();
}
