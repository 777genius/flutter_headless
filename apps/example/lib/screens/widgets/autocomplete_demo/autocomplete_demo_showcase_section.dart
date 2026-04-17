import 'package:flutter/material.dart';

import '../demo_section.dart';
import 'autocomplete_demo_command_shell_card.dart';
import 'autocomplete_demo_editorial_shell_card.dart';
import 'autocomplete_demo_team_filter_shell_card.dart';
import 'autocomplete_demo_travel_shell_card.dart';

class AutocompleteDemoShowcaseSection extends StatelessWidget {
  const AutocompleteDemoShowcaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Headless Shell Gallery',
      description:
          'Same keyboard and selection core, four very different shells.',
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
                child: const AutocompleteDemoTravelShellCard(),
              ),
              SizedBox(
                width: cardWidth,
                child: const AutocompleteDemoEditorialShellCard(),
              ),
              SizedBox(
                width: cardWidth,
                child: const AutocompleteDemoCommandShellCard(),
              ),
              SizedBox(
                width: cardWidth,
                child: const AutocompleteDemoTeamFilterShellCard(),
              ),
            ],
          );
        },
      ),
    );
  }
}
