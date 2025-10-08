import 'package:logging/logging.dart';
import 'package:mobile/providers/api.dart';
import 'package:mobile/providers/extensions.dart';
import 'package:mobile/providers/queue.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/edit_op.dart';

part 'sync_worker.g.dart';

/// Background worker that listens to [EditQueue] and processes the queue when there are pending operations.
@riverpod
class SyncWorker extends _$SyncWorker {
  bool _isProcessing = false;

  final log = Logger('SyncWorker');

  @override
  int build() {
    ref.listen(editQueueProvider, (previous, next) {
      _process(next.value ?? const []);
    });
    return 1;
  }

  Future<void> _process(List<EditOp> ops) async {
    if (ops.isEmpty) {
      log.info('No pending operations, skipping processing.');
      return;
    }

    if (_isProcessing) {
      log.info('Another process is running, skipping this trigger.');
      return;
    }

    _isProcessing = true;

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
      _isProcessing = false;
    }
  }
}
