import 'package:logging/logging.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/extensions.dart';
import 'package:mobile/providers/queue.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/edit_op.dart';
import '../models/insert_item.dart';

part 'sync_worker.g.dart';

/// Background worker that listens to [EditQueue] and [InsertQueue] and processes the queue when there are pending operations.
///
/// Value of this provider doesn't matter.
@riverpod
class SyncWorker extends _$SyncWorker {
  bool _editProcessing = false;
  bool _insertProcessing = false;

  final log = Logger('SyncWorker');

  @override
  int build() {
    ref.listen(editQueueProvider, (previous, next) {
      _processEdit(next.value ?? const []);
    });

    ref.listen(insertQueueProvider, (previous, next) {
      _processInsert(next.value ?? const []);
    });

    return 1;
  }

  Future<void> _processEdit(List<EditOp> ops) async {
    if (ops.isEmpty) {
      log.info('No pending operations, skipping processing.');
      return;
    }

    if (_editProcessing) {
      log.info('Another process is running, skipping this trigger.');
      return;
    }

    _editProcessing = true;

    log.info('Processing ${ops.length} EditOp');

    try {
      final api = await ref.read(apiRepositoryProvider.future);
      final queue = ref.read(editQueueProvider.notifier);

      await api.edit(ops, abortTrigger: ref.abortTrigger());

      // FIXME: Wait for refresh to complete before popping the queue?
      ref.invalidate(searchProvider);

      queue.pop(ops.length);
      log.info('Processed ${ops.length} EditOp successfully.');
    } catch (e, st) {
      log.severe('Failed to process EditOp', e, st);
    } finally {
      _editProcessing = false;
    }
  }

  Future<void> _processInsert(List<InsertItem> items) async {
    if (items.isEmpty) {
      log.info('No pending insert items, skipping processing.');
      return;
    }

    if (_insertProcessing) {
      log.info('Another process is running, skipping this trigger.');
      return;
    }

    _insertProcessing = true;

    log.info('Processing ${items.length} InsertItem');

    try {
      final api = await ref.read(apiRepositoryProvider.future);
      final queue = ref.read(insertQueueProvider.notifier);

      await api.insert(items, abortTrigger: ref.abortTrigger());

      queue.pop(items.length);

      log.info('Processed ${items.length} InsertItem successfully.');
    } catch (e, st) {
      log.severe('Failed to process InsertItem', e, st);
    } finally {
      _insertProcessing = false;
    }
  }
}
