import 'package:flutter/material.dart';

import '../widgets/theme_mode_switch.dart';
import 'widgets/button_comparison_row.dart';
import 'widgets/button_overrides_demo_section.dart';
import 'widgets/button_variants_demo_section.dart';
import 'widgets/demo_section.dart';
import 'widgets/flutter_standard_buttons_section.dart';

class ButtonDemoScreen extends StatefulWidget {
  const ButtonDemoScreen({super.key});

  @override
  State<ButtonDemoScreen> createState() => _ButtonDemoScreenState();
}

class _ButtonDemoScreenState extends State<ButtonDemoScreen> {
  int _pressCount = 0;
  bool _isDisabled = false;

  void _onPressed() => setState(() => _pressCount++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Demo'),
        actions: const [
          ThemeModeSwitch(),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: const Text('Disabled'),
              subtitle: Text('Press count: $_pressCount'),
              value: _isDisabled,
              onChanged: (value) => setState(() => _isDisabled = value),
            ),
          ),
          const SizedBox(height: 24),
          ButtonComparisonRow(
            left: ButtonVariantsDemoSection(
              isDisabled: _isDisabled,
              onPressed: _onPressed,
            ),
            right: FlutterStandardButtonsSection(
              isDisabled: _isDisabled,
              onPressed: _onPressed,
            ),
          ),
          const SizedBox(height: 24),
          ButtonOverridesDemoSection(
            isDisabled: _isDisabled,
            onPressed: _onPressed,
          ),
          const SizedBox(height: 24),
          const _KeyboardHintsSection(),
        ],
      ),
    );
  }
}

class _KeyboardHintsSection extends StatelessWidget {
  const _KeyboardHintsSection();

  @override
  Widget build(BuildContext context) {
    return const DemoSection(
      title: 'Keyboard & Focus',
      description: 'Use Tab to navigate between buttons.\n'
          'Focus ring appears in keyboard mode (not on mouse click).',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tab - Focus next button'),
          Text('Shift+Tab - Focus previous'),
          Text('Space - Activate on key UP'),
          Text('Enter - Activate on key DOWN'),
        ],
      ),
    );
  }
}
