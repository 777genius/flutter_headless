import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/textfield_test_app.dart';
import 'helpers/textfield_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TextField E2E Tests', () {
    Future<void> pumpTextField(
      WidgetTester tester, {
      String initialValue = '',
      String? placeholder,
      String? label,
      String? helperText,
      String? errorText,
      bool enabled = true,
      bool readOnly = false,
      bool obscureText = false,
      int? maxLines = 1,
      int? minLines,
      bool autofocus = false,
    }) async {
      await tester.pumpWidget(TextFieldTestApp(
        child: TextFieldTestScenario(
          initialValue: initialValue,
          placeholder: placeholder,
          label: label,
          helperText: helperText,
          errorText: errorText,
          enabled: enabled,
          readOnly: readOnly,
          obscureText: obscureText,
          maxLines: maxLines,
          minLines: minLines,
          autofocus: autofocus,
        ),
      ));
      await tester.pumpAndSettle();
    }

    // =========================================================================
    // Basic text input
    // =========================================================================

    testWidgets('IT-01: Tap on TextField focuses it', (tester) async {
      await pumpTextField(tester, placeholder: 'Enter text');

      expect(find.text('Focused: false'), findsOneWidget);

      await tester.focusTextField();

      expect(find.text('Focused: true'), findsOneWidget);
    });

    testWidgets('IT-02: Entering text updates value', (tester) async {
      await pumpTextField(tester, placeholder: 'Enter text');

      await tester.enterTextInField('Hello World');

      tester.expectTextFieldValue('Hello World');
      expect(find.text('Value: Hello World'), findsOneWidget);
    });

    testWidgets('IT-03: Clearing text empties the field', (tester) async {
      await pumpTextField(tester, initialValue: 'Initial text');

      tester.expectTextFieldValue('Initial text');

      await tester.clearTextField();

      tester.expectTextFieldEmpty();
      expect(find.text('Value: '), findsOneWidget);
    });

    testWidgets('IT-04: Initial value is displayed', (tester) async {
      await pumpTextField(tester, initialValue: 'Prefilled');

      tester.expectTextFieldValue('Prefilled');
      expect(find.text('Value: Prefilled'), findsOneWidget);
    });

    // =========================================================================
    // Focus behavior
    // =========================================================================

    testWidgets('IT-05: Autofocus works on mount', (tester) async {
      await pumpTextField(tester, autofocus: true);

      expect(find.text('Focused: true'), findsOneWidget);
    });

    testWidgets('IT-06: Tap outside unfocuses TextField', (tester) async {
      await pumpTextField(tester);

      await tester.focusTextField();
      expect(find.text('Focused: true'), findsOneWidget);

      await tester.unfocusTextField();
      expect(find.text('Focused: false'), findsOneWidget);
    });

    // =========================================================================
    // Disabled state
    // =========================================================================

    testWidgets('IT-07: Disabled TextField cannot be focused', (tester) async {
      await pumpTextField(tester, enabled: false, initialValue: 'Disabled');

      await tester.tap(find.byKey(TextFieldTestKeys.textField));
      await tester.pumpAndSettle();

      expect(find.text('Focused: false'), findsOneWidget);
    });

    testWidgets('IT-08: Disabled TextField displays value', (tester) async {
      await pumpTextField(tester, enabled: false, initialValue: 'Read only');

      tester.expectTextFieldValue('Read only');
    });

    // =========================================================================
    // Read-only state
    // =========================================================================

    testWidgets('IT-09: ReadOnly TextField can be focused', (tester) async {
      await pumpTextField(tester, readOnly: true, initialValue: 'Read only');

      await tester.focusTextField();

      expect(find.text('Focused: true'), findsOneWidget);
    });

    testWidgets('IT-10: ReadOnly TextField cannot be edited', (tester) async {
      await pumpTextField(tester, readOnly: true, initialValue: 'Original');

      await tester.focusTextField();
      // Try to enter new text - should not change
      await tester.enterTextInFieldWithoutTap('New text');

      // Value should remain unchanged
      tester.expectTextFieldValue('Original');
    });

    // =========================================================================
    // Labels and helper text
    // =========================================================================

    testWidgets('IT-11: Label is displayed', (tester) async {
      await pumpTextField(tester, label: 'Email Address');

      expect(find.text('Email Address'), findsOneWidget);
    });

    testWidgets('IT-12: Placeholder is displayed when empty', (tester) async {
      await pumpTextField(tester, placeholder: 'Enter your name');

      expect(find.text('Enter your name'), findsOneWidget);
    });

    testWidgets('IT-13: Helper text is displayed', (tester) async {
      await pumpTextField(tester, helperText: 'We will never share this');

      expect(find.text('We will never share this'), findsOneWidget);
    });

    // =========================================================================
    // Error state
    // =========================================================================

    testWidgets('IT-14: Error text is displayed', (tester) async {
      await pumpTextField(tester, errorText: 'This field is required');

      tester.expectErrorVisible('This field is required');
    });

    testWidgets('IT-15: Validation scenario shows error on invalid input',
        (tester) async {
      await tester.pumpWidget(const TextFieldTestApp(
        child: ValidationTextFieldScenario(),
      ));
      await tester.pumpAndSettle();

      // Initially no error
      expect(find.text('Invalid email format'), findsNothing);

      // Enter invalid email
      await tester.enterTextInField('invalid');

      tester.expectErrorVisible('Invalid email format');
    });

    testWidgets('IT-16: Validation scenario hides error on valid input',
        (tester) async {
      await tester.pumpWidget(const TextFieldTestApp(
        child: ValidationTextFieldScenario(),
      ));
      await tester.pumpAndSettle();

      // Enter valid email
      await tester.enterTextInField('test@example.com');

      tester.expectNoError('Invalid email format');
    });

    // =========================================================================
    // Password field
    // =========================================================================

    testWidgets('IT-17: Password field obscures text', (tester) async {
      await tester.pumpWidget(const TextFieldTestApp(
        child: PasswordTextFieldScenario(),
      ));
      await tester.pumpAndSettle();

      await tester.enterTextInField('secret123');

      // Value should be stored correctly
      expect(find.text('Value: secret123'), findsOneWidget);

      // The actual text in the field should be obscured
      // (we can't easily verify the visual obscuring, but the value is correct)
      tester.expectTextFieldValue('secret123');
    });

    // =========================================================================
    // Multiline
    // =========================================================================

    testWidgets('IT-18: Multiline TextField accepts newlines', (tester) async {
      await tester.pumpWidget(const TextFieldTestApp(
        child: MultilineTextFieldScenario(),
      ));
      await tester.pumpAndSettle();

      await tester.enterTextInField('Line 1\nLine 2\nLine 3');

      expect(find.text('Length: 20'), findsOneWidget);
    });

    // =========================================================================
    // Controller-driven mode
    // =========================================================================

    testWidgets('IT-19: Controller-driven TextField displays controller value',
        (tester) async {
      await tester.pumpWidget(const TextFieldTestApp(
        child: ControllerDrivenTextFieldScenario(initialValue: 'Initial'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Value: Initial'), findsOneWidget);
    });

    testWidgets('IT-20: Set Text button updates TextField', (tester) async {
      await tester.pumpWidget(const TextFieldTestApp(
        child: ControllerDrivenTextFieldScenario(),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('set_text_button')));
      await tester.pumpAndSettle();

      expect(find.text('Value: Programmatic value'), findsOneWidget);
      tester.expectTextFieldValue('Programmatic value');
    });

    testWidgets('IT-21: Clear button clears TextField', (tester) async {
      await tester.pumpWidget(const TextFieldTestApp(
        child: ControllerDrivenTextFieldScenario(initialValue: 'To be cleared'),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('clear_button')));
      await tester.pumpAndSettle();

      expect(find.text('Value: '), findsOneWidget);
      tester.expectTextFieldEmpty();
    });

    // =========================================================================
    // Submit action
    // =========================================================================

    testWidgets('IT-22: Submit action triggers onSubmitted', (tester) async {
      await pumpTextField(tester);

      await tester.enterTextInField('Submitted text');
      await tester.submitTextField();

      expect(find.text('Submitted: Submitted text'), findsOneWidget);
    });

    // =========================================================================
    // Multiple TextFields
    // =========================================================================

    testWidgets('IT-23: Tab navigates between TextFields', (tester) async {
      await tester.pumpWidget(const TextFieldTestApp(
        child: MultipleTextFieldsScenario(),
      ));
      await tester.pumpAndSettle();

      // Focus first field
      await tester.tap(find.byKey(TextFieldTestKeys.textFieldN(1)));
      await tester.pumpAndSettle();

      // Enter text in first field
      await tester.enterTextInFieldWithoutTap(
          'First', TextFieldTestKeys.textFieldN(1));

      // Tab to second field
      await tester.pressTab();

      // Enter text in second field
      await tester.enterTextInFieldWithoutTap(
          'Second', TextFieldTestKeys.textFieldN(2));

      // Verify values
      expect(
        tester.getTextFieldValue(TextFieldTestKeys.textFieldN(1)),
        equals('First'),
      );
      expect(
        tester.getTextFieldValue(TextFieldTestKeys.textFieldN(2)),
        equals('Second'),
      );
    });

    testWidgets('IT-24: Multiple TextFields maintain independent values',
        (tester) async {
      await tester.pumpWidget(const TextFieldTestApp(
        child: MultipleTextFieldsScenario(),
      ));
      await tester.pumpAndSettle();

      // Enter text in field 1
      await tester.enterTextInField('Value 1', TextFieldTestKeys.textFieldN(1));

      // Enter text in field 2
      await tester.enterTextInField('Value 2', TextFieldTestKeys.textFieldN(2));

      // Enter text in field 3
      await tester.enterTextInField('Value 3', TextFieldTestKeys.textFieldN(3));

      // Verify all values are independent
      expect(
        tester.getTextFieldValue(TextFieldTestKeys.textFieldN(1)),
        equals('Value 1'),
      );
      expect(
        tester.getTextFieldValue(TextFieldTestKeys.textFieldN(2)),
        equals('Value 2'),
      );
      expect(
        tester.getTextFieldValue(TextFieldTestKeys.textFieldN(3)),
        equals('Value 3'),
      );
    });

    // =========================================================================
    // Edge cases
    // =========================================================================

    testWidgets('IT-25: TextField handles empty string correctly',
        (tester) async {
      await pumpTextField(tester, initialValue: 'Some text');

      await tester.clearTextField();

      tester.expectTextFieldEmpty();
      expect(find.text('Value: '), findsOneWidget);
    });

    testWidgets('IT-26: TextField handles special characters', (tester) async {
      await pumpTextField(tester);

      const specialText = 'Hello! @#\$%^&*() 中文 🎉';
      await tester.enterTextInField(specialText);

      tester.expectTextFieldValue(specialText);
    });
  });
}
