import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_textfield/headless_textfield.dart';

import '../../theme_mode_scope.dart';
import 'demo_section.dart';

final class TextFieldOverridesDemoSection extends StatelessWidget {
  const TextFieldOverridesDemoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isCupertino = ThemeModeScope.of(context).isCupertino;

    return DemoSection(
      title: 'Per-Instance Overrides',
      description: 'Cupertino: container tokens affect visuals.\n'
          'Material: strict M3 parity uses InputDecorator, so container tokens are ignored.\n'
          'This demo uses preset-specific MaterialTextFieldOverrides to show container changes.',
      child: Column(
        children: [
          _DemoOverrideField(
            placeholder: 'Rounded corners',
            variant: RTextFieldVariant.outlined,
            cupertinoOverrides: RenderOverrides.only(
              const RTextFieldOverrides.tokens(
                containerBorderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
            materialOverrides: RenderOverrides.only(
              MaterialTextFieldOverrides(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            isCupertino: isCupertino,
          ),
          const SizedBox(height: 12),
          _DemoOverrideField(
            placeholder: 'Filled background',
            variant: RTextFieldVariant.filled,
            cupertinoOverrides: RenderOverrides.only(
              RTextFieldOverrides.tokens(
                containerBackgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHigh,
                containerBorderWidth: 0,
              ),
            ),
            materialOverrides: RenderOverrides.only(
              MaterialTextFieldOverrides(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
              ),
            ),
            isCupertino: isCupertino,
          ),
          const SizedBox(height: 12),
          _DemoOverrideField(
            placeholder: 'Thick accent border',
            variant: RTextFieldVariant.outlined,
            cupertinoOverrides: RenderOverrides.only(
              RTextFieldOverrides.tokens(
                containerBorderColor: Theme.of(context).colorScheme.primary,
                containerBorderWidth: 2,
              ),
            ),
            materialOverrides: RenderOverrides.only(
              MaterialTextFieldOverrides(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            isCupertino: isCupertino,
          ),
          const SizedBox(height: 12),
          _DemoOverrideField(
            placeholder: 'Custom cursor & selection',
            variant: RTextFieldVariant.underlined,
            cupertinoOverrides: RenderOverrides.only(
              RTextFieldOverrides.tokens(
                cursorColor: Theme.of(context).colorScheme.tertiary,
                selectionColor: Theme.of(context)
                    .colorScheme
                    .tertiary
                    .withValues(alpha: 0.3),
              ),
            ),
            materialOverrides: RenderOverrides.only(
              RTextFieldOverrides.tokens(
                cursorColor: Theme.of(context).colorScheme.tertiary,
                selectionColor: Theme.of(context)
                    .colorScheme
                    .tertiary
                    .withValues(alpha: 0.3),
              ),
            ),
            isCupertino: isCupertino,
          ),
          const SizedBox(height: 12),
          _DemoOverrideField(
            placeholder: 'Dense padding',
            variant: RTextFieldVariant.filled,
            cupertinoOverrides: RenderOverrides.only(
              const RTextFieldOverrides.tokens(
                containerPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
            materialOverrides: RenderOverrides.only(
              const MaterialTextFieldOverrides(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
            isCupertino: isCupertino,
          ),
        ],
      ),
    );
  }
}

final class _DemoOverrideField extends StatelessWidget {
  const _DemoOverrideField({
    required this.placeholder,
    required this.variant,
    required this.cupertinoOverrides,
    required this.materialOverrides,
    required this.isCupertino,
  });

  final String placeholder;
  final RTextFieldVariant variant;
  final RenderOverrides cupertinoOverrides;
  final RenderOverrides materialOverrides;
  final bool isCupertino;

  @override
  Widget build(BuildContext context) {
    return RTextField(
      value: '',
      onChanged: _noop,
      placeholder: placeholder,
      variant: variant,
      overrides: isCupertino ? cupertinoOverrides : materialOverrides,
    );
  }
}

void _noop(String _) {}
