// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_worker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Background worker that listens to [EditQueue] and processes the queue when there are pending operations.

@ProviderFor(SyncWorker)
const syncWorkerProvider = SyncWorkerProvider._();

/// Background worker that listens to [EditQueue] and processes the queue when there are pending operations.
final class SyncWorkerProvider extends $NotifierProvider<SyncWorker, int> {
  /// Background worker that listens to [EditQueue] and processes the queue when there are pending operations.
  const SyncWorkerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncWorkerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncWorkerHash();

  @$internal
  @override
  SyncWorker create() => SyncWorker();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$syncWorkerHash() => r'92f35088e237840b7333b0b40884188d19e32033';

/// Background worker that listens to [EditQueue] and processes the queue when there are pending operations.

abstract class _$SyncWorker extends $Notifier<int> {
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
