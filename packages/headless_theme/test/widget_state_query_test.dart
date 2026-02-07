import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

void main() {
  group('HeadlessWidgetStateQuery', () {
    test('disabled suppresses pressed/hovered/dragged (v1 normalization)', () {
      final q = HeadlessWidgetStateQuery({
        WidgetState.disabled,
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.dragged,
        WidgetState.focused,
      });

      expect(q.isDisabled, isTrue);
      expect(q.isPressed, isFalse);
      expect(q.isHovered, isFalse);
      expect(q.isDragged, isFalse);
      expect(q.isFocused, isTrue);
    });

    test('error is preserved (not suppressed by disabled)', () {
      final q = HeadlessWidgetStateQuery({
        WidgetState.disabled,
        WidgetState.error,
      });

      expect(q.isDisabled, isTrue);
      expect(q.isError, isTrue);
    });

    test(
        'interactionVisualState precedence: pressed > hovered > focused > none',
        () {
      expect(
        HeadlessWidgetStateQuery({
          WidgetState.focused,
        }).interactionVisualState,
        HeadlessInteractionVisualState.focused,
      );

      expect(
        HeadlessWidgetStateQuery({
          WidgetState.focused,
          WidgetState.hovered,
        }).interactionVisualState,
        HeadlessInteractionVisualState.hovered,
      );

      expect(
        HeadlessWidgetStateQuery({
          WidgetState.focused,
          WidgetState.hovered,
          WidgetState.pressed,
        }).interactionVisualState,
        HeadlessInteractionVisualState.pressed,
      );

      expect(
        HeadlessWidgetStateQuery(const {}).interactionVisualState,
        HeadlessInteractionVisualState.none,
      );
    });
  });

  group('Dropdown trigger visual state', () {
    test('disabled wins over open/pressed/hovered/focused', () {
      final s = resolveDropdownTriggerVisualState(
        q: HeadlessWidgetStateQuery({
          WidgetState.disabled,
          WidgetState.pressed,
          WidgetState.hovered,
          WidgetState.focused,
        }),
        overlayPhase: ROverlayPhase.open,
      );
      expect(s, HeadlessDropdownTriggerVisualState.disabled);
    });

    test('open wins over pressed/hovered/focused', () {
      final s = resolveDropdownTriggerVisualState(
        q: HeadlessWidgetStateQuery({
          WidgetState.pressed,
          WidgetState.hovered,
          WidgetState.focused,
        }),
        overlayPhase: ROverlayPhase.opening,
      );
      expect(s, HeadlessDropdownTriggerVisualState.open);
    });

    test('pressed wins over hovered/focused when closed', () {
      final s = resolveDropdownTriggerVisualState(
        q: HeadlessWidgetStateQuery({
          WidgetState.pressed,
          WidgetState.hovered,
          WidgetState.focused,
        }),
        overlayPhase: ROverlayPhase.closed,
      );
      expect(s, HeadlessDropdownTriggerVisualState.pressed);
    });
  });

  group('Dropdown item visual state', () {
    final item = HeadlessListItemModel(
      id: ListboxItemId('a'),
      primaryText: 'A',
      typeaheadLabel: 'a',
    );
    final disabledItem = HeadlessListItemModel(
      id: ListboxItemId('b'),
      primaryText: 'B',
      typeaheadLabel: 'b',
      isDisabled: true,
    );

    test('disabled wins over highlighted/selected', () {
      final s = resolveDropdownItemVisualState(
        item: disabledItem,
        isHighlighted: true,
        isSelected: true,
      );
      expect(s, HeadlessDropdownItemVisualState.disabled);
    });

    test('highlighted wins over selected', () {
      final s = resolveDropdownItemVisualState(
        item: item,
        isHighlighted: true,
        isSelected: true,
      );
      expect(s, HeadlessDropdownItemVisualState.highlighted);
    });

    test('selected when selected and not highlighted', () {
      final s = resolveDropdownItemVisualState(
        item: item,
        isHighlighted: false,
        isSelected: true,
      );
      expect(s, HeadlessDropdownItemVisualState.selected);
    });
  });
}
