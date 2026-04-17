import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_textfield/headless_textfield.dart';

import 'menu_country_selector_theme.dart';

final class RPhoneFieldCountryMenuSearchField extends StatelessWidget {
  const RPhoneFieldCountryMenuSearchField({
    required this.controller,
    required this.focusNode,
    required this.theme,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final RPhoneFieldCountryMenuTheme theme;

  @override
  Widget build(BuildContext context) {
    return RTextField(
      key: const ValueKey('phone-country-menu-search'),
      controller: controller,
      focusNode: focusNode,
      placeholder: 'Search country or dial code',
      slots: RTextFieldSlots(
        leading: Icon(Icons.search_rounded, color: theme.searchIconColor),
      ),
      style: const RTextFieldStyle(
        containerPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      overrides: RenderOverrides({
        RTextFieldOverrides: RTextFieldOverrides.tokens(
          textStyle: theme.searchTextStyle,
          textColor: theme.searchTextStyle.color,
          placeholderColor: theme.secondaryTextStyle.color,
          cursorColor: theme.accentColor,
          selectionColor: theme.accentColor.withValues(alpha: 0.18),
          containerBackgroundColor: theme.searchBackgroundColor,
          containerBorderColor: theme.searchBorderColor,
          containerBorderRadius: BorderRadius.circular(16),
          containerBorderWidth: 1.2,
        ),
      }),
      variant: RTextFieldVariant.outlined,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      scrollPadding: EdgeInsets.zero,
      autocorrect: false,
      enableSuggestions: false,
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
    );
  }
}
