import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:headless_foundation/headless_foundation.dart' show OverlayController;
import 'package:headless_cupertino/headless_cupertino.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_theme/headless_theme.dart';


/// Adaptive App bootstrap for Headless.
///
/// Chooses between [MaterialApp] and [CupertinoApp] based on platform and
/// installs the matching headless theme + AnchoredOverlayEngineHost.
class HeadlessAdaptiveApp extends StatefulWidget {
  const HeadlessAdaptiveApp({
    super.key,
    this.platformOverride,
    this.materialHeadlessTheme,
    this.cupertinoHeadlessTheme,
    this.overlayController,
    this.enableAutoRepositionTicker = false,
    // Shared app config
    this.title = '',
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
    // Material config
    this.materialTheme,
    this.materialDarkTheme,
    this.materialThemeMode,
    this.materialColor,
    this.scaffoldMessengerKey,
    // Cupertino config
    this.cupertinoTheme,
    this.cupertinoColor,
  });

  /// Optional platform override for deterministic testing.
  final TargetPlatform? platformOverride;

  /// Optional Material headless theme override.
  final HeadlessTheme? materialHeadlessTheme;

  /// Optional Cupertino headless theme override.
  final HeadlessTheme? cupertinoHeadlessTheme;

  /// Optional external overlay controller.
  final OverlayController? overlayController;

  /// When enabled, AnchoredOverlayEngineHost will request reposition every frame while overlays
  /// are active.
  final bool enableAutoRepositionTicker;

  // Shared app config
  final String title;
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

  // Material config
  final ThemeData? materialTheme;
  final ThemeData? materialDarkTheme;
  final ThemeMode? materialThemeMode;
  final Color? materialColor;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  // Cupertino config
  final CupertinoThemeData? cupertinoTheme;
  final Color? cupertinoColor;

  @override
  State<HeadlessAdaptiveApp> createState() => _HeadlessAdaptiveAppState();
}

class _HeadlessAdaptiveAppState extends State<HeadlessAdaptiveApp> {
  @override
  Widget build(BuildContext context) {
    final useCupertino = _useCupertinoPlatform(context);

    final theme = useCupertino
        ? (widget.cupertinoHeadlessTheme ?? CupertinoHeadlessTheme())
        : (widget.materialHeadlessTheme ?? MaterialHeadlessTheme());

    return HeadlessApp(
      theme: theme,
      overlayController: widget.overlayController,
      enableAutoRepositionTicker: widget.enableAutoRepositionTicker,
      appBuilder: (overlayBuilder) {
        if (useCupertino) {
          return CupertinoApp(
            title: widget.title,
            color: widget.cupertinoColor,
            theme: widget.cupertinoTheme,
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
          );
        }

        return MaterialApp(
          title: widget.title,
          theme: widget.materialTheme,
          darkTheme: widget.materialDarkTheme,
          themeMode: widget.materialThemeMode,
          color: widget.materialColor,
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
        );
      },
    );
  }

  bool _useCupertinoPlatform(BuildContext context) {
    final hasMaterialTheme =
        context.findAncestorWidgetOfExactType<Theme>() != null;
    final platform = widget.platformOverride ??
        (hasMaterialTheme ? Theme.of(context).platform : defaultTargetPlatform);
    return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
  }
}

