import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_foundation/headless_foundation.dart' show OverlayController;
import 'package:headless_theme/headless_theme.dart';

import 'src/material_headless_theme.dart';

/// MaterialApp bootstrap for Headless.
///
/// What it does:
/// - Provides [HeadlessThemeProvider] with [MaterialHeadlessTheme] by default.
/// - Installs [AnchoredOverlayEngineHost] (required for overlay-based components).
/// - Manages [OverlayController] lifecycle unless you pass one.
///
/// Intended to reduce onboarding boilerplate:
/// `HeadlessThemeProvider` + `AnchoredOverlayEngineHost` + `MaterialApp(...)`.
class HeadlessMaterialApp extends StatefulWidget {
  const HeadlessMaterialApp({
    super.key,
    this.headlessTheme,
    this.overlayController,
    this.enableAutoRepositionTicker = false,
    this.requireResolvedTokens = true,
    this.title = '',
    this.debugShowCheckedModeBanner = false,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.color,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorKey,
    this.scaffoldMessengerKey,
    this.builder,
    this.locale,
    this.localizationsDelegates,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
  });

  /// Headless theme used by components (capability provider).
  ///
  /// Defaults to [MaterialHeadlessTheme].
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
  /// Defaults to true because the Material preset always provides token resolvers.
  /// If you provide a custom [headlessTheme] that intentionally omits token resolvers,
  /// you can disable this.
  final bool requireResolvedTokens;

  // MaterialApp subset (keep onboarding-friendly)
  final String title;
  final bool debugShowCheckedModeBanner;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;
  final Color? color;
  final Widget? home;
  final Map<String, WidgetBuilder> routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final RouteFactory? onUnknownRoute;
  final GlobalKey<NavigatorState>? navigatorKey;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final TransitionBuilder? builder;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;

  @override
  State<HeadlessMaterialApp> createState() => _HeadlessMaterialAppState();
}

class _HeadlessMaterialAppState extends State<HeadlessMaterialApp> {
  @override
  Widget build(BuildContext context) {
    final theme = widget.headlessTheme ?? MaterialHeadlessTheme();

    return HeadlessApp(
      theme: theme,
      overlayController: widget.overlayController,
      enableAutoRepositionTicker: widget.enableAutoRepositionTicker,
      appBuilder: (overlayBuilder) {
        return HeadlessThemeOverridesScope.only<HeadlessRendererPolicy>(
          capability: HeadlessRendererPolicy(
            requireResolvedTokens: widget.requireResolvedTokens,
          ),
          child: MaterialApp(
            title: widget.title,
            debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
            theme: widget.theme,
            darkTheme: widget.darkTheme,
            themeMode: widget.themeMode,
            color: widget.color,
            home: widget.home,
            routes: widget.routes,
            initialRoute: widget.initialRoute,
            onGenerateRoute: widget.onGenerateRoute,
            onUnknownRoute: widget.onUnknownRoute,
            navigatorKey: widget.navigatorKey,
            scaffoldMessengerKey: widget.scaffoldMessengerKey,
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

