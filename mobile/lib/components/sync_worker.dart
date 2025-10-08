import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/sync_worker.dart';

/// Flutter widget for [EditSyncWorker] to keep it alive in the widget tree.
///
/// Just place this somewhere in the widget tree.
///
/// FIXME: Move the worker to maybe `flutter_workmanager`?
class SyncWorkerWidget extends ConsumerWidget {
  const SyncWorkerWidget({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(editSyncWorkerProvider);

    return child ?? const SizedBox.shrink();
  }
}
