import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/theme.dart';

import 'docs_nav_link.dart';
import '../theme/docs_responsive.dart';

class DocsHomeHeroAction {
  const DocsHomeHeroAction({
    required this.text,
    required this.href,
    required this.theme,
    this.isExternal = false,
  });

  final String text;
  final String href;
  final String theme;
  final bool isExternal;
}

class DocsHomeHero extends StatelessComponent {
  const DocsHomeHero({
    required this.name,
    required this.text,
    required this.tagline,
    required this.actions,
    super.key,
  });

  final String name;
  final String text;
  final String tagline;
  final List<DocsHomeHeroAction> actions;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      Document.head(children: [Style(styles: _styles)]),
      section(classes: 'docs-home-hero', [
        div(classes: 'docs-home-hero-copy', [
          h1(classes: 'docs-home-hero-name', [Component.text(name)]),
          p(classes: 'docs-home-hero-text', [Component.text(text)]),
          p(classes: 'docs-home-hero-tagline', [Component.text(tagline)]),
          if (actions.isNotEmpty)
            div(classes: 'docs-home-hero-actions', [
              for (final action in actions)
                DocsNavLink(
                  to: action.href,
                  target: action.isExternal ? Target.blank : null,
                  attributes: {if (action.isExternal) 'rel': 'noopener'},
                  classes: action.theme == 'brand'
                      ? 'docs-home-hero-action is-brand'
                      : 'docs-home-hero-action is-alt',
                  children: [Component.text(action.text)],
                ),
            ]),
        ]),
        div(classes: 'docs-home-hero-scene', [
          // Core behavior nucleus
          div(classes: 'docs-home-core', [
            div(classes: 'docs-home-core-ring ring-outer', const []),
            div(classes: 'docs-home-core-ring ring-inner', const []),
            div(classes: 'docs-home-core-label', [
              Component.text('Behavior'),
            ]),
          ]),
          // Orbiting renderer cards
          div(classes: 'docs-home-orbit', [
            div(classes: 'docs-home-renderer r-material', [
              div(classes: 'docs-home-renderer-icon', [Component.text('M')]),
              div(classes: 'docs-home-renderer-name', [
                Component.text('Material'),
              ]),
            ]),
            div(classes: 'docs-home-renderer r-cupertino', [
              div(classes: 'docs-home-renderer-icon', [Component.text('C')]),
              div(classes: 'docs-home-renderer-name', [
                Component.text('Cupertino'),
              ]),
            ]),
            div(classes: 'docs-home-renderer r-custom', [
              div(classes: 'docs-home-renderer-icon', [Component.text('*')]),
              div(classes: 'docs-home-renderer-name', [
                Component.text('Custom'),
              ]),
            ]),
          ]),
          // Floating concept particles
          span(classes: 'docs-home-particle p-one', [Component.text('slots')]),
          span(classes: 'docs-home-particle p-two', [Component.text('a11y')]),
          span(classes: 'docs-home-particle p-three', [Component.text('tokens')]),
          span(classes: 'docs-home-particle p-four', [Component.text('focus')]),
        ]),
      ]),
    ]);
  }

  static List<StyleRule> get _styles => [
    css.keyframes('docs-home-orbit-spin', {
      '0%': const Styles(raw: {'transform': 'rotate(0deg)'}),
      '100%': const Styles(raw: {'transform': 'rotate(360deg)'}),
    }),
    css.keyframes('docs-home-orbit-counter', {
      '0%': const Styles(raw: {'transform': 'rotate(0deg)'}),
      '100%': const Styles(raw: {'transform': 'rotate(-360deg)'}),
    }),
    css.keyframes('docs-home-core-pulse', {
      '0%, 100%': const Styles(raw: {'transform': 'scale(1)', 'opacity': '0.5'}),
      '50%': const Styles(raw: {'transform': 'scale(1.12)', 'opacity': '0.8'}),
    }),
    css.keyframes('docs-home-core-glow', {
      '0%, 100%': const Styles(raw: {'box-shadow': '0 0 20px color-mix(in srgb, var(--docs-shell-accent) 30%, transparent), 0 0 40px color-mix(in srgb, var(--docs-shell-accent) 10%, transparent)'}),
      '50%': const Styles(raw: {'box-shadow': '0 0 30px color-mix(in srgb, var(--docs-shell-accent) 50%, transparent), 0 0 60px color-mix(in srgb, var(--docs-shell-accent) 20%, transparent)'}),
    }),
    css.keyframes('docs-home-particle-float', {
      '0%, 100%': const Styles(
        opacity: 0,
        raw: {'transform': 'translateY(10px)'},
      ),
      '15%, 85%': const Styles(opacity: 0.62),
      '50%': const Styles(
        opacity: 0.88,
        raw: {'transform': 'translateY(-16px)'},
      ),
    }),
    css.keyframes('docs-home-hero-glow', {
      '0%': const Styles(
        opacity: 0.56,
        raw: {'transform': 'translateX(-50%) scale(1)'},
      ),
      '100%': const Styles(
        opacity: 1,
        raw: {'transform': 'translateX(-50%) scale(1.16)'},
      ),
    }),
    css('.docs-home-hero', [
      css('&').styles(
        display: Display.grid,
        alignItems: AlignItems.center,
        gap: Gap.all(2.5.rem),
        raw: {
          'grid-template-columns': 'minmax(0, 1.15fr) minmax(18rem, 25rem)',
          'position': 'relative',
          'isolation': 'isolate',
        },
      ),
      css('&::before').styles(
        content: '""',
        position: Position.absolute(top: (-5).percent, left: 50.percent),
        width: 38.rem,
        height: 38.rem,
        radius: BorderRadius.circular(999.px),
        pointerEvents: PointerEvents.none,
        filter: Filter.blur(64.px),
        opacity: 0.9,
        zIndex: ZIndex(-1),
        raw: {
          'background':
              'radial-gradient(circle, color-mix(in srgb, var(--docs-shell-accent) 18%, transparent) 0%, color-mix(in srgb, var(--docs-shell-accent-strong) 10%, transparent) 42%, transparent 72%)',
          'transform': 'translateX(-50%)',
          'animation': 'docs-home-hero-glow 6s ease-in-out infinite alternate',
        },
      ),
      css('.docs-home-hero-copy').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.start,
        raw: {'min-width': '0'},
      ),
      css('.docs-home-hero-eyebrow').styles(
        display: Display.inlineFlex,
        alignItems: AlignItems.center,
        padding: Padding.symmetric(horizontal: 0.8.rem, vertical: 0.38.rem),
        margin: Margin.only(bottom: 1.rem),
        radius: BorderRadius.circular(999.px),
        border: Border.all(
          width: 1.px,
          color: Color('var(--docs-shell-border-strong)'),
        ),
        color: Color('var(--docs-shell-accent-strong)'),
        backgroundColor: Color('var(--docs-shell-accent-soft)'),
        fontWeight: FontWeight.w700,
        fontSize: 0.76.rem,
        textTransform: TextTransform.upperCase,
        letterSpacing: 0.12.rem,
      ),
      css('.docs-home-hero-name').styles(
        margin: Margin.zero,
        fontSize: 3.65.rem,
        fontWeight: FontWeight.w900,
        color: ContentColors.headings,
        raw: {
          'line-height': '1.02',
          'letter-spacing': '-0.055em',
          'max-width': '12ch',
          'text-wrap': 'balance',
        },
      ),
      css('.docs-home-hero-text').styles(
        margin: Margin.only(top: 0.9.rem),
        fontSize: 1.34.rem,
        fontWeight: FontWeight.w700,
        color: Color('var(--docs-shell-accent-strong)'),
        raw: {'letter-spacing': '-0.025em'},
      ),
      css('.docs-home-hero-tagline').styles(
        margin: Margin.only(top: 0.95.rem),
        maxWidth: 34.rem,
        fontSize: 1.05.rem,
        color: Color('var(--docs-shell-muted)'),
        raw: {'line-height': '1.72', 'text-wrap': 'pretty'},
      ),
      css('.docs-home-hero-actions').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(0.9.rem),
        margin: Margin.only(top: 1.6.rem),
      ),
      css('.docs-home-hero-action').styles(
        display: Display.inlineFlex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        minHeight: 3.1.rem,
        padding: Padding.symmetric(horizontal: 1.15.rem, vertical: 0.72.rem),
        radius: BorderRadius.circular(1.rem),
        border: Border.all(width: 1.px, color: Color('transparent')),
        fontWeight: FontWeight.w700,
        transition: Transition(
          'transform, box-shadow, background-color, border-color, color',
          duration: 180.ms,
          curve: Curve.easeInOut,
        ),
        raw: {'box-shadow': '0 18px 38px rgba(15, 23, 42, 0.08)'},
      ),
      css(
        '.docs-home-hero-action:hover',
      ).styles(raw: {'transform': 'translateY(-1px)'}),
      css('.docs-home-hero-action:focus-visible').styles(
        outline: Outline(
          width: OutlineWidth(3.px),
          style: OutlineStyle.solid,
          color: Color('var(--docs-shell-focus)'),
          offset: 3.px,
        ),
      ),
      css('.docs-home-hero-action.is-brand').styles(
        color: Colors.white,
        backgroundColor: Color('var(--docs-shell-accent-strong)'),
      ),
      css(
        '.docs-home-hero-action.is-brand:hover',
      ).styles(backgroundColor: Color('var(--docs-shell-accent)')),
      css('.docs-home-hero-action.is-alt').styles(
        color: ContentColors.headings,
        backgroundColor: Color('var(--docs-shell-surface-elevated)'),
        border: Border.all(
          width: 1.px,
          color: Color('var(--docs-shell-border)'),
        ),
      ),
      css('.docs-home-hero-action.is-alt:hover').styles(
        color: Color('var(--docs-shell-accent-strong)'),
        border: Border.all(
          width: 1.px,
          color: Color('var(--docs-shell-border-strong)'),
        ),
        backgroundColor: Color('var(--docs-shell-accent-soft)'),
      ),
      css('.docs-home-hero-scene').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        position: Position.relative(),
        width: 100.percent,
        height: 21.rem,
      ),
      // Core behavior nucleus
      css('.docs-home-core').styles(
        position: Position.relative(),
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        width: 5.5.rem,
        height: 5.5.rem,
        radius: BorderRadius.circular(999.px),
        backgroundColor: Color('var(--docs-shell-surface-elevated)'),
        zIndex: ZIndex(2),
        raw: {
          'animation': 'docs-home-core-glow 4s ease-in-out infinite',
          'border': '2px solid var(--docs-shell-accent)',
        },
      ),
      css('.docs-home-core-ring').styles(
        position: Position.absolute(),
        radius: BorderRadius.circular(999.px),
        raw: {
          'border': '1.5px dashed color-mix(in srgb, var(--docs-shell-accent) 30%, transparent)',
          'animation': 'docs-home-core-pulse 4s ease-in-out infinite',
        },
      ),
      css('.docs-home-core-ring.ring-outer').styles(
        width: 8.rem,
        height: 8.rem,
        raw: {'animation-delay': '0s'},
      ),
      css('.docs-home-core-ring.ring-inner').styles(
        width: 6.5.rem,
        height: 6.5.rem,
        raw: {'animation-delay': '1s'},
      ),
      css('.docs-home-core-label').styles(
        fontSize: 0.72.rem,
        fontWeight: FontWeight.w800,
        textTransform: TextTransform.upperCase,
        letterSpacing: 0.08.rem,
        color: Color('var(--docs-shell-accent-strong)'),
        zIndex: ZIndex(3),
      ),
      // Orbiting renderers
      css('.docs-home-orbit').styles(
        position: Position.absolute(
          top: Unit.zero,
          right: Unit.zero,
          bottom: Unit.zero,
          left: Unit.zero,
        ),
        raw: {
          'animation': 'docs-home-orbit-spin 18s linear infinite',
        },
      ),
      css('.docs-home-renderer').styles(
        position: Position.absolute(),
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        gap: Gap.all(0.3.rem),
        raw: {
          'animation': 'docs-home-orbit-counter 18s linear infinite',
        },
      ),
      css('.docs-home-renderer-icon').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        width: 2.8.rem,
        height: 2.8.rem,
        radius: BorderRadius.circular(0.8.rem),
        fontWeight: FontWeight.w900,
        fontSize: 1.1.rem,
        backgroundColor: Color('var(--docs-shell-surface-elevated)'),
        raw: {
          'box-shadow': '0 8px 24px color-mix(in srgb, var(--docs-shell-shadow) 70%, transparent)',
          'border': '1.5px solid var(--docs-shell-border-strong)',
        },
      ),
      css('.docs-home-renderer-name').styles(
        fontSize: 0.62.rem,
        fontWeight: FontWeight.w700,
        textTransform: TextTransform.upperCase,
        letterSpacing: 0.06.rem,
        color: Color('var(--docs-shell-muted)'),
      ),
      css('.docs-home-renderer.r-material').styles(
        raw: {'top': '2%', 'left': '50%', 'transform': 'translateX(-50%)'},
      ),
      css('.docs-home-renderer.r-material .docs-home-renderer-icon').styles(
        color: Color('var(--docs-shell-accent-strong)'),
        raw: {
          'border-color': 'var(--docs-shell-accent)',
          'background': 'linear-gradient(135deg, var(--docs-shell-surface-elevated) 60%, var(--docs-shell-accent-soft) 100%)',
        },
      ),
      css('.docs-home-renderer.r-cupertino').styles(
        raw: {'bottom': '8%', 'left': '8%'},
      ),
      css('.docs-home-renderer.r-cupertino .docs-home-renderer-icon').styles(
        color: const Color('#007aff'),
        raw: {
          'border-color': '#007aff44',
          'background': 'linear-gradient(135deg, var(--docs-shell-surface-elevated) 60%, #007aff14 100%)',
        },
      ),
      css('.docs-home-renderer.r-custom').styles(
        raw: {'bottom': '8%', 'right': '8%'},
      ),
      css('.docs-home-renderer.r-custom .docs-home-renderer-icon').styles(
        color: const Color('#a855f7'),
        raw: {
          'border-color': '#a855f744',
          'background': 'linear-gradient(135deg, var(--docs-shell-surface-elevated) 60%, #a855f714 100%)',
        },
      ),
      css('.docs-home-particle').styles(
        position: Position.absolute(),
        fontWeight: FontWeight.w700,
        color: Color(
          'color-mix(in srgb, var(--docs-shell-accent) 58%, transparent)',
        ),
        opacity: 0,
        pointerEvents: PointerEvents.none,
        raw: {
          'font-family': 'var(--content-code-font)',
          'animation': 'docs-home-particle-float 8s ease-in-out infinite',
        },
      ),
      css(
        '.docs-home-particle.p-one',
      ).styles(raw: {'top': '14%', 'right': '5%', 'animation-delay': '0s'}),
      css(
        '.docs-home-particle.p-two',
      ).styles(raw: {'bottom': '16%', 'left': '4%', 'animation-delay': '2s'}),
      css(
        '.docs-home-particle.p-three',
      ).styles(raw: {'top': '24%', 'left': '10%', 'animation-delay': '4s'}),
      css(
        '.docs-home-particle.p-four',
      ).styles(raw: {'right': '9%', 'bottom': '10%', 'animation-delay': '6s'}),
      downContent([
        css('&').styles(
          gap: Gap.all(2.rem),
          raw: {'grid-template-columns': 'minmax(0, 1fr)'},
        ),
        css('.docs-home-hero-copy').styles(alignItems: AlignItems.center),
        css(
          '.docs-home-hero-name',
        ).styles(fontSize: 3.1.rem, textAlign: TextAlign.center),
        css('.docs-home-hero-text').styles(textAlign: TextAlign.center),
        css('.docs-home-hero-tagline').styles(textAlign: TextAlign.center),
        css(
          '.docs-home-hero-actions',
        ).styles(justifyContent: JustifyContent.center),
        css('.docs-home-hero-scene').styles(height: 18.rem),
      ]),
      downMobile([
        css('.docs-home-hero-name').styles(fontSize: 2.5.rem),
        css('.docs-home-hero-text').styles(fontSize: 1.12.rem),
        css('.docs-home-hero-tagline').styles(fontSize: 0.98.rem),
        css('.docs-home-hero-scene').styles(height: 15.5.rem),
      ]),
      downCompact([
        css(
          '.docs-home-hero-actions',
        ).styles(width: 100.percent, raw: {'justify-content': 'stretch'}),
        css(
          '.docs-home-hero-action',
        ).styles(width: 100.percent, raw: {'justify-content': 'center'}),
        css('.docs-home-particle').styles(display: Display.none),
      ]),
    ]),
    css.media(MediaQuery.raw('(prefers-reduced-motion: reduce)'), [
      css('.docs-home-hero::before').styles(raw: {'animation': 'none'}),
      css('.docs-home-orbit').styles(raw: {'animation': 'none'}),
      css('.docs-home-renderer').styles(raw: {'animation': 'none'}),
      css('.docs-home-core').styles(raw: {'animation': 'none'}),
      css('.docs-home-core-ring').styles(raw: {'animation': 'none'}),
      css(
        '.docs-home-particle',
      ).styles(display: Display.none, opacity: 0, raw: {'animation': 'none'}),
      css('.docs-home-hero-action').styles(raw: {'transition': 'none'}),
    ]),
  ];
}
