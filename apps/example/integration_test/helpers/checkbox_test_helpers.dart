import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

abstract final class CheckboxTestKeys {
  static const checkbox = Key('checkbox');
  static const checkboxValue = Key('checkbox_value');
  static const listTile = Key('checkbox_list_tile');
  static const listTileValue = Key('checkbox_list_tile_value');
  static const listTileSelected = Key('checkbox_list_tile_selected');
}

extension CheckboxTesterExtensions on WidgetTester {
  Future<void> tapCheckbox() async {
    await tap(find.byKey(CheckboxTestKeys.checkbox));
    await pumpAndSettle();
  }

  Future<void> tapListTile() async {
    await tap(find.byKey(CheckboxTestKeys.listTile));
    await pumpAndSettle();
  }

  void expectCheckboxValue(String value) {
    expect(find.text('Value: $value'), findsOneWidget);
  }

  void expectListTileValue(String value) {
    expect(find.text('Tile value: $value'), findsOneWidget);
  }

  void expectListTileSelected(String value) {
    expect(find.text('Selected: $value'), findsOneWidget);
  }
}
