// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_worker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Background worker that listens to [EditQueue] and processes the queue when there are pending operations.

@ProviderFor(EditSyncWorker)
const editSyncWorkerProvider = EditSyncWorkerProvider._();

/// Background worker that listens to [EditQueue] and processes the queue when there are pending operations.
final class EditSyncWorkerProvider
    extends $NotifierProvider<EditSyncWorker, int> {
  /// Background worker that listens to [EditQueue] and processes the queue when there are pending operations.
  const EditSyncWorkerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editSyncWorkerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editSyncWorkerHash();

  @$internal
  @override
  EditSyncWorker create() => EditSyncWorker();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$editSyncWorkerHash() => r'0eda67951b22a16409166f5a58562e8f9df51b13';

/// Background worker that listens to [EditQueue] and processes the queue when there are pending operations.

abstract class _$EditSyncWorker extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
