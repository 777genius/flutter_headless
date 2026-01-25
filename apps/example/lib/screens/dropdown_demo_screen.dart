import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import '../widgets/theme_mode_switch.dart';
import 'widgets/demo_section.dart';
import 'widgets/scoped_dropdown_renderer_demo_section.dart';
import 'widgets/scoped_dropdown_renderer_and_tokens_demo_section.dart';

class DropdownDemoScreen extends StatefulWidget {
  const DropdownDemoScreen({super.key});

  @override
  State<DropdownDemoScreen> createState() => _DropdownDemoScreenState();
}

class _DropdownDemoScreenState extends State<DropdownDemoScreen> {
  String? _defaultValue;
  String? _overridesValue;
  String? _slotsValue;
  bool _isDisabled = false;

  static const _items = [
    'apple',
    'banana',
    'cherry',
    'disabled',
    'elderberry',
  ];

  static final _itemAdapter = HeadlessItemAdapter<String>(
    id: (value) => ListboxItemId(value),
    primaryText: _labelForValue,
    isDisabled: (value) => value == 'disabled',
  );

  static String _labelForValue(String value) {
    return switch (value) {
      'apple' => 'Apple',
      'banana' => 'Banana',
      'cherry' => 'Cherry',
      'disabled' => 'Disabled Option',
      'elderberry' => 'Elderberry',
      _ => value,
    };
  }

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
          const SizedBox(height: 8),

          // Keyboard hints
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keyboard Navigation (D1)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Tab - Focus trigger'),
                  Text('Enter/Space/ArrowDown - Open menu'),
                  Text('ArrowDown/Up - Move highlight'),
                  Text('Enter - Select highlighted'),
                  Text('Escape - Close without selecting'),
                  SizedBox(height: 8),
                  Text(
                    'Invariant: highlighted != selected\n'
                    '(highlight moves, selection only on Enter)',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // D1 - Default (keyboard-only)
          DemoSection(
            title: 'D1 - Default (Keyboard Demo)',
            description: 'Default Material dropdown.\n'
                'Focus and use keyboard to navigate.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RDropdownButton<String>(
                  value: _defaultValue,
                  onChanged: _isDisabled
                      ? null
                      : (value) => setState(() => _defaultValue = value),
                  items: _items,
                  itemAdapter: _itemAdapter,
                  placeholder: 'Select a fruit...',
                ),
                const SizedBox(height: 8),
                Text('Selected: ${_defaultValue ?? 'none'}'),
                const SizedBox(height: 4),
                const Text(
                  'Try: Open menu → Arrow keys move highlight → '
                  'Escape closes without changing selection',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // D2 - Per-instance overrides
          DemoSection(
            title: 'D2 - Per-instance Overrides',
            description: 'Contract-level overrides (RDropdownOverrides).\n'
                'Custom trigger/menu/item styling.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RDropdownButton<String>(
                  value: _overridesValue,
                  onChanged: _isDisabled
                      ? null
                      : (value) => setState(() => _overridesValue = value),
                  items: _items,
                  itemAdapter: _itemAdapter,
                  placeholder: 'Select a fruit...',
                  overrides: RenderOverrides({
                    RDropdownOverrides: RDropdownOverrides.tokens(
                      triggerBorderColor: Colors.deepPurple,
                      triggerBorderRadius: BorderRadius.circular(16),
                      menuMaxHeight: 200,
                      menuBorderRadius: BorderRadius.circular(16),
                      itemPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  }),
                ),
                const SizedBox(height: 8),
                Text('Selected: ${_overridesValue ?? 'none'}'),
                const SizedBox(height: 8),
                const Text(
                  'Note: Overrides affect only visuals.\n'
                  'Behavior (keyboard, close contract) unchanged.',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // D3 - Slots
          DemoSection(
            title: 'D3 - Slots (Structural Override)',
            description: 'Replace menuSurface with custom container.\n'
                'Uses Decorate to wrap default content.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RDropdownButton<String>(
                  value: _slotsValue,
                  onChanged: _isDisabled
                      ? null
                      : (value) => setState(() => _slotsValue = value),
                  items: _items,
                  itemAdapter: _itemAdapter,
                  placeholder: 'Select a fruit...',
                  slots: RDropdownButtonSlots(
                    menuSurface: Decorate((ctx, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade50,
                              Colors.purple.shade50,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.purple.shade200,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: child,
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Selected: ${_slotsValue ?? 'none'}'),
                const SizedBox(height: 8),
                const Text(
                  'Note: ctx.child contains the default content.\n'
                  'Slots modify structure, not behavior.',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // D4 - Scoped capability override (renderer)
          ScopedDropdownRendererDemoSection(
            isDisabled: _isDisabled,
            items: _items,
            itemAdapter: _itemAdapter,
          ),
          const SizedBox(height: 24),

          // D5 - Scoped capability override (renderer + tokens)
          ScopedDropdownRendererAndTokensDemoSection(
            isDisabled: _isDisabled,
            items: _items,
            itemAdapter: _itemAdapter,
          ),
          const SizedBox(height: 24),

          // Close contract demo
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Close Contract',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'close() -> closing phase (animation starts)\n'
                    'completeClose() -> closed phase (overlay removed)\n\n'
                    'Renderer MUST call onCompleteClose() after exit animation.',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
