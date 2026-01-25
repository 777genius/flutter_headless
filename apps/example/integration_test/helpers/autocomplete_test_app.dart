import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

class AutocompleteTestApp extends StatefulWidget {
  const AutocompleteTestApp({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AutocompleteTestApp> createState() => _AutocompleteTestAppState();
}

class _AutocompleteTestAppState extends State<AutocompleteTestApp> {
  final _overlayController = OverlayController();

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeadlessThemeProvider(
      theme: MaterialHeadlessTheme(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnchoredOverlayEngineHost(
          controller: _overlayController,
          child: Scaffold(body: widget.child),
        ),
      ),
    );
  }
}
