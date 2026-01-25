import 'package:flutter_test/flutter_test.dart';
import 'package:headless_foundation/headless_foundation.dart';

// Test effect implementations
class TestSyncEffect extends SyncEffect<int> {
  TestSyncEffect(this._key, this.value, {this.onExecute});

  final EffectKey _key;
  final int value;
  final void Function()? onExecute;

  @override
  EffectKey get key => _key;

  @override
  int execute() {
    onExecute?.call();
    return value;
  }
}

class TestAsyncEffect extends AsyncEffect<int> {
  TestAsyncEffect(
    this._key,
    this.value, {
    this.delay = const Duration(milliseconds: 10),
    this.onExecute,
  });

  final EffectKey _key;
  final int value;
  final Duration delay;
  final void Function()? onExecute;

  @override
  EffectKey get key => _key;

  @override
  Future<int> execute() async {
    onExecute?.call();
    await Future<void>.delayed(delay);
    return value;
  }
}

class TestFailingEffect extends SyncEffect<void> {
  TestFailingEffect(this._key, this.error);

  final EffectKey _key;
  final Object error;

  @override
  EffectKey get key => _key;

  @override
  void execute() {
    throw error;
  }
}

class TestNonCoalescableEffect extends SyncEffect<int> {
  TestNonCoalescableEffect(this._key, this.value, {this.onExecute});

  final EffectKey _key;
  final int value;
  final void Function()? onExecute;

  @override
  EffectKey get key => _key;

  @override
  bool get coalescable => false;

  @override
  int execute() {
    onExecute?.call();
    return value;
  }
}

