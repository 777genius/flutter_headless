import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import 'package:headless_material/primitives.dart';
import '../overrides/material_list_tile_overrides.dart';
import 'material_checkbox_list_tile_token_resolver.dart';

/// Material 3 renderer for CheckboxListTile components.
class MaterialCheckboxListTileRenderer implements RCheckboxListTileRenderer {
  const MaterialCheckboxListTileRenderer({
    this.defaults,
  });

  final MaterialListTileOverrides? defaults;

  @override
  Widget render(RCheckboxListTileRenderRequest request) {
    final state = request.state;
    final spec = request.spec;
    final slots = request.slots;
    final tokens = _resolveTokens(request);
    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.material;

    final animationDuration = tokens.motion?.stateChangeDuration ??
        motionTheme.button.stateChangeDuration;

    final checkbox = slots?.checkbox != null
        ? slots!.checkbox!.build(
            RCheckboxListTileCheckboxContext(
              spec: spec,
              state: state,
              child: request.checkbox,
            ),
            (_) => request.checkbox,
          )
        : request.checkbox;
    final checkboxBox = SizedBox.square(
      dimension: 48,
      child: checkbox,
    );
    final defaultTitle = DefaultTextStyle(
      style: tokens.titleStyle,
      child: request.title,
    );
    final title = slots?.title != null
        ? slots!.title!.build(
            RCheckboxListTileTextContext(
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
            RCheckboxListTileTextContext(
              spec: spec,
              state: state,
              child: defaultSubtitle ?? const SizedBox.shrink(),
            ),
            (_) => defaultSubtitle ?? const SizedBox.shrink(),
          )
        : defaultSubtitle;
    final secondary = slots?.secondary != null
        ? slots!.secondary!.build(
            RCheckboxListTileSecondaryContext(
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

    final leading = resolvedAffinity == RCheckboxControlAffinity.leading
        ? checkboxBox
        : secondary;
    final trailing = resolvedAffinity == RCheckboxControlAffinity.leading
        ? secondary
        : checkboxBox;

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
      onTap: null, // single activation source: handled by the component
    );
    final result = slots?.tile != null
        ? slots!.tile!.build(
            RCheckboxListTileTileContext(
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

  RCheckboxListTileResolvedTokens _resolveTokens(
    RCheckboxListTileRenderRequest request,
  ) {
    final policy = HeadlessThemeProvider.of(request.context)
        ?.capability<HeadlessRendererPolicy>();
    final requireTokens = policy?.requireResolvedTokens == true;
    final resolved = request.resolvedTokens;
    if (requireTokens && resolved == null) {
      throw StateError(
        '[Headless] MaterialCheckboxListTileRenderer требует resolvedTokens.\n'
        'Как исправить:\n'
        '- Используй preset: HeadlessMaterialApp(...)\n'
        '- Или предоставь RCheckboxListTileTokenResolver в HeadlessTheme\n'
        '- Или отключи strict: HeadlessMaterialApp(requireResolvedTokens: false, ...)',
      );
    }
    assert(
      !requireTokens || resolved != null,
      'MaterialCheckboxListTileRenderer requires resolvedTokens when '
      'HeadlessRendererPolicy.requireResolvedTokens is enabled.',
    );
    if (resolved != null) return resolved;

    return const MaterialCheckboxListTileTokenResolver().resolve(
      context: request.context,
      spec: request.spec,
      states: request.state.toWidgetStates(),
      constraints: request.constraints,
      overrides: request.overrides,
    );
  }

  RCheckboxControlAffinity _resolveAffinity(
    RCheckboxControlAffinity affinity,
    BuildContext context,
  ) {
    if (affinity != RCheckboxControlAffinity.platform) return affinity;
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return RCheckboxControlAffinity.trailing;
    }
    return RCheckboxControlAffinity.leading;
  }
}
