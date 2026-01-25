import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import '../theme_mode_scope.dart';
import '../widgets/theme_mode_switch.dart';
import 'widgets/demo_section.dart';

class SwitchDemoScreen extends StatefulWidget {
  const SwitchDemoScreen({super.key});

  @override
  State<SwitchDemoScreen> createState() => _SwitchDemoScreenState();
}

class _SwitchDemoScreenState extends State<SwitchDemoScreen> {
  bool _defaultValue = false;
  bool _overridesValue = true;
  bool _listTileValue = false;
  bool _thumbIconValue = false;
  bool _isDisabled = false;
  bool _flutterSwitchValue = false;
  bool _flutterListTileValue = false;
  bool _flutterCupertinoValue = false;
  bool _flutterCupertinoTileValue = false;

  @override
  Widget build(BuildContext context) {
    final scope = ThemeModeScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch Demo'),
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

          // S0 - Flutter reference
          DemoSection(
            title: 'S0 - Flutter (reference)',
            description: 'Native Flutter widgets for visual parity check.\n'
                'These should match Flutter defaults for your ThemeData.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!scope.isCupertino) ...[
                  Row(
                    children: [
                      Switch(
                        value: _flutterSwitchValue,
                        onChanged: _isDisabled
                            ? null
                            : (v) => setState(() => _flutterSwitchValue = v),
                      ),
                      const SizedBox(width: 16),
                      Text(_flutterSwitchValue ? 'ON' : 'OFF'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: SwitchListTile(
                      value: _flutterListTileValue,
                      onChanged: _isDisabled
                          ? null
                          : (v) => setState(() => _flutterListTileValue = v),
                      title: const Text('Enable notifications'),
                      subtitle: const Text('Receive push notifications'),
                    ),
                  ),
                ] else ...[
                  CupertinoTheme(
                    data: CupertinoThemeData(
                      brightness:
                          scope.isDark ? Brightness.dark : Brightness.light,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CupertinoSwitch(
                              value: _flutterCupertinoValue,
                              onChanged: _isDisabled
                                  ? null
                                  : (v) => setState(
                                        () => _flutterCupertinoValue = v,
                                      ),
                            ),
                            const SizedBox(width: 16),
                            Text(_flutterCupertinoValue ? 'ON' : 'OFF'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        MergeSemantics(
                          child: CupertinoListTile(
                            title: const Text('Enable notifications'),
                            subtitle: const Text('Receive push notifications'),
                            trailing: CupertinoSwitch(
                              value: _flutterCupertinoTileValue,
                              onChanged: _isDisabled
                                  ? null
                                  : (v) => setState(
                                        () => _flutterCupertinoTileValue = v,
                                      ),
                            ),
                            onTap: _isDisabled
                                ? null
                                : () => setState(
                                      () => _flutterCupertinoTileValue =
                                          !_flutterCupertinoTileValue,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // S1 - Default
          DemoSection(
            title: 'S1 - Default RSwitch',
            description: 'Basic switch with default Material styling.\n'
                'Try: Click, Space (up), Enter (down)',
            child: Row(
              children: [
                RSwitch(
                  value: _defaultValue,
                  onChanged:
                      _isDisabled ? null : (v) => setState(() => _defaultValue = v),
                ),
                const SizedBox(width: 16),
                Text(_defaultValue ? 'ON' : 'OFF'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // S2 - Per-instance overrides
          DemoSection(
            title: 'S2 - Per-instance Overrides',
            description: 'Custom colors via RSwitchOverrides.\n'
                'Green track when on, red when off.',
            child: Row(
              children: [
                RSwitch(
                  value: _overridesValue,
                  onChanged: _isDisabled
                      ? null
                      : (v) => setState(() => _overridesValue = v),
                  overrides: RenderOverrides({
                    RSwitchOverrides: RSwitchOverrides.tokens(
                      activeTrackColor: Colors.green,
                      inactiveTrackColor: Colors.red.shade200,
                      activeThumbColor: Colors.white,
                      inactiveThumbColor: Colors.white,
                    ),
                  }),
                ),
                const SizedBox(width: 16),
                Text(_overridesValue ? 'ON' : 'OFF'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // S3 - thumbIcon
          DemoSection(
            title: 'S3 - thumbIcon (Material 3)',
            description: 'Icon inside thumb based on state.\n'
                'Check when on, close when off.',
            child: Row(
              children: [
                RSwitch(
                  value: _thumbIconValue,
                  onChanged: _isDisabled
                      ? null
                      : (v) => setState(() => _thumbIconValue = v),
                  thumbIcon: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Icon(Icons.check, size: 16);
                    }
                    return const Icon(Icons.close, size: 16);
                  }),
                ),
                const SizedBox(width: 16),
                Text(_thumbIconValue ? 'ON' : 'OFF'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // S4 - RSwitchListTile
          DemoSection(
            title: 'S4 - RSwitchListTile',
            description: 'Full-row toggle with title/subtitle.\n'
                'Single activation source (whole row is tappable).',
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: RSwitchListTile(
                value: _listTileValue,
                onChanged: _isDisabled
                    ? null
                    : (v) => setState(() => _listTileValue = v),
                title: const Text('Enable notifications'),
                subtitle: const Text('Receive push notifications'),
              ),
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
                  Text('Tab - Focus next switch'),
                  Text('Space - Toggle on key UP'),
                  Text('Enter - Toggle on key DOWN'),
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
