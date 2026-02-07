import 'package:flutter/cupertino.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart'
    show OverlayController;
import 'package:headless_theme/headless_theme.dart';

import 'src/cupertino_headless_theme.dart';

/// CupertinoApp bootstrap for Headless.
///
/// What it does:
/// - Provides [HeadlessThemeProvider] with [CupertinoHeadlessTheme] by default.
/// - Installs [AnchoredOverlayEngineHost] (required for overlay-based components).
/// - Manages [OverlayController] lifecycle unless you pass one.
class HeadlessCupertinoApp extends StatefulWidget {
  const HeadlessCupertinoApp({
    super.key,
    this.headlessTheme,
    this.overlayController,
    this.enableAutoRepositionTicker = false,
    this.requireResolvedTokens = true,
    this.title = '',
    this.color,
    this.theme,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorKey,
    this.builder,
    this.locale,
    this.localizationsDelegates,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
  });

  /// Headless theme used by components (capability provider).
  ///
  /// Defaults to [CupertinoHeadlessTheme].
  final HeadlessTheme? headlessTheme;

  /// Optional external overlay controller.
  ///
  /// If provided, it will NOT be disposed by this widget.
  final OverlayController? overlayController;

  /// When enabled, AnchoredOverlayEngineHost will request reposition every frame while overlays
  /// are active.
  final bool enableAutoRepositionTicker;

  /// When true, preset renderers require non-null resolvedTokens.
  ///
  /// Defaults to true because the Cupertino preset always provides token resolvers.
  /// If you provide a custom [headlessTheme] that intentionally omits token resolvers,
  /// you can disable this.
  final bool requireResolvedTokens;

  // CupertinoApp subset (keep onboarding-friendly)
  final String title;
  final Color? color;
  final CupertinoThemeData? theme;
  final Widget? home;
  final Map<String, WidgetBuilder> routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final RouteFactory? onUnknownRoute;
  final GlobalKey<NavigatorState>? navigatorKey;
  final TransitionBuilder? builder;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;

  @override
  State<HeadlessCupertinoApp> createState() => _HeadlessCupertinoAppState();
}

class _HeadlessCupertinoAppState extends State<HeadlessCupertinoApp> {
  @override
  Widget build(BuildContext context) {
    final theme = widget.headlessTheme ?? CupertinoHeadlessTheme();

    return HeadlessApp(
      theme: theme,
      overlayController: widget.overlayController,
      enableAutoRepositionTicker: widget.enableAutoRepositionTicker,
      appBuilder: (overlayBuilder) {
        return HeadlessThemeOverridesScope.only<HeadlessRendererPolicy>(
          capability: HeadlessRendererPolicy(
            requireResolvedTokens: widget.requireResolvedTokens,
          ),
          child: CupertinoApp(
            title: widget.title,
            color: widget.color,
            theme: widget.theme,
            home: widget.home,
            routes: widget.routes,
            initialRoute: widget.initialRoute,
            onGenerateRoute: widget.onGenerateRoute,
            onUnknownRoute: widget.onUnknownRoute,
            navigatorKey: widget.navigatorKey,
            builder: (context, child) {
              final builtChild = widget.builder?.call(context, child) ?? child;
              return overlayBuilder(context, builtChild);
            },
            locale: widget.locale,
            localizationsDelegates: widget.localizationsDelegates,
            localeResolutionCallback: widget.localeResolutionCallback,
            supportedLocales: widget.supportedLocales,
          ),
        );
      },
    );
  }
}
