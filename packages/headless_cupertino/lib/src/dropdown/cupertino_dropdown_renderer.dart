import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import 'cupertino_dropdown_menu_view.dart';
import 'cupertino_dropdown_token_resolver.dart';
import 'cupertino_dropdown_trigger_view.dart';

/// Cupertino renderer for Dropdown components.
///
/// Implements [RDropdownButtonRenderer] (non-generic) with iOS styling.
///
/// CRITICAL INVARIANTS:
/// 1. Must handle both [RDropdownRenderTarget.trigger] and [RDropdownRenderTarget.menu].
/// 2. Close contract: when [overlayPhase == closing], renderer MUST call
///    [commands.completeClose()] after exit animation completes.
/// 3. Uses popover-style menu (not ActionSheet) per v1 spec.
///
/// See `docs/V1_DECISIONS.md` → "0.2 Overlay" → "Close contract v1".
class CupertinoDropdownRenderer implements RDropdownButtonRenderer {
  const CupertinoDropdownRenderer();

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
        HeadlessMotionTheme.cupertino;
    return CupertinoDropdownTriggerView(
      request: request,
      tokens: resolved.trigger,
      menuMotion: resolved.menu.motion ?? motionTheme.dropdownMenu,
    );
  }

  /// Render the menu (in overlay) - popover style.
  Widget _renderMenu(RDropdownMenuRenderRequest request) {
    final tokens = _resolveTokens(request);
    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.cupertino;
    return CupertinoDropdownMenuView(
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
        '[Headless] CupertinoDropdownRenderer требует resolvedTokens.\n'
        'Как исправить:\n'
        '- Используй preset: HeadlessCupertinoApp(...)\n'
        '- Или предоставь RDropdownTokenResolver в HeadlessTheme\n'
        '- Или отключи strict: HeadlessCupertinoApp(requireResolvedTokens: false, ...)',
      );
    }
    assert(
      !requireTokens || request.resolvedTokens != null,
      'CupertinoDropdownRenderer requires resolvedTokens when '
      'HeadlessRendererPolicy.requireResolvedTokens is enabled.',
    );
    if (resolved != null) return resolved;

    return const CupertinoDropdownTokenResolver().resolve(
      context: request.context,
      spec: request.spec,
      triggerStates: request.state.toTriggerWidgetStates(),
      overlayPhase: request.state.overlayPhase,
      constraints: request.constraints,
      overrides: request.overrides,
    );
  }
}
