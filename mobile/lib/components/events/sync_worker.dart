import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/sync_worker.dart';

/// Flutter widget for [SyncWorker] to keep it alive in the widget tree.
///
/// Just place this somewhere in the widget tree.
///
/// FIXME: Move the worker to maybe `flutter_workmanager`?
class SyncWorkerWidget extends ConsumerWidget {
  const SyncWorkerWidget({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(syncWorkerProvider);
    ref.watch(shareQueueBridgeProvider);

    return child ?? const SizedBox.shrink();
  }
}
