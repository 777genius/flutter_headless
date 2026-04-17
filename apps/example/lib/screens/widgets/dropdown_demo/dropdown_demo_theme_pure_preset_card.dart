import 'package:flutter/cupertino.dart';
import 'package:headless/headless.dart';

import '../../../theme_mode_scope.dart';
import '../cupertino_demo_scope.dart';
import 'dropdown_demo_data.dart';
import 'dropdown_demo_cupertino_parity_surface.dart';
import 'dropdown_demo_theme_preset_card.dart';
import 'dropdown_demo_theme_preset_comparison.dart';
import 'dropdown_demo_theme_preset_native_controls.dart';

class DropdownDemoThemePurePresetCard extends StatefulWidget {
  const DropdownDemoThemePurePresetCard({super.key});

  @override
  State<DropdownDemoThemePurePresetCard> createState() =>
      _DropdownDemoThemePurePresetCardState();
}

class _DropdownDemoThemePurePresetCardState
    extends State<DropdownDemoThemePurePresetCard> {
  String _selected = 'San Francisco';

  @override
  Widget build(BuildContext context) {
    final isCupertino = ThemeModeScope.of(context).isCupertino;

    return DropdownDemoThemePresetCard(
      title: 'Pure preset',
      caption: isCupertino
          ? 'The active Cupertino preset beside the native picker trigger.'
          : 'The active Material preset beside the native Flutter field.',
      child: DropdownDemoThemePresetComparison(
        nativeChild: isCupertino
            ? CupertinoDemoScope(
                child: DropdownDemoNativeCupertinoButton(
                  controlKey: const Key('dropdown-theme-pure-native'),
                  label: _selected,
                  onPressed: () => _openPicker(context),
                ),
              )
            : DropdownDemoNativeMaterialCityField(
                value: _selected,
                onChanged: (value) => setState(() => _selected = value),
              ),
        headlessChild: isCupertino
            ? CupertinoDemoScope(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RDropdownButton<String>(
                    key: const Key('dropdown-theme-pure-headless'),
                    items: dropdownDemoCityCodes.keys.toList(),
                    itemAdapter: dropdownDemoCityAdapter,
                    value: _selected,
                    onChanged: (value) => setState(() => _selected = value),
                    placeholder: 'Choose a city',
                    semanticLabel: 'Theme preset dropdown city selector',
                    slots: RDropdownButtonSlots(
                      anchor: Replace((ctx) {
                        return DropdownDemoCupertinoHeadlessAnchor(
                          key: const Key('dropdown-theme-pure-headless-surface'),
                          label: _selected,
                          isOpen: ctx.state.isOpen,
                        );
                      }),
                    ),
                    overrides: RenderOverrides.only(
                      const RDropdownOverrides.tokens(
                        triggerBackgroundColor: CupertinoColors.transparent,
                        triggerBorderColor: CupertinoColors.transparent,
                        triggerPadding: EdgeInsets.zero,
                        triggerMinSize: Size(0, 44),
                      ),
                    ),
                  ),
                ),
              )
            : RDropdownButton<String>(
                key: const Key('dropdown-theme-pure-headless'),
                items: dropdownDemoCityCodes.keys.toList(),
                itemAdapter: dropdownDemoCityAdapter,
                value: _selected,
                onChanged: (value) => setState(() => _selected = value),
                placeholder: 'Choose a city',
                semanticLabel: 'Theme preset dropdown city selector',
                slots: RDropdownButtonSlots(
                  anchor: Decorate((ctx, child) {
                    return KeyedSubtree(
                      key: const Key('dropdown-theme-pure-headless-surface'),
                      child: child,
                    );
                  }),
                ),
              ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final cities = dropdownDemoCityCodes.keys.toList();
    final initialIndex = cities.indexOf(_selected);
    final controller = FixedExtentScrollController(
      initialItem: initialIndex < 0 ? 0 : initialIndex,
    );
    var pendingIndex = initialIndex < 0 ? 0 : initialIndex;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        final background = CupertinoDynamicColor.resolve(
          CupertinoColors.systemBackground,
          context,
        );
        final border = CupertinoDynamicColor.resolve(
          CupertinoColors.separator,
          context,
        );

        return SizedBox(
          height: 280,
          child: DecoratedBox(
            decoration: BoxDecoration(color: background),
            child: Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: border)),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CupertinoButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Done'),
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: controller,
                    itemExtent: 32,
                    onSelectedItemChanged: (index) {
                      pendingIndex = index;
                      setState(() => _selected = cities[index]);
                    },
                    children: [
                      for (final city in cities) Center(child: Text(city)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    controller.dispose();
    setState(() => _selected = cities[pendingIndex]);
  }
}
