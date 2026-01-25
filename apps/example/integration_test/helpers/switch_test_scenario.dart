import 'package:flutter/material.dart';
import 'package:headless_switch/headless_switch.dart';

import 'switch_test_helpers.dart';

class SwitchTestScenario extends StatefulWidget {
  const SwitchTestScenario({
    super.key,
    this.initialValue = false,
    this.disabled = false,
    this.autofocus = false,
  });

  final bool initialValue;
  final bool disabled;
  final bool autofocus;

  @override
  State<SwitchTestScenario> createState() => _SwitchTestScenarioState();
}

class _SwitchTestScenarioState extends State<SwitchTestScenario> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RSwitch(
            key: SwitchTestKeys.switch_,
            value: _value,
            autofocus: widget.autofocus,
            onChanged: widget.disabled ? null : (v) => setState(() => _value = v),
          ),
          const SizedBox(height: 16),
          Text(
            'Value: $_value',
            key: SwitchTestKeys.switchValue,
          ),
        ],
      ),
    );
  }
}

class SwitchListTileTestScenario extends StatefulWidget {
  const SwitchListTileTestScenario({
    super.key,
    this.initialValue = false,
    this.disabled = false,
  });

  final bool initialValue;
  final bool disabled;

  @override
  State<SwitchListTileTestScenario> createState() =>
      _SwitchListTileTestScenarioState();
}

class _SwitchListTileTestScenarioState extends State<SwitchListTileTestScenario> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 320,
            child: RSwitchListTile(
              key: SwitchTestKeys.listTile,
              value: _value,
              onChanged: widget.disabled ? null : (v) => setState(() => _value = v),
              title: const Text('Tile title'),
              subtitle: const Text('Tile subtitle'),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tile value: $_value',
            key: SwitchTestKeys.listTileValue,
          ),
        ],
      ),
    );
  }
}
