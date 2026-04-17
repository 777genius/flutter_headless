import 'package:flutter/material.dart';
import 'package:headless_phone_field/headless_phone_field.dart';

final class PhoneCountryInlineAnchor extends StatelessWidget {
  const PhoneCountryInlineAnchor({
    required this.request,
    required this.isOpen,
    this.showDivider = true,
    this.chipMinWidth = 0,
    this.chipMinHeight = 32,
    this.chipPadding = const EdgeInsetsDirectional.only(
      start: 12,
      end: 10,
      top: 6,
      bottom: 6,
    ),
    this.dividerGap = 8,
    this.outerPadding = const EdgeInsetsDirectional.only(start: 4, end: 0),
    this.flagGap = 6,
    this.dialCodeGap = 2,
    this.arrowSize = 18,
    super.key,
  });

  final RPhoneFieldCountryButtonRequest request;
  final bool isOpen;
  final bool showDivider;
  final double chipMinWidth;
  final double chipMinHeight;
  final EdgeInsetsGeometry chipPadding;
  final double dividerGap;
  final EdgeInsetsGeometry outerPadding;
  final double flagGap;
  final double dialCodeGap;
  final double arrowSize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final flagStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          height: 1,
        );
    final dialCodeStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1,
        );

    return Padding(
      padding: outerPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(18),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: chipMinWidth,
                minHeight: chipMinHeight,
              ),
              child: Padding(
                padding: chipPadding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(request.country.flagEmoji, style: flagStyle),
                    SizedBox(width: flagGap),
                    Text(
                      request.country.formattedDialCode,
                      style: dialCodeStyle,
                    ),
                    SizedBox(width: dialCodeGap),
                    AnimatedRotation(
                      turns: isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: Icon(
                        Icons.arrow_drop_down_rounded,
                        size: arrowSize,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (showDivider) ...[
            SizedBox(width: dividerGap),
            Container(
              width: 1,
              height: 24,
              color: scheme.outlineVariant.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 0),
          ],
        ],
      ),
    );
  }
}
