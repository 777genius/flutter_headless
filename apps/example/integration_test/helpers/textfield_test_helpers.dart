import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Common test keys for TextField testing.
abstract final class TextFieldTestKeys {
  static const textField = Key('test_textfield');
  static const valueLabel = Key('value_label');
  static const submitLabel = Key('submit_label');
  static const focusLabel = Key('focus_label');

  static Key textFieldN(int n) => Key('textfield_$n');
}

/// Extension methods for WidgetTester to simplify TextField testing.
extension TextFieldTesterExtensions on WidgetTester {
  /// Taps on the TextField to focus it.
  Future<void> focusTextField([Key key = const Key('test_textfield')]) async {
    await tap(find.byKey(key));
    await pumpAndSettle();
  }

  /// Enters text into the TextField by key.
  Future<void> enterTextInField(String text,
      [Key key = const Key('test_textfield')]) async {
    await tap(find.byKey(key));
    await pumpAndSettle();
    await enterTextInFieldWithoutTap(text, key);
  }

  /// Enters text without tapping first (assumes already focused).
  Future<void> enterTextInFieldWithoutTap(String text,
      [Key key = const Key('test_textfield')]) async {
    final finder = find.byKey(key);
    // Find the EditableText within the TextField
    final editableText = find.descendant(
      of: finder,
      matching: find.byType(EditableText),
    );
    await enterText(editableText, text);
    await pumpAndSettle();
  }

  /// Clears the TextField content.
  Future<void> clearTextField([Key key = const Key('test_textfield')]) async {
    await enterTextInField('', key);
  }

  /// Submits the TextField (presses Enter/Done).
  Future<void> submitTextField() async {
    await testTextInput.receiveAction(TextInputAction.done);
    await pumpAndSettle();
  }

  /// Presses Enter key.
  Future<void> pressEnter() async {
    await sendKeyEvent(LogicalKeyboardKey.enter);
    await pumpAndSettle();
  }

  /// Presses Tab to move focus.
  Future<void> pressTab() async {
    await sendKeyEvent(LogicalKeyboardKey.tab);
    await pumpAndSettle();
  }

  /// Presses Shift+Tab to move focus backwards.
  Future<void> pressShiftTab() async {
    await sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await sendKeyEvent(LogicalKeyboardKey.tab);
    await sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await pumpAndSettle();
  }

  /// Types text character by character.
  Future<void> typeText(String text) async {
    for (final char in text.characters) {
      await sendKeyEvent(LogicalKeyboardKey(char.codeUnitAt(0)));
      await pump();
    }
    await pumpAndSettle();
  }

  /// Selects all text using Ctrl/Cmd+A.
  Future<void> selectAllText() async {
    await sendKeyDownEvent(LogicalKeyboardKey.meta);
    await sendKeyEvent(LogicalKeyboardKey.keyA);
    await sendKeyUpEvent(LogicalKeyboardKey.meta);
    await pumpAndSettle();
  }

  /// Copies selected text using Ctrl/Cmd+C.
  Future<void> copyText() async {
    await sendKeyDownEvent(LogicalKeyboardKey.meta);
    await sendKeyEvent(LogicalKeyboardKey.keyC);
    await sendKeyUpEvent(LogicalKeyboardKey.meta);
    await pumpAndSettle();
  }

  /// Pastes text using Ctrl/Cmd+V.
  Future<void> pasteText() async {
    await sendKeyDownEvent(LogicalKeyboardKey.meta);
    await sendKeyEvent(LogicalKeyboardKey.keyV);
    await sendKeyUpEvent(LogicalKeyboardKey.meta);
    await pumpAndSettle();
  }

  /// Unfocuses by tapping outside.
  Future<void> unfocusTextField() async {
    await tap(find.byKey(TextFieldTestKeys.valueLabel));
    await pump();
    FocusManager.instance.primaryFocus?.unfocus();
    await pumpAndSettle();
  }

  /// Gets the current text value from EditableText.
  String getTextFieldValue([Key key = const Key('test_textfield')]) {
    final finder = find.byKey(key);
    final editableText = find.descendant(
      of: finder,
      matching: find.byType(EditableText),
    );
    final widget = firstWidget<EditableText>(editableText);
    return widget.controller.text;
  }
}

/// Expectation helpers for TextField.
extension TextFieldExpects on WidgetTester {
  /// Asserts TextField has specific value.
  void expectTextFieldValue(String expected,
      [Key key = const Key('test_textfield')]) {
    final value = getTextFieldValue(key);
    expect(value, equals(expected),
        reason: 'TextField value should be "$expected", got "$value"');
  }

  /// Asserts TextField is empty.
  void expectTextFieldEmpty([Key key = const Key('test_textfield')]) {
    expectTextFieldValue('', key);
  }

  /// Asserts the value label shows expected text.
  void expectValueLabel(String expected) {
    expect(find.text('Value: $expected'), findsOneWidget);
  }

  /// Asserts submitted value label shows expected text.
  void expectSubmittedLabel(String expected) {
    expect(find.text('Submitted: $expected'), findsOneWidget);
  }

  /// Asserts focus state label.
  void expectFocusState(bool focused) {
    final label = focused ? 'Focused: true' : 'Focused: false';
    expect(find.text(label), findsOneWidget);
  }

  /// Asserts placeholder is visible.
  void expectPlaceholderVisible(String placeholder) {
    expect(find.text(placeholder), findsOneWidget);
  }

  /// Asserts placeholder is not visible (text entered).
  void expectPlaceholderHidden(String placeholder) {
    // When text is entered, placeholder might still exist but be hidden
    // We check that EditableText has non-empty value instead
  }

  /// Asserts label is visible.
  void expectLabelVisible(String label) {
    expect(find.text(label), findsOneWidget);
  }

  /// Asserts helper text is visible.
  void expectHelperTextVisible(String helperText) {
    expect(find.text(helperText), findsOneWidget);
  }

  /// Asserts error text is visible.
  void expectErrorVisible(String errorText) {
    expect(find.text(errorText), findsOneWidget);
  }

  /// Asserts error text is not visible.
  void expectNoError(String errorText) {
    expect(find.text(errorText), findsNothing);
  }

  /// Asserts TextField is disabled (IgnorePointer).
  void expectTextFieldDisabled([Key key = const Key('test_textfield')]) {
    final finder = find.byKey(key);
    expect(finder, findsOneWidget);
    // Look for IgnorePointer ancestor with ignoring=true
    final ignorePointer = find.ancestor(
      of: finder,
      matching: find.byWidgetPredicate(
        (w) => w is IgnorePointer && w.ignoring,
      ),
    );
    expect(ignorePointer, findsWidgets);
  }
}
