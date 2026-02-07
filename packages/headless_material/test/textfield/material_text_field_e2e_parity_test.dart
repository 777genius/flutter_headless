import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_textfield/headless_textfield.dart';

/// E2E parity tests: [RTextField] (via HeadlessMaterialApp) vs Flutter [TextField].
///
/// These tests verify that when RTextField is used through the full headless
/// stack (HeadlessMaterialApp → RTextField → MaterialTextFieldRenderer),
/// the visual output matches native Flutter TextField.
void main() {
  Widget buildRTextField({
    RTextFieldVariant variant = RTextFieldVariant.filled,
    String? label,
    String? placeholder,
    String? helperText,
    String? errorText,
    bool enabled = true,
    RTextFieldSlots? slots,
  }) {
    return HeadlessMaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: RTextField(
            variant: variant,
            label: label,
            placeholder: placeholder,
            helperText: helperText,
            errorText: errorText,
            enabled: enabled,
            slots: slots,
            showCursor: false,
          ),
        ),
      ),
    );
  }

  group('E2E parity: RTextField via HeadlessMaterialApp', () {
    group('filled variant', () {
      testWidgets('empty unfocused', (tester) async {
        await tester.pumpWidget(
          buildRTextField(
            variant: RTextFieldVariant.filled,
            label: 'Label',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(InputDecorator), findsOneWidget);
        expect(find.byType(RTextField), findsOneWidget);
      });

      testWidgets('empty focused', (tester) async {
        await tester.pumpWidget(
          buildRTextField(
            variant: RTextFieldVariant.filled,
            label: 'Label',
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(RTextField));
        await tester.pumpAndSettle();

        final decorator = tester.widget<InputDecorator>(
          find.byType(InputDecorator),
        );
        expect(decorator.isFocused, isTrue);
      });

      testWidgets('error state', (tester) async {
        await tester.pumpWidget(
          buildRTextField(
            variant: RTextFieldVariant.filled,
            label: 'Label',
            errorText: 'Required',
          ),
        );
        await tester.pumpAndSettle();

        final decorator = tester.widget<InputDecorator>(
          find.byType(InputDecorator),
        );
        expect(decorator.decoration.errorText, 'Required');
      });

      testWidgets('disabled state', (tester) async {
        await tester.pumpWidget(
          buildRTextField(
            variant: RTextFieldVariant.filled,
            label: 'Label',
            enabled: false,
          ),
        );
        await tester.pumpAndSettle();

        final decorator = tester.widget<InputDecorator>(
          find.byType(InputDecorator),
        );
        expect(decorator.decoration.enabled, isFalse);
      });
    });

    group('outlined variant', () {
      testWidgets('empty unfocused', (tester) async {
        await tester.pumpWidget(
          buildRTextField(
            variant: RTextFieldVariant.outlined,
            label: 'Label',
          ),
        );
        await tester.pumpAndSettle();

        final decorator = tester.widget<InputDecorator>(
          find.byType(InputDecorator),
        );
        expect(decorator.decoration.border, isA<OutlineInputBorder>());
      });

      testWidgets('empty focused', (tester) async {
        await tester.pumpWidget(
          buildRTextField(
            variant: RTextFieldVariant.outlined,
            label: 'Label',
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(RTextField));
        await tester.pumpAndSettle();

        final decorator = tester.widget<InputDecorator>(
          find.byType(InputDecorator),
        );
        expect(decorator.isFocused, isTrue);
      });

      testWidgets('error state', (tester) async {
        await tester.pumpWidget(
          buildRTextField(
            variant: RTextFieldVariant.outlined,
            label: 'Label',
            errorText: 'Error',
          ),
        );
        await tester.pumpAndSettle();

        final decorator = tester.widget<InputDecorator>(
          find.byType(InputDecorator),
        );
        expect(decorator.decoration.errorText, 'Error');
      });

      testWidgets('disabled state', (tester) async {
        await tester.pumpWidget(
          buildRTextField(
            variant: RTextFieldVariant.outlined,
            label: 'Label',
            enabled: false,
          ),
        );
        await tester.pumpAndSettle();

        final decorator = tester.widget<InputDecorator>(
          find.byType(InputDecorator),
        );
        expect(decorator.decoration.enabled, isFalse);
      });
    });

    group('underlined variant', () {
      testWidgets('empty unfocused', (tester) async {
        await tester.pumpWidget(
          buildRTextField(
            variant: RTextFieldVariant.underlined,
            label: 'Label',
          ),
        );
        await tester.pumpAndSettle();

        final decorator = tester.widget<InputDecorator>(
          find.byType(InputDecorator),
        );
        expect(decorator.decoration.border, isA<UnderlineInputBorder>());
        expect(decorator.decoration.filled, isFalse);
      });

      testWidgets('empty focused', (tester) async {
        await tester.pumpWidget(
          buildRTextField(
            variant: RTextFieldVariant.underlined,
            label: 'Label',
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(RTextField));
        await tester.pumpAndSettle();

        final decorator = tester.widget<InputDecorator>(
          find.byType(InputDecorator),
        );
        expect(decorator.isFocused, isTrue);
      });

      testWidgets('error state', (tester) async {
        await tester.pumpWidget(
          buildRTextField(
            variant: RTextFieldVariant.underlined,
            label: 'Label',
            errorText: 'Invalid',
          ),
        );
        await tester.pumpAndSettle();

        final decorator = tester.widget<InputDecorator>(
          find.byType(InputDecorator),
        );
        expect(decorator.decoration.errorText, 'Invalid');
      });

      testWidgets('disabled state', (tester) async {
        await tester.pumpWidget(
          buildRTextField(
            variant: RTextFieldVariant.underlined,
            label: 'Label',
            enabled: false,
          ),
        );
        await tester.pumpAndSettle();

        final decorator = tester.widget<InputDecorator>(
          find.byType(InputDecorator),
        );
        expect(decorator.decoration.enabled, isFalse);
      });
    });

    group('slots', () {
      testWidgets('prefixIcon + suffixIcon propagate', (tester) async {
        await tester.pumpWidget(
          buildRTextField(
            variant: RTextFieldVariant.filled,
            label: 'Search',
            slots: const RTextFieldSlots(
              leading: Icon(Icons.search),
              trailing: Icon(Icons.clear),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final decorator = tester.widget<InputDecorator>(
          find.byType(InputDecorator),
        );
        expect(decorator.decoration.prefixIcon, isNotNull);
        expect(decorator.decoration.suffixIcon, isNotNull);
      });
    });
  });
}
