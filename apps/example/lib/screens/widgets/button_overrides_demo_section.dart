import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'demo_section.dart';

final class ButtonOverridesDemoSection extends StatelessWidget {
  const ButtonOverridesDemoSection({
    super.key,
    required this.isDisabled,
    required this.onPressed,
  });

  final bool isDisabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DemoSection(
      title: 'Per-Instance Overrides',
      description: 'Contract-level RButtonOverrides: colors, padding, radii.\n'
          'Overrides affect tokens (visuals), NOT behavior.',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          RTextButton(
            onPressed: isDisabled ? null : onPressed,
            variant: RButtonVariant.filled,
            overrides: RenderOverrides.only(
              RButtonOverrides.tokens(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
            ),
            child: const Text('Error color'),
          ),
          RTextButton(
            onPressed: isDisabled ? null : onPressed,
            variant: RButtonVariant.outlined,
            overrides: RenderOverrides.only(
              RButtonOverrides.tokens(
                borderRadius: BorderRadius.circular(24),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
            ),
            child: const Text('Pill shape'),
          ),
          RTextButton(
            onPressed: isDisabled ? null : onPressed,
            variant: RButtonVariant.tonal,
            overrides: RenderOverrides.only(
              RButtonOverrides.tokens(
                backgroundColor: colorScheme.tertiaryContainer,
                foregroundColor: colorScheme.onTertiaryContainer,
              ),
            ),
            child: const Text('Tertiary tonal'),
          ),
        ],
      ),
    );
  }
}
