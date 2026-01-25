import 'package:flutter/foundation.dart';

/// Key for effect deduplication and cancellation.
///
/// Must be deterministic - same inputs must produce same key.
/// Format: `category:targetId[:opId]`
///
/// Examples:
/// - `overlay:close:dialog-1`
/// - `focus:restore:menu-dropdown`
/// - `fetch:users:op-123`
@immutable
class EffectKey {
  const EffectKey({
    required this.category,
    required this.targetId,
    this.opId,
  });

  /// Effect category (overlay, focus, announce, fetch, etc.)
  final String category;

  /// Target identifier (component/overlay/element id)
  final String targetId;

  /// Optional operation ID for cancellation granularity
  final String? opId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EffectKey &&
        other.category == category &&
        other.targetId == targetId &&
        other.opId == opId;
  }

  @override
  int get hashCode => Object.hash(category, targetId, opId);

  @override
  String toString() {
    if (opId != null) {
      return '$category:$targetId:$opId';
    }
    return '$category:$targetId';
  }

  /// Create key without opId (for key-based matching ignoring opId).
  EffectKey withoutOpId() => EffectKey(
        category: category,
        targetId: targetId,
      );

  /// Check if this key matches another (ignoring opId if not specified).
  bool matches(EffectKey other) {
    if (category != other.category) return false;
    if (targetId != other.targetId) return false;
    // If either has no opId, match by category+targetId only
    if (opId == null || other.opId == null) return true;
    return opId == other.opId;
  }
}
