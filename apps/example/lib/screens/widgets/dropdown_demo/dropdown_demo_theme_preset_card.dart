import 'package:flutter/material.dart';

import '../demo_mode_palette.dart';

class DropdownDemoThemePresetCard extends StatelessWidget {
  const DropdownDemoThemePresetCard({
    required this.title,
    required this.caption,
    required this.child,
    super.key,
  });

  final String title;
  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = DemoModePalette.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.secondaryText,
                  height: 1.3,
                ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
