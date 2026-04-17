import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'dropdown_demo_content.dart';
import 'dropdown_demo_data.dart';
import 'dropdown_demo_option.dart';
import 'dropdown_demo_shell_card.dart';

class DropdownDemoCommandShellCard extends StatefulWidget {
  const DropdownDemoCommandShellCard({super.key});

  @override
  State<DropdownDemoCommandShellCard> createState() =>
      _DropdownDemoCommandShellCardState();
}

class _DropdownDemoCommandShellCardState
    extends State<DropdownDemoCommandShellCard> {
  DropdownDemoOption _selected = dropdownDemoCommandOptions[0];

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF74F08A),
      brightness: Brightness.dark,
    );

    return DropdownDemoShellCard(
      title: 'Command Palette',
      caption: 'Dense operational shell with badge-heavy rows.',
      kicker: 'Item slots',
      modeLabel: 'Dark shell',
      colorScheme: scheme,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1713),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF2D4635)),
      ),
      childBuilder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Runtime target',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 14),
          RDropdownButton<DropdownDemoOption>(
            value: _selected,
            onChanged: (value) => setState(() => _selected = value),
            items: dropdownDemoCommandOptions,
            itemAdapter: dropdownDemoOptionAdapter,
            semanticLabel: 'Command palette dropdown',
            slots: RDropdownButtonSlots(
              anchor: Replace((ctx) {
                return _DropdownDemoCommandAnchor(
                  item: ctx.selectedItem,
                  isOpen: ctx.state.isOpen,
                );
              }),
              menuSurface: Decorate((ctx, child) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF111C16),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFF2D4635)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 32,
                        offset: Offset(0, 18),
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
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: ctx.isHighlighted
                          ? const Color(0x1F74F08A)
                          : ctx.isSelected
                              ? const Color(0x1638C874)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: ctx.isHighlighted
                            ? const Color(0x3374F08A)
                            : Colors.transparent,
                      ),
                    ),
                    child: child,
                  ),
                );
              }),
              itemContent: Replace((ctx) {
                return _DropdownDemoCommandItem(item: ctx.item);
              }),
            ),
            overrides: RenderOverrides.only(
              RDropdownOverrides.tokens(
                triggerBackgroundColor: Colors.transparent,
                triggerBorderColor: Colors.transparent,
                triggerPadding: EdgeInsets.zero,
                triggerMinSize: const Size(0, 58),
                menuBackgroundColor: const Color(0xFF111C16),
                menuBorderColor: const Color(0xFF2D4635),
                menuBorderRadius: BorderRadius.circular(22),
                menuElevation: 10,
                itemPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                itemMinHeight: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownDemoCommandAnchor extends StatelessWidget {
  const _DropdownDemoCommandAnchor({
    required this.item,
    required this.isOpen,
  });

  final HeadlessListItemModel? item;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF111C16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2D4635), width: 1.3),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0x1F74F08A),
              borderRadius: BorderRadius.circular(14),
            ),
            child: DropdownDemoContent(
              content: item?.leading,
              style: const TextStyle(fontSize: 19),
              iconColor: const Color(0xFF74F08A),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item?.primaryText ?? '',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFE7F8E4),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownDemoContent(
                  content: item?.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF85A38E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0x1F74F08A),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownDemoContent(
                  content: item?.trailing,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF74F08A),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF74F08A),
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

class _DropdownDemoCommandItem extends StatelessWidget {
  const _DropdownDemoCommandItem({required this.item});

  final HeadlessListItemModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        DropdownDemoContent(
          content: item.leading,
          style: const TextStyle(fontSize: 18),
          iconColor: const Color(0xFF74F08A),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.primaryText,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: const Color(0xFFE7F8E4),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              DropdownDemoContent(
                content: item.subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF85A38E),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0x1638C874),
            borderRadius: BorderRadius.circular(999),
          ),
          child: DropdownDemoContent(
            content: item.trailing,
            style: theme.textTheme.labelMedium?.copyWith(
              color: const Color(0xFF74F08A),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
