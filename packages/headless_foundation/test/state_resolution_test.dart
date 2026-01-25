import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:flutter/widgets.dart';

void main() {
  group('StateResolutionPolicy', () {
    test('normalize: disabled suppresses pressed/hovered/dragged', () {
      const policy = StateResolutionPolicy();

      final raw = <WidgetState>{
        WidgetState.disabled,
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.dragged,
        WidgetState.focused,
      };

      final normalized = policy.normalize(raw);

      expect(normalized.contains(WidgetState.disabled), isTrue);
      expect(normalized.contains(WidgetState.focused), isTrue);
      expect(normalized.contains(WidgetState.pressed), isFalse);
      expect(normalized.contains(WidgetState.hovered), isFalse);
      expect(normalized.contains(WidgetState.dragged), isFalse);
    });

    test('precedence: includes base empty set at the end', () {
      const policy = StateResolutionPolicy();
      final result = policy.precedence({WidgetState.hovered, WidgetState.focused});
      expect(result.last, <WidgetState>{});
    });
  });

  group('WidgetStateMap', () {
    test('resolve: picks most specific match by precedence', () {
      const policy = StateResolutionPolicy();

      final map = HeadlessWidgetStateMap<String>({
        <WidgetState>{}: 'base',
        {WidgetState.focused}: 'focused',
        {WidgetState.hovered}: 'hovered',
        {WidgetState.hovered, WidgetState.focused}: 'hovered+focused',
      });

      final value = map.resolve(
        {WidgetState.hovered, WidgetState.focused},
        policy,
      );

      expect(value, 'hovered+focused');
    });

    test('resolve: falls back to defaultValue when no entry matches', () {
      const policy = StateResolutionPolicy();

      final map = HeadlessWidgetStateMap<String>(
        {
          {WidgetState.focused}: 'focused',
        },
        defaultValue: 'default',
      );

      final value = map.resolve({WidgetState.hovered}, policy);
      expect(value, 'default');
    });

    test('resolveOrThrow: throws when no match and no default', () {
      const policy = StateResolutionPolicy();

      final map = HeadlessWidgetStateMap<String>({
        {WidgetState.focused}: 'focused',
      });

      expect(
        () => map.resolveOrThrow({WidgetState.hovered}, policy),
        throwsA(isA<StateResolutionError>()),
      );
    });
  });
}

