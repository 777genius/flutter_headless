import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'demo_section.dart';

class ScopedDropdownRendererDemoSection extends StatefulWidget {
  const ScopedDropdownRendererDemoSection({
    super.key,
    required this.isDisabled,
    required this.items,
    required this.itemAdapter,
  });

  final bool isDisabled;
  final List<String> items;
  final HeadlessItemAdapter<String> itemAdapter;

  @override
  State<ScopedDropdownRendererDemoSection> createState() =>
      _ScopedDropdownRendererDemoSectionState();
}

class _ScopedDropdownRendererDemoSectionState
    extends State<ScopedDropdownRendererDemoSection> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'D4 - Scoped Capability Override (Renderer)',
      description: 'Override only RDropdownButtonRenderer in subtree.\n'
          'Behavior stays the same; visuals change without forking the theme.',
      child: Builder(
        builder: (context) {
          final baseTheme = HeadlessThemeProvider.themeOf(context);
          final baseRenderer = requireCapability<RDropdownButtonRenderer>(
            baseTheme,
            componentName: 'ScopedDropdownRendererDemoSection',
          );

          return HeadlessThemeOverridesScope.only<RDropdownButtonRenderer>(
            capability: DemoScopedDropdownRenderer(base: baseRenderer),
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
                  placeholder: 'Scoped renderer override...',
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

final class DemoScopedDropdownRenderer implements RDropdownButtonRenderer {
  const DemoScopedDropdownRenderer({required this.base});

  final RDropdownButtonRenderer base;

  @override
  Widget render(RDropdownRenderRequest request) {
    final built = base.render(request);

    if (request is! RDropdownTriggerRenderRequest) {
      return built;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius:
                request.resolvedTokens?.trigger.borderRadius ??
                    BorderRadius.circular(12),
            border: Border.all(
              color: Colors.teal,
              width: 2,
            ),
          ),
          child: built,
        ),
        Positioned(
          top: -10,
          left: 12,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                'SCOPED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

