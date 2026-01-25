/// Headless Button component.
///
/// Provides [RTextButton] - a button component that handles all behavior
/// (focus, keyboard, pointer input) but delegates visual rendering to
/// a [RButtonRenderer] capability from the theme.
///
/// ## Usage
///
/// ```dart
/// RTextButton(
///   onPressed: () => print('Pressed!'),
///   child: Text('Click me'),
/// )
/// ```
///
/// ## Renderer Required
///
/// This component requires a [RButtonRenderer] capability from
/// [HeadlessThemeProvider]. In debug, missing capabilities trigger a
/// standardized error. In release, the component renders a diagnostic
/// placeholder instead of crashing.
library;

export 'r_button_style.dart';
export 'r_text_button.dart';

