import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';

import 'phone_field_shell_gallery_preset.dart';

BoxDecoration phoneFieldShellCardDecoration(
  BuildContext context,
  PhoneFieldShellPreset preset,
) {
  final scheme = Theme.of(context).colorScheme;

  return switch (preset) {
    PhoneFieldShellPreset.soft => BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.secondaryContainer.withValues(alpha: 0.82),
            scheme.tertiaryContainer.withValues(alpha: 0.58),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.42),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 28,
            offset: Offset(0, 18),
          ),
        ],
      ),
    PhoneFieldShellPreset.minimal => BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFD7CAB3).withValues(alpha: 0.72),
        ),
      ),
    PhoneFieldShellPreset.travel => BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE7F4FF), Color(0xFFF7FBFF)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFC6DAEF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x142E78C7),
            blurRadius: 26,
            offset: Offset(0, 16),
          ),
        ],
      ),
    PhoneFieldShellPreset.console => BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A201B), Color(0xFF111612)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF4D6857)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 24,
            offset: Offset(0, 16),
          ),
        ],
      ),
  };
}

RenderOverrides phoneFieldShellOverrides(
  BuildContext context,
  PhoneFieldShellPreset preset,
) {
  final scheme = Theme.of(context).colorScheme;

  return switch (preset) {
    PhoneFieldShellPreset.soft => RenderOverrides({
        RTextFieldOverrides: RTextFieldOverrides.tokens(
          containerPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          minSize: const Size(0, 46),
          containerBorderRadius: BorderRadius.circular(22),
          containerBackgroundColor: scheme.surface.withValues(alpha: 0.72),
          containerBorderColor: scheme.outlineVariant.withValues(alpha: 0.45),
          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.04,
              ),
          iconSpacing: 5,
        ),
      }),
    PhoneFieldShellPreset.minimal => RenderOverrides({
        RTextFieldOverrides: RTextFieldOverrides.tokens(
          containerPadding:
              const EdgeInsets.symmetric(horizontal: 2, vertical: 14),
          containerBorderColor: const Color(0xFFD7CAB3),
          textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                height: 1.05,
              ),
          cursorColor: const Color(0xFF9A5A1B),
          selectionColor: const Color(0xFF9A5A1B).withValues(alpha: 0.18),
          iconSpacing: 12,
        ),
      }),
    PhoneFieldShellPreset.travel => RenderOverrides({
        RTextFieldOverrides: RTextFieldOverrides.tokens(
          containerPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF173B63),
                fontWeight: FontWeight.w600,
                height: 1.05,
              ),
          cursorColor: const Color(0xFF2E78C7),
          selectionColor: const Color(0xFF2E78C7).withValues(alpha: 0.18),
          containerBackgroundColor: Colors.white.withValues(alpha: 0.74),
          containerBorderRadius: BorderRadius.circular(24),
          containerBorderColor: const Color(0xFFC6DAEF),
          iconSpacing: 5,
        ),
      }),
    PhoneFieldShellPreset.console => RenderOverrides({
        RTextFieldOverrides: RTextFieldOverrides.tokens(
          containerPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
          textColor: const Color(0xFFEAF7DF),
          placeholderColor: const Color(0xFF8CA08E),
          cursorColor: const Color(0xFF9BE66E),
          selectionColor: const Color(0xFF9BE66E).withValues(alpha: 0.24),
          containerBackgroundColor: const Color(0xFF151B16),
          containerBorderColor: const Color(0xFF4D6857),
          containerBorderRadius: BorderRadius.circular(18),
          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFFEAF7DF),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.35,
            height: 1.04,
            fontFamilyFallback: const [
              'SF Mono',
              'Roboto Mono',
              'monospace',
            ],
          ),
          iconSpacing: 5,
        ),
      }),
  };
}
