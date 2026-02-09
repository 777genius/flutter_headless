import 'package:flutter/material.dart';

import 'demo_section.dart';
import 'variant_row.dart';

/// Material variant of Flutter standard buttons for comparison.
final class FlutterMaterialButtonsContent extends StatelessWidget {
  const FlutterMaterialButtonsContent({
    super.key,
    required this.isDisabled,
    required this.onPressed,
  });

  final bool isDisabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isDisabled ? null : onPressed;

    return DemoSection(
      title: 'Flutter Standard (Material)',
      description: 'Native Material buttons for Tab-focus comparison.\n'
          'FilledButton | FilledButton.tonal | OutlinedButton | TextButton',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VariantRow(
            label: 'FILLED (FilledButton)',
            children: [
              for (final label in _sizeLabels)
                FilledButton(
                  onPressed: effectiveOnPressed,
                  child: Text(label),
                ),
            ],
          ),
          const SizedBox(height: 16),
          VariantRow(
            label: 'TONAL (FilledButton.tonal)',
            children: [
              for (final label in _sizeLabels)
                FilledButton.tonal(
                  onPressed: effectiveOnPressed,
                  child: Text(label),
                ),
            ],
          ),
          const SizedBox(height: 16),
          VariantRow(
            label: 'OUTLINED (OutlinedButton)',
            children: [
              for (final label in _sizeLabels)
                OutlinedButton(
                  onPressed: effectiveOnPressed,
                  child: Text(label),
                ),
            ],
          ),
          const SizedBox(height: 16),
          VariantRow(
            label: 'TEXT (TextButton)',
            children: [
              for (final label in _sizeLabels)
                TextButton(
                  onPressed: effectiveOnPressed,
                  child: Text(label),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

const _sizeLabels = ['small', 'medium', 'large'];
