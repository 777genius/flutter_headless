import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'demo_section.dart';

final class ButtonVariantsDemoSection extends StatelessWidget {
  const ButtonVariantsDemoSection({
    super.key,
    required this.isDisabled,
    required this.onPressed,
  });

  final bool isDisabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Headless Variants x Sizes',
      description: 'Matrix of all appearance variants and size options.\n'
          'filled | tonal | outlined | text  x  small | medium | large',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final variant in RButtonVariant.values) ...[
            Text(
              variant.name.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final size in RButtonSize.values)
                  RTextButton(
                    onPressed: isDisabled ? null : onPressed,
                    variant: variant,
                    size: size,
                    child: Text(size.name),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
