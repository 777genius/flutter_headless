import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../contracts/r_phone_field_country_selector_navigator.dart';
import 'menu_country_selector_panel.dart';
import 'menu_country_selector_theme.dart';

final class RPhoneFieldCountryMenuOverlay extends StatelessWidget {
  const RPhoneFieldCountryMenuOverlay({
    required this.request,
    required this.searchFocusNode,
    required this.onCountrySelected,
    required this.width,
    required this.height,
    required this.backgroundColor,
    super.key,
  });

  final RPhoneFieldCountrySelectorRequest request;
  final FocusNode searchFocusNode;
  final ValueChanged<IsoCode> onCountrySelected;
  final double width;
  final double height;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = resolvePhoneFieldCountryMenuTheme(context, request);

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: width,
        child: Container(
          key: const ValueKey('phone-country-menu-surface'),
          height: height,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.outlineColor,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.16),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: RPhoneFieldCountryMenuPanel(
            request: request,
            searchFocusNode: searchFocusNode,
            onCountrySelected: onCountrySelected,
          ),
        ),
      ),
    );
  }
}
