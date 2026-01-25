import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_theme/headless_theme.dart';

import '../primitives/cupertino_pressable_opacity.dart';

/// Cupertino renderer for CheckboxListTile components.
class CupertinoCheckboxListTileRenderer implements RCheckboxListTileRenderer {
  const CupertinoCheckboxListTileRenderer();

  @override
  Widget render(RCheckboxListTileRenderRequest request) {
    final tokens = request.resolvedTokens;
    final state = request.state;
    final spec = request.spec;
    final slots = request.slots;
    final policy =
        HeadlessThemeProvider.of(request.context)?.capability<HeadlessRendererPolicy>();
    assert(
      policy?.requireResolvedTokens != true || tokens != null,
      'CupertinoCheckboxListTileRenderer requires resolvedTokens when '
      'HeadlessRendererPolicy.requireResolvedTokens is enabled.',
    );
    final motionTheme = HeadlessThemeProvider.of(request.context)
            ?.capability<HeadlessMotionTheme>() ??
        HeadlessMotionTheme.cupertino;

    final effectiveTokens = tokens ??
        RCheckboxListTileResolvedTokens(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minHeight: 44,
          horizontalGap: 12,
          verticalGap: 4,
          titleStyle: const TextStyle(fontSize: 16),
          subtitleStyle: const TextStyle(fontSize: 13),
          disabledOpacity: 1.0,
          pressOverlayColor: CupertinoColors.activeBlue.withValues(alpha: 0.12),
          pressOpacity: 0.4,
          motion: RCheckboxListTileMotionTokens(
            stateChangeDuration: motionTheme.button.stateChangeDuration,
          ),
        );

    final animationDuration = effectiveTokens.motion?.stateChangeDuration ??
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
    final defaultTitle = DefaultTextStyle(
      style: effectiveTokens.titleStyle,
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
            style: effectiveTokens.subtitleStyle,
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
        ? checkbox
        : secondary;
    final trailing = resolvedAffinity == RCheckboxControlAffinity.leading
        ? secondary
        : checkbox;

    final textColumn = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        if (subtitle != null)
          Padding(
            padding: EdgeInsets.only(top: effectiveTokens.verticalGap),
            child: subtitle,
          ),
      ],
    );

    final content = Row(
      textDirection: spec.textDirection,
      crossAxisAlignment:
          spec.isThreeLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        if (leading != null) leading,
        if (leading != null)
          SizedBox(width: effectiveTokens.horizontalGap),
        Expanded(child: textColumn),
        if (trailing != null)
          SizedBox(width: effectiveTokens.horizontalGap),
        if (trailing != null) trailing,
      ],
    );

    final defaultTile = ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: request.constraints?.minHeight ?? effectiveTokens.minHeight,
      ),
      child: Padding(
        padding: effectiveTokens.contentPadding,
        child: content,
      ),
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

    Widget wrapped = CupertinoPressableOpacity(
      duration: animationDuration,
      pressedOpacity: effectiveTokens.pressOpacity,
      isPressed: state.isPressed,
      isEnabled: !state.isDisabled,
      visualEffects: request.visualEffects,
      child: result,
    );

    if (state.isDisabled && effectiveTokens.disabledOpacity < 1) {
      wrapped = Opacity(
        opacity: effectiveTokens.disabledOpacity,
        child: wrapped,
      );
    }

    return wrapped;
  }

  RCheckboxControlAffinity _resolveAffinity(
    RCheckboxControlAffinity affinity,
    BuildContext context,
  ) {
    if (affinity != RCheckboxControlAffinity.platform) return affinity;
    final platform = defaultTargetPlatform;
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return RCheckboxControlAffinity.trailing;
    }
    return RCheckboxControlAffinity.leading;
  }
}

