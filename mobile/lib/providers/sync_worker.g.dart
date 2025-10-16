// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_worker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Background worker that listens to [EditQueue] and [InsertQueue] and processes the queue when there are pending operations.
///
/// Value of this provider doesn't matter.

@ProviderFor(SyncWorker)
const syncWorkerProvider = SyncWorkerProvider._();

/// Background worker that listens to [EditQueue] and [InsertQueue] and processes the queue when there are pending operations.
///
/// Value of this provider doesn't matter.
final class SyncWorkerProvider extends $NotifierProvider<SyncWorker, int> {
  /// Background worker that listens to [EditQueue] and [InsertQueue] and processes the queue when there are pending operations.
  ///
  /// Value of this provider doesn't matter.
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

String _$syncWorkerHash() => r'dfeedbff3591cf27afc74ff22b486366faf5f177';

/// Background worker that listens to [EditQueue] and [InsertQueue] and processes the queue when there are pending operations.
///
/// Value of this provider doesn't matter.

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

/// Bridge between [sharedMediaProvider] and [insertQueueProvider].

@ProviderFor(shareQueueBridge)
const shareQueueBridgeProvider = ShareQueueBridgeProvider._();

/// Bridge between [sharedMediaProvider] and [insertQueueProvider].

final class ShareQueueBridgeProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Bridge between [sharedMediaProvider] and [insertQueueProvider].
  const ShareQueueBridgeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareQueueBridgeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareQueueBridgeHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return shareQueueBridge(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$shareQueueBridgeHash() => r'f37779ffcecda7a117a54dbf7e3536e75b89b6e1';
