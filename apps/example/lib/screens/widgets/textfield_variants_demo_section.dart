import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_cupertino/headless_cupertino.dart';
import 'package:headless_textfield/headless_textfield.dart';

import '../../theme_mode_scope.dart';
import 'demo_section.dart';

final class TextFieldVariantsDemoSection extends StatelessWidget {
  const TextFieldVariantsDemoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isCupertino = ThemeModeScope.of(context).isCupertino;

    return DemoSection(
      title: 'Variants (intent)',
      description: 'Three visual intents: filled / outlined / underlined.\n'
          'Cupertino does not have a native underlined variant.\n'
          'Use Cupertino-only borderless via RCupertinoTextField.borderless().',
      child: Column(
        children: [
          if (!isCupertino) ...[
            RTextField(
              value: '',
              onChanged: _noop,
              label: 'Filled',
              placeholder: 'filled',
              variant: RTextFieldVariant.filled,
            ),
            const SizedBox(height: 12),
            RTextField(
              value: '',
              onChanged: _noop,
              label: 'Outlined',
              placeholder: 'outlined',
              variant: RTextFieldVariant.outlined,
            ),
            const SizedBox(height: 12),
            RTextField(
              value: '',
              onChanged: _noop,
              label: 'Underlined',
              placeholder: 'underlined',
              variant: RTextFieldVariant.underlined,
            ),
          ] else ...[
            RCupertinoTextField(
              value: '',
              onChanged: _noop,
              placeholder: 'default (bordered)',
              clearButtonMode: RTextFieldOverlayVisibilityMode.never,
            ),
            const SizedBox(height: 12),
            RCupertinoTextField.borderless(
              value: '',
              onChanged: _noop,
              placeholder: 'borderless',
              clearButtonMode: RTextFieldOverlayVisibilityMode.never,
            ),
          ],
        ],
      ),
    );
  }
}

void _noop(String _) {}
