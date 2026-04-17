import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../presentation/country_selector/dialog_country_selector_navigator.dart';
import '../presentation/country_selector/menu_country_selector_navigator.dart';
import '../presentation/country_selector/modal_bottom_sheet_country_selector_navigator.dart';
import '../presentation/country_selector/page_country_selector_navigator.dart';

enum RPhoneFieldMenuAnchorTarget {
  trigger,
  field,
}

@immutable
final class RPhoneFieldCountrySelectorRequest {
  const RPhoneFieldCountrySelectorRequest({
    required this.countries,
    required this.favoriteCountries,
    required this.selectedCountry,
    required this.showDialCode,
    required this.noResultMessage,
    required this.searchAutofocus,
    required this.subtitleStyle,
    required this.titleStyle,
    required this.searchBoxDecoration,
    required this.searchBoxTextStyle,
    required this.searchBoxIconColor,
    required this.scrollPhysics,
    required this.backgroundColor,
    required this.flagSize,
    required this.anchorRectGetter,
    this.fieldRectGetter,
    this.triggerRectGetter,
    required this.restoreFocusNode,
    required this.useRootNavigator,
  });

  final List<IsoCode>? countries;
  final List<IsoCode>? favoriteCountries;
  final IsoCode selectedCountry;
  final bool showDialCode;
  final String? noResultMessage;
  final bool searchAutofocus;
  final TextStyle? subtitleStyle;
  final TextStyle? titleStyle;
  final InputDecoration? searchBoxDecoration;
  final TextStyle? searchBoxTextStyle;
  final Color? searchBoxIconColor;
  final ScrollPhysics? scrollPhysics;
  final Color? backgroundColor;
  final double flagSize;
  final Rect? Function()? anchorRectGetter;
  final Rect? Function()? fieldRectGetter;
  final Rect? Function()? triggerRectGetter;
  final FocusNode? restoreFocusNode;
  final bool useRootNavigator;
}

abstract interface class RPhoneFieldCountrySelectorNavigator {
  const factory RPhoneFieldCountrySelectorNavigator.page({
    bool searchAutofocus,
    Color? backgroundColor,
    bool useRootNavigator,
  }) = RPhoneFieldPageCountrySelectorNavigator;

  const factory RPhoneFieldCountrySelectorNavigator.dialog({
    double? height,
    double? width,
    bool searchAutofocus,
    Color? backgroundColor,
    bool useRootNavigator,
  }) = RPhoneFieldDialogCountrySelectorNavigator;

  const factory RPhoneFieldCountrySelectorNavigator.modalBottomSheet({
    double? height,
    bool searchAutofocus,
    Color? backgroundColor,
    bool useRootNavigator,
  }) = RPhoneFieldModalBottomSheetCountrySelectorNavigator;

  const factory RPhoneFieldCountrySelectorNavigator.menu({
    double? height,
    bool searchAutofocus,
    Color? backgroundColor,
    RPhoneFieldMenuAnchorTarget anchorTarget,
    bool useRootNavigator,
  }) = RPhoneFieldMenuCountrySelectorNavigator;

  bool get searchAutofocus;
  Color? get backgroundColor;
  bool get useRootNavigator;

  Future<IsoCode?> show(
    BuildContext context,
    RPhoneFieldCountrySelectorRequest request,
  );
}
