import 'package:flutter/material.dart';

import '../widgets/theme_mode_switch.dart';
import 'widgets/phone_field_custom_trigger_demo_section.dart';
import 'widgets/phone_field_logic_demo_section.dart';
import 'widgets/phone_field_navigator_demo_section.dart';
import 'widgets/phone_field_shell_gallery_demo_section.dart';
import 'widgets/phone_field_showcase_hero.dart';
import 'widgets/phone_field_showcase_theme_scope.dart';

class PhoneFieldDemoScreen extends StatelessWidget {
  const PhoneFieldDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Headless Phone Field'),
        actions: const [
          ThemeModeSwitch(),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scheme.primaryContainer.withValues(alpha: 0.08),
              scheme.surface,
              scheme.surface,
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: const SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PhoneFieldShowcaseThemeScope(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PhoneFieldShowcaseHero(),
                        SizedBox(height: 24),
                        PhoneFieldShellGalleryDemoSection(),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  PhoneFieldNavigatorDemoSection(),
                  SizedBox(height: 24),
                  PhoneFieldCustomTriggerDemoSection(),
                  SizedBox(height: 24),
                  PhoneFieldLogicDemoSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
