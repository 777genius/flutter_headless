import 'package:flutter/material.dart';
import 'package:flutter_country_selector/flutter_country_selector.dart';

import '../../contracts/r_phone_field_country_selector_navigator.dart';

class RPhoneFieldPageCountrySelectorNavigator
    implements RPhoneFieldCountrySelectorNavigator {
  const RPhoneFieldPageCountrySelectorNavigator({
    this.searchAutofocus = false,
    this.backgroundColor,
    this.useRootNavigator = true,
  });

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
    final routeTheme = _buildPageSelectorTheme(
      Theme.of(context),
      request: request,
      backgroundColor: backgroundColor,
    );

    return Navigator.of(context, rootNavigator: useRootNavigator).push(
      MaterialPageRoute<IsoCode>(
        builder: (_) => Localizations.override(
          context: context,
          locale: Localizations.maybeLocaleOf(context),
          child: Theme(
            data: routeTheme,
            child: CountrySelector.page(
              onCountrySelected: (country) => Navigator.of(
                context,
                rootNavigator: useRootNavigator,
              ).pop(country),
              countries: request.countries ?? IsoCode.values,
              favoriteCountries: request.favoriteCountries,
              showDialCode: request.showDialCode,
              noResultMessage: request.noResultMessage,
              searchAutofocus: searchAutofocus,
              subtitleStyle: request.subtitleStyle,
              titleStyle: request.titleStyle,
              searchBoxDecoration: request.searchBoxDecoration,
              searchBoxTextStyle: request.searchBoxTextStyle,
              searchBoxIconColor: request.searchBoxIconColor,
              scrollPhysics: request.scrollPhysics,
              flagSize: request.flagSize,
            ),
          ),
        ),
      ),
    );
  }
}

ThemeData _buildPageSelectorTheme(
  ThemeData baseTheme, {
  required RPhoneFieldCountrySelectorRequest request,
  required Color? backgroundColor,
}) {
  final background = backgroundColor ?? request.backgroundColor;
  if (background == null) return baseTheme;

  final primaryText =
      request.titleStyle?.color ?? baseTheme.colorScheme.onSurface;
  final secondaryText =
      request.subtitleStyle?.color ?? baseTheme.colorScheme.onSurfaceVariant;

  return baseTheme.copyWith(
    scaffoldBackgroundColor: background,
    canvasColor: background,
    dividerColor: secondaryText.withValues(alpha: 0.28),
    colorScheme: baseTheme.colorScheme.copyWith(
      surface: background,
      onSurface: primaryText,
      onSurfaceVariant: secondaryText,
      shadow: Colors.black.withValues(alpha: 0.24),
    ),
    appBarTheme: baseTheme.appBarTheme.copyWith(
      backgroundColor: background,
      foregroundColor: primaryText,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      iconTheme: IconThemeData(color: primaryText),
      titleTextStyle: baseTheme.textTheme.titleLarge?.copyWith(
        color: primaryText,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
      hintStyle: baseTheme.textTheme.bodyLarge?.copyWith(color: secondaryText),
    ),
  );
}
