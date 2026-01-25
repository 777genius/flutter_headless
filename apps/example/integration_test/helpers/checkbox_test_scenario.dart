import 'package:flutter/material.dart';
import 'package:headless_checkbox/headless_checkbox.dart';

import 'checkbox_test_helpers.dart';

class CheckboxTestScenario extends StatefulWidget {
  const CheckboxTestScenario({
    super.key,
    this.initialValue = false,
    this.tristate = false,
  });

  final bool? initialValue;
  final bool tristate;

  @override
  State<CheckboxTestScenario> createState() => _CheckboxTestScenarioState();
}

class _CheckboxTestScenarioState extends State<CheckboxTestScenario> {
  late bool? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final displayValue = _value?.toString() ?? 'null';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RCheckbox(
            key: CheckboxTestKeys.checkbox,
            value: _value,
            tristate: widget.tristate,
            onChanged: (v) => setState(() => _value = v),
          ),
          const SizedBox(height: 16),
          Text(
            'Value: $displayValue',
            key: CheckboxTestKeys.checkboxValue,
          ),
        ],
      ),
    );
  }
}

class CheckboxListTileTestScenario extends StatefulWidget {
  const CheckboxListTileTestScenario({
    super.key,
    this.initialValue = false,
    this.tristate = false,
  });

  final bool? initialValue;
  final bool tristate;

  @override
  State<CheckboxListTileTestScenario> createState() =>
      _CheckboxListTileTestScenarioState();
}

class _CheckboxListTileTestScenarioState
    extends State<CheckboxListTileTestScenario> {
  late bool? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final displayValue = _value?.toString() ?? 'null';
    final isSelected = _value == true;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 320,
            child: RCheckboxListTile(
              key: CheckboxTestKeys.listTile,
              value: _value,
              tristate: widget.tristate,
              selected: isSelected,
              onChanged: (v) => setState(() => _value = v),
              title: const Text('Tile title'),
              subtitle: const Text('Tile subtitle'),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tile value: $displayValue',
            key: CheckboxTestKeys.listTileValue,
          ),
          Text(
            'Selected: $isSelected',
            key: CheckboxTestKeys.listTileSelected,
          ),
        ],
      ),
    );
  }
}

