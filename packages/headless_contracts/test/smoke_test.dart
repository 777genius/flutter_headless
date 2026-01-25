import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';

void main() {
  test('headless_contracts exports renderers', () {
    // Verify core types are exported
    expect(RenderOverrides, isNotNull);
    expect(HeadlessRendererPolicy, isNotNull);
  });

  test('headless_contracts exports button contracts', () {
    expect(RButtonRenderer, isNotNull);
    expect(RButtonRenderRequest, isNotNull);
    expect(RButtonSpec, isNotNull);
    expect(RButtonState, isNotNull);
    expect(RButtonSlots, isNotNull);
  });

  test('headless_contracts exports dropdown contracts', () {
    expect(RDropdownButtonRenderer, isNotNull);
    expect(RDropdownRenderRequest, isNotNull);
    expect(RDropdownButtonSpec, isNotNull);
    expect(RDropdownButtonState, isNotNull);
  });

  test('headless_contracts exports textfield contracts', () {
    expect(RTextFieldRenderer, isNotNull);
    expect(RTextFieldRenderRequest, isNotNull);
    expect(RTextFieldSpec, isNotNull);
    expect(RTextFieldState, isNotNull);
  });

  test('headless_contracts exports slot override', () {
    expect(SlotOverride, isNotNull);
    expect(Replace, isNotNull);
    expect(Decorate, isNotNull);
    expect(Enhance, isNotNull);
  });
}
