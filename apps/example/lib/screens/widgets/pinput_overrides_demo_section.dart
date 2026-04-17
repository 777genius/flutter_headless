import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_pinput/headless_pinput.dart';

import 'demo_section.dart';

final class PinputOverridesDemoSection extends StatelessWidget {
  const PinputOverridesDemoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DemoSection(
      title: 'Per-Instance Overrides',
      description:
          'Visual tweaks stay outside the behavior layer. You can use style sugar or raw RenderOverrides without touching completion, focus, clipboard or keyboard logic.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RPinInput(
            value: '84',
            onChanged: _noop,
            variant: RPinInputVariant.outlined,
            style: RPinInputStyle(
              cellGap: 10,
              cellBorderRadius: 24,
              cellBorderWidth: 2,
              borderColor: scheme.tertiary,
              cursorColor: scheme.tertiary,
            ),
          ),
          const SizedBox(height: 12),
          RPinInput(
            value: '135',
            onChanged: _noop,
            variant: RPinInputVariant.filled,
            style: RPinInputStyle(
              cellWidth: 48,
              cellHeight: 56,
              cellGap: 8,
              backgroundColor: scheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 12),
          RPinInput(
            value: '900',
            onChanged: _noop,
            variant: RPinInputVariant.elevated,
            overrides: RenderOverrides.only(
              RPinInputOverrides.tokens(
                borderColor: scheme.primary,
                cursorColor: scheme.primary,
                textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _noop(String _) {}
