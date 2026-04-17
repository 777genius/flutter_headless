import 'package:flutter/material.dart';

import '../widgets/theme_mode_switch.dart';
import 'widgets/autocomplete_demo/autocomplete_demo_parity_section.dart';
import 'widgets/autocomplete_demo/autocomplete_demo_showcase_section.dart';
import 'widgets/autocomplete_demo/autocomplete_demo_theme_presets_section.dart';

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
          AutocompleteDemoThemePresetsSection(),
          SizedBox(height: 24),
          AutocompleteDemoParitySection(),
          SizedBox(height: 24),
          AutocompleteDemoShowcaseSection(),
        ],
      ),
    );
  }
}