void main() {
  group('EffectKey', () {
    test('equality works correctly', () {
      const key1 = EffectKey(category: 'overlay', targetId: 'dialog-1');
      const key2 = EffectKey(category: 'overlay', targetId: 'dialog-1');
      const key3 = EffectKey(category: 'overlay', targetId: 'dialog-2');

      expect(key1, equals(key2));
      expect(key1, isNot(equals(key3)));
    });

    test('equality with opId', () {
      const key1 =
          EffectKey(category: 'fetch', targetId: 'users', opId: 'op-1');
      const key2 =
          EffectKey(category: 'fetch', targetId: 'users', opId: 'op-1');
      const key3 =
          EffectKey(category: 'fetch', targetId: 'users', opId: 'op-2');

      expect(key1, equals(key2));
      expect(key1, isNot(equals(key3)));
    });

    test('matches ignores opId when not specified', () {
      const keyWithOp =
          EffectKey(category: 'fetch', targetId: 'users', opId: 'op-1');
      const keyWithoutOp = EffectKey(category: 'fetch', targetId: 'users');
      const differentTarget = EffectKey(category: 'fetch', targetId: 'posts');

      expect(keyWithOp.matches(keyWithoutOp), isTrue);
      expect(keyWithoutOp.matches(keyWithOp), isTrue);
      expect(keyWithOp.matches(differentTarget), isFalse);
    });

    test('toString format', () {
      const key1 = EffectKey(category: 'overlay', targetId: 'dialog-1');
      const key2 =
          EffectKey(category: 'fetch', targetId: 'users', opId: 'op-1');

      expect(key1.toString(), 'overlay:dialog-1');
      expect(key2.toString(), 'fetch:users:op-1');
    });
  });

  group('T1 — Dedupe within batch', () {
    test('same key effects are deduplicated (execute once)', () async {
      var executeCount = 0;
      final results = <EffectResult<dynamic>>[];

      final executor = EffectExecutor(onResult: results.add);
      addTearDown(executor.dispose);

      const key = EffectKey(category: 'test', targetId: 'A');

      executor.execute([
        TestSyncEffect(key, 1, onExecute: () => executeCount++),
        TestSyncEffect(key, 2, onExecute: () => executeCount++),
      ]);

      // Wait for microtask
      await Future<void>.delayed(Duration.zero);

      expect(executeCount, 1); // Only last one executes
      expect(results.length, 1);
      expect((results.first as EffectSucceeded).value, 2); // Last value wins
    });
  });

  group('T2 — Coalesce (last wins)', () {
    test('coalescable effects: last data wins', () async {
      final results = <EffectResult<dynamic>>[];

      final executor = EffectExecutor(onResult: results.add);
      addTearDown(executor.dispose);

      const key = EffectKey(category: 'reposition', targetId: 'menu');

      executor.execute([
        TestSyncEffect(key, 1),
        TestSyncEffect(key, 2),
        TestSyncEffect(key, 3),
      ]);

      await Future<void>.delayed(Duration.zero);

      expect(results.length, 1);
      expect((results.first as EffectSucceeded).value, 3);
    });

    test('non-coalescable effects all execute', () async {
      var executeCount = 0;
      final results = <EffectResult<dynamic>>[];

      final executor = EffectExecutor(onResult: results.add);
      addTearDown(executor.dispose);

      const key = EffectKey(category: 'test', targetId: 'A');

      executor.execute([
        TestNonCoalescableEffect(key, 1, onExecute: () => executeCount++),
        TestNonCoalescableEffect(key, 2, onExecute: () => executeCount++),
      ]);

      await Future<void>.delayed(Duration.zero);

      expect(executeCount, 2); // All execute
      expect(results.length, 2);
    });
  });

  group('T3 — Cancel before completion', () {
    test('cancel prevents Succeeded dispatch', () async {
      final results = <EffectResult<dynamic>>[];

      final executor = EffectExecutor(onResult: results.add);
      addTearDown(executor.dispose);

      const key =
          EffectKey(category: 'fetch', targetId: 'users', opId: 'op-1');

      executor.execute([
        TestAsyncEffect(key, 42, delay: const Duration(milliseconds: 50)),
      ]);

      // Cancel before completion
      await Future<void>.delayed(const Duration(milliseconds: 10));
      executor.cancel(key);

      // Wait for async to "complete" (but cancelled)
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Should have Cancelled result, not Succeeded
      expect(results.length, 1);
      expect(results.first, isA<EffectCancelled>());
    });

    test('cancel by category+targetId cancels all matching', () async {
      final results = <EffectResult<dynamic>>[];

      final executor = EffectExecutor(onResult: results.add);
      addTearDown(executor.dispose);

      const key1 =
          EffectKey(category: 'fetch', targetId: 'users', opId: 'op-1');
      const key2 =
          EffectKey(category: 'fetch', targetId: 'users', opId: 'op-2');
      const cancelKey = EffectKey(category: 'fetch', targetId: 'users');

      executor.execute([
        TestAsyncEffect(key1, 1, delay: const Duration(milliseconds: 50)),
        TestAsyncEffect(key2, 2, delay: const Duration(milliseconds: 50)),
      ]);

      await Future<void>.delayed(const Duration(milliseconds: 10));
      executor.cancel(cancelKey);

      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Both should be cancelled
      expect(results.length, 2);
      expect(results.every((r) => r is EffectCancelled), isTrue);
    });

    test('cancel is one-shot: future effects with same key execute normally',
        () async {
      // Regression test for "sticky cancellation" bug:
      // Cancel without opId should NOT block future effects with same category+targetId
      final results = <EffectResult<dynamic>>[];

      final executor = EffectExecutor(onResult: results.add);
      addTearDown(executor.dispose);

      const key1 =
          EffectKey(category: 'fetch', targetId: 'users', opId: 'op-1');
      const cancelKey = EffectKey(category: 'fetch', targetId: 'users');
      const key2 =
          EffectKey(category: 'fetch', targetId: 'users', opId: 'op-2');

      // Start first async effect
      executor.execute([
        TestAsyncEffect(key1, 1, delay: const Duration(milliseconds: 50)),
      ]);

      // Cancel by "wide" key (no opId)
      await Future<void>.delayed(const Duration(milliseconds: 10));
      executor.cancel(cancelKey);

      await Future<void>.delayed(const Duration(milliseconds: 100));

      // First effect should be cancelled
      expect(results.length, 1);
      expect(results.first, isA<EffectCancelled>());

      results.clear();

      // Start NEW effect with same category+targetId (different opId)
      executor.execute([
        TestAsyncEffect(key2, 42, delay: const Duration(milliseconds: 10)),
      ]);

      await Future<void>.delayed(const Duration(milliseconds: 50));

      // NEW effect should succeed (not be "sticky cancelled")
      expect(results.length, 1);
      expect(results.first, isA<EffectSucceeded>());
      expect((results.first as EffectSucceeded).value, 42);
    });
  });

  group('T4 — Error → Failed', () {
    test('exception in effect produces Failed result', () async {
      final results = <EffectResult<dynamic>>[];

      final executor = EffectExecutor(onResult: results.add);
      addTearDown(executor.dispose);

      const key = EffectKey(category: 'test', targetId: 'A');
      final error = Exception('Test error');

      executor.execute([
        TestFailingEffect(key, error),
      ]);

      await Future<void>.delayed(Duration.zero);

      expect(results.length, 1);
      expect(results.first, isA<EffectFailed>());
      expect((results.first as EffectFailed).error, error);
    });

    test('executor survives error and continues working', () async {
      final results = <EffectResult<dynamic>>[];

      final executor = EffectExecutor(onResult: results.add);
      addTearDown(executor.dispose);

      const key1 = EffectKey(category: 'test', targetId: 'A');
      const key2 = EffectKey(category: 'test', targetId: 'B');

      // First batch with error
      executor.execute([
        TestFailingEffect(key1, Exception('Fail')),
      ]);

      await Future<void>.delayed(Duration.zero);

      // Second batch should still work
      executor.execute([
        TestSyncEffect(key2, 42),
      ]);

      await Future<void>.delayed(Duration.zero);

      expect(results.length, 2);
      expect(results[0], isA<EffectFailed>());
      expect(results[1], isA<EffectSucceeded>());
      expect((results[1] as EffectSucceeded).value, 42);
    });
  });

  group('T5 — No synchronous reducer recursion', () {
    test('result dispatch is asynchronous (microtask)', () async {
      final results = <EffectResult<dynamic>>[];
      var dispatchedDuringExecute = false;

      final executor = EffectExecutor(onResult: (result) {
        results.add(result);
      });
      addTearDown(executor.dispose);

      const key = EffectKey(category: 'test', targetId: 'A');

      // Execute and immediately check if result dispatched
      executor.execute([
        TestSyncEffect(key, 1),
      ]);

      // Synchronously check - should be empty
      dispatchedDuringExecute = results.isNotEmpty;

      expect(dispatchedDuringExecute, isFalse,
          reason: 'Result should not dispatch synchronously');

      // After microtask - should have result
      await Future<void>.delayed(Duration.zero);

      expect(results.length, 1);
    });

    test('no recursion even if onResult dispatches new effects', () async {
      final results = <EffectResult<dynamic>>[];
      var recursionDetected = false;
      var executing = false;

      late EffectExecutor executor;
      executor = EffectExecutor(onResult: (result) {
        results.add(result);

        // Try to cause recursion by executing during callback
        if (results.length == 1) {
          if (executing) {
            recursionDetected = true;
          }
          const key2 = EffectKey(category: 'test', targetId: 'B');
          executor.execute([TestSyncEffect(key2, 2)]);
        }
      });
      addTearDown(executor.dispose);

      const key1 = EffectKey(category: 'test', targetId: 'A');

      executing = true;
      executor.execute([TestSyncEffect(key1, 1)]);
      executing = false;

      // Process all microtasks
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(recursionDetected, isFalse);
      expect(results.length, 2);
    });
  });

  group('EffectResult', () {
    test('sealed class pattern matching works', () {
      const key = EffectKey(category: 'test', targetId: 'A');

      final succeeded = EffectResult<int>.succeeded(key, 42);
      final failed = EffectResult<int>.failed(key, Exception('err'), StackTrace.current);
      final cancelled = EffectResult<int>.cancelled(key);

      String describe(EffectResult<int> result) {
        return switch (result) {
          EffectSucceeded(:final value) => 'success: $value',
          EffectFailed(:final error) => 'failed: $error',
          EffectCancelled() => 'cancelled',
        };
      }

      expect(describe(succeeded), 'success: 42');
      expect(describe(failed), contains('failed:'));
      expect(describe(cancelled), 'cancelled');
    });
  });

  group('EffectExecutor', () {
    test('isPending tracks async effects', () async {
      final executor = EffectExecutor(onResult: (_) {});
      addTearDown(executor.dispose);

      const key = EffectKey(category: 'fetch', targetId: 'users');

      expect(executor.isPending(key), isFalse);

      executor.execute([
        TestAsyncEffect(key, 1, delay: const Duration(milliseconds: 50)),
      ]);

      expect(executor.isPending(key), isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(executor.isPending(key), isFalse);
    });

    test('dispose cancels all pending', () async {
      final results = <EffectResult<dynamic>>[];

      final executor = EffectExecutor(onResult: results.add);

      const key = EffectKey(category: 'fetch', targetId: 'users');

      executor.execute([
        TestAsyncEffect(key, 1, delay: const Duration(milliseconds: 100)),
      ]);

      expect(executor.isPending(key), isTrue);

      executor.dispose();

      expect(executor.isPending(key), isFalse);
    });
  });
}
