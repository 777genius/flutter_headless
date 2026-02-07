import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'dropdown_test_helpers.dart';

/// Test app wrapper with proper AnchoredOverlayEngineHost setup.
class DropdownTestApp extends StatefulWidget {
  const DropdownTestApp({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<DropdownTestApp> createState() => _DropdownTestAppState();
}

class _DropdownTestAppState extends State<DropdownTestApp> {
  final _overlayController = OverlayController();

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeadlessThemeProvider(
      theme: MaterialHeadlessTheme(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnchoredOverlayEngineHost(
          controller: _overlayController,
          child: Scaffold(body: widget.child),
        ),
      ),
    );
  }
}

/// Simple dropdown test scenario widget.
class DropdownTestScenario extends StatefulWidget {
  const DropdownTestScenario({
    super.key,
    this.disabled = false,
    this.initialValue,
    this.items,
    this.itemAdapter,
  });

  final bool disabled;
  final String? initialValue;
  final List<String>? items;
  final HeadlessItemAdapter<String>? itemAdapter;

  @override
  State<DropdownTestScenario> createState() => DropdownTestScenarioState();
}

class DropdownTestScenarioState extends State<DropdownTestScenario> {
  late String? _selectedValue;
  int selectionCount = 0;

  String? get selectedValue => _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RDropdownButton<String>(
            key: DropdownTestKeys.dropdown,
            value: _selectedValue,
            disabled: widget.disabled,
            placeholder: 'Select a fruit',
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
                selectionCount++;
              });
            },
            items: widget.items ?? DropdownTestItems.fruits,
            itemAdapter: widget.itemAdapter ?? DropdownTestItems.fruitAdapter,
          ),
          const SizedBox(height: 20),
          Text(
            'Selected: ${_selectedValue ?? 'None'}',
            key: DropdownTestKeys.selectionLabel,
          ),
          Text(
            'Selection count: $selectionCount',
            key: DropdownTestKeys.selectionCount,
          ),
        ],
      ),
    );
  }
}

/// Test scenario with scrollable page for scroll passthrough testing.
class ScrollableDropdownScenario extends StatefulWidget {
  const ScrollableDropdownScenario({super.key});

  @override
  State<ScrollableDropdownScenario> createState() =>
      _ScrollableDropdownScenarioState();
}

class _ScrollableDropdownScenarioState
    extends State<ScrollableDropdownScenario> {
  String? _selectedValue;
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: DropdownTestKeys.scrollablePage,
      controller: _scrollController,
      child: Column(
        children: [
          const SizedBox(height: 100),
          RDropdownButton<String>(
            key: DropdownTestKeys.dropdown,
            value: _selectedValue,
            placeholder: 'Select a fruit',
            onChanged: (v) => setState(() => _selectedValue = v),
            items: DropdownTestItems.fruits,
            itemAdapter: DropdownTestItems.fruitAdapter,
          ),
          for (int i = 0; i < 50; i++)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Item $i'),
            ),
        ],
      ),
    );
  }
}

/// Test scenario with multiple dropdowns stacked vertically.
class MultipleDropdownsScenario extends StatefulWidget {
  const MultipleDropdownsScenario({super.key});

  @override
  State<MultipleDropdownsScenario> createState() =>
      _MultipleDropdownsScenarioState();
}

class _MultipleDropdownsScenarioState extends State<MultipleDropdownsScenario> {
  final _values = <int, String?>{};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 1; i <= 3; i++) ...[
            Text('Dropdown $i:'),
            const SizedBox(height: 8),
            RDropdownButton<String>(
              key: DropdownTestKeys.dropdownN(i),
              value: _values[i],
              placeholder: 'Select...',
              onChanged: (v) => setState(() => _values[i] = v),
              items: DropdownTestItems.fruitsShort,
              itemAdapter: DropdownTestItems.fruitAdapter,
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}
