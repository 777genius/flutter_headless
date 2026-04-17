import 'package:flutter/material.dart';

import '../../../theme_mode_scope.dart';
import '../demo_section.dart';
import 'autocomplete_demo_cupertino_primitives_parity_card.dart';
import 'autocomplete_demo_material_sdk_parity_card.dart';

class AutocompleteDemoParitySection extends StatelessWidget {
  const AutocompleteDemoParitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final isCupertino = ThemeModeScope.of(context).isCupertino;

    return DemoSection(
      title: 'Flutter Native vs Headless API',
      description: isCupertino
          ? 'Left is Flutter\'s native Cupertino composition. Right is our RAutocomplete widget on the active header preset.'
          : 'Left is Flutter\'s Autocomplete<T>. Right is our RAutocomplete<T> on the active header preset. Material can look close, so this section is about ownership and behavior parity.',
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: isCupertino
              ? const AutocompleteDemoCupertinoPrimitivesParityCard()
              : const AutocompleteDemoMaterialSdkParityCard(),
        ),
      ),
    );
  }
}
