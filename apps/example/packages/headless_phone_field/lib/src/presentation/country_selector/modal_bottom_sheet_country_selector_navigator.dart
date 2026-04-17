import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../contracts/r_phone_field_country_selector_navigator.dart';
import 'country_selector_view.dart';

class RPhoneFieldModalBottomSheetCountrySelectorNavigator
    implements RPhoneFieldCountrySelectorNavigator {
  const RPhoneFieldModalBottomSheetCountrySelectorNavigator({
    this.height,
    this.searchAutofocus = false,
    this.backgroundColor,
    this.useRootNavigator = true,
  });

  final double? height;
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
    return showModalBottomSheet<IsoCode>(
      context: context,
      useRootNavigator: useRootNavigator,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      builder: (_) => SafeArea(
        child: SizedBox(
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
