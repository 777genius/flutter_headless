import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import '../widgets/theme_mode_switch.dart';

class IntentionalErrorsScreen extends StatefulWidget {
  const IntentionalErrorsScreen({super.key});

  @override
  State<IntentionalErrorsScreen> createState() => _IntentionalErrorsScreenState();
}

class _IntentionalErrorsScreenState extends State<IntentionalErrorsScreen> {
  String? _e1Error;
  String? _e2Error;
  String? _e3Error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intentional Errors'),
        actions: const [
          ThemeModeSwitch(),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            color: Color(0xFFFFF3E0),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Demo Purpose Only',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This screen demonstrates what happens when headless '
                    'components are used incorrectly. These errors are intentional '
                    'and triggered by button press (not on screen load).',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // E1 - MissingThemeException
          _ErrorDemoCard(
            title: 'E1 - MissingThemeException',
            description: 'What happens when RTextButton is rendered '
                'without HeadlessThemeProvider in ancestor tree.',
            error: _e1Error,
            onRunDemo: () {
              setState(() => _e1Error = null);
              // Demo: Show what MissingThemeException looks like.
              // In real code, this exception is thrown by HeadlessThemeProvider.themeOf()
              // when no provider exists in the widget tree.
              //
              // Example of code that would throw:
              //   HeadlessThemeProvider.themeOf(context); // throws if no provider
              //
              // We demonstrate the exception format directly:
              const exception = MissingThemeException();
              setState(() => _e1Error = exception.toString());
            },
          ),
          const SizedBox(height: 16),

          // E2 - MissingCapabilityException
          _ErrorDemoCard(
            title: 'E2 - MissingCapabilityException',
            description: 'What happens when HeadlessThemeProvider exists '
                'but the theme doesn\'t provide required capability.',
            error: _e2Error,
            onRunDemo: () {
              setState(() => _e2Error = null);
              try {
                // Create a theme that doesn't provide RButtonRenderer
                final emptyTheme = _EmptyTheme();

                // Try to require a capability that doesn't exist
                requireCapability<RButtonRenderer>(
                  emptyTheme,
                  componentName: 'RTextButton',
                );
              } on MissingCapabilityException catch (e) {
                setState(() => _e2Error = e.toString());
              } catch (e) {
                setState(() => _e2Error = 'Caught: $e');
              }
            },
          ),
          const SizedBox(height: 24),

          // E3 - MissingOverlayHostException
          _ErrorDemoCard(
            title: 'E3 - MissingOverlayHostException',
            description: 'What happens when RDropdownButton is used '
                'without AnchoredOverlayEngineHost in ancestor tree.',
            error: _e3Error,
            onRunDemo: () {
              setState(() => _e3Error = null);
              const exception = MissingOverlayHostException(
                componentName: 'RDropdownButton',
              );
              setState(() => _e3Error = exception.toString());
            },
          ),
          const SizedBox(height: 24),

          // How to fix
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to Fix',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'E1 - Wrap your app with HeadlessThemeProvider:\n',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'HeadlessThemeProvider(\n'
                    '  theme: MaterialHeadlessTheme(),\n'
                    '  child: MyApp(),\n'
                    ')',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'E2 - Use a preset that provides required capabilities:\n',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '// MaterialHeadlessTheme provides:\n'
                    '// - RButtonRenderer\n'
                    '// - RButtonTokenResolver\n'
                    '// - RDropdownButtonRenderer\n'
                    '// - RDropdownTokenResolver',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'E3 - Add AnchoredOverlayEngineHost above your app:\n',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'AnchoredOverlayEngineHost(\n'
                    '  controller: OverlayController(),\n'
                    '  child: MaterialApp(home: MyApp()),\n'
                    ')',
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

class _ErrorDemoCard extends StatelessWidget {
  const _ErrorDemoCard({
    required this.title,
    required this.description,
    required this.error,
    required this.onRunDemo,
  });

  final String title;
  final String description;
  final String? error;
  final VoidCallback onRunDemo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(height: 24),
            ElevatedButton.icon(
              onPressed: onRunDemo,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Run Error Demo'),
            ),
            if (error != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Exception caught:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty theme that doesn't provide any capabilities.
/// Used to demonstrate MissingCapabilityException.
class _EmptyTheme implements HeadlessTheme {
  @override
  T? capability<T>() => null;
}
