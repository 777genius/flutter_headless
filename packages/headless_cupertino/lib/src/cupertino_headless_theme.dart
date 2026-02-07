import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import 'accessibility/cupertino_tap_target_policy.dart';
import 'button/cupertino_button_token_resolver.dart';
import 'button/cupertino_flutter_parity_button_renderer.dart';
import 'checkbox/cupertino_checkbox_renderer.dart';
import 'checkbox/cupertino_checkbox_token_resolver.dart';
import 'checkbox_list_tile/cupertino_checkbox_list_tile_renderer.dart';
import 'checkbox_list_tile/cupertino_checkbox_list_tile_token_resolver.dart';
import 'dropdown/cupertino_dropdown_renderer.dart';
import 'dropdown/cupertino_dropdown_token_resolver.dart';
import 'primitives/cupertino_pressable_surface.dart';
import 'switch/cupertino_switch_renderer.dart';
import 'switch/cupertino_switch_token_resolver.dart';
import 'switch_list_tile/cupertino_switch_list_tile_renderer.dart';
import 'switch_list_tile/cupertino_switch_list_tile_token_resolver.dart';
import 'textfield/cupertino_text_field_renderer.dart';
import 'textfield/cupertino_text_field_token_resolver.dart';

/// Cupertino (iOS) theme preset for Headless components.
///
/// Implements [HeadlessTheme] and provides iOS-styled capabilities:
/// - [RButtonRenderer] via [CupertinoFlutterParityButtonRenderer] (parity visual port)
/// - [RButtonTokenResolver] via [CupertinoButtonTokenResolver]
/// - [RDropdownButtonRenderer] via [CupertinoDropdownRenderer]
/// - [RDropdownTokenResolver] via [CupertinoDropdownTokenResolver]
///
/// Usage:
/// ```dart
/// HeadlessThemeProvider(
///   theme: CupertinoHeadlessTheme(),
///   child: MyApp(),
/// )
/// ```
///
/// For scoped customization:
/// ```dart
/// HeadlessThemeProvider(
///   theme: CupertinoHeadlessTheme.dark(),
///   child: DarkSection(),
/// )
/// ```
class CupertinoHeadlessTheme extends HeadlessTheme {
  /// Creates a Cupertino theme preset with optional customization.
  ///
  /// [brightness] - Optional brightness (light/dark). Defaults to system.
  CupertinoHeadlessTheme({
    Brightness? brightness,
  })  : _brightness = brightness,
        _tapTargetPolicy = const CupertinoTapTargetPolicy(),
        _buttonRenderer = const CupertinoFlutterParityButtonRenderer(),
        _buttonTokenResolver = CupertinoButtonTokenResolver(
          brightness: brightness,
        ),
        _checkboxRenderer = const CupertinoCheckboxRenderer(),
        _checkboxTokenResolver = CupertinoCheckboxTokenResolver(
          brightness: brightness,
        ),
        _checkboxListTileRenderer = const CupertinoCheckboxListTileRenderer(),
        _checkboxListTileTokenResolver = CupertinoCheckboxListTileTokenResolver(
          brightness: brightness,
        ),
        _switchRenderer = const CupertinoSwitchRenderer(),
        _switchTokenResolver = CupertinoSwitchTokenResolver(
          brightness: brightness,
        ),
        _switchListTileRenderer = const CupertinoSwitchListTileRenderer(),
        _switchListTileTokenResolver = CupertinoSwitchListTileTokenResolver(
          brightness: brightness,
        ),
        _dropdownRenderer = const CupertinoDropdownRenderer(),
        _dropdownTokenResolver = CupertinoDropdownTokenResolver(
          brightness: brightness,
        ),
        _textFieldRenderer = const CupertinoTextFieldRenderer(),
        _textFieldTokenResolver = CupertinoTextFieldTokenResolver(
          brightness: brightness,
        ),
        _pressableSurfaceFactory = const CupertinoPressableSurface();

  final Brightness? _brightness;
  final CupertinoTapTargetPolicy _tapTargetPolicy;
  final RButtonRenderer _buttonRenderer;
  final CupertinoButtonTokenResolver _buttonTokenResolver;
  final CupertinoCheckboxRenderer _checkboxRenderer;
  final CupertinoCheckboxTokenResolver _checkboxTokenResolver;
  final CupertinoCheckboxListTileRenderer _checkboxListTileRenderer;
  final CupertinoCheckboxListTileTokenResolver _checkboxListTileTokenResolver;
  final CupertinoSwitchRenderer _switchRenderer;
  final CupertinoSwitchTokenResolver _switchTokenResolver;
  final CupertinoSwitchListTileRenderer _switchListTileRenderer;
  final CupertinoSwitchListTileTokenResolver _switchListTileTokenResolver;
  final CupertinoDropdownRenderer _dropdownRenderer;
  final CupertinoDropdownTokenResolver _dropdownTokenResolver;
  final CupertinoTextFieldRenderer _textFieldRenderer;
  final CupertinoTextFieldTokenResolver _textFieldTokenResolver;
  final CupertinoPressableSurface _pressableSurfaceFactory;

  /// Creates a dark variant of the Cupertino theme.
  factory CupertinoHeadlessTheme.dark() {
    return CupertinoHeadlessTheme(
      brightness: Brightness.dark,
    );
  }

  /// Creates a light variant of the Cupertino theme.
  factory CupertinoHeadlessTheme.light() {
    return CupertinoHeadlessTheme(
      brightness: Brightness.light,
    );
  }

  /// Creates a copy of this theme with specified overrides.
  CupertinoHeadlessTheme copyWith({
    Brightness? brightness,
  }) {
    return CupertinoHeadlessTheme(
      brightness: brightness ?? _brightness,
    );
  }

  @override
  T? capability<T>() {
    // Accessibility capabilities
    if (T == HeadlessTapTargetPolicy) {
      return _tapTargetPolicy as T;
    }

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

    // Interaction capabilities
    if (T == HeadlessPressableSurfaceFactory) {
      return _pressableSurfaceFactory as T;
    }

    // No capability found
    return null;
  }
}
