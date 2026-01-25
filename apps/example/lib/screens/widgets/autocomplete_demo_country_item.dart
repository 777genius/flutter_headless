import 'package:flutter/material.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'autocomplete_demo_content.dart';

class AutocompleteDemoCountryItem extends StatelessWidget {
  const AutocompleteDemoCountryItem({
    required this.item,
    required this.isSelected,
    super.key,
  });

  final HeadlessListItemModel item;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final titleStyle = theme.textTheme.bodyMedium;
    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: colors.onSurfaceVariant,
    );
    final trailingStyle = theme.textTheme.labelSmall?.copyWith(
      color: colors.onSurfaceVariant,
    );
    final indicatorColor = colors.primary;

    return Row(
      children: [
        AutocompleteDemoContent(
          content: item.leading,
          style: titleStyle,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutocompleteDemoContent(
                content: item.title,
                style: titleStyle,
              ),
              if (item.subtitle != null)
                AutocompleteDemoContent(
                  content: item.subtitle,
                  style: subtitleStyle,
                ),
            ],
          ),
        ),
        if (item.trailing != null) ...[
          const SizedBox(width: 12),
          AutocompleteDemoContent(
            content: item.trailing,
            style: trailingStyle,
          ),
        ],
        if (isSelected) ...[
          const SizedBox(width: 12),
          Icon(
            Icons.check,
            size: 18,
            color: indicatorColor,
          ),
        ],
      ],
    );
  }
}
