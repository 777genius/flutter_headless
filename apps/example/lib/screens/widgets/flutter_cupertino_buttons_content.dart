import 'package:flutter/cupertino.dart';

import 'demo_section.dart';
import 'variant_row.dart';

/// Cupertino variant of Flutter standard buttons for comparison.
final class FlutterCupertinoButtonsContent extends StatelessWidget {
  const FlutterCupertinoButtonsContent({
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
      title: 'Flutter Standard (Cupertino)',
      description: 'Native Cupertino buttons for Tab-focus comparison.\n'
          'CupertinoButton.filled | CupertinoButton',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VariantRow(
            label: 'FILLED (CupertinoButton.filled)',
            children: [
              for (final label in _sizeLabels)
                CupertinoButton.filled(
                  onPressed: effectiveOnPressed,
                  child: Text(label),
                ),
            ],
          ),
          const SizedBox(height: 16),
          VariantRow(
            label: 'TONAL (CupertinoButton.tinted)',
            children: [
              for (final label in _sizeLabels)
                CupertinoButton.tinted(
                  onPressed: effectiveOnPressed,
                  child: Text(label),
                ),
            ],
          ),
          const SizedBox(height: 16),
          VariantRow(
            label: 'PLAIN (CupertinoButton)',
            children: [
              for (final label in _sizeLabels)
                CupertinoButton(
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
