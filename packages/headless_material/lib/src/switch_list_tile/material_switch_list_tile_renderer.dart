import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import 'package:headless_material/primitives.dart';
import '../overrides/material_list_tile_overrides.dart';
import 'material_switch_list_tile_token_resolver.dart';

/// Material 3 renderer for SwitchListTile components.
class MaterialSwitchListTileRenderer implements RSwitchListTileRenderer {
  const MaterialSwitchListTileRenderer({
    this.defaults,
  });

  final MaterialListTileOverrides? defaults;

  @override
  Widget render(RSwitchListTileRenderRequest request) {
    final state = request.state;
    final spec = request.spec;
    final slots = request.slots;
    final tokens = _resolveTokens(request);
    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.material;

    final animationDuration = tokens.motion?.stateChangeDuration ??
        motionTheme.button.stateChangeDuration;

    final switchWidget = slots?.switchIndicator != null
        ? slots!.switchIndicator!.build(
            RSwitchListTileSwitchContext(
              spec: spec,
              state: state,
              child: request.switchWidget,
            ),
            (_) => request.switchWidget,
          )
        : request.switchWidget;
    // Reserve a minimum trailing slot width, but do NOT expand to fill the tile.
    // ListTile asserts when trailing consumes the entire tile width.
    final switchBox = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 60, minHeight: 48),
      child: Align(
        alignment: Alignment.center,
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: switchWidget,
      ),
    );
    final defaultTitle = DefaultTextStyle(
      style: tokens.titleStyle,
      child: request.title,
    );
    final title = slots?.title != null
        ? slots!.title!.build(
            RSwitchListTileTextContext(
              spec: spec,
              state: state,
              child: defaultTitle,
            ),
            (_) => defaultTitle,
          )
        : defaultTitle;
    final defaultSubtitle = request.subtitle == null
        ? null
        : DefaultTextStyle(
            style: tokens.subtitleStyle,
            child: request.subtitle!,
          );
    final subtitle = slots?.subtitle != null
        ? slots!.subtitle!.build(
            RSwitchListTileTextContext(
              spec: spec,
              state: state,
              child: defaultSubtitle ?? const SizedBox.shrink(),
            ),
            (_) => defaultSubtitle ?? const SizedBox.shrink(),
          )
        : defaultSubtitle;
    final secondary = slots?.secondary != null
        ? slots!.secondary!.build(
            RSwitchListTileSecondaryContext(
              spec: spec,
              state: state,
              child: request.secondary ?? const SizedBox.shrink(),
            ),
            (_) => request.secondary ?? const SizedBox.shrink(),
          )
        : request.secondary;

    final resolvedAffinity = _resolveAffinity(
      spec.controlAffinity,
      request.context,
    );

    final leading = resolvedAffinity == RSwitchControlAffinity.leading
        ? switchBox
        : secondary;
    final trailing = resolvedAffinity == RSwitchControlAffinity.leading
        ? secondary
        : switchBox;

    final materialOverrides =
        request.overrides?.get<MaterialListTileOverrides>();
    final titleAlignment =
        materialOverrides?.titleAlignment ?? defaults?.titleAlignment;

    final defaultTile = ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      isThreeLine: spec.isThreeLine,
      dense: spec.dense,
      enabled: !state.isDisabled,
      selected: spec.selected,
      selectedColor: spec.selectedColor,
      contentPadding: tokens.contentPadding,
      titleAlignment: titleAlignment,
      mouseCursor: state.isDisabled
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onTap: null, // single activation source: handled by the component
    );
    final result = slots?.tile != null
        ? slots!.tile!.build(
            RSwitchListTileTileContext(
              spec: spec,
              state: state,
              child: defaultTile,
            ),
            (_) => defaultTile,
          )
        : defaultTile;

    Widget constrained = ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: request.constraints?.minHeight ?? tokens.minHeight,
      ),
      child: result,
    );

    constrained = MaterialPressableOverlay(
      borderRadius: BorderRadius.circular(12),
      overlayColor: tokens.pressOverlayColor,
      duration: animationDuration,
      isPressed: state.isPressed,
      isEnabled: !state.isDisabled,
      visualEffects: request.visualEffects,
      child: constrained,
    );

    if (state.isDisabled && tokens.disabledOpacity < 1) {
      constrained = Opacity(
        opacity: tokens.disabledOpacity,
        child: constrained,
      );
    }

    return constrained;
  }

  RSwitchListTileResolvedTokens _resolveTokens(
    RSwitchListTileRenderRequest request,
  ) {
    final policy = HeadlessThemeProvider.of(request.context)
        ?.capability<HeadlessRendererPolicy>();
    final requireTokens = policy?.requireResolvedTokens == true;
    final resolved = request.resolvedTokens;
    if (requireTokens && resolved == null) {
      throw StateError(
        '[Headless] MaterialSwitchListTileRenderer требует resolvedTokens.\n'
        'Как исправить:\n'
        '- Используй preset: HeadlessMaterialApp(...)\n'
        '- Или предоставь RSwitchListTileTokenResolver в HeadlessTheme\n'
        '- Или отключи strict: HeadlessMaterialApp(requireResolvedTokens: false, ...)',
      );
    }
    assert(
      !requireTokens || resolved != null,
      'MaterialSwitchListTileRenderer requires resolvedTokens when '
      'HeadlessRendererPolicy.requireResolvedTokens is enabled.',
    );
    if (resolved != null) return resolved;

    return const MaterialSwitchListTileTokenResolver().resolve(
      context: request.context,
      spec: request.spec,
      states: request.state.toWidgetStates(),
      constraints: request.constraints,
      overrides: request.overrides,
    );
  }

  RSwitchControlAffinity _resolveAffinity(
    RSwitchControlAffinity affinity,
    BuildContext context,
  ) {
    if (affinity != RSwitchControlAffinity.platform) return affinity;
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return RSwitchControlAffinity.trailing;
    }
    return RSwitchControlAffinity.leading;
  }
}
