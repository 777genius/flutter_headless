import 'package:flutter/material.dart';
import 'package:headless/headless.dart';
import 'package:headless_pinput/headless_pinput.dart';

import '../widgets/theme_mode_switch.dart';
import 'widgets/pinput_behavior_demo_section.dart';
import 'widgets/pinput_custom_keyboard_demo_section.dart';
import 'widgets/pinput_overrides_demo_section.dart';
import 'widgets/pinput_variants_demo_section.dart';

class PinputDemoScreen extends StatefulWidget {
  const PinputDemoScreen({super.key});

  @override
  State<PinputDemoScreen> createState() => _PinputDemoScreenState();
}

class _PinputDemoScreenState extends State<PinputDemoScreen> {
  String _controlledValue = '';
  String _lastCompleted = 'none';
  final _customKeyboardController = TextEditingController();

  @override
  void dispose() {
    _customKeyboardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeadlessThemeOverridesScope(
      overrides: CapabilityOverrides.build((b) {
        b
          ..set<RPinInputRenderer>(const DemoPinInputRenderer())
          ..set<RPinInputTokenResolver>(const DemoPinInputTokenResolver());
      }),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pinput Demo'),
          actions: const [
            ThemeModeSwitch(),
            SizedBox(width: 16),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PinputBehaviorDemoSection(
                value: _controlledValue,
                lastCompleted: _lastCompleted,
                onChanged: (value) => setState(() => _controlledValue = value),
                onCompleted: (value) => setState(() => _lastCompleted = value),
              ),
              const SizedBox(height: 24),
              const PinputVariantsDemoSection(),
              const SizedBox(height: 24),
              const PinputOverridesDemoSection(),
              const SizedBox(height: 24),
              PinputCustomKeyboardDemoSection(
                controller: _customKeyboardController,
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
