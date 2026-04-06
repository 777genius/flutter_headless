// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:headless_workspace_docs/components/docs_search.dart'
    as _docs_search;
import 'package:headless_workspace_docs/components/docs_theme_toggle.dart'
    as _docs_theme_toggle;
import 'package:jaspr_content/components/_internal/tab_bar.dart' as _tab_bar;
import 'package:jaspr_content/components/_internal/zoomable_image.dart'
    as _zoomable_image;
import 'package:jaspr_content/components/callout.dart' as _callout;
import 'package:jaspr_content/components/image.dart' as _image;
import 'package:jaspr_content/components/tabs.dart' as _tabs;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _docs_search.DocsSearchShell: ClientTarget<_docs_search.DocsSearchShell>(
      'docs_search',
    ),
    _docs_theme_toggle.DocsThemeToggle:
        ClientTarget<_docs_theme_toggle.DocsThemeToggle>('docs_theme_toggle'),
    _tab_bar.TabBar: ClientTarget<_tab_bar.TabBar>(
      'jaspr_content:tab_bar',
      params: __tab_barTabBar,
    ),
    _zoomable_image.ZoomableImage: ClientTarget<_zoomable_image.ZoomableImage>(
      'jaspr_content:zoomable_image',
      params: __zoomable_imageZoomableImage,
    ),
  },
  styles: () => [
    ..._tab_bar.TabBar.styles,
    ..._zoomable_image.ZoomableImage.styles,
    ..._callout.Callout.styles,
    ..._image.Image.styles,
    ..._tabs.Tabs.styles,
  ],
);

Map<String, Object?> __tab_barTabBar(_tab_bar.TabBar c) => {
  'initialValue': c.initialValue,
  'items': c.items,
};
Map<String, Object?> __zoomable_imageZoomableImage(
  _zoomable_image.ZoomableImage c,
) => {'src': c.src, 'alt': c.alt, 'caption': c.caption};
