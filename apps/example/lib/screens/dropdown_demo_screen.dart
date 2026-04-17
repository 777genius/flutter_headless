import 'package:flutter/material.dart';

import '../widgets/theme_mode_switch.dart';
import 'widgets/dropdown_demo/dropdown_demo_parity_section.dart';
import 'widgets/dropdown_demo/dropdown_demo_showcase_section.dart';
import 'widgets/dropdown_demo/dropdown_demo_theme_presets_section.dart';

class DropdownDemoScreen extends StatelessWidget {
  const DropdownDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dropdown Demo'),
        actions: const [
          ThemeModeSwitch(),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          DropdownDemoThemePresetsSection(),
          SizedBox(height: 24),
          DropdownDemoParitySection(),
          SizedBox(height: 24),
          DropdownDemoShowcaseSection(),
        ],
      ),
    );
  }
}
