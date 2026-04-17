import 'package:flutter/widgets.dart';

class DropdownDemoThemePresetComparison extends StatelessWidget {
  const DropdownDemoThemePresetComparison({
    required this.nativeChild,
    required this.headlessChild,
    super.key,
  });

  final Widget nativeChild;
  final Widget headlessChild;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 560;
        if (!isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DropdownDemoThemePresetLane(
                label: 'Flutter Native',
                child: nativeChild,
              ),
              const SizedBox(height: 14),
              _DropdownDemoThemePresetLane(
                label: 'Headless Preset',
                child: headlessChild,
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _DropdownDemoThemePresetLane(
                label: 'Flutter Native',
                child: nativeChild,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _DropdownDemoThemePresetLane(
                label: 'Headless Preset',
                child: headlessChild,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DropdownDemoThemePresetLane extends StatelessWidget {
  const _DropdownDemoThemePresetLane({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = DefaultTextStyle.of(context).style;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
