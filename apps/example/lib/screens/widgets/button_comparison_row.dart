import 'package:flutter/material.dart';

/// Lays out two widgets side-by-side on wide screens (> 800px)
/// or stacked vertically on narrow screens.
///
/// Used to compare headless and Flutter standard buttons.
final class ButtonComparisonRow extends StatelessWidget {
  const ButtonComparisonRow({
    super.key,
    required this.left,
    required this.right,
  });

  final Widget left;
  final Widget right;

  static const double _breakpoint = 800;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _breakpoint) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                const SizedBox(width: 16),
                Expanded(child: right),
              ],
            ),
          );
        }

        return Column(
          children: [
            left,
            const SizedBox(height: 16),
            right,
          ],
        );
      },
    );
  }
}
