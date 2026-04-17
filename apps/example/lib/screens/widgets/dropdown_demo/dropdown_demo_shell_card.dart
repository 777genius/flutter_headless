import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

class DropdownDemoShellCard extends StatelessWidget {
  const DropdownDemoShellCard({
    required this.title,
    required this.caption,
    required this.kicker,
    required this.modeLabel,
    required this.colorScheme,
    required this.decoration,
    required this.childBuilder,
    super.key,
  });

  final String title;
  final String caption;
  final String kicker;
  final String modeLabel;
  final ColorScheme colorScheme;
  final Decoration decoration;
  final WidgetBuilder childBuilder;

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    final scopedTextTheme = baseTheme.textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );
    final scopedTheme = ThemeData.from(
      colorScheme: colorScheme,
      textTheme: scopedTextTheme,
      useMaterial3: true,
    ).copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      cardColor: Colors.transparent,
      textTheme: scopedTextTheme,
    );

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
                  _DropdownDemoShellPill(
                    label: kicker,
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: colorScheme.onPrimaryContainer,
                  ),
                  _DropdownDemoShellPill(
                    label: modeLabel,
                    backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
                    foregroundColor: colorScheme.onSurface,
                    borderColor: colorScheme.outline.withValues(alpha: 0.32),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: scopedTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                caption,
                style: scopedTheme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.28,
                ),
              ),
              const SizedBox(height: 18),
              Builder(builder: childBuilder),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownDemoShellPill extends StatelessWidget {
  const _DropdownDemoShellPill({
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
