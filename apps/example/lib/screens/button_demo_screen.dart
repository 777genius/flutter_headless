import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import '../widgets/theme_mode_switch.dart';
import 'widgets/demo_section.dart';

class ButtonDemoScreen extends StatefulWidget {
  const ButtonDemoScreen({super.key});

  @override
  State<ButtonDemoScreen> createState() => _ButtonDemoScreenState();
}

class _ButtonDemoScreenState extends State<ButtonDemoScreen> {
  int _defaultPressCount = 0;
  int _overridesPressCount = 0;
  int _scopedPressCount = 0;
  bool _isDisabled = false;

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
          // Controls
          Card(
            child: SwitchListTile(
              title: const Text('Disabled'),
              subtitle: const Text('Toggle to test disabled state'),
              value: _isDisabled,
              onChanged: (value) => setState(() => _isDisabled = value),
            ),
          ),
          const SizedBox(height: 24),

          // B1 - Default
          DemoSection(
            title: 'B1 - Default',
            description: 'RTextButton with default Material styling.\n'
                'Try: Mouse click, Space (up), Enter (down)',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RTextButton(
                  onPressed: _isDisabled
                      ? null
                      : () => setState(() => _defaultPressCount++),
                  child: const Text('Default Button'),
                ),
                const SizedBox(height: 8),
                Text('Press count: $_defaultPressCount'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // B2 - Per-instance overrides
          DemoSection(
            title: 'B2 - Per-instance Overrides',
            description: 'Contract-level overrides (RButtonOverrides).\n'
                'Custom colors, borderRadius, padding.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RTextButton(
                  onPressed: _isDisabled
                      ? null
                      : () => setState(() => _overridesPressCount++),
                  overrides: RenderOverrides({
                    RButtonOverrides: RButtonOverrides.tokens(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  }),
                  child: const Text('Custom Styled Button'),
                ),
                const SizedBox(height: 8),
                Text('Press count: $_overridesPressCount'),
                const SizedBox(height: 8),
                const Text(
                  'Note: Overrides affect tokens (visuals),\n'
                  'but NOT behavior (keyboard, a11y).',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // B3 - Scoped theme
          DemoSection(
            title: 'B3 - Scoped Theme',
            description: 'Local HeadlessThemeProvider for subtree.\n'
                'Different default styling without global changes.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Global theme button
                    Column(
                      children: [
                        RTextButton(
                          onPressed: _isDisabled
                              ? null
                              : () => setState(() => _scopedPressCount++),
                          child: const Text('Global'),
                        ),
                        const SizedBox(height: 4),
                        const Text('Global theme', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Scoped theme button
                    HeadlessThemeProvider(
                      theme: MaterialHeadlessTheme(
                        colorScheme: ColorScheme.fromSeed(
                          seedColor: Colors.teal,
                        ),
                      ),
                      child: Column(
                        children: [
                          RTextButton(
                            onPressed: _isDisabled
                                ? null
                                : () => setState(() => _scopedPressCount++),
                            child: const Text('Scoped'),
                          ),
                          const SizedBox(height: 4),
                          const Text('Teal theme', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Total press count: $_scopedPressCount'),
                const SizedBox(height: 8),
                const Text(
                  'Note: Scoped theme does NOT leak outside its subtree.',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Keyboard hints
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keyboard Testing',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Tab - Focus next button'),
                  Text('Space - Activate on key UP'),
                  Text('Enter - Activate on key DOWN'),
                  Text('Shift+Tab - Focus previous'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
