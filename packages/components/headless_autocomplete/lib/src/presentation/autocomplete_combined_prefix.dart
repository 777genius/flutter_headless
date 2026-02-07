import 'package:flutter/widgets.dart';

/// Combines selected-values prefix (chips/csv) with a user-provided prefix.
///
/// This prevents multi-select from silently disabling selected-values rendering
/// when the user already supplies `fieldSlots.prefix`.
final class AutocompleteCombinedPrefix extends StatelessWidget {
  const AutocompleteCombinedPrefix({
    required this.selectedPrefix,
    required this.userPrefix,
    super.key,
  });

  final Widget selectedPrefix;
  final Widget? userPrefix;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            selectedPrefix,
            if (userPrefix != null) ...[
              const SizedBox(width: 8),
              userPrefix!,
            ],
          ],
        ),
      ),
    );
  }
}
