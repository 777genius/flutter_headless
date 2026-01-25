import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'example_cupertino_headless_theme.dart';
import 'theme_mode_scope.dart';
import 'screens/home_screen.dart';
import 'screens/button_demo_screen.dart';
import 'screens/dropdown_demo_screen.dart';
import 'screens/intentional_errors_screen.dart';
import 'screens/textfield_demo_screen.dart';
import 'screens/autocomplete_demo_screen.dart';
import 'screens/switch_demo_screen.dart';
import 'screens/glass_demo_screen.dart';

void main() {
  runApp(const HeadlessExampleApp());
}

class HeadlessExampleApp extends StatefulWidget {
  const HeadlessExampleApp({super.key});

  @override
  State<HeadlessExampleApp> createState() => _HeadlessExampleAppState();
}

class _HeadlessExampleAppState extends State<HeadlessExampleApp> {
  AppThemeMode _mode = AppThemeMode.material;
  bool _isDark = false;

  void _toggleMode() {
    setState(() {
      _mode = _mode == AppThemeMode.material
          ? AppThemeMode.cupertino
          : AppThemeMode.material;
    });
  }

  void _toggleBrightness() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final materialTheme = _isDark
        ? ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          )
        : ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          );

    final headlessTheme = _mode == AppThemeMode.material
        ? MaterialHeadlessTheme(colorScheme: materialTheme.colorScheme)
        : (_isDark
            ? ExampleCupertinoHeadlessTheme.dark()
            : ExampleCupertinoHeadlessTheme.light());

    return ThemeModeScope(
      mode: _mode,
      toggleMode: _toggleMode,
      isDark: _isDark,
      toggleBrightness: _toggleBrightness,
      child: HeadlessMaterialApp(
        headlessTheme: headlessTheme,
        title: 'Headless UI Example',
        theme: materialTheme,
        darkTheme: materialTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/button': (context) => const ButtonDemoScreen(),
          '/dropdown': (context) => const DropdownDemoScreen(),
          '/autocomplete': (context) => const AutocompleteDemoScreen(),
          '/errors': (context) => const IntentionalErrorsScreen(),
          '/textfield': (context) => const TextFieldDemoScreen(),
          '/switch': (context) => const SwitchDemoScreen(),
          '/glass': (context) => const GlassDemoScreen(),
        },
      ),
    );
  }
}
