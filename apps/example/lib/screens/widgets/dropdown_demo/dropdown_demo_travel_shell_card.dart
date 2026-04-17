import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'dropdown_demo_content.dart';
import 'dropdown_demo_data.dart';
import 'dropdown_demo_shell_card.dart';
import 'dropdown_demo_option.dart';

class DropdownDemoTravelShellCard extends StatefulWidget {
  const DropdownDemoTravelShellCard({super.key});

  @override
  State<DropdownDemoTravelShellCard> createState() =>
      _DropdownDemoTravelShellCardState();
}

class _DropdownDemoTravelShellCardState
    extends State<DropdownDemoTravelShellCard> {
  DropdownDemoOption _selected = dropdownDemoTravelOptions[1];

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1976D2),
      brightness: Brightness.light,
    );

    return DropdownDemoShellCard(
      title: 'Travel Desk',
      caption: 'Anchor slot plus richer route rows.',
      kicker: 'Anchor slot',
      modeLabel: 'Menu surface',
      colorScheme: scheme,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF4FBFF), Color(0xFFEAF5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFC7DCF3)),
      ),
      childBuilder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Airport pickup',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 14),
          RDropdownButton<DropdownDemoOption>(
            value: _selected,
            onChanged: (value) => setState(() => _selected = value),
            items: dropdownDemoTravelOptions,
            itemAdapter: dropdownDemoOptionAdapter,
            semanticLabel: 'Travel desk dropdown',
            slots: RDropdownButtonSlots(
              anchor: Replace((ctx) {
                return _DropdownDemoTravelAnchor(
                  item: ctx.selectedItem,
                  isOpen: ctx.state.isOpen,
                );
              }),
              menuSurface: Decorate((ctx, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFFFFF), Color(0xFFF3F9FF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFD4E3F2)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A4C7DB0),
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
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: ctx.isHighlighted
                          ? const Color(0xFFDDEEFF)
                          : ctx.isSelected
                              ? const Color(0xFFE9F4FF)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: child,
                  ),
                );
              }),
              itemContent: Replace((ctx) {
                return _DropdownDemoTravelItem(item: ctx.item);
              }),
            ),
            overrides: RenderOverrides.only(
              RDropdownOverrides.tokens(
                triggerBackgroundColor: Colors.transparent,
                triggerBorderColor: Colors.transparent,
                triggerPadding: EdgeInsets.zero,
                triggerMinSize: const Size(0, 72),
                menuBackgroundColor: Colors.white,
                menuBorderColor: const Color(0xFFD4E3F2),
                menuBorderRadius: BorderRadius.circular(24),
                menuElevation: 8,
                itemPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                itemMinHeight: 72,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownDemoTravelAnchor extends StatelessWidget {
  const _DropdownDemoTravelAnchor({
    required this.item,
    required this.isOpen,
  });

  final HeadlessListItemModel? item;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFC5D9EF), width: 1.4),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F1FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: DropdownDemoContent(
              content: item?.leading,
              style: const TextStyle(fontSize: 24),
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
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownDemoContent(
                  content: item?.subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF5C6D83),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F4FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownDemoContent(
                  content: item?.trailing,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF175CA8),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF175CA8),
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

class _DropdownDemoTravelItem extends StatelessWidget {
  const _DropdownDemoTravelItem({required this.item});

  final HeadlessListItemModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFE6F1FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownDemoContent(
            content: item.leading,
            style: const TextStyle(fontSize: 22),
          ),
        ),
        const SizedBox(width: 14),
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
                  color: const Color(0xFF5C6D83),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        DropdownDemoContent(
          content: item.trailing,
          style: theme.textTheme.labelLarge?.copyWith(
            color: const Color(0xFF175CA8),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
