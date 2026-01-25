import 'package:flutter/material.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'autocomplete_rich_content.dart';
import 'autocomplete_test_helpers.dart';

class AutocompleteRichItemRow extends StatelessWidget {
  const AutocompleteRichItemRow({
    required this.item,
    required this.index,
    required this.isSelected,
    super.key,
  });

  final HeadlessListItemModel item;
  final int index;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium;
    final subtitleStyle = theme.textTheme.bodySmall;
    final trailingStyle = theme.textTheme.labelSmall;
    final indicatorColor = theme.colorScheme.primary;

    return Row(
      key: AutocompleteTestKeys.richItem(index),
      children: [
        AutocompleteRichContent(content: item.leading, style: textStyle),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutocompleteRichContent(
                content: item.title,
                style: textStyle,
              ),
              AutocompleteRichContent(
                content: item.subtitle,
                style: subtitleStyle,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        AutocompleteRichContent(
          content: item.trailing,
          style: trailingStyle,
        ),
        if (isSelected) ...[
          const SizedBox(width: 8),
          Icon(Icons.check, size: 16, color: indicatorColor),
        ],
      ],
    );
  }
}
