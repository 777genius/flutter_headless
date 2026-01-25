import 'package:flutter/material.dart';

import '../widgets/theme_mode_switch.dart';
import 'widgets/autocomplete_demo_basic_section.dart';
import 'widgets/autocomplete_demo_multiselect_section.dart';
import 'widgets/autocomplete_demo_rich_section.dart';

class AutocompleteDemoScreen extends StatelessWidget {
  const AutocompleteDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autocomplete Demo'),
        actions: const [
          ThemeModeSwitch(),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          AutocompleteDemoBasicSection(),
          SizedBox(height: 24),
          AutocompleteDemoRichSection(),
          SizedBox(height: 24),
          AutocompleteDemoMultiSelectSection(),
        ],
      ),
    );
  }
}
