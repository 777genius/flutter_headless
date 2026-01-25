/// Renderer contracts and slot overrides for Headless components.
///
/// This package defines the capability contracts (ISP) that components use
/// to request renderers via [HeadlessTheme.capability<T>()].
///
/// Renderers implement these contracts to provide visual representation.
/// Components never know the concrete renderer implementation.
library;

export 'renderers.dart';
export 'slots.dart';
