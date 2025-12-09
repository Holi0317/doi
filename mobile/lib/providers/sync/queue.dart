import 'package:collection/collection.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/edit_op.dart';
import '../bindings/storage.dart';

part 'queue.g.dart';

/// A queue (fifo) of edit operations [EditOp] to be performed when online.
///
/// This queue is persisted to sqlite local storage.
///
/// The state is immutable; any modification to the queue will create a new list instance.
///
/// Note on appliedAt:
/// See GH-18.
/// After applying an edit operation (sending it to the server successfully),
/// the operation is marked as applied by setting its [EditOp.appliedAt] to the current time.
/// We are keeping the operation alive in the queue for a short period (1 minute) so that
/// when riverpod is refreshing queries, we can still keep the optimistic update intact.
///
/// Main reason for this is riverpod have no way to await for invalidation to complete,
/// so if we remove the operation from the queue immediately after applying it,
/// the query may refresh before the optimistic update is applied, causing a flicker in the UI.
@riverpod
@JsonPersist()
class EditQueue extends _$EditQueue {
  @override
  List<EditOp> build() {
    persist(
      ref.watch(storageProvider.future),
      options: const StorageOptions(destroyKey: 'edit-queue:v1'),
    ).future;

    return const [];
  }

  @override
  set state(List<EditOp> value) => super.state = List.unmodifiable(value);

  void add(EditOp op) {
    addAll([op]);
  }

  void addAll(Iterable<EditOp> ops) {
    state = [...state, ...ops];
  }

  /// Marks the given [ops] as applied by setting their [EditOp.appliedAt] to the current time.
  /// If [ops] is empty, does nothing.
  /// The comparison is done by identity (using `identical`), so the exact same instances must be provided.
  void markApplied(List<EditOp> ops) {
    if (ops.isEmpty) {
      return;
    }

    final now = DateTime.now();

    state = state.map((op) {
      if (ops.any((operand) => identical(op, operand))) {
        return op.copyWith(appliedAt: now);
      }

      return op;
    }).toList();
  }

  /// Remove all operations that were marked as applied more than 1 minute ago.
  void popApplied() {
    final deadline = DateTime.now().subtract(const Duration(minutes: 1));

    state = state
        .skipWhile(
          (op) => op.appliedAt != null && op.appliedAt!.isBefore(deadline),
        )
        .toList();
  }

  /// Resets the queue to empty.
  void reset() {
    state = const [];
  }
}

/// Map view for [EditQueue].
/// This will exclude insert operations since they don't have an associated id.
@riverpod
Map<int, List<EditOp>> editQueueById(Ref ref) {
  final queue = ref.watch(editQueueProvider);

  return queue
      .where((op) => op.maybeId != null)
      .groupListsBy((op) => op.maybeId!);
}

/// List of pending (not yet applied) edit operations.
@riverpod
List<EditOp> editQueuePending(Ref ref) {
  final queue = ref.watch(editQueueProvider);

  return queue.where((op) => op.appliedAt == null).toList();
}
