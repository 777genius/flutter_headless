import 'package:flutter/material.dart';
import 'package:headless_phone_field/headless_phone_field.dart';
import 'phone_field_shell_gallery_country_buttons.dart';
import 'phone_field_shell_gallery_support.dart';
import 'showcase_pill.dart';

final class PhoneFieldShellGalleryCard extends StatelessWidget {
  const PhoneFieldShellGalleryCard({required this.preset, super.key});

  final PhoneFieldShellPreset preset;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: phoneFieldShellCardDecoration(context, preset),
      child: Padding(
        padding: phoneFieldShellCardPadding(preset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShellHeader(preset: preset),
            SizedBox(height: phoneFieldShellHeaderGap(preset)),
            _ShellSummary(preset: preset),
            SizedBox(height: phoneFieldShellFactsGap(preset)),
            _ShellFacts(preset: preset),
            SizedBox(height: phoneFieldShellFieldSectionGap(preset)),
            _ShellFieldSection(preset: preset),
          ],
        ),
      ),
    );
  }
}

final class _ShellSummary extends StatelessWidget {
  const _ShellSummary({required this.preset});

  final PhoneFieldShellPreset preset;

  @override
  Widget build(BuildContext context) {
    final bodyColor = phoneFieldShellBodyColor(context, preset);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          phoneFieldShellTitle(preset),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: phoneFieldShellTitleColor(context, preset),
                fontWeight: FontWeight.w900,
                height: 1.02,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          phoneFieldShellDescription(preset),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bodyColor,
                height: 1.3,
              ),
        ),
      ],
    );
  }
}

final class _ShellFieldSection extends StatelessWidget {
  const _ShellFieldSection({required this.preset});

  final PhoneFieldShellPreset preset;

  @override
  Widget build(BuildContext context) {
    final bodyColor = phoneFieldShellBodyColor(context, preset);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          phoneFieldShellFieldCaption(preset),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: bodyColor,
                fontWeight: FontWeight.w800,
              ),
        ),
        SizedBox(height: phoneFieldShellCaptionGap(preset)),
        SizedBox(
          key: ValueKey('phone-shell-field-${preset.name}'),
          width: double.infinity,
          child: RPhoneField(
            initialValue: phoneFieldShellInitialValue(preset),
            placeholder: 'Type or paste a number',
            countries: phoneFieldShellCountries(preset),
            favoriteCountries: phoneFieldShellFavoriteCountries(preset),
            countrySelectorNavigator: phoneFieldShellGalleryNavigator(preset),
            countrySelectorTitleStyle: phoneFieldShellMenuTitleStyle(
              context,
              preset,
            ),
            countrySelectorSubtitleStyle: phoneFieldShellMenuSubtitleStyle(
              context,
              preset,
            ),
            countrySelectorSearchBoxTextStyle:
                phoneFieldShellMenuSearchTextStyle(
              context,
              preset,
            ),
            countrySelectorSearchBoxIconColor:
                phoneFieldShellMenuSearchIconColor(preset),
            variant: phoneFieldShellVariant(preset),
            style: RPhoneFieldStyle(
              countryButtonPlacement: phoneFieldShellPlacement(preset),
            ),
            scrollPadding: EdgeInsets.zero,
            fieldOverrides: phoneFieldShellOverrides(context, preset),
            countryButtonBuilder: (context, request) =>
                buildPhoneFieldShellCountryButton(
              context,
              request,
              preset,
            ),
          ),
        ),
      ],
    );
  }
}

final class _ShellHeader extends StatelessWidget {
  const _ShellHeader({required this.preset});

  final PhoneFieldShellPreset preset;

  @override
  Widget build(BuildContext context) {
    return switch (preset) {
      PhoneFieldShellPreset.soft => const _SoftShellHeader(),
      PhoneFieldShellPreset.minimal => const _MinimalShellHeader(),
      PhoneFieldShellPreset.travel => const _TravelShellHeader(),
      PhoneFieldShellPreset.console => const _ConsoleShellHeader(),
    };
  }
}

final class _SoftShellHeader extends StatelessWidget {
  const _SoftShellHeader();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: const [
        ShowcasePill(icon: Icons.shopping_bag_rounded, label: 'Checkout shell'),
        _ShellTag(label: 'Sheet selector'),
      ],
    );
  }
}

final class _MinimalShellHeader extends StatelessWidget {
  const _MinimalShellHeader();

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
          letterSpacing: 1.3,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF9A5A1B),
        );

    return Row(
      children: [
        Text('ISSUE 07', style: labelStyle),
        const Spacer(),
        Text('Menu selector', style: labelStyle),
      ],
    );
  }
}

final class _TravelShellHeader extends StatelessWidget {
  const _TravelShellHeader();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: const [
        ShowcasePill(
          icon: Icons.flight_takeoff_rounded,
          label: 'Arrival desk',
        ),
        _ShellTag(label: 'Dialog selector'),
      ],
    );
  }
}

final class _ConsoleShellHeader extends StatelessWidget {
  const _ConsoleShellHeader();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: const [
        ShowcasePill(
          icon: Icons.memory_rounded,
          label: 'Incident ready',
          backgroundColor: Color(0xFF243027),
          foregroundColor: Color(0xFFEAF7DF),
        ),
        _ShellTag(
          label: 'Page selector',
          backgroundColor: Color(0xFF151B16),
          foregroundColor: Color(0xFF9BE66E),
          borderColor: Color(0xFF4D6857),
        ),
      ],
    );
  }
}

final class _ShellTag extends StatelessWidget {
  const _ShellTag({
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: backgroundColor ?? scheme.surface.withValues(alpha: 0.72),
        shape: StadiumBorder(
          side: BorderSide(
            color: borderColor ?? scheme.outlineVariant.withValues(alpha: 0.46),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: foregroundColor ?? scheme.onSurfaceVariant,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
        ),
      ),
    );
  }
}

final class _ShellFacts extends StatelessWidget {
  const _ShellFacts({required this.preset});

  final PhoneFieldShellPreset preset;

  @override
  Widget build(BuildContext context) {
    final accent = phoneFieldShellAccentColor(preset);
    final foreground = preset == PhoneFieldShellPreset.console
        ? const Color(0xFFEAF7DF)
        : accent;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ShowcasePill(
          icon: Icons.tune_rounded,
          label: phoneFieldShellFactPrimary(preset),
          backgroundColor: accent.withValues(alpha: 0.16),
          foregroundColor: foreground,
        ),
        ShowcasePill(
          icon: Icons.code_rounded,
          label: phoneFieldShellFactSecondary(preset),
          backgroundColor: accent.withValues(alpha: 0.12),
          foregroundColor: foreground,
        ),
      ],
    );
  }
}
