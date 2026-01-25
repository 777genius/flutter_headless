import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_contracts/headless_contracts.dart';

void main() {
  group('MaterialHeadlessTheme', () {
    test('provides RButtonRenderer capability', () {
      final theme = MaterialHeadlessTheme();
      final capability = theme.capability<RButtonRenderer>();

      expect(capability, isNotNull);
      expect(capability, isA<MaterialButtonRenderer>());
    });

    test('provides RButtonTokenResolver capability', () {
      final theme = MaterialHeadlessTheme();
      final capability = theme.capability<RButtonTokenResolver>();

      expect(capability, isNotNull);
      expect(capability, isA<MaterialButtonTokenResolver>());
    });

    test('provides RDropdownButtonRenderer capability', () {
      final theme = MaterialHeadlessTheme();
      final capability = theme.capability<RDropdownButtonRenderer>();

      expect(capability, isNotNull);
      expect(capability, isA<MaterialDropdownRenderer>());
    });

    test('provides RDropdownTokenResolver capability', () {
      final theme = MaterialHeadlessTheme();
      final capability = theme.capability<RDropdownTokenResolver>();

      expect(capability, isNotNull);
      expect(capability, isA<MaterialDropdownTokenResolver>());
    });

    test('dropdown capabilities return same instance across calls', () {
      final theme = MaterialHeadlessTheme();

      // Multiple calls should return the same instance (no new allocations)
      final renderer1 = theme.capability<RDropdownButtonRenderer>();
      final renderer2 = theme.capability<RDropdownButtonRenderer>();
      final resolver1 = theme.capability<RDropdownTokenResolver>();
      final resolver2 = theme.capability<RDropdownTokenResolver>();

      // All should be non-null
      expect(renderer1, isNotNull);
      expect(renderer2, isNotNull);
      expect(resolver1, isNotNull);
      expect(resolver2, isNotNull);

      // Same instance returned across multiple calls
      expect(identical(renderer1, renderer2), isTrue);
      expect(identical(resolver1, resolver2), isTrue);
    });

    test('returns null for unknown capability', () {
      final theme = MaterialHeadlessTheme();
      final capability = theme.capability<String>();

      expect(capability, isNull);
    });

    test('copyWith creates new theme with overrides', () {
      final original = MaterialHeadlessTheme();
      final darkScheme = const ColorScheme.dark();
      final copy = original.copyWith(colorScheme: darkScheme);

      expect(copy, isNot(same(original)));
      expect(copy.capability<RButtonRenderer>(), isNotNull);
    });

    test('factory constructors create themed variants', () {
      final light = MaterialHeadlessTheme.light();
      final dark = MaterialHeadlessTheme.dark();

      expect(light.capability<RButtonRenderer>(), isNotNull);
      expect(dark.capability<RButtonRenderer>(), isNotNull);
    });
  });
}
