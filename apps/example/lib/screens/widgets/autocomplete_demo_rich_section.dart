import 'package:flutter/material.dart';
import 'autocomplete_demo_country.dart';
import 'demo_section.dart';
import 'autocomplete_demo_rich_field.dart';

class AutocompleteDemoRichSection extends StatefulWidget {
  const AutocompleteDemoRichSection({super.key});

  @override
  State<AutocompleteDemoRichSection> createState() =>
      _AutocompleteDemoRichSectionState();
}

class _AutocompleteDemoRichSectionState
    extends State<AutocompleteDemoRichSection> {
  AutocompleteDemoCountry? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.colorScheme.onSurfaceVariant;
    final selectedLabel = _selected == null
        ? 'none'
        : '${_selected!.name} (${_selected!.dialCode})';

    return DemoSection(
      title: 'D2 - Rich Items (Flags + Dial Codes)',
      description: 'Menu items use slots to render flag, name and dial code.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutocompleteDemoRichField(
            onSelected: (value) => setState(() => _selected = value),
          ),
          const SizedBox(height: 8),
          Text('Selected: $selectedLabel'),
          const SizedBox(height: 4),
          Text(
            'Demo uses HeadlessContent for leading/subtitle/trailing.',
            style: theme.textTheme.bodySmall?.copyWith(color: hintColor),
          ),
        ],
      ),
    );
  }
}
