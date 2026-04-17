import 'package:flutter/material.dart';

import 'dropdown_demo_data.dart';

class DropdownDemoUnderlineVisual extends StatelessWidget {
  const DropdownDemoUnderlineVisual({
    required this.value,
    required this.onChanged,
    this.ignorePointer = false,
    this.dropdownKey,
    super.key,
  });

  final String value;
  final ValueChanged<String?> onChanged;
  final bool ignorePointer;
  final Key? dropdownKey;

  @override
  Widget build(BuildContext context) {
    final dropdown = DropdownButton<String>(
      key: dropdownKey,
      value: value,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: onChanged,
      items: dropdownDemoFruitValues.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );

    if (!ignorePointer) return dropdown;
    return IgnorePointer(child: dropdown);
  }
}

class DropdownDemoSelectedItemVisual extends StatelessWidget {
  const DropdownDemoSelectedItemVisual({
    required this.value,
    required this.onChanged,
    this.ignorePointer = false,
    this.dropdownKey,
    super.key,
  });

  final String value;
  final ValueChanged<String?> onChanged;
  final bool ignorePointer;
  final Key? dropdownKey;

  @override
  Widget build(BuildContext context) {
    final dropdown = DropdownButton<String>(
      key: dropdownKey,
      value: value,
      onChanged: onChanged,
      selectedItemBuilder: (context) {
        return dropdownDemoCityCodes.values.map((code) {
          return Container(
            alignment: Alignment.centerLeft,
            constraints: const BoxConstraints(minWidth: 100),
            child: Text(
              code,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList();
      },
      items: dropdownDemoCityCodes.keys.map((city) {
        return DropdownMenuItem<String>(
          value: city,
          child: Text(city),
        );
      }).toList(),
    );

    if (!ignorePointer) return dropdown;
    return IgnorePointer(child: dropdown);
  }
}

class DropdownDemoFlutterMenuSurface extends StatelessWidget {
  const DropdownDemoFlutterMenuSurface({
    required this.triggerKey,
    required this.child,
    super.key,
  });

  static const EdgeInsetsGeometry _menuMargin = EdgeInsetsDirectional.only(
    start: 16,
    end: 24,
  );

  final GlobalKey triggerKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final resolvedMargin = _menuMargin.resolve(Directionality.of(context));
    final triggerBox =
        triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final triggerWidth = triggerBox?.size.width;
    final menuWidth = triggerWidth == null
        ? null
        : triggerWidth + resolvedMargin.horizontal;

    return Transform.translate(
      offset: Offset(-resolvedMargin.left, 0),
      child: SizedBox(width: menuWidth, child: child),
    );
  }
}
