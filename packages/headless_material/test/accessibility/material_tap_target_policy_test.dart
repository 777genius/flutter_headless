import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_theme/headless_theme.dart';

void main() {
  group('MaterialTapTargetPolicy', () {
    test('padded returns Size(48, 48) at default density', () {
      final size = MaterialTapTargetPolicy.computeMinTapTargetSize(
        tapTargetSize: MaterialTapTargetSize.padded,
      );
      expect(size, const Size(48, 48));
    });

    test('shrinkWrap returns Size.zero', () {
      final size = MaterialTapTargetPolicy.computeMinTapTargetSize(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );
      expect(size, Size.zero);
    });

    test('density adjustment works correctly', () {
      final size = MaterialTapTargetPolicy.computeMinTapTargetSize(
        tapTargetSize: MaterialTapTargetSize.padded,
        density: const VisualDensity(horizontal: -2, vertical: -2),
      );
      expect(size, const Size(40, 40));
    });

    test('negative density does not produce negative size', () {
      final size = MaterialTapTargetPolicy.computeMinTapTargetSize(
        tapTargetSize: MaterialTapTargetSize.padded,
        density: const VisualDensity(horizontal: -4, vertical: -4),
      );
      expect(size.width, greaterThanOrEqualTo(0));
      expect(size.height, greaterThanOrEqualTo(0));
    });

    testWidgets('minTapTargetSize reads from Theme', (tester) async {
      const policy = MaterialTapTargetPolicy();
      Size? result;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            materialTapTargetSize: MaterialTapTargetSize.padded,
            visualDensity: VisualDensity.standard,
          ),
          home: Builder(
            builder: (context) {
              result = policy.minTapTargetSize(
                context: context,
                component: HeadlessTapTargetComponent.button,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, const Size(48, 48));
    });
  });
}
