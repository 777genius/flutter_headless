import 'package:flutter/material.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'autocomplete_demo_content.dart';

class AutocompleteDemoTeamFilterItem extends StatelessWidget {
  const AutocompleteDemoTeamFilterItem({
    required this.item,
    required this.colorScheme,
    required this.isSelected,
    required this.isHighlighted,
    super.key,
  });

  final HeadlessListItemModel item;
  final ColorScheme colorScheme;
  final bool isSelected;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      key: ValueKey('autocomplete-team-item-${item.id.value}'),
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          _AutocompleteDemoTeamFilterIndicator(
            id: item.id.value,
            colorScheme: colorScheme,
            isSelected: isSelected,
          ),
          const SizedBox(width: 12),
          _AutocompleteDemoTeamFilterFlag(
            content: item.leading,
            backgroundColor: _flagBackgroundColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.primaryText,
              style: theme.textTheme.titleMedium?.copyWith(
                color: const Color(0xFF241F30),
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _pillBackgroundColor,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: _pillBorderColor),
            ),
            child: AutocompleteDemoContent(
              content: item.subtitle,
              style: theme.textTheme.labelLarge?.copyWith(
                color: const Color(0xFF5C498D),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color get _surfaceColor {
    if (isSelected) return const Color(0xFFF0E8FF);
    if (isHighlighted) return const Color(0xFFF7F2FF);
    return const Color(0xFFFFFDFF);
  }

  Color get _borderColor {
    if (isSelected) return const Color(0xFFD5C3FF);
    if (isHighlighted) return const Color(0xFFE4D7FA);
    return const Color(0xFFECE3FA);
  }

  Color get _flagBackgroundColor =>
      isSelected ? const Color(0xFFFFFFFF) : const Color(0xFFF7F2FF);

  Color get _pillBackgroundColor =>
      isSelected ? const Color(0xFFFFFFFF) : const Color(0xFFF8F4FF);

  Color get _pillBorderColor =>
      isSelected ? const Color(0xFFD8C6FF) : const Color(0xFFE7DDF8);
}

class _AutocompleteDemoTeamFilterIndicator extends StatelessWidget {
  const _AutocompleteDemoTeamFilterIndicator({
    required this.id,
    required this.colorScheme,
    required this.isSelected,
  });

  final String id;
  final ColorScheme colorScheme;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('autocomplete-team-indicator-$id'),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? colorScheme.primary : const Color(0xFF6F6688),
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check_rounded, size: 18, color: colorScheme.onPrimary)
          : null,
    );
  }
}

class _AutocompleteDemoTeamFilterFlag extends StatelessWidget {
  const _AutocompleteDemoTeamFilterFlag({
    required this.content,
    required this.backgroundColor,
  });

  final HeadlessContent? content;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: AutocompleteDemoContent(
        content: content,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
      ),
    );
  }
}
