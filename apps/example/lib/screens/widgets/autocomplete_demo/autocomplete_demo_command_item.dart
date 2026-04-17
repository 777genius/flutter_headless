import 'package:flutter/material.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'autocomplete_demo_content.dart';

class AutocompleteDemoCommandItem extends StatelessWidget {
  const AutocompleteDemoCommandItem({
    required this.item,
    required this.colorScheme,
    super.key,
  });

  final HeadlessListItemModel item;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: AutocompleteDemoContent(
            content: item.leading,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            item.primaryText,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: AutocompleteDemoContent(
            content: item.subtitle,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
