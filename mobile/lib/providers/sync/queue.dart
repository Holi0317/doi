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

  void add(EditOp op) {
    addAll([op]);
  }

  void addAll(Iterable<EditOp> ops) {
    state = List.unmodifiable([...state, ...ops]);
  }

  /// Pops [length] items from the front of the queue.
  ///
  /// If [length] is 0, does nothing.
  /// If [length] is greater than the length of the queue, raise [RangeError].
  void pop(int length) {
    if (length == 0) {
      return;
    }

    state = List.unmodifiable(state.slice(length).toList());
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
