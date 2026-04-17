import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'dropdown_demo_data.dart';
import 'dropdown_demo_sdk_visuals.dart';
import '../material_demo_parity_card.dart';

class DropdownDemoUnderlineParityCard extends StatefulWidget {
  const DropdownDemoUnderlineParityCard({super.key});

  @override
  State<DropdownDemoUnderlineParityCard> createState() =>
      _DropdownDemoUnderlineParityCardState();
}

class _DropdownDemoUnderlineParityCardState
    extends State<DropdownDemoUnderlineParityCard> {
  final GlobalKey _triggerVisualKey = GlobalKey();
  String _selected = dropdownDemoFruitValues.first;

  @override
  Widget build(BuildContext context) {
    return MaterialDemoParityCard(
      title: 'SDK Sample 01',
      caption: 'Flutter sample underline, matched by a headless trigger shell.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MaterialDemoParityLabel('Flutter SDK'),
          const SizedBox(height: 12),
          DropdownDemoUnderlineVisual(
            dropdownKey: const Key('dropdown-sdk-underline-visual'),
            value: _selected,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selected = value);
            },
          ),
          const SizedBox(height: 18),
          const MaterialDemoParityLabel('Headless Parity'),
          const SizedBox(height: 12),
          RDropdownButton<String>(
            value: _selected,
            onChanged: (value) => setState(() => _selected = value),
            items: dropdownDemoFruitValues,
            itemAdapter: dropdownDemoFruitAdapter,
            semanticLabel: 'Headless parity underline dropdown',
            slots: RDropdownButtonSlots(
              anchor: Replace((ctx) {
                return DropdownDemoUnderlineVisual(
                  key: _triggerVisualKey,
                  dropdownKey: const Key('dropdown-headless-underline-button'),
                  value: _selected,
                  onChanged: (_) {},
                  ignorePointer: true,
                );
              }),
              menuSurface: Decorate((ctx, child) {
                return KeyedSubtree(
                  key: const Key('dropdown-headless-underline-menu-surface'),
                  child: DropdownDemoFlutterMenuSurface(
                    triggerKey: _triggerVisualKey,
                    child: child,
                  ),
                );
              }),
              itemContent: Replace((ctx) {
                return Text(
                  ctx.item.primaryText,
                  style: const TextStyle(color: Colors.deepPurple),
                );
              }),
            ),
            overrides: RenderOverrides.only(
              RDropdownOverrides.tokens(
                triggerBackgroundColor: Colors.transparent,
                triggerBorderColor: Colors.transparent,
                triggerPadding: EdgeInsets.zero,
                triggerMinSize: const Size(44, 44),
                menuBackgroundColor: Colors.white,
                menuBorderColor: const Color(0x1F673AB7),
                menuBorderRadius: BorderRadius.circular(4),
                menuElevation: 8,
                itemPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
