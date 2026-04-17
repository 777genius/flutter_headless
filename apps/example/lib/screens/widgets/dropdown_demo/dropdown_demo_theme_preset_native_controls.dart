import 'package:flutter/material.dart';
import 'package:headless_foundation/headless_foundation.dart';

import 'dropdown_demo_cupertino_parity_surface.dart';
import 'dropdown_demo_data.dart';
import 'dropdown_demo_option.dart';

class DropdownDemoNativeMaterialCityField extends StatelessWidget {
  const DropdownDemoNativeMaterialCityField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: const Key('dropdown-theme-pure-native'),
      initialValue: value,
      isExpanded: true,
      onChanged: (next) {
        if (next != null) onChanged(next);
      },
      items: [
        for (final city in dropdownDemoCityCodes.keys)
          DropdownMenuItem<String>(
            value: city,
            child: Text(city),
          ),
      ],
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(),
      ),
    );
  }
}

class DropdownDemoNativeMaterialTravelField extends StatelessWidget {
  const DropdownDemoNativeMaterialTravelField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final DropdownDemoOption value;
  final ValueChanged<DropdownDemoOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<DropdownDemoOption>(
      key: const Key('dropdown-theme-rich-native'),
      initialValue: value,
      isExpanded: true,
      onChanged: (next) {
        if (next != null) onChanged(next);
      },
      selectedItemBuilder: (context) {
        return [
          for (final option in dropdownDemoTravelOptions)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(option.title, overflow: TextOverflow.ellipsis),
            ),
        ];
      },
      items: [
        for (final option in dropdownDemoTravelOptions)
          DropdownMenuItem<DropdownDemoOption>(
            value: option,
            child: Row(
              children: [
                switch (option.leading) {
                  HeadlessEmojiContent(:final emoji) => Text(emoji),
                  HeadlessTextContent(:final text) => Text(text),
                  HeadlessIconContent(:final icon) => Icon(icon, size: 18),
                  null => const SizedBox.shrink(),
                },
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    option.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  option.shortLabel,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
      ],
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(),
      ),
    );
  }
}

class DropdownDemoNativeCupertinoButton extends StatelessWidget {
  const DropdownDemoNativeCupertinoButton({
    required this.controlKey,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final Key controlKey;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DropdownDemoCupertinoNativeTrigger(
      controlKey: controlKey,
      label: label,
      onPressed: onPressed,
    );
  }
}
