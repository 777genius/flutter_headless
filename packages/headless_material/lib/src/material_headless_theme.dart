import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import 'button/material_button_renderer.dart';
import 'button/material_button_token_resolver.dart';
import 'checkbox/material_checkbox_renderer.dart';
import 'checkbox/material_checkbox_token_resolver.dart';
import 'checkbox_list_tile/material_checkbox_list_tile_renderer.dart';
import 'checkbox_list_tile/material_checkbox_list_tile_token_resolver.dart';
import 'dropdown/material_dropdown_renderer.dart';
import 'dropdown/material_dropdown_token_resolver.dart';
import 'switch/material_switch_renderer.dart';
import 'switch/material_switch_token_resolver.dart';
import 'switch_list_tile/material_switch_list_tile_renderer.dart';
import 'switch_list_tile/material_switch_list_tile_token_resolver.dart';
import 'textfield/material_text_field_renderer.dart';
import 'textfield/material_text_field_token_resolver.dart';
import 'autocomplete/material_autocomplete_selected_values_renderer.dart';
import 'material_headless_defaults.dart';
import '../primitives/material_ink_pressable_surface.dart';

/// Material 3 theme preset for Headless components.
///
/// Implements [HeadlessTheme] and provides Material-styled capabilities:
/// - [RButtonRenderer] via [MaterialButtonRenderer]
/// - [RButtonTokenResolver] via [MaterialButtonTokenResolver]
/// - [RDropdownButtonRenderer] via [MaterialDropdownRenderer]
/// - [RDropdownTokenResolver] via [MaterialDropdownTokenResolver]
/// - [RTextFieldRenderer] via [MaterialTextFieldRenderer]
/// - [RTextFieldTokenResolver] via [MaterialTextFieldTokenResolver]
///
/// Usage:
/// ```dart
/// HeadlessThemeProvider(
///   theme: MaterialHeadlessTheme(),
///   child: MyApp(),
/// )
/// ```
///
/// For scoped customization:
/// ```dart
/// HeadlessThemeProvider(
///   theme: MaterialHeadlessTheme.copyWith(
///     colorScheme: darkColorScheme,
///   ),
///   child: DarkSection(),
/// )
/// ```
class MaterialHeadlessTheme extends HeadlessTheme {
  /// Creates a Material 3 theme preset with optional customization.
  ///
  /// [colorScheme] - Custom color scheme (defaults to Material 3 baseline).
  /// [textTheme] - Custom text theme.
  /// [defaults] - User-friendly defaults for component policies.
  MaterialHeadlessTheme({
    ColorScheme? colorScheme,
    TextTheme? textTheme,
    MaterialHeadlessDefaults? defaults,
  })  : _colorScheme = colorScheme,
        _textTheme = textTheme,
        _defaults = defaults,
        _buttonRenderer = const MaterialButtonRenderer(),
        _buttonTokenResolver = MaterialButtonTokenResolver(
          colorScheme: colorScheme,
          textTheme: textTheme,
          defaults: defaults?.button,
        ),
        _checkboxRenderer = const MaterialCheckboxRenderer(),
        _checkboxTokenResolver = MaterialCheckboxTokenResolver(
          colorScheme: colorScheme,
        ),
        _checkboxListTileRenderer = MaterialCheckboxListTileRenderer(
          defaults: defaults?.listTile,
        ),
        _checkboxListTileTokenResolver = MaterialCheckboxListTileTokenResolver(
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        _switchRenderer = const MaterialSwitchRenderer(),
        _switchTokenResolver = MaterialSwitchTokenResolver(
          colorScheme: colorScheme,
        ),
        _switchListTileRenderer = MaterialSwitchListTileRenderer(
          defaults: defaults?.listTile,
        ),
        _switchListTileTokenResolver = MaterialSwitchListTileTokenResolver(
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        _dropdownRenderer = const MaterialDropdownRenderer(),
        _dropdownTokenResolver = MaterialDropdownTokenResolver(
          colorScheme: colorScheme,
          textTheme: textTheme,
          defaults: defaults?.dropdown,
        ),
        _textFieldRenderer = const MaterialTextFieldRenderer(),
        _textFieldTokenResolver = MaterialTextFieldTokenResolver(
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        _autocompleteSelectedValuesRenderer =
            const MaterialAutocompleteSelectedValuesRenderer(),
        _pressableSurfaceFactory = const MaterialInkPressableSurface();

  final ColorScheme? _colorScheme;
  final TextTheme? _textTheme;
  final MaterialHeadlessDefaults? _defaults;
  final MaterialButtonRenderer _buttonRenderer;
  final MaterialButtonTokenResolver _buttonTokenResolver;
  final MaterialCheckboxRenderer _checkboxRenderer;
  final MaterialCheckboxTokenResolver _checkboxTokenResolver;
  final MaterialCheckboxListTileRenderer _checkboxListTileRenderer;
  final MaterialCheckboxListTileTokenResolver _checkboxListTileTokenResolver;
  final MaterialSwitchRenderer _switchRenderer;
  final MaterialSwitchTokenResolver _switchTokenResolver;
  final MaterialSwitchListTileRenderer _switchListTileRenderer;
  final MaterialSwitchListTileTokenResolver _switchListTileTokenResolver;
  final MaterialDropdownRenderer _dropdownRenderer;
  final MaterialDropdownTokenResolver _dropdownTokenResolver;
  final MaterialTextFieldRenderer _textFieldRenderer;
  final MaterialTextFieldTokenResolver _textFieldTokenResolver;
  final MaterialAutocompleteSelectedValuesRenderer _autocompleteSelectedValuesRenderer;
  final MaterialInkPressableSurface _pressableSurfaceFactory;

  /// Creates a dark variant of the Material theme.
  factory MaterialHeadlessTheme.dark() {
    return MaterialHeadlessTheme(
      colorScheme: const ColorScheme.dark(),
    );
  }

  /// Creates a light variant of the Material theme.
  factory MaterialHeadlessTheme.light() {
    return MaterialHeadlessTheme(
      colorScheme: const ColorScheme.light(),
    );
  }

  /// Creates a copy of this theme with specified overrides.
  MaterialHeadlessTheme copyWith({
    ColorScheme? colorScheme,
    TextTheme? textTheme,
    MaterialHeadlessDefaults? defaults,
  }) {
    return MaterialHeadlessTheme(
      colorScheme: colorScheme ?? _colorScheme,
      textTheme: textTheme ?? _textTheme,
      defaults: defaults ?? _defaults,
    );
  }

  @override
  T? capability<T>() {
    // Button capabilities
    if (T == RButtonRenderer) {
      return _buttonRenderer as T;
    }
    if (T == RButtonTokenResolver) {
      return _buttonTokenResolver as T;
    }

    // Checkbox capabilities
    if (T == RCheckboxRenderer) {
      return _checkboxRenderer as T;
    }
    if (T == RCheckboxTokenResolver) {
      return _checkboxTokenResolver as T;
    }
    if (T == RCheckboxListTileRenderer) {
      return _checkboxListTileRenderer as T;
    }
    if (T == RCheckboxListTileTokenResolver) {
      return _checkboxListTileTokenResolver as T;
    }

    // Switch capabilities
    if (T == RSwitchRenderer) {
      return _switchRenderer as T;
    }
    if (T == RSwitchTokenResolver) {
      return _switchTokenResolver as T;
    }
    if (T == RSwitchListTileRenderer) {
      return _switchListTileRenderer as T;
    }
    if (T == RSwitchListTileTokenResolver) {
      return _switchListTileTokenResolver as T;
    }

    // Dropdown capabilities (non-generic contracts)
    if (T == RDropdownButtonRenderer) {
      return _dropdownRenderer as T;
    }
    if (T == RDropdownTokenResolver) {
      return _dropdownTokenResolver as T;
    }

    // TextField capabilities
    if (T == RTextFieldRenderer) {
      return _textFieldRenderer as T;
    }
    if (T == RTextFieldTokenResolver) {
      return _textFieldTokenResolver as T;
    }

    // Autocomplete capabilities
    if (T == RAutocompleteSelectedValuesRenderer) {
      return _autocompleteSelectedValuesRenderer as T;
    }

    // Interaction capabilities
    if (T == HeadlessPressableSurfaceFactory) {
      return _pressableSurfaceFactory as T;
    }

    // No capability found
    return null;
  }
}
