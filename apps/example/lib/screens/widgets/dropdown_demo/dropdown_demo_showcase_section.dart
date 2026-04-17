import 'package:flutter/material.dart';

import '../demo_section.dart';
import 'dropdown_demo_command_shell_card.dart';
import 'dropdown_demo_editorial_shell_card.dart';
import 'dropdown_demo_team_shell_card.dart';
import 'dropdown_demo_travel_shell_card.dart';

class DropdownDemoShowcaseSection extends StatelessWidget {
  const DropdownDemoShowcaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Headless Shell Gallery',
      description:
          'The same dropdown behavior core, reshaped into four visibly different shells.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 960;
          final cardWidth =
              isWide ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;

          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: cardWidth,
                child: const DropdownDemoTravelShellCard(),
              ),
              SizedBox(
                width: cardWidth,
                child: const DropdownDemoEditorialShellCard(),
              ),
              SizedBox(
                width: cardWidth,
                child: const DropdownDemoCommandShellCard(),
              ),
              SizedBox(
                width: cardWidth,
                child: const DropdownDemoTeamShellCard(),
              ),
            ],
          );
        },
      ),
    );
  }
}
