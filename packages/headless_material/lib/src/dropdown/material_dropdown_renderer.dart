import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import 'material_dropdown_menu_view.dart';
import 'material_dropdown_token_resolver.dart';
import 'material_dropdown_trigger_view.dart';

/// Material 3 renderer for Dropdown components.
///
/// Implements [RDropdownButtonRenderer] with Material Design 3 visuals.
///
/// CRITICAL INVARIANTS:
/// 1. Must handle both [RDropdownRenderTarget.trigger] and [RDropdownRenderTarget.menu].
/// 2. Close contract: when [overlayPhase == closing], renderer MUST call
///    [commands.completeClose()] after exit animation completes.
/// 3. Slots can customize anchor, menu, item, menuSurface.
///
/// See `docs/V1_DECISIONS.md` → "0.2 Overlay" → "Close contract v1".
class MaterialDropdownRenderer implements RDropdownButtonRenderer {
  const MaterialDropdownRenderer();

  @override
  Widget render(RDropdownRenderRequest request) {
    return switch (request) {
      RDropdownTriggerRenderRequest() => _renderTrigger(request),
      RDropdownMenuRenderRequest() => _renderMenu(request),
    };
  }

  /// Render the trigger/anchor button.
  Widget _renderTrigger(RDropdownTriggerRenderRequest request) {
    final resolved = _resolveTokens(request);
    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.material;
    final menuMotion = resolved.menu.motion ?? motionTheme.dropdownMenu;
    return MaterialDropdownTriggerView(
      request: request,
      tokens: resolved.trigger,
      menuMotion: menuMotion,
    );
  }

  /// Render the menu (in overlay).
  Widget _renderMenu(RDropdownMenuRenderRequest request) {
    final tokens = _resolveTokens(request);
    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.material;
    return MaterialDropdownMenuView(
      request: request,
      tokens: tokens,
      menuMotion: tokens.menu.motion ?? motionTheme.dropdownMenu,
    );
  }

  RDropdownResolvedTokens _resolveTokens(RDropdownRenderRequest request) {
    final policy = HeadlessThemeProvider.of(request.context)
        ?.capability<HeadlessRendererPolicy>();
    final requireTokens = policy?.requireResolvedTokens == true;
    final resolved = request.resolvedTokens;
    if (requireTokens && resolved == null) {
      throw StateError(
        '[Headless] MaterialDropdownRenderer требует resolvedTokens.\n'
        'Как исправить:\n'
        '- Используй preset: HeadlessMaterialApp(...)\n'
        '- Или предоставь RDropdownTokenResolver в HeadlessTheme\n'
        '- Или отключи strict: HeadlessMaterialApp(requireResolvedTokens: false, ...)',
      );
    }
    assert(
      !requireTokens || request.resolvedTokens != null,
      'MaterialDropdownRenderer requires resolvedTokens when '
      'HeadlessRendererPolicy.requireResolvedTokens is enabled.',
    );
    if (resolved != null) return resolved;

    return const MaterialDropdownTokenResolver().resolve(
      context: request.context,
      spec: request.spec,
      triggerStates: request.state.toTriggerWidgetStates(),
      overlayPhase: request.state.overlayPhase,
      constraints: request.constraints,
      overrides: request.overrides,
    );
  }
}
