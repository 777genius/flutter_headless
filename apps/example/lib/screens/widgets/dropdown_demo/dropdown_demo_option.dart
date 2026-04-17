import 'package:headless_foundation/headless_foundation.dart';

class DropdownDemoOption {
  const DropdownDemoOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.shortLabel,
    this.leading,
  });

  final String id;
  final String title;
  final String subtitle;
  final String shortLabel;
  final HeadlessContent? leading;
}
