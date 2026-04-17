import 'package:flutter/widgets.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../logic/r_phone_field_country_data.dart';

typedef RPhoneNumberValidator = String? Function(PhoneNumber value);

typedef RPhoneFieldCountryButtonBuilder = Widget Function(
  BuildContext context,
  RPhoneFieldCountryButtonRequest request,
);

enum RPhoneFieldCountryButtonPlacement {
  leading,
  prefix,
  trailing,
  suffix,
}

@immutable
final class RPhoneFieldCountryButtonRequest {
  const RPhoneFieldCountryButtonRequest({
    required this.country,
    required this.countries,
    required this.favoriteCountries,
    required this.enabled,
    required this.style,
    required this.noResultMessage,
    required this.searchAutofocus,
    required this.onPressed,
    required this.onCountrySelected,
  });

  final RPhoneFieldCountryData country;
  final List<RPhoneFieldCountryData> countries;
  final List<RPhoneFieldCountryData> favoriteCountries;
  final bool enabled;
  final RPhoneFieldCountryButtonStyle style;
  final String? noResultMessage;
  final bool searchAutofocus;
  final VoidCallback onPressed;
  final ValueChanged<IsoCode> onCountrySelected;
}

@immutable
final class RPhoneFieldCountryButtonStyle {
  const RPhoneFieldCountryButtonStyle({
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.spacing = 8,
    this.showFlag = true,
    this.showDialCode = true,
    this.showIsoCode = false,
    this.showDropdownIcon = true,
    this.dropdownIconSize = 16,
    this.dropdownIconColor,
    this.disabledOpacity = 0.56,
  });

  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final bool showFlag;
  final bool showDialCode;
  final bool showIsoCode;
  final bool showDropdownIcon;
  final double dropdownIconSize;
  final Color? dropdownIconColor;
  final double disabledOpacity;

  RPhoneFieldCountryButtonStyle copyWith({
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    double? spacing,
    bool? showFlag,
    bool? showDialCode,
    bool? showIsoCode,
    bool? showDropdownIcon,
    double? dropdownIconSize,
    Color? dropdownIconColor,
    double? disabledOpacity,
  }) {
    return RPhoneFieldCountryButtonStyle(
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      spacing: spacing ?? this.spacing,
      showFlag: showFlag ?? this.showFlag,
      showDialCode: showDialCode ?? this.showDialCode,
      showIsoCode: showIsoCode ?? this.showIsoCode,
      showDropdownIcon: showDropdownIcon ?? this.showDropdownIcon,
      dropdownIconSize: dropdownIconSize ?? this.dropdownIconSize,
      dropdownIconColor: dropdownIconColor ?? this.dropdownIconColor,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    );
  }
}
