import 'package:flutter/widgets.dart';

import 'r_dropdown_menu_motion_tokens.dart';

/// Resolved visual tokens for dropdown rendering.
///
/// These are the **final, computed values** that a renderer uses.
/// Token resolution happens in the component (or theme), not in the renderer.
///
/// Tokens are split into trigger/menu/item groups to keep the API organized
/// and allow independent customization of each part.
///
/// See `docs/V1_DECISIONS.md` → "Token Resolution Layer".
@immutable
final class RDropdownResolvedTokens {
  const RDropdownResolvedTokens({
    required this.trigger,
    required this.menu,
    required this.item,
  });

  /// Tokens for the trigger button.
  final RDropdownTriggerTokens trigger;

  /// Tokens for the menu surface.
  final RDropdownMenuTokens menu;

  /// Tokens for menu items.
  final RDropdownItemTokens item;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RDropdownResolvedTokens &&
        other.trigger == trigger &&
        other.menu == menu &&
        other.item == item;
  }

  @override
  int get hashCode => Object.hash(trigger, menu, item);
}

/// Resolved tokens for the dropdown trigger button.
@immutable
final class RDropdownTriggerTokens {
  const RDropdownTriggerTokens({
    required this.textStyle,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.padding,
    required this.minSize,
    required this.borderRadius,
    required this.iconColor,
    required this.pressOverlayColor,
    required this.pressOpacity,
  });

  /// Text style for selected value / placeholder.
  final TextStyle textStyle;

  /// Foreground color (text, icon).
  final Color foregroundColor;

  /// Background fill color.
  final Color backgroundColor;

  /// Border/outline color.
  final Color borderColor;

  /// Content padding.
  final EdgeInsetsGeometry padding;

  /// Minimum touch target size (WCAG/platform guidelines).
  final Size minSize;

  /// Corner radius.
  final BorderRadius borderRadius;

  /// Dropdown arrow icon color.
  final Color iconColor;

  /// Visual-only press overlay color (e.g., Material pressed highlight).
  ///
  /// Used by renderers together with "visual effects hooks" to provide
  /// pressed feedback without owning activation logic.
  final Color pressOverlayColor;

  /// Visual-only pressed opacity (e.g., Cupertino pressed fade).
  ///
  /// Value in range [0..1]. Renderers may ignore this if not applicable.
  final double pressOpacity;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RDropdownTriggerTokens &&
        other.textStyle == textStyle &&
        other.foregroundColor == foregroundColor &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.padding == padding &&
        other.minSize == minSize &&
        other.borderRadius == borderRadius &&
        other.iconColor == iconColor &&
        other.pressOverlayColor == pressOverlayColor &&
        other.pressOpacity == pressOpacity;
  }

  @override
  int get hashCode => Object.hash(
        textStyle,
        foregroundColor,
        backgroundColor,
        borderColor,
        padding,
        minSize,
        borderRadius,
        iconColor,
        pressOverlayColor,
        pressOpacity,
      );
}

/// Resolved tokens for the dropdown menu surface.
@immutable
final class RDropdownMenuTokens {
  const RDropdownMenuTokens({
    required this.backgroundColor,
    required this.backgroundOpacity,
    required this.borderColor,
    required this.borderRadius,
    required this.elevation,
    required this.maxHeight,
    required this.padding,
    required this.backdropBlurSigma,
    required this.shadowColor,
    required this.shadowBlurRadius,
    required this.shadowOffset,
    this.motion,
  });

  /// Menu surface background color.
  final Color backgroundColor;

  /// Background opacity for translucent menu surfaces.
  final double backgroundOpacity;

  /// Menu border color.
  final Color borderColor;

  /// Menu corner radius.
  final BorderRadius borderRadius;

  /// Elevation/shadow depth.
  final double elevation;

  /// Maximum menu height before scrolling.
  final double maxHeight;

  /// Menu content padding (around item list).
  final EdgeInsetsGeometry padding;

  /// Backdrop blur sigma for translucent menu surfaces.
  final double backdropBlurSigma;

  /// Shadow color for menu surface.
  final Color shadowColor;

  /// Shadow blur radius for menu surface.
  final double shadowBlurRadius;

  /// Shadow offset for menu surface.
  final Offset shadowOffset;

  /// Motion tokens for enter/exit animations.
  ///
  /// If null, renderer uses its preset defaults.
  final RDropdownMenuMotionTokens? motion;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RDropdownMenuTokens &&
        other.backgroundColor == backgroundColor &&
        other.backgroundOpacity == backgroundOpacity &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.elevation == elevation &&
        other.maxHeight == maxHeight &&
        other.padding == padding &&
        other.backdropBlurSigma == backdropBlurSigma &&
        other.shadowColor == shadowColor &&
        other.shadowBlurRadius == shadowBlurRadius &&
        other.shadowOffset == shadowOffset &&
        other.motion == motion;
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        backgroundOpacity,
        borderColor,
        borderRadius,
        elevation,
        maxHeight,
        padding,
        backdropBlurSigma,
        shadowColor,
        shadowBlurRadius,
        shadowOffset,
        motion,
      );
}

/// Resolved tokens for dropdown menu items.
@immutable
final class RDropdownItemTokens {
  const RDropdownItemTokens({
    required this.textStyle,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.highlightBackgroundColor,
    required this.selectedBackgroundColor,
    required this.disabledForegroundColor,
    required this.padding,
    required this.minHeight,
    required this.selectedMarkerColor,
  });

  /// Text style for item label.
  final TextStyle textStyle;

  /// Normal foreground color.
  final Color foregroundColor;

  /// Normal background color.
  final Color backgroundColor;

  /// Background color when item is keyboard-highlighted.
  final Color highlightBackgroundColor;

  /// Background color when item is selected.
  final Color selectedBackgroundColor;

  /// Foreground color when item is disabled.
  final Color disabledForegroundColor;

  /// Item content padding.
  final EdgeInsetsGeometry padding;

  /// Minimum item height.
  final double minHeight;

  /// Color for selected item marker (checkmark).
  final Color selectedMarkerColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RDropdownItemTokens &&
        other.textStyle == textStyle &&
        other.foregroundColor == foregroundColor &&
        other.backgroundColor == backgroundColor &&
        other.highlightBackgroundColor == highlightBackgroundColor &&
        other.selectedBackgroundColor == selectedBackgroundColor &&
        other.disabledForegroundColor == disabledForegroundColor &&
        other.padding == padding &&
        other.minHeight == minHeight &&
        other.selectedMarkerColor == selectedMarkerColor;
  }

  @override
  int get hashCode => Object.hash(
        textStyle,
        foregroundColor,
        backgroundColor,
        highlightBackgroundColor,
        selectedBackgroundColor,
        disabledForegroundColor,
        padding,
        minHeight,
        selectedMarkerColor,
      );
}
