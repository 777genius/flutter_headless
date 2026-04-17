import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../contracts/r_phone_field_country_selector_navigator.dart';
import 'country_selector_view.dart';

class RPhoneFieldDialogCountrySelectorNavigator
    implements RPhoneFieldCountrySelectorNavigator {
  const RPhoneFieldDialogCountrySelectorNavigator({
    this.height,
    this.width,
    this.searchAutofocus = false,
    this.backgroundColor,
    this.useRootNavigator = true,
  });

  final double? height;
  final double? width;
  @override
  final bool searchAutofocus;
  @override
  final Color? backgroundColor;
  @override
  final bool useRootNavigator;

  @override
  Future<IsoCode?> show(
    BuildContext context,
    RPhoneFieldCountrySelectorRequest request,
  ) {
    return showDialog<IsoCode>(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (_) => Dialog(
        backgroundColor: backgroundColor,
        child: SizedBox(
          width: width,
          height: height,
          child: buildPhoneFieldCountrySelectorView(
            context: context,
            request: request,
            onCountrySelected: (country) => Navigator.of(
              context,
              rootNavigator: useRootNavigator,
            ).pop(country),
          ),
        ),
      ),
    );
  }
}
