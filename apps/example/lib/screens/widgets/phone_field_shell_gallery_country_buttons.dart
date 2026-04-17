import 'package:flutter/material.dart';
import 'package:headless_phone_field/headless_phone_field.dart';

import 'phone_country_menu_button.dart';
import 'phone_field_shell_gallery_support.dart';

Widget buildPhoneFieldShellCountryButton(
  BuildContext context,
  RPhoneFieldCountryButtonRequest request,
  PhoneFieldShellPreset preset,
) {
  return PhoneCountryMenuButton(
    request: request,
    padding: switch (preset) {
      PhoneFieldShellPreset.soft ||
      PhoneFieldShellPreset.minimal =>
        const EdgeInsets.symmetric(vertical: 2),
      _ => EdgeInsets.zero,
    },
    constraints: switch (preset) {
      PhoneFieldShellPreset.soft => const BoxConstraints(
          minWidth: 104,
          minHeight: 36,
        ),
      PhoneFieldShellPreset.travel => const BoxConstraints(
          minWidth: 108,
          minHeight: 38,
        ),
      PhoneFieldShellPreset.console => const BoxConstraints(
          minWidth: 116,
          minHeight: 38,
        ),
      _ => const BoxConstraints(
          minWidth: 44,
          minHeight: 32,
        ),
    },
    anchorBuilder: (context, request, isOpen) => switch (preset) {
      PhoneFieldShellPreset.soft => _SoftCountryAnchor(request: request),
      PhoneFieldShellPreset.minimal => _MinimalCountryAnchor(request: request),
      PhoneFieldShellPreset.travel => _TravelCountryAnchor(request: request),
      PhoneFieldShellPreset.console => _ConsoleCountryAnchor(request: request),
    },
  );
}

final class _SoftCountryAnchor extends StatelessWidget {
  const _SoftCountryAnchor({required this.request});

  final RPhoneFieldCountryButtonRequest request;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(request.country.flagEmoji),
            const SizedBox(width: 3),
            Text(
              request.country.formattedDialCode,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
            ),
            const SizedBox(width: 1),
            const Icon(Icons.arrow_drop_down_rounded, size: 15),
          ],
        ),
      ),
    );
  }
}

final class _MinimalCountryAnchor extends StatelessWidget {
  const _MinimalCountryAnchor({required this.request});

  final RPhoneFieldCountryButtonRequest request;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${request.country.isoCode.name} ',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: const Color(0xFF9A5A1B),
                  height: 1,
                ),
          ),
          TextSpan(
            text: request.country.formattedDialCode,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
          ),
          const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 2),
              child: Icon(Icons.expand_more_rounded, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

final class _ConsoleCountryAnchor extends StatelessWidget {
  const _ConsoleCountryAnchor({required this.request});

  final RPhoneFieldCountryButtonRequest request;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF243027),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF4D6857)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF9BE66E),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              request.country.flagEmoji,
              style: const TextStyle(height: 1),
            ),
            const SizedBox(width: 5),
            Text(
              request.country.formattedDialCode,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color(0xFFEAF7DF),
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                height: 1,
                fontFamilyFallback: const [
                  'SF Mono',
                  'Roboto Mono',
                  'monospace',
                ],
              ),
            ),
            const SizedBox(width: 1),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: Color(0xFF9BE66E),
            ),
          ],
        ),
      ),
    );
  }
}

final class _TravelCountryAnchor extends StatelessWidget {
  const _TravelCountryAnchor({required this.request});

  final RPhoneFieldCountryButtonRequest request;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFC6DAEF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                color: Color(0xFFE7F4FF),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  request.country.flagEmoji,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              request.country.formattedDialCode,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF173B63),
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
            ),
            const SizedBox(width: 1),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: Color(0xFF2E78C7),
            ),
          ],
        ),
      ),
    );
  }
}
