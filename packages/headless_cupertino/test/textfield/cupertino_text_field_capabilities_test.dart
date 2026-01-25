import 'package:flutter_test/flutter_test.dart';
import 'package:headless_cupertino/headless_cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';

void main() {
  group('CupertinoHeadlessTheme TextField capabilities', () {
    test('provides RTextFieldRenderer capability', () {
      final theme = CupertinoHeadlessTheme();
      final capability = theme.capability<RTextFieldRenderer>();

      expect(capability, isNotNull);
      expect(capability, isA<CupertinoTextFieldRenderer>());
    });

    test('provides RTextFieldTokenResolver capability', () {
      final theme = CupertinoHeadlessTheme();
      final capability = theme.capability<RTextFieldTokenResolver>();

      expect(capability, isNotNull);
      expect(capability, isA<CupertinoTextFieldTokenResolver>());
    });

    test('TextField capabilities return same instance across calls', () {
      final theme = CupertinoHeadlessTheme();

      final renderer1 = theme.capability<RTextFieldRenderer>();
      final renderer2 = theme.capability<RTextFieldRenderer>();
      final resolver1 = theme.capability<RTextFieldTokenResolver>();
      final resolver2 = theme.capability<RTextFieldTokenResolver>();

      expect(renderer1, isNotNull);
      expect(renderer2, isNotNull);
      expect(resolver1, isNotNull);
      expect(resolver2, isNotNull);

      expect(identical(renderer1, renderer2), isTrue);
      expect(identical(resolver1, resolver2), isTrue);
    });

    test('light theme provides TextField capabilities', () {
      final theme = CupertinoHeadlessTheme.light();

      expect(theme.capability<RTextFieldRenderer>(), isNotNull);
      expect(theme.capability<RTextFieldTokenResolver>(), isNotNull);
    });

    test('dark theme provides TextField capabilities', () {
      final theme = CupertinoHeadlessTheme.dark();

      expect(theme.capability<RTextFieldRenderer>(), isNotNull);
      expect(theme.capability<RTextFieldTokenResolver>(), isNotNull);
    });
  });
}
