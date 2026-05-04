import 'package:flutter/material.dart';
import 'package:headless_phone_field/headless_phone_field.dart';

final class PhoneCountryShowcaseAnchor extends StatelessWidget {
  const PhoneCountryShowcaseAnchor({
    required this.request,
    required this.isOpen,
    required this.placement,
    super.key,
  });

  final RPhoneFieldCountryButtonRequest request;
  final bool isOpen;
  final RPhoneFieldCountryButtonPlacement placement;

  @override
  Widget build(BuildContext context) {
    return switch (placement) {
      RPhoneFieldCountryButtonPlacement.leading ||
      RPhoneFieldCountryButtonPlacement.trailing =>
        _PhoneCountrySurfaceAnchor(request: request, isOpen: isOpen),
      RPhoneFieldCountryButtonPlacement.prefix =>
        _PhoneCountryInlineAccentAnchor(
          request: request,
          isOpen: isOpen,
          dividerSide: _PhoneCountryDividerSide.end,
        ),
      RPhoneFieldCountryButtonPlacement.suffix =>
        _PhoneCountryInlineAccentAnchor(
          request: request,
          isOpen: isOpen,
          dividerSide: _PhoneCountryDividerSide.start,
        ),
    };
  }
}

enum _PhoneCountryDividerSide { start, end }

final class _PhoneCountrySurfaceAnchor extends StatelessWidget {
  const _PhoneCountrySurfaceAnchor({
    required this.request,
    required this.isOpen,
  });

  final RPhoneFieldCountryButtonRequest request;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.secondaryContainer.withValues(alpha: 0.8),
            scheme.tertiaryContainer.withValues(alpha: 0.65),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.65),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              request.country.flagEmoji,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 8),
            Text(
              request.country.formattedDialCode,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: scheme.onSecondaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(width: 6),
            AnimatedRotation(
              turns: isOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 180),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: scheme.onSecondaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _PhoneCountryInlineAccentAnchor extends StatelessWidget {
  const _PhoneCountryInlineAccentAnchor({
    required this.request,
    required this.isOpen,
    required this.dividerSide,
  });

  final RPhoneFieldCountryButtonRequest request;
  final bool isOpen;
  final _PhoneCountryDividerSide dividerSide;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final flagStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          height: 1,
        );
    final dialCodeStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
          height: 1,
        );
    final chevron = AnimatedRotation(
      turns: isOpen ? 0.5 : 0,
      duration: const Duration(milliseconds: 180),
      child: Icon(
        Icons.arrow_drop_down_rounded,
        size: 18,
        color: scheme.onSurfaceVariant,
      ),
    );

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        child: SizedBox(
          height: 34,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 12, end: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (dividerSide == _PhoneCountryDividerSide.start) ...[
                  _PhoneCountryInlineDivider(color: scheme.outlineVariant),
                  const SizedBox(width: 8),
                ],
                Text(
                  request.country.flagEmoji,
                  style: flagStyle,
                ),
                const SizedBox(width: 8),
                Text(
                  request.country.formattedDialCode,
                  style: dialCodeStyle,
                ),
                const SizedBox(width: 2),
                chevron,
                if (dividerSide == _PhoneCountryDividerSide.end) ...[
                  const SizedBox(width: 8),
                  _PhoneCountryInlineDivider(color: scheme.outlineVariant),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _PhoneCountryInlineDivider extends StatelessWidget {
  const _PhoneCountryInlineDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 18,
      color: color.withValues(alpha: 0.7),
    );
  }
}
