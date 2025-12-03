import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/edit_op.dart';
import '../../utils.dart';
import '../api/api.dart';
import '../extensions.dart';
import '../share_handler.dart';
import 'queue.dart';

part 'sync_worker.g.dart';

/// Background worker that listens to [EditQueue] and processes the queue when there are pending operations.
///
/// Value of this provider doesn't matter.
@riverpod
class SyncWorker extends _$SyncWorker {
  bool _editProcessing = false;

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

      // FIXME(GH-18): Wait for refresh to complete before popping the queue?
      ref.invalidate(searchProvider);

      queue.pop(ops.length);
      log.info('Processed ${ops.length} EditOp successfully.');
    } catch (e, st) {
      log.severe('Failed to process EditOp', e, st);
    } finally {
      _editProcessing = false;
    }
  }
}

/// Bridge between [sharedMediaProvider] and [editQueueProvider].
///
/// FIXME(GH-11): Refactor share handling
@riverpod
int shareQueueBridge(Ref ref) {
  final log = Logger('ShareQueueBridge');

  ref.listen(sharedMediaProvider, (previous, next) {
    final value = next.value;
    if (value == null) {
      return;
    }

    log.fine('Received and cleaning shared media: $value');

    final content = value.content;
    if (content == null || content.isEmpty) {
      log.warning("Received shared media with empty content, ignoring. $value");
      return;
    }

    final url = isWebUri(content);
    if (url == null) {
      log.warning("Received shared media with invalid URL, ignoring. $value");
      return;
    }

    log.info("Inserting shared URL into insert queue: $url");

    ref
        .read(editQueueProvider.notifier)
        .add(EditOp.insert(url: url.toString()));
  });

  return 1;
}
