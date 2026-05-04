import 'package:flutter/cupertino.dart';
import 'package:headless/headless.dart';

import '../cupertino_demo_scope.dart';
import '../cupertino_demo_parity_card.dart';
import 'dropdown_demo_data.dart';
import 'dropdown_demo_cupertino_parity_surface.dart';
import 'dropdown_demo_theme_preset_comparison.dart';

class DropdownDemoCupertinoPickerParityCard extends StatefulWidget {
  const DropdownDemoCupertinoPickerParityCard({super.key});

  @override
  State<DropdownDemoCupertinoPickerParityCard> createState() =>
      _DropdownDemoCupertinoPickerParityCardState();
}

class _DropdownDemoCupertinoPickerParityCardState
    extends State<DropdownDemoCupertinoPickerParityCard> {
  int _selectedIndex = 0;

  String get _selectedValue => dropdownDemoFruitValues[_selectedIndex];

  Future<void> _openPicker(BuildContext context) async {
    final controller = FixedExtentScrollController(initialItem: _selectedIndex);
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

        return Container(
          height: 280,
          color: background,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: border),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    setState(() => _selectedIndex = index);
                  },
                  children: [
                    for (final value in dropdownDemoFruitValues)
                      Center(child: Text(value)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoDemoParityCard(
      title: 'Picker popup',
      caption:
          'The standard Flutter Cupertino selection flow uses a modal picker instead of DropdownButton.',
      child: DropdownDemoThemePresetComparison(
        nativeChild: DropdownDemoCupertinoNativeTrigger(
          controlKey: const Key('dropdown-cupertino-picker-native-trigger'),
          label: _selectedValue,
          onPressed: () => _openPicker(context),
        ),
        headlessChild: CupertinoDemoScope(
          child: Align(
            alignment: Alignment.centerLeft,
            child: RDropdownButton<String>(
              key: const Key('dropdown-cupertino-picker-headless-trigger'),
              value: _selectedValue,
              onChanged: (value) {
                setState(() {
                  _selectedIndex = dropdownDemoFruitValues.indexOf(value);
                });
              },
              items: dropdownDemoFruitValues,
              itemAdapter: dropdownDemoFruitAdapter,
              semanticLabel: 'Headless cupertino picker parity dropdown',
              slots: RDropdownButtonSlots(
                anchor: Replace((ctx) {
                  return DropdownDemoCupertinoHeadlessAnchor(
                    key:
                        const Key('dropdown-cupertino-picker-headless-surface'),
                    label: _selectedValue,
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
