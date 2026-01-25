import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import '../primitives/cupertino_pressable_opacity.dart';
import 'cupertino_switch_list_tile_token_resolver.dart';

/// Cupertino renderer for SwitchListTile components.
class CupertinoSwitchListTileRenderer implements RSwitchListTileRenderer {
  const CupertinoSwitchListTileRenderer();

  @override
  Widget render(RSwitchListTileRenderRequest request) {
    final state = request.state;
    final spec = request.spec;
    final slots = request.slots;
    final tokens = _resolveTokens(request);
    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.cupertino;

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

    final resolvedAffinity = _resolveAffinity(spec.controlAffinity);

    final isLeading = resolvedAffinity == RSwitchControlAffinity.leading;

    final textColumn = Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          if (subtitle != null) ...[
            SizedBox(height: tokens.verticalGap),
            subtitle,
          ],
        ],
      ),
    );

    final List<Widget> rowChildren = [];
    if (secondary != null && !isLeading) {
      rowChildren.add(secondary);
      rowChildren.add(SizedBox(width: tokens.horizontalGap));
    }
    if (isLeading) {
      rowChildren.add(switchWidget);
      rowChildren.add(SizedBox(width: tokens.horizontalGap));
    }
    rowChildren.add(textColumn);
    if (!isLeading) {
      rowChildren.add(SizedBox(width: tokens.horizontalGap));
      rowChildren.add(switchWidget);
    }
    if (secondary != null && isLeading) {
      rowChildren.add(SizedBox(width: tokens.horizontalGap));
      rowChildren.add(secondary);
    }

    final defaultTile = Padding(
      padding: tokens.contentPadding,
      child: Row(
        children: rowChildren,
      ),
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

    constrained = CupertinoPressableOpacity(
      duration: animationDuration,
      pressedOpacity: tokens.pressOpacity,
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
        '[Headless] CupertinoSwitchListTileRenderer requires resolvedTokens.\n'
        'Fix: Use HeadlessCupertinoApp or provide RSwitchListTileTokenResolver.',
      );
    }
    assert(
      !requireTokens || resolved != null,
      'CupertinoSwitchListTileRenderer requires resolvedTokens when '
      'HeadlessRendererPolicy.requireResolvedTokens is enabled.',
    );
    if (resolved != null) return resolved;

    return const CupertinoSwitchListTileTokenResolver().resolve(
      context: request.context,
      spec: request.spec,
      states: request.state.toWidgetStates(),
      constraints: request.constraints,
      overrides: request.overrides,
    );
  }

  RSwitchControlAffinity _resolveAffinity(RSwitchControlAffinity affinity) {
    if (affinity != RSwitchControlAffinity.platform) return affinity;
    return RSwitchControlAffinity.trailing;
  }
}
