import 'package:flutter/cupertino.dart';
import 'package:headless/headless.dart';

import '../../../theme_mode_scope.dart';
import '../cupertino_demo_scope.dart';
import 'dropdown_demo_data.dart';
import 'dropdown_demo_cupertino_parity_surface.dart';
import 'dropdown_demo_option.dart';
import 'dropdown_demo_theme_preset_card.dart';
import 'dropdown_demo_theme_preset_comparison.dart';
import 'dropdown_demo_theme_preset_native_controls.dart';

class DropdownDemoThemeRichPresetCard extends StatefulWidget {
  const DropdownDemoThemeRichPresetCard({super.key});

  @override
  State<DropdownDemoThemeRichPresetCard> createState() =>
      _DropdownDemoThemeRichPresetCardState();
}

class _DropdownDemoThemeRichPresetCardState
    extends State<DropdownDemoThemeRichPresetCard> {
  DropdownDemoOption _selected = dropdownDemoTravelOptions[1];

  @override
  Widget build(BuildContext context) {
    final isCupertino = ThemeModeScope.of(context).isCupertino;

    return DropdownDemoThemePresetCard(
      title: 'Rich items',
      caption: isCupertino
          ? 'The same active Cupertino preset, but with richer item labels.'
          : 'The same Material preset, still using richer list rows.',
      child: DropdownDemoThemePresetComparison(
        nativeChild: isCupertino
            ? CupertinoDemoScope(
                child: DropdownDemoNativeCupertinoButton(
                  controlKey: const Key('dropdown-theme-rich-native'),
                  label: _selected.title,
                  onPressed: () => _openActionSheet(context),
                ),
              )
            : DropdownDemoNativeMaterialTravelField(
                value: _selected,
                onChanged: (value) => setState(() => _selected = value),
              ),
        headlessChild: isCupertino
            ? CupertinoDemoScope(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RDropdownButton<DropdownDemoOption>(
                    key: const Key('dropdown-theme-rich-headless'),
                    items: dropdownDemoTravelOptions,
                    itemAdapter: dropdownDemoOptionAdapter,
                    value: _selected,
                    onChanged: (value) => setState(() => _selected = value),
                    placeholder: 'Choose a desk',
                    semanticLabel: 'Theme preset dropdown rich selector',
                    slots: RDropdownButtonSlots(
                      anchor: Replace((ctx) {
                        return DropdownDemoCupertinoHeadlessAnchor(
                          key: const Key('dropdown-theme-rich-headless-surface'),
                          label: _selected.title,
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
            : RDropdownButton<DropdownDemoOption>(
                key: const Key('dropdown-theme-rich-headless'),
                items: dropdownDemoTravelOptions,
                itemAdapter: dropdownDemoOptionAdapter,
                value: _selected,
                onChanged: (value) => setState(() => _selected = value),
                placeholder: 'Choose a desk',
                semanticLabel: 'Theme preset dropdown rich selector',
                slots: RDropdownButtonSlots(
                  anchor: Decorate((ctx, child) {
                    return KeyedSubtree(
                      key: const Key('dropdown-theme-rich-headless-surface'),
                      child: child,
                    );
                  }),
                ),
              ),
      ),
    );
  }

  Future<void> _openActionSheet(BuildContext context) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text('Choose a desk'),
          actions: [
            for (final option in dropdownDemoTravelOptions)
              CupertinoActionSheetAction(
                onPressed: () {
                  setState(() => _selected = option);
                  Navigator.of(context).pop();
                },
                child: Text(option.title),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }
}
