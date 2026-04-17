import 'package:flutter/material.dart';
import 'package:headless_phone_field/headless_phone_field.dart';

import 'phone_field_shell_gallery_preset.dart';

RPhoneFieldCountrySelectorNavigator phoneFieldShellGalleryNavigator(
  PhoneFieldShellPreset preset,
) =>
    switch (preset) {
      PhoneFieldShellPreset.soft =>
        RPhoneFieldCountrySelectorNavigator.modalBottomSheet(
          height: 480,
          searchAutofocus: true,
          backgroundColor: phoneFieldShellMenuBackgroundColor(preset),
        ),
      PhoneFieldShellPreset.minimal => RPhoneFieldCountrySelectorNavigator.menu(
          height: 360,
          searchAutofocus: true,
          backgroundColor: phoneFieldShellMenuBackgroundColor(preset),
          anchorTarget: RPhoneFieldMenuAnchorTarget.field,
        ),
      PhoneFieldShellPreset.travel =>
        RPhoneFieldCountrySelectorNavigator.dialog(
          width: 480,
          height: 560,
          searchAutofocus: true,
          backgroundColor: phoneFieldShellMenuBackgroundColor(preset),
        ),
      PhoneFieldShellPreset.console => RPhoneFieldCountrySelectorNavigator.page(
          searchAutofocus: true,
          backgroundColor: phoneFieldShellMenuBackgroundColor(preset),
        ),
    };

Color phoneFieldShellMenuBackgroundColor(PhoneFieldShellPreset preset) =>
    switch (preset) {
      PhoneFieldShellPreset.soft => const Color(0xFFF8F1FF),
      PhoneFieldShellPreset.minimal => const Color(0xFFFFFBF4),
      PhoneFieldShellPreset.travel => const Color(0xFFF0F7FF),
      PhoneFieldShellPreset.console => const Color(0xFF172019),
    };

TextStyle? phoneFieldShellMenuTitleStyle(
  BuildContext context,
  PhoneFieldShellPreset preset,
) =>
    switch (preset) {
      PhoneFieldShellPreset.soft => _menuTextStyle(
          context,
          color: const Color(0xFF2F234A),
        ),
      PhoneFieldShellPreset.minimal => _menuTextStyle(
          context,
          color: const Color(0xFF4C3317),
        ),
      PhoneFieldShellPreset.travel => _menuTextStyle(
          context,
          color: const Color(0xFF173B63),
        ),
      PhoneFieldShellPreset.console => _menuTextStyle(
          context,
          color: const Color(0xFFEAF7DF),
        ),
    };

TextStyle? phoneFieldShellMenuSubtitleStyle(
  BuildContext context,
  PhoneFieldShellPreset preset,
) =>
    switch (preset) {
      PhoneFieldShellPreset.soft =>
        Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF6D5B8C),
            ),
      PhoneFieldShellPreset.minimal =>
        Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF86613C),
            ),
      PhoneFieldShellPreset.travel =>
        Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF557395),
            ),
      PhoneFieldShellPreset.console =>
        Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF9FB59F),
            ),
    };

TextStyle? phoneFieldShellMenuSearchTextStyle(
  BuildContext context,
  PhoneFieldShellPreset preset,
) =>
    switch (preset) {
      PhoneFieldShellPreset.soft => _menuSearchTextStyle(
          context,
          color: const Color(0xFF2F234A),
        ),
      PhoneFieldShellPreset.minimal => _menuSearchTextStyle(
          context,
          color: const Color(0xFF4C3317),
        ),
      PhoneFieldShellPreset.travel => _menuSearchTextStyle(
          context,
          color: const Color(0xFF173B63),
        ),
      PhoneFieldShellPreset.console => _menuSearchTextStyle(
          context,
          color: const Color(0xFFEAF7DF),
        ),
    };

Color phoneFieldShellMenuSearchIconColor(PhoneFieldShellPreset preset) =>
    switch (preset) {
      PhoneFieldShellPreset.soft => const Color(0xFF7A63A6),
      PhoneFieldShellPreset.minimal => const Color(0xFF9A5A1B),
      PhoneFieldShellPreset.travel => const Color(0xFF2E78C7),
      PhoneFieldShellPreset.console => const Color(0xFF9BE66E),
    };

TextStyle? _menuTextStyle(
  BuildContext context, {
  required Color color,
}) {
  return Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
      );
}

TextStyle? _menuSearchTextStyle(
  BuildContext context, {
  required Color color,
}) {
  return Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      );
}
