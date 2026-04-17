import 'package:flutter/material.dart';
import 'package:headless_pinput/headless_pinput.dart';

import 'demo_section.dart';

final class PinputCustomKeyboardDemoSection extends StatelessWidget {
  const PinputCustomKeyboardDemoSection({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Custom Keyboard',
      description:
          'This is the headless payoff. Native keyboard is disabled, but the same input logic still drives focus, cursor and completion. Any keypad UI can control the field through the controller.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RPinInput(
            key: const ValueKey('pinput-custom-keyboard'),
            controller: controller,
            onChanged: onChanged,
            useNativeKeyboard: false,
            variant: RPinInputVariant.filledRounded,
          ),
          const SizedBox(height: 12),
          Text(
              'Controller value: ${controller.text.isEmpty ? 'empty' : controller.text}'),
          const SizedBox(height: 12),
          _PinKeypad(
            controller: controller,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

final class _PinKeypad extends StatelessWidget {
  const _PinKeypad({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];

    return Column(
      children: [
        for (final row in rows) ...[
          Row(
            children: [
              for (final digit in row) ...[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: FilledButton.tonal(
                      onPressed: () => _appendDigit(digit),
                      child: Text(digit),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: FilledButton.tonal(
                  onPressed: _clearPin,
                  child: const Text('Clear'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: FilledButton.tonal(
                  onPressed: () => _appendDigit('0'),
                  child: const Text('0'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: FilledButton.tonal(
                  onPressed: _deletePin,
                  child: const Icon(Icons.backspace_outlined),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _appendDigit(String digit) {
    controller.appendPin(digit, maxLength: 6);
    onChanged(controller.text);
  }

  void _deletePin() {
    controller.deletePin();
    onChanged(controller.text);
  }

  void _clearPin() {
    controller.clear();
    onChanged(controller.text);
  }
}
