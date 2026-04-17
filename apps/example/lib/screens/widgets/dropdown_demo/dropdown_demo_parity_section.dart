import 'package:flutter/material.dart';

import '../../../theme_mode_scope.dart';
import '../demo_section.dart';
import 'dropdown_demo_cupertino_action_sheet_parity_card.dart';
import 'dropdown_demo_cupertino_picker_parity_card.dart';
import 'dropdown_demo_selected_item_parity_card.dart';
import 'dropdown_demo_underline_parity_card.dart';

class DropdownDemoParitySection extends StatelessWidget {
  const DropdownDemoParitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final isCupertino = ThemeModeScope.of(context).isCupertino;

    return DemoSection(
      title: 'Flutter Parity',
      description: isCupertino
          ? 'Flutter does not ship a direct Cupertino dropdown. '
              'These are the native selection patterns to compare against the active Cupertino preset.'
          : 'Native Flutter Material DropdownButton samples, compared against the active headless Material preset.',
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
                child: isCupertino
                    ? const DropdownDemoCupertinoPickerParityCard()
                    : const DropdownDemoUnderlineParityCard(),
              ),
              SizedBox(
                width: cardWidth,
                child: isCupertino
                    ? const DropdownDemoCupertinoActionSheetParityCard()
                    : const DropdownDemoSelectedItemParityCard(),
              ),
            ],
          );
        },
      ),
    );
  }
}
