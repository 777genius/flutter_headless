import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'dropdown_demo_data.dart';
import 'dropdown_demo_sdk_visuals.dart';
import '../material_demo_parity_card.dart';

class DropdownDemoSelectedItemParityCard extends StatefulWidget {
  const DropdownDemoSelectedItemParityCard({super.key});

  @override
  State<DropdownDemoSelectedItemParityCard> createState() =>
      _DropdownDemoSelectedItemParityCardState();
}

class _DropdownDemoSelectedItemParityCardState
    extends State<DropdownDemoSelectedItemParityCard> {
  final GlobalKey _triggerVisualKey = GlobalKey();
  String _selected = dropdownDemoCityCodes.keys.first;

  @override
  Widget build(BuildContext context) {
    return MaterialDemoParityCard(
      title: 'selectedItemBuilder',
      caption:
          'The trigger can compress the chosen value while the menu stays rich.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MaterialDemoParityLabel('Flutter SDK'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Select a city:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(width: 8),
              DropdownDemoSelectedItemVisual(
                dropdownKey: const Key('dropdown-sdk-selected-item-visual'),
                value: _selected,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selected = value);
                },
              ),
            ],
          ),
          const SizedBox(height: 18),
          const MaterialDemoParityLabel('Headless Parity'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Select a city:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(width: 8),
              RDropdownButton<String>(
                value: _selected,
                onChanged: (value) => setState(() => _selected = value),
                items: dropdownDemoCityCodes.keys.toList(),
                itemAdapter: dropdownDemoCityAdapter,
                semanticLabel: 'Headless selected item builder dropdown',
                slots: RDropdownButtonSlots(
                  anchor: Replace((ctx) {
                    return DropdownDemoSelectedItemVisual(
                      key: _triggerVisualKey,
                      dropdownKey: const Key(
                        'dropdown-headless-selected-item-button',
                      ),
                      value: _selected,
                      onChanged: (_) {},
                      ignorePointer: true,
                    );
                  }),
                  menuSurface: Decorate((ctx, child) {
                    return DropdownDemoFlutterMenuSurface(
                      triggerKey: _triggerVisualKey,
                      child: child,
                    );
                  }),
                  itemContent: Replace((ctx) {
                    return Text(ctx.item.primaryText);
                  }),
                ),
                overrides: RenderOverrides.only(
                  RDropdownOverrides.tokens(
                    triggerBackgroundColor: Colors.transparent,
                    triggerBorderColor: Colors.transparent,
                    triggerPadding: EdgeInsets.zero,
                    triggerMinSize: const Size(44, 44),
                    menuBorderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
