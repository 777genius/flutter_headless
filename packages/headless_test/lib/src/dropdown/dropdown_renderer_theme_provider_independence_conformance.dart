import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

/// Conformance: preset renderers MUST NOT require [HeadlessThemeProvider].
///
/// Presets are allowed to use:
/// - `HeadlessThemeProvider.of(context)` (nullable) for optional capabilities
/// but MUST NOT call:
/// - `HeadlessThemeProvider.themeOf(context)` inside renderer code paths
///
/// Rationale: conformance suites often render preset renderers in isolation.
void dropdownRendererMustNotRequireThemeProviderConformance({
  required String presetName,
  required RDropdownButtonRenderer Function() rendererGetter,
  required Widget Function(Widget child) wrapApp,
}) {
  group('$presetName dropdown renderer theme-provider independence', () {
    const commands = RDropdownCommands(
      open: _noop,
      close: _noop,
      selectIndex: _selectNoop,
      highlight: _selectNoop,
      completeClose: _noop,
    );
    final tokens = _defaultTokens();

    testWidgets('trigger does not throw without HeadlessThemeProvider',
        (tester) async {
      await tester.pumpWidget(
        wrapApp(
          Builder(
            builder: (context) {
              return rendererGetter().render(
                RDropdownTriggerRenderRequest(
                  context: context,
                  spec: const RDropdownButtonSpec(),
                  state: const RDropdownButtonState(
                    overlayPhase: ROverlayPhase.closed,
                  ),
                  items: [
                    HeadlessListItemModel(
                      id: ListboxItemId('a'),
                      primaryText: 'A',
                      typeaheadLabel: 'a',
                    ),
                  ],
                  commands: commands,
                  resolvedTokens: tokens,
                ),
              );
            },
          ),
        ),
      );

      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('menu does not throw without HeadlessThemeProvider', (tester) async {
      await tester.pumpWidget(
        wrapApp(
          Builder(
            builder: (context) {
              return rendererGetter().render(
                RDropdownMenuRenderRequest(
                  context: context,
                  spec: const RDropdownButtonSpec(),
                  state: const RDropdownButtonState(
                    overlayPhase: ROverlayPhase.open,
                  ),
                  items: [
                    HeadlessListItemModel(
                      id: ListboxItemId('a'),
                      primaryText: 'A',
                      typeaheadLabel: 'a',
                    ),
                  ],
                  commands: commands,
                  resolvedTokens: tokens,
                ),
              );
            },
          ),
        ),
      );

      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}

void _noop() {}
void _selectNoop(int _) {}

RDropdownResolvedTokens _defaultTokens() {
  return RDropdownResolvedTokens(
    trigger: RDropdownTriggerTokens(
      textStyle: const TextStyle(fontSize: 14),
      foregroundColor: const Color(0xFF000000),
      backgroundColor: const Color(0xFFFFFFFF),
      borderColor: const Color(0xFFCCCCCC),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      minSize: const Size(44, 44),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      iconColor: const Color(0xFF000000),
      pressOverlayColor: const Color(0x11000000),
      pressOpacity: 1.0,
    ),
    menu: RDropdownMenuTokens(
      backgroundColor: const Color(0xFFFFFFFF),
      backgroundOpacity: 1.0,
      borderColor: const Color(0xFFCCCCCC),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      elevation: 0,
      maxHeight: 300,
      padding: const EdgeInsets.symmetric(vertical: 6),
      backdropBlurSigma: 0,
      shadowColor: const Color(0x00000000),
      shadowBlurRadius: 0,
      shadowOffset: Offset.zero,
      motion: HeadlessMotionTheme.standard().dropdownMenu,
    ),
    item: RDropdownItemTokens(
      textStyle: const TextStyle(fontSize: 14),
      foregroundColor: const Color(0xFF000000),
      backgroundColor: const Color(0x00000000),
      highlightBackgroundColor: const Color(0x11000000),
      selectedBackgroundColor: const Color(0x22000000),
      disabledForegroundColor: const Color(0xFF888888),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      minHeight: 44,
      selectedMarkerColor: const Color(0xFF000000),
    ),
  );
}

