import 'package:flutter/material.dart';

import 'demo_section.dart';
import 'phone_field_shell_gallery_card.dart';
import 'phone_field_shell_gallery_support.dart';

final class PhoneFieldShellGalleryDemoSection extends StatelessWidget {
  const PhoneFieldShellGalleryDemoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Make The Same Logic Look Like Different Products',
      description:
          'This grid uses a scoped custom renderer. The same phone logic is '
          'remixed into branded shells, selector flows, and trigger layouts.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = phoneFieldShellCardWidth(constraints.maxWidth);

          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final preset in PhoneFieldShellPreset.values)
                SizedBox(
                  width: width,
                  child: PhoneFieldShellGalleryCard(preset: preset),
                ),
            ],
          );
        },
      ),
    );
  }
}
