import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

abstract final class SwitchTestKeys {
  static const switch_ = Key('test_switch');
  static const switchValue = Key('switch_value');
  static const listTile = Key('switch_list_tile');
  static const listTileValue = Key('switch_list_tile_value');
}

extension SwitchTesterExtensions on WidgetTester {
  Future<void> tapSwitch() async {
    await tap(find.byKey(SwitchTestKeys.switch_));
    await pumpAndSettle();
  }

  Future<void> tapListTile() async {
    await tap(find.byKey(SwitchTestKeys.listTile));
    await pumpAndSettle();
  }

  Future<void> pressSpace() async {
    await sendKeyDownEvent(LogicalKeyboardKey.space);
    await pump();
    await sendKeyUpEvent(LogicalKeyboardKey.space);
    await pumpAndSettle();
  }

  Future<void> pressEnter() async {
    await sendKeyDownEvent(LogicalKeyboardKey.enter);
    await pump();
    await sendKeyUpEvent(LogicalKeyboardKey.enter);
    await pumpAndSettle();
  }

  void expectSwitchValue(bool value) {
    expect(find.text('Value: $value'), findsOneWidget);
  }

  void expectListTileValue(bool value) {
    expect(find.text('Tile value: $value'), findsOneWidget);
  }
}
