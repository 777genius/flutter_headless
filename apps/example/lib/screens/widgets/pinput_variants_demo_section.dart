import 'package:flutter/material.dart';
import 'package:headless_pinput/headless_pinput.dart';

import 'demo_section.dart';

final class PinputVariantsDemoSection extends StatelessWidget {
  const PinputVariantsDemoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Variants (intent)',
      description:
          'The logic is identical. Only typed variant intent changes. The renderer decides how outlined, elevated, filled, rounded and underlined should look.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _VariantRow(label: 'Outlined', variant: RPinInputVariant.outlined),
          SizedBox(height: 12),
          _VariantRow(label: 'Elevated', variant: RPinInputVariant.elevated),
          SizedBox(height: 12),
          _VariantRow(label: 'Filled', variant: RPinInputVariant.filled),
          SizedBox(height: 12),
          _VariantRow(
            label: 'Filled Rounded',
            variant: RPinInputVariant.filledRounded,
          ),
          SizedBox(height: 12),
          _VariantRow(
              label: 'Underlined', variant: RPinInputVariant.underlined),
        ],
      ),
    );
  }
}

final class _VariantRow extends StatelessWidget {
  const _VariantRow({
    required this.label,
    required this.variant,
  });

  final String label;
  final RPinInputVariant variant;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        RPinInput(
          value: '42',
          onChanged: _noop,
          variant: variant,
        ),
      ],
    );
  }
}

void _noop(String _) {}
