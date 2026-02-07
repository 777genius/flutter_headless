import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

// Test capability
abstract interface class TestCapability {
  String getValue();
}

class _TestCapabilityImpl implements TestCapability {
  @override
  String getValue() => 'test-value';
}

// Test theme that returns null for all capabilities
class _EmptyTheme extends HeadlessTheme {
  const _EmptyTheme();

  @override
  T? capability<T>() => null;
}

// Test theme that provides TestCapability
class _ThemeWithCapability extends HeadlessTheme {
  const _ThemeWithCapability(this._testCapability);

  final TestCapability _testCapability;

  @override
  T? capability<T>() {
    if (T == TestCapability) {
      return _testCapability as T;
    }
    return null;
  }
}

void main() {
  group('T1 — Missing capability throws standardized error', () {
    test(
        'requireCapability throws MissingCapabilityException when capability is null',
        () {
      const theme = _EmptyTheme();

      expect(
        () => requireCapability<TestCapability>(
          theme,
          componentName: 'RTestComponent',
        ),
        throwsA(isA<MissingCapabilityException>()),
      );
    });

    test('error message has correct prefix', () {
      const theme = _EmptyTheme();

      try {
        requireCapability<TestCapability>(
          theme,
          componentName: 'RTestComponent',
        );
        fail('Should have thrown');
      } on MissingCapabilityException catch (e) {
        final message = e.toString();

        // MUST: Fixed prefix
        expect(
          message,
          startsWith('[Headless] Missing required capability:'),
        );
      }
    });

    test('error message contains capability type', () {
      const theme = _EmptyTheme();

      try {
        requireCapability<TestCapability>(
          theme,
          componentName: 'RTestComponent',
        );
        fail('Should have thrown');
      } on MissingCapabilityException catch (e) {
        final message = e.toString();

        expect(message, contains('TestCapability'));
      }
    });

    test('error message contains component name', () {
      const theme = _EmptyTheme();

      try {
        requireCapability<TestCapability>(
          theme,
          componentName: 'RTestComponent',
        );
        fail('Should have thrown');
      } on MissingCapabilityException catch (e) {
        final message = e.toString();

        expect(message, contains('Component: RTestComponent'));
      }
    });

    test('error message contains fix-it markers', () {
      const theme = _EmptyTheme();

      try {
        requireCapability<TestCapability>(
          theme,
          componentName: 'RTestComponent',
        );
        fail('Should have thrown');
      } on MissingCapabilityException catch (e) {
        final message = e.toString();
        expect(message, contains('Preset fix'));
        expect(message, contains('Custom fix'));
        expect(message, contains("import 'package:headless/headless.dart'"));
        expect(message, contains('HeadlessMaterialApp'));
        expect(message, contains('HeadlessCupertinoApp'));
        expect(message, contains('HeadlessApp'));
        expect(message, contains('Spec: docs/SPEC_V1.md'));
        expect(message, contains('Conformance: docs/CONFORMANCE.md'));
      }
    });

    test('exception properties are accessible', () {
      const exception = MissingCapabilityException(
        capabilityType: 'RButtonRenderer',
        componentName: 'RTextButton',
      );

      expect(exception.capabilityType, 'RButtonRenderer');
      expect(exception.componentName, 'RTextButton');
    });
  });

  group('T2 — Present capability returns object', () {
    test('requireCapability returns capability when present', () {
      final testCapability = _TestCapabilityImpl();
      final theme = _ThemeWithCapability(testCapability);

      final result = requireCapability<TestCapability>(
        theme,
        componentName: 'RTestComponent',
      );

      expect(result, same(testCapability));
    });

    test('returned capability is functional', () {
      final testCapability = _TestCapabilityImpl();
      final theme = _ThemeWithCapability(testCapability);

      final result = requireCapability<TestCapability>(
        theme,
        componentName: 'RTestComponent',
      );

      expect(result.getValue(), 'test-value');
    });
  });

  group('RButtonRenderer contract', () {
    test('RButtonSpec has sensible defaults', () {
      const spec = RButtonSpec();

      expect(spec.variant, RButtonVariant.outlined);
      expect(spec.size, RButtonSize.medium);
      expect(spec.semanticLabel, isNull);
    });

    test('RButtonState has all flags false by default', () {
      const state = RButtonState();

      expect(state.isPressed, isFalse);
      expect(state.isHovered, isFalse);
      expect(state.isFocused, isFalse);
      expect(state.showFocusHighlight, isFalse);
      expect(state.isDisabled, isFalse);
    });

    test('RButtonState.fromWidgetStates converts correctly', () {
      final state = RButtonState.fromWidgetStates({
        WidgetState.pressed,
        WidgetState.focused,
      });

      expect(state.isPressed, isTrue);
      expect(state.isHovered, isFalse);
      expect(state.isFocused, isTrue);
      expect(state.isDisabled, isFalse);
    });

    test('RButtonState.toWidgetStates converts back correctly', () {
      const state = RButtonState(
        isPressed: true,
        isDisabled: true,
      );

      final widgetStates = state.toWidgetStates();

      expect(widgetStates, contains(WidgetState.pressed));
      expect(widgetStates, contains(WidgetState.disabled));
      expect(widgetStates, isNot(contains(WidgetState.hovered)));
      expect(widgetStates, isNot(contains(WidgetState.focused)));
    });
  });
}
