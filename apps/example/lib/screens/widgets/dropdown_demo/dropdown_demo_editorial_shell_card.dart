import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'dropdown_demo_content.dart';
import 'dropdown_demo_data.dart';
import 'dropdown_demo_option.dart';
import 'dropdown_demo_shell_card.dart';

class DropdownDemoEditorialShellCard extends StatefulWidget {
  const DropdownDemoEditorialShellCard({super.key});

  @override
  State<DropdownDemoEditorialShellCard> createState() =>
      _DropdownDemoEditorialShellCardState();
}

class _DropdownDemoEditorialShellCardState
    extends State<DropdownDemoEditorialShellCard> {
  DropdownDemoOption _selected = dropdownDemoEditorialOptions[0];

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFA05A0A),
      brightness: Brightness.light,
    );

    return DropdownDemoShellCard(
      title: 'Editorial Minimal',
      caption: 'Selected value compressed into a sparse underlined shell.',
      kicker: 'Selected shell',
      modeLabel: 'Thin chrome',
      colorScheme: scheme,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF4),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE6D3B6)),
      ),
      childBuilder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Print routing',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          RDropdownButton<DropdownDemoOption>(
            value: _selected,
            onChanged: (value) => setState(() => _selected = value),
            items: dropdownDemoEditorialOptions,
            itemAdapter: dropdownDemoOptionAdapter,
            semanticLabel: 'Editorial minimal dropdown',
            slots: RDropdownButtonSlots(
              anchor: Replace((ctx) {
                return _DropdownDemoEditorialAnchor(
                  item: ctx.selectedItem,
                  isOpen: ctx.state.isOpen,
                );
              }),
              menuSurface: Decorate((ctx, child) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFCF8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE1C49E)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: child,
                );
              }),
              item: Decorate((ctx, child) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: ctx.isHighlighted
                            ? const Color(0xFFC38B49)
                            : const Color(0x00000000),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: child,
                );
              }),
              itemContent: Replace((ctx) {
                return _DropdownDemoEditorialItem(item: ctx.item);
              }),
            ),
            overrides: RenderOverrides.only(
              RDropdownOverrides.tokens(
                triggerBackgroundColor: Colors.transparent,
                triggerBorderColor: Colors.transparent,
                triggerPadding: EdgeInsets.zero,
                triggerMinSize: const Size(0, 58),
                menuBackgroundColor: const Color(0xFFFFFCF8),
                menuBorderColor: const Color(0xFFE1C49E),
                menuBorderRadius: BorderRadius.circular(20),
                menuElevation: 3,
                itemPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                itemMinHeight: 64,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownDemoEditorialAnchor extends StatelessWidget {
  const _DropdownDemoEditorialAnchor({
    required this.item,
    required this.isOpen,
  });

  final HeadlessListItemModel? item;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFC38B49), width: 2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item?.primaryText ?? '',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownDemoContent(
                content: item?.trailing,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFA05A0A),
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
                  color: Color(0xFFA05A0A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DropdownDemoEditorialItem extends StatelessWidget {
  const _DropdownDemoEditorialItem({required this.item});

  final HeadlessListItemModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            item.primaryText,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        DropdownDemoContent(
          content: item.trailing,
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color(0xFFA05A0A),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}
