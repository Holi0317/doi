import 'package:collection/collection.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/edit_op.dart';
import '../models/insert_item.dart';
import 'storage.dart';

part 'queue.g.dart';

/// A queue (fifo) of edit operations [EditOp] to be performed when online.
///
/// This queue is persisted to sqlite local storage.
@riverpod
@JsonPersist()
class EditQueue extends _$EditQueue {
  @override
  Future<List<EditOp>> build() async {
    await persist(
      ref.watch(storageProvider.future),
      options: const StorageOptions(destroyKey: 'edit-queue:v1'),
    ).future;

    return List.unmodifiable(state.value ?? const []);
  }

  void add(EditOp op) {
    addAll([op]);
  }

  void addAll(Iterable<EditOp> ops) {
    state = AsyncValue.data(
      List.unmodifiable([...state.value ?? const [], ...ops]),
    );
  }

  /// Pops [length] items from the front of the queue.
  ///
  /// If [length] is 0, does nothing.
  /// If [length] is greater than the length of the queue, raise [RangeError].
  void pop(int length) {
    if (length == 0) {
      return;
    }

    final val = state.value ?? const [];
    state = AsyncValue.data(List.unmodifiable(val.slice(length).toList()));
  }
}

/// Map view for [EditQueue].
@riverpod
Future<Map<int, List<EditOp>>> editQueueById(Ref ref) async {
  final queue = await ref.watch(editQueueProvider.future);

  return queue.groupListsBy((op) => op.id);
}

/// A queue (fifo) of insert operations [InsertItem] to be performed when online.
///
/// This queue is persisted to sqlite local storage.
@riverpod
@JsonPersist()
class InsertQueue extends _$InsertQueue {
  @override
  Future<List<InsertItem>> build() async {
    await persist(
      ref.watch(storageProvider.future),
      options: const StorageOptions(destroyKey: 'insert-queue:v1'),
    ).future;

    return List.unmodifiable(state.value ?? const []);
  }

  void add(InsertItem op) {
    addAll([op]);
  }

  void addAll(Iterable<InsertItem> ops) {
    state = AsyncValue.data(
      List.unmodifiable([...state.value ?? const [], ...ops]),
    );
  }

  /// Pops [length] items from the front of the queue.
  ///
  /// If [length] is 0, does nothing.
  /// If [length] is greater than the length of the queue, raise [RangeError].
  void pop(int length) {
    if (length == 0) {
      return;
    }

    final val = state.value ?? const [];
    state = AsyncValue.data(List.unmodifiable(val.slice(length).toList()));
  }
}
