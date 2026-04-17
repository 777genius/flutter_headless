import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'autocomplete_demo_scoped_theme.dart';
import '../showcase_text_field_scope.dart';

class AutocompleteDemoShellCard extends StatelessWidget {
  const AutocompleteDemoShellCard({
    required this.title,
    required this.caption,
    required this.kicker,
    required this.modeLabel,
    required this.colorScheme,
    required this.decoration,
    required this.child,
    super.key,
  });

  final String title;
  final String caption;
  final String kicker;
  final String modeLabel;
  final ColorScheme colorScheme;
  final Decoration decoration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scopedTheme = autocompleteDemoScopedTheme(context, colorScheme);

    return Theme(
      data: scopedTheme,
      child: HeadlessThemeProvider(
        theme: MaterialHeadlessTheme(
          colorScheme: colorScheme,
          textTheme: scopedTheme.textTheme,
        ),
        child: Container(
          decoration: decoration,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _AutocompleteDemoShellPill(
                    label: kicker,
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: colorScheme.onPrimaryContainer,
                  ),
                  _AutocompleteDemoShellPill(
                    label: modeLabel,
                    backgroundColor:
                        colorScheme.surface.withValues(alpha: 0.78),
                    foregroundColor: colorScheme.onSurface,
                    borderColor: colorScheme.outline.withValues(alpha: 0.4),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: scopedTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                caption,
                style: scopedTheme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 20),
              ShowcaseTextFieldScope(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _AutocompleteDemoShellPill extends StatelessWidget {
  const _AutocompleteDemoShellPill({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
      ),
    );
  }
}
