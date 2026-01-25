import 'package:flutter/widgets.dart';

/// Base class for slot overrides in renderer contracts.
///
/// Slots allow partial customization of component visuals without
/// reimplementing the entire renderer.
///
/// Three override strategies are supported:
/// - [Replace]: Full takeover, ignores default widget
/// - [Decorate]: Wraps the default widget
/// - [Enhance]: Modifies context, keeps default structure
///
/// See `docs/V1_DECISIONS.md` → "4) Renderer contracts + Slots override".
///
/// ## Example
///
/// ```dart
/// RDropdownButton(
///   slots: RDropdownButtonSlots(
///     // Replace the menu surface entirely
///     menuSurface: Replace((ctx) => MyCustomSurface(child: ctx.child)),
///     // Wrap items with animation
///     item: Decorate((ctx, child) => FadeIn(child: child)),
///   ),
/// )
/// ```
sealed class SlotOverride<C> {
  const SlotOverride();

  /// Build the slot widget.
  ///
  /// [ctx] — slot context (state, callbacks, etc.)
  /// [defaults] — function to get the default widget
  Widget build(C ctx, Widget Function(C) defaults);
}

/// Full replacement of a slot — default is ignored (intentional).
///
/// Use when you need complete control over the slot's rendering.
/// LSP: Contract `build()` is respected, but semantics = "full takeover".
///
/// ## Example
///
/// ```dart
/// Replace((ctx) => MyCustomWidget(
///   isSelected: ctx.isSelected,
///   label: ctx.label,
/// ))
/// ```
final class Replace<C> extends SlotOverride<C> {
  const Replace(this.builder);

  /// Builder that receives context and returns a widget.
  final Widget Function(C ctx) builder;

  @override
  Widget build(C ctx, Widget Function(C) defaults) => builder(ctx);
}

/// Decoration wrapper around the default — receives child and can wrap/modify.
///
/// Use when you want to add styling, animation, or behavior around
/// the default widget.
///
/// ## Example
///
/// ```dart
/// Decorate((ctx, child) => Container(
///   decoration: myDecoration,
///   child: child,
/// ))
/// ```
final class Decorate<C> extends SlotOverride<C> {
  const Decorate(this.builder);

  /// Builder that receives context and default child widget.
  final Widget Function(C ctx, Widget child) builder;

  @override
  Widget build(C ctx, Widget Function(C) defaults) =>
      builder(ctx, defaults(ctx));
}

/// Enhancement of the default — transforms context before calling defaults.
///
/// Use when you need to modify parameters but keep the default structure.
///
/// ## Example
///
/// ```dart
/// Enhance((ctx) => ctx.copyWith(
///   textStyle: ctx.textStyle.copyWith(fontWeight: FontWeight.bold),
/// ))
/// ```
final class Enhance<C> extends SlotOverride<C> {
  const Enhance(this.enhancer);

  /// Function that transforms the context.
  final C Function(C ctx) enhancer;

  @override
  Widget build(C ctx, Widget Function(C) defaults) => defaults(enhancer(ctx));
}
