// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:headless_workspace_docs/components/docs_search.dart'
    deferred as _docs_search;
import 'package:headless_workspace_docs/components/docs_theme_toggle.dart'
    deferred as _docs_theme_toggle;
import 'package:jaspr_content/components/_internal/tab_bar.dart'
    deferred as _tab_bar;
import 'package:jaspr_content/components/_internal/zoomable_image.dart'
    deferred as _zoomable_image;

/// Default [ClientOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.client.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultClientOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ClientOptions get defaultClientOptions => ClientOptions(
  clients: {
    'docs_search': ClientLoader(
      (p) => _docs_search.DocsSearchShell(),
      loader: _docs_search.loadLibrary,
    ),
    'docs_theme_toggle': ClientLoader(
      (p) => _docs_theme_toggle.DocsThemeToggle(),
      loader: _docs_theme_toggle.loadLibrary,
    ),
    'jaspr_content:tab_bar': ClientLoader(
      (p) => _tab_bar.TabBar(
        initialValue: p['initialValue'] as String,
        items: (p['items'] as Map<String, Object?>).cast<String, String>(),
      ),
      loader: _tab_bar.loadLibrary,
    ),
    'jaspr_content:zoomable_image': ClientLoader(
      (p) => _zoomable_image.ZoomableImage(
        src: p['src'] as String,
        alt: p['alt'] as String?,
        caption: p['caption'] as String?,
      ),
      loader: _zoomable_image.loadLibrary,
    ),
  },
);
