import 'package:collection/collection.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:mobile/providers/storage.dart';
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/edit_op.dart';

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

  Future<void> add(EditOp op) async {
    state = AsyncValue.data(
      List.unmodifiable([...state.value ?? const [], op]),
    );
  }
}

/// Map view for [EditQueue].
@riverpod
Future<Map<int, List<EditOp>>> editQueueById(Ref ref) async {
  final queue = await ref.watch(editQueueProvider.future);

  return queue.groupListsBy((op) => op.id);
}
