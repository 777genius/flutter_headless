import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'demo_section.dart';
import 'scoped_dropdown_renderer_demo_section.dart';

class ScopedDropdownRendererAndTokensDemoSection extends StatefulWidget {
  const ScopedDropdownRendererAndTokensDemoSection({
    super.key,
    required this.isDisabled,
    required this.items,
    required this.itemAdapter,
  });

  final bool isDisabled;
  final List<String> items;
  final HeadlessItemAdapter<String> itemAdapter;

  @override
  State<ScopedDropdownRendererAndTokensDemoSection> createState() =>
      _ScopedDropdownRendererAndTokensDemoSectionState();
}

class _ScopedDropdownRendererAndTokensDemoSectionState
    extends State<ScopedDropdownRendererAndTokensDemoSection> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'D5 - Scoped Capability Override (Renderer + Tokens)',
      description:
          'Override RDropdownButtonRenderer + RDropdownTokenResolver together.\n'
          'This keeps visuals consistent (renderer + tokens agree).',
      child: Builder(
        builder: (context) {
          final baseTheme = HeadlessThemeProvider.themeOf(context);
          final baseRenderer = requireCapability<RDropdownButtonRenderer>(
            baseTheme,
            componentName: 'ScopedDropdownRendererAndTokensDemoSection',
          );
          final baseTokenResolver = requireCapability<RDropdownTokenResolver>(
            baseTheme,
            componentName: 'ScopedDropdownRendererAndTokensDemoSection',
          );

          return HeadlessThemeOverridesScope(
            overrides: CapabilityOverrides.build((b) {
              b
                ..set<RDropdownButtonRenderer>(
                  DemoScopedDropdownRenderer(base: baseRenderer),
                )
                ..set<RDropdownTokenResolver>(
                  DemoScopedDropdownTokenResolver(base: baseTokenResolver),
                );
            }),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RDropdownButton<String>(
                  value: _value,
                  onChanged: widget.isDisabled
                      ? null
                      : (value) => setState(() => _value = value),
                  items: widget.items,
                  itemAdapter: widget.itemAdapter,
                  placeholder: 'Scoped renderer + tokens...',
                ),
                const SizedBox(height: 8),
                Text('Selected: ${_value ?? 'none'}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

final class DemoScopedDropdownTokenResolver implements RDropdownTokenResolver {
  const DemoScopedDropdownTokenResolver({required this.base});

  final RDropdownTokenResolver base;

  @override
  RDropdownResolvedTokens resolve({
    required BuildContext context,
    required RDropdownButtonSpec spec,
    required Set<WidgetState> triggerStates,
    required ROverlayPhase overlayPhase,
    BoxConstraints? constraints,
    RenderOverrides? overrides,
  }) {
    final tokens = base.resolve(
      context: context,
      spec: spec,
      triggerStates: triggerStates,
      overlayPhase: overlayPhase,
      constraints: constraints,
      overrides: overrides,
    );

    // Demo-only: push visual delta via tokens, not by changing component behavior.
    final trigger = tokens.trigger;
    return RDropdownResolvedTokens(
      trigger: RDropdownTriggerTokens(
        textStyle: trigger.textStyle,
        foregroundColor: trigger.foregroundColor,
        backgroundColor: trigger.backgroundColor,
        borderColor: Colors.teal,
        padding: trigger.padding,
        minSize: trigger.minSize,
        borderRadius: BorderRadius.circular(24),
        iconColor: Colors.teal,
        pressOverlayColor: trigger.pressOverlayColor,
        pressOpacity: trigger.pressOpacity,
      ),
      menu: tokens.menu,
      item: tokens.item,
    );
  }
}
