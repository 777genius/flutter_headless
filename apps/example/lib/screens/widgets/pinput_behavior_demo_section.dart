import 'package:flutter/material.dart';
import 'package:headless_pinput/headless_pinput.dart';

import 'demo_section.dart';

final class PinputBehaviorDemoSection extends StatelessWidget {
  const PinputBehaviorDemoSection({
    super.key,
    required this.value,
    required this.lastCompleted,
    required this.onChanged,
    required this.onCompleted,
  });

  final String value;
  final String lastCompleted;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Controlled Mode + Validation',
      description:
          'Behavior is preserved from pinput: completion, validation, hidden EditableText and per-cell state mapping.\n'
          'Use 246810 to satisfy the validator.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RPinInput(
            key: const ValueKey('pinput-controlled'),
            value: value,
            onChanged: onChanged,
            onCompleted: onCompleted,
            showErrorWhenFocused: true,
            validator: (pin) {
              if (pin.isEmpty || pin.length < 6) return null;
              return pin == '246810' ? null : 'Demo validator: expected 246810';
            },
            variant: RPinInputVariant.outlined,
          ),
          const SizedBox(height: 12),
          Text('Current value: ${value.isEmpty ? 'empty' : value}'),
          const SizedBox(height: 4),
          Text('Last completed: $lastCompleted'),
        ],
      ),
    );
  }
}
