/// Exception thrown when an [AnchoredOverlayEngineHost] is required but not found.
///
/// This is a programming error - the component requires a host ancestor to function.
/// Unlike asserts, this exception is thrown in release mode to provide diagnostics.
class MissingOverlayHostException implements Exception {
  const MissingOverlayHostException({
    required this.componentName,
  });

  final String componentName;

  @override
  String toString() {
    return '[OverlayEngine] $componentName requires an AnchoredOverlayEngineHost ancestor.\n'
        'Fix: wrap your tree with AnchoredOverlayEngineHost(controller: OverlayController(), child: ...)';
  }
}
