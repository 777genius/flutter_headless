import 'package:flutter/material.dart';

import '../widgets/theme_mode_switch.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Headless UI for Flutter'),
        centerTitle: true,
        actions: const [
          ThemeModeSwitch(),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _HeaderCard(),
          const SizedBox(height: 24),
          _DemoTile(
            title: 'Button Demo',
            subtitle: 'Default, per-instance overrides, scoped theme',
            icon: Icons.smart_button,
            onTap: () => Navigator.pushNamed(context, '/button'),
          ),
          const SizedBox(height: 12),
          _DemoTile(
            title: 'Dropdown Demo',
            subtitle: 'Keyboard navigation, overrides, slots',
            icon: Icons.arrow_drop_down_circle,
            onTap: () => Navigator.pushNamed(context, '/dropdown'),
          ),
          const SizedBox(height: 12),
          _DemoTile(
            title: 'Autocomplete Demo',
            subtitle: 'Input + menu composition with rich items',
            icon: Icons.search,
            onTap: () => Navigator.pushNamed(context, '/autocomplete'),
          ),
          const SizedBox(height: 12),
          _DemoTile(
            title: 'TextField Demo',
            subtitle: 'Controlled, controller-driven, validation, multiline',
            icon: Icons.text_fields,
            onTap: () => Navigator.pushNamed(context, '/textfield'),
          ),
          const SizedBox(height: 12),
          _DemoTile(
            title: 'Switch Demo',
            subtitle: 'RSwitch, RSwitchListTile, thumbIcon, overrides',
            icon: Icons.toggle_on,
            onTap: () => Navigator.pushNamed(context, '/switch'),
          ),
          const SizedBox(height: 12),
          _DemoTile(
            title: 'Intentional Errors',
            subtitle: 'MissingTheme / MissingCapability demos',
            icon: Icons.error_outline,
            onTap: () => Navigator.pushNamed(context, '/errors'),
          ),
          const SizedBox(height: 12),
          _DemoTile(
            title: 'Glassmorphism Demo',
            subtitle: 'iOS-inspired glass effect with BackdropFilter',
            icon: Icons.blur_on,
            onTap: () => Navigator.pushNamed(context, '/glass'),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Headless Components Demo',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This app demonstrates the headless component architecture. '
              'Components handle behavior (state, keyboard, a11y), '
              'while renderers handle visuals. Use the switch above '
              'to toggle between Material and Cupertino themes.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            const Text(
              'Customization layers:\n'
              '1. Preset theme (Material/Cupertino)\n'
              '2. Per-instance contract overrides\n'
              '3. Slots (structural customization)\n'
              '4. Scoped theme (local theme override)',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoTile extends StatelessWidget {
  const _DemoTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
