import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'dropdown_demo_content.dart';
import 'dropdown_demo_data.dart';
import 'dropdown_demo_option.dart';
import 'dropdown_demo_shell_card.dart';

class DropdownDemoTeamShellCard extends StatefulWidget {
  const DropdownDemoTeamShellCard({super.key});

  @override
  State<DropdownDemoTeamShellCard> createState() =>
      _DropdownDemoTeamShellCardState();
}

class _DropdownDemoTeamShellCardState extends State<DropdownDemoTeamShellCard> {
  DropdownDemoOption _selected = dropdownDemoTeamOptions[2];

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7C5CFF),
      brightness: Brightness.light,
    );

    return DropdownDemoShellCard(
      title: 'Team Filter',
      caption: 'Same dropdown behavior turned into a compact filter chip.',
      kicker: 'Compact trigger',
      modeLabel: 'Badge menu',
      colorScheme: scheme,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF9F5FF), Color(0xFFF4EEFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFDCCCF9)),
      ),
      childBuilder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assignee lane',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: RDropdownButton<DropdownDemoOption>(
              value: _selected,
              onChanged: (value) => setState(() => _selected = value),
              items: dropdownDemoTeamOptions,
              itemAdapter: dropdownDemoOptionAdapter,
              semanticLabel: 'Team filter dropdown',
              slots: RDropdownButtonSlots(
                anchor: Replace((ctx) {
                  return _DropdownDemoTeamAnchor(
                    item: ctx.selectedItem,
                    isOpen: ctx.state.isOpen,
                  );
                }),
                menuSurface: Decorate((ctx, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDFF),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFE2D8F6)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x147C5CFF),
                          blurRadius: 24,
                          offset: Offset(0, 14),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: child,
                  );
                }),
                item: Decorate((ctx, child) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: ctx.isSelected
                            ? const Color(0xFFF0E8FF)
                            : ctx.isHighlighted
                                ? const Color(0xFFF7F2FF)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: child,
                    ),
                  );
                }),
                itemContent: Replace((ctx) {
                  return _DropdownDemoTeamItem(item: ctx.item);
                }),
              ),
              overrides: RenderOverrides.only(
                RDropdownOverrides.tokens(
                  triggerBackgroundColor: Colors.transparent,
                  triggerBorderColor: Colors.transparent,
                  triggerPadding: EdgeInsets.zero,
                  triggerMinSize: const Size(240, 58),
                  menuBackgroundColor: const Color(0xFFFFFDFF),
                  menuBorderColor: const Color(0xFFE2D8F6),
                  menuBorderRadius: BorderRadius.circular(22),
                  menuElevation: 8,
                  itemPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  itemMinHeight: 58,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownDemoTeamAnchor extends StatelessWidget {
  const _DropdownDemoTeamAnchor({
    required this.item,
    required this.isOpen,
  });

  final HeadlessListItemModel? item;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFDCCCF9), width: 1.4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF0E8FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: DropdownDemoContent(
              content: item?.leading,
              style: const TextStyle(fontSize: 18),
              iconColor: const Color(0xFF7C5CFF),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Team',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF7B689C),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item?.primaryText ?? '',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0E8FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownDemoContent(
                  content: item?.trailing,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF7C5CFF),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF7C5CFF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownDemoTeamItem extends StatelessWidget {
  const _DropdownDemoTeamItem({required this.item});

  final HeadlessListItemModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        DropdownDemoContent(
          content: item.leading,
          style: const TextStyle(fontSize: 18),
          iconColor: const Color(0xFF7C5CFF),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.primaryText,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              DropdownDemoContent(
                content: item.subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF7B689C),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        DropdownDemoContent(
          content: item.trailing,
          style: theme.textTheme.labelLarge?.copyWith(
            color: const Color(0xFF7C5CFF),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
