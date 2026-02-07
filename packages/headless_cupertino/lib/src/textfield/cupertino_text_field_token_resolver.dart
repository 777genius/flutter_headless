import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import '../overrides/cupertino_text_field_overrides.dart';

/// Cupertino token resolver for TextField components.
///
/// Implements [RTextFieldTokenResolver] with iOS styling.
///
/// Token resolution priority:
/// 1. Preset-specific overrides: `overrides.get<CupertinoTextFieldOverrides>()`
/// 2. Contract overrides: `overrides.get<RTextFieldOverrides>()`
/// 3. Theme defaults / preset defaults
///
/// Defaults follow iOS HIG:
/// - Padding: 7px all sides
/// - Border radius: 5px
/// - Border width: 0.0 (matching Flutter's CupertinoTextField)
class CupertinoTextFieldTokenResolver implements RTextFieldTokenResolver {
  /// Creates a Cupertino text field token resolver.
  ///
  /// [brightness] - Optional brightness override (light/dark).
  const CupertinoTextFieldTokenResolver({
    this.brightness,
  });

  /// Optional brightness override.
  final Brightness? brightness;

  @override
  RTextFieldResolvedTokens resolve({
    required BuildContext context,
    required RTextFieldSpec spec,
    required Set<WidgetState> states,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    final effectiveBrightness =
        brightness ?? CupertinoTheme.brightnessOf(context);
    final isDark = effectiveBrightness == Brightness.dark;

    final cupertinoOverrides = overrides?.get<CupertinoTextFieldOverrides>();
    final textFieldOverrides = overrides?.get<RTextFieldOverrides>();

    final q = HeadlessWidgetStateQuery(states);
    final isFocused = q.isFocused;
    final isDisabled = q.isDisabled;
    final isError = q.isError;
    // Cupertino does not have a native "underlined" text field variant.
    // Borderless is an explicit Cupertino-only override.
    final isBorderless = cupertinoOverrides?.isBorderless ?? false;

    // Resolve colors based on state
    final colors = _resolveColors(
      isDark: isDark,
      isFocused: isFocused,
      isDisabled: isDisabled,
      isError: isError,
      isBorderless: isBorderless,
    );

    // Resolve padding
    final padding = cupertinoOverrides?.padding ??
        textFieldOverrides?.containerPadding ??
        const EdgeInsets.all(7.0);

    // Resolve border
    final borderRadius = textFieldOverrides?.containerBorderRadius ??
        const BorderRadius.all(Radius.circular(5.0));
    final borderWidth = textFieldOverrides?.containerBorderWidth ?? 0.0;

    // Resolve text styles
    final textStyle = textFieldOverrides?.textStyle ??
        CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 17);
    final placeholderStyle = textFieldOverrides?.placeholderStyle ??
        textStyle.copyWith(fontWeight: FontWeight.w400);

    // Default animation duration
    const defaultDuration = Duration(milliseconds: 200);

    return RTextFieldResolvedTokens(
      containerPadding: padding,
      containerBackgroundColor: textFieldOverrides?.containerBackgroundColor ??
          _resolveBackgroundColor(
            isBorderless: isBorderless,
            fallback: colors.background,
          ),
      containerBorderColor:
          textFieldOverrides?.containerBorderColor ?? colors.border,
      containerBorderRadius: borderRadius,
      containerBorderWidth: borderWidth,
      containerElevation: 0.0,
      containerAnimationDuration:
          textFieldOverrides?.containerAnimationDuration ?? defaultDuration,
      labelStyle:
          textFieldOverrides?.labelStyle ?? textStyle.copyWith(fontSize: 13),
      labelColor: textFieldOverrides?.labelColor ?? colors.label,
      helperStyle:
          textFieldOverrides?.helperStyle ?? textStyle.copyWith(fontSize: 13),
      helperColor: textFieldOverrides?.helperColor ?? colors.helper,
      errorStyle:
          textFieldOverrides?.errorStyle ?? textStyle.copyWith(fontSize: 13),
      errorColor: textFieldOverrides?.errorColor ?? CupertinoColors.systemRed,
      messageSpacing: 4.0,
      textStyle: textStyle,
      textColor: textFieldOverrides?.textColor ?? colors.text,
      placeholderStyle: placeholderStyle,
      placeholderColor:
          textFieldOverrides?.placeholderColor ?? colors.placeholder,
      cursorColor: textFieldOverrides?.cursorColor ??
          CupertinoTheme.of(context).primaryColor,
      selectionColor: textFieldOverrides?.selectionColor ??
          CupertinoTheme.of(context).primaryColor.withValues(alpha: 0.3),
      disabledOpacity: 0.38,
      iconColor: textFieldOverrides?.iconColor ?? colors.icon,
      iconSpacing: 8.0,
      minSize: textFieldOverrides?.minSize ?? Size.zero,
    );
  }

  Color _resolveBackgroundColor({
    required bool isBorderless,
    required Color fallback,
  }) {
    if (isBorderless) {
      return CupertinoColors.transparent;
    }
    return fallback;
  }

  _TextFieldColors _resolveColors({
    required bool isDark,
    required bool isFocused,
    required bool isDisabled,
    required bool isError,
    required bool isBorderless,
  }) {
    // Background
    final background =
        isDark ? CupertinoColors.darkBackgroundGray : CupertinoColors.white;

    // Border
    Color border;
    if (isBorderless) {
      border = CupertinoColors.transparent;
    } else if (isError) {
      border = CupertinoColors.systemRed;
    } else if (isFocused) {
      border = isDark ? CupertinoColors.systemBlue : CupertinoColors.activeBlue;
    } else {
      border = isDark
          ? const Color(0xFF3D3D3D) // systemGrey4 dark
          : const Color(0xFFC6C6C8); // systemGrey4 light
    }

    // Text colors
    final text = isDark ? CupertinoColors.white : CupertinoColors.black;
    final placeholder =
        isDark ? CupertinoColors.systemGrey : CupertinoColors.placeholderText;
    final label =
        isDark ? CupertinoColors.systemGrey : CupertinoColors.secondaryLabel;
    final helper = label;
    final icon =
        isDark ? CupertinoColors.systemGrey : CupertinoColors.secondaryLabel;

    return _TextFieldColors(
      background: background,
      border: border,
      text: text,
      placeholder: placeholder,
      label: label,
      helper: helper,
      icon: icon,
    );
  }
}

class _TextFieldColors {
  const _TextFieldColors({
    required this.background,
    required this.border,
    required this.text,
    required this.placeholder,
    required this.label,
    required this.helper,
    required this.icon,
  });

  final Color background;
  final Color border;
  final Color text;
  final Color placeholder;
  final Color label;
  final Color helper;
  final Color icon;
}
