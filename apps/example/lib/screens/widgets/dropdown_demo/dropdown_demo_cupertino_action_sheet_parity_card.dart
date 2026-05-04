import 'package:flutter/cupertino.dart';
import 'package:headless/headless.dart';

import '../cupertino_demo_scope.dart';
import '../cupertino_demo_parity_card.dart';
import 'dropdown_demo_data.dart';
import 'dropdown_demo_cupertino_parity_surface.dart';
import 'dropdown_demo_option.dart';
import 'dropdown_demo_theme_preset_comparison.dart';

class DropdownDemoCupertinoActionSheetParityCard extends StatefulWidget {
  const DropdownDemoCupertinoActionSheetParityCard({super.key});

  @override
  State<DropdownDemoCupertinoActionSheetParityCard> createState() =>
      _DropdownDemoCupertinoActionSheetParityCardState();
}

class _DropdownDemoCupertinoActionSheetParityCardState
    extends State<DropdownDemoCupertinoActionSheetParityCard> {
  DropdownDemoOption _selected = dropdownDemoEditorialOptions.first;

  Future<void> _openActionSheet(BuildContext context) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text('Choose an issue'),
          actions: [
            for (final option in dropdownDemoEditorialOptions)
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

  @override
  Widget build(BuildContext context) {
    return CupertinoDemoParityCard(
      title: 'Action sheet',
      caption:
          'For short lists, Flutter ships CupertinoActionSheet instead of a direct dropdown.',
      child: DropdownDemoThemePresetComparison(
        nativeChild: DropdownDemoCupertinoNativeTrigger(
          controlKey: const Key('dropdown-cupertino-action-native-trigger'),
          label: _selected.title,
          onPressed: () => _openActionSheet(context),
        ),
        headlessChild: CupertinoDemoScope(
          child: Align(
            alignment: Alignment.centerLeft,
            child: RDropdownButton<DropdownDemoOption>(
              key: const Key('dropdown-cupertino-action-headless-trigger'),
              value: _selected,
              onChanged: (value) {
                setState(() => _selected = value);
              },
              items: dropdownDemoEditorialOptions,
              itemAdapter: dropdownDemoOptionAdapter,
              placeholder: 'Choose an issue',
              semanticLabel: 'Headless cupertino action sheet parity dropdown',
              slots: RDropdownButtonSlots(
                anchor: Replace((ctx) {
                  return DropdownDemoCupertinoHeadlessAnchor(
                    key:
                        const Key('dropdown-cupertino-action-headless-surface'),
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
        ),
      ),
    );
  }
}
