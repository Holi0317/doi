// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A queue (fifo) of edit operations [EditOp] to be performed when online.
///
/// This queue is persisted to sqlite local storage.
///
/// The state is immutable; any modification to the queue will create a new list instance.
///
/// Note on appliedAt:
/// See GH-18.
/// After applying an edit operation (sending it to the server successfully),
/// the operation is marked as applied by setting its [EditOp.appliedAt] to the current time.
/// We are keeping the operation alive in the queue for a short period (1 minute) so that
/// when riverpod is refreshing queries, we can still keep the optimistic update intact.
///
/// Main reason for this is riverpod have no way to await for invalidation to complete,
/// so if we remove the operation from the queue immediately after applying it,
/// the query may refresh before the optimistic update is applied, causing a flicker in the UI.

@ProviderFor(EditQueue)
@JsonPersist()
const editQueueProvider = EditQueueProvider._();

/// A queue (fifo) of edit operations [EditOp] to be performed when online.
///
/// This queue is persisted to sqlite local storage.
///
/// The state is immutable; any modification to the queue will create a new list instance.
///
/// Note on appliedAt:
/// See GH-18.
/// After applying an edit operation (sending it to the server successfully),
/// the operation is marked as applied by setting its [EditOp.appliedAt] to the current time.
/// We are keeping the operation alive in the queue for a short period (1 minute) so that
/// when riverpod is refreshing queries, we can still keep the optimistic update intact.
///
/// Main reason for this is riverpod have no way to await for invalidation to complete,
/// so if we remove the operation from the queue immediately after applying it,
/// the query may refresh before the optimistic update is applied, causing a flicker in the UI.
@JsonPersist()
final class EditQueueProvider
    extends $NotifierProvider<EditQueue, List<EditOp>> {
  /// A queue (fifo) of edit operations [EditOp] to be performed when online.
  ///
  /// This queue is persisted to sqlite local storage.
  ///
  /// The state is immutable; any modification to the queue will create a new list instance.
  ///
  /// Note on appliedAt:
  /// See GH-18.
  /// After applying an edit operation (sending it to the server successfully),
  /// the operation is marked as applied by setting its [EditOp.appliedAt] to the current time.
  /// We are keeping the operation alive in the queue for a short period (1 minute) so that
  /// when riverpod is refreshing queries, we can still keep the optimistic update intact.
  ///
  /// Main reason for this is riverpod have no way to await for invalidation to complete,
  /// so if we remove the operation from the queue immediately after applying it,
  /// the query may refresh before the optimistic update is applied, causing a flicker in the UI.
  const EditQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editQueueHash();

  @$internal
  @override
  EditQueue create() => EditQueue();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EditOp> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EditOp>>(value),
    );
  }
}

String _$editQueueHash() => r'd63f4143aabda75a71f71527157822a0e409ac1f';

/// A queue (fifo) of edit operations [EditOp] to be performed when online.
///
/// This queue is persisted to sqlite local storage.
///
/// The state is immutable; any modification to the queue will create a new list instance.
///
/// Note on appliedAt:
/// See GH-18.
/// After applying an edit operation (sending it to the server successfully),
/// the operation is marked as applied by setting its [EditOp.appliedAt] to the current time.
/// We are keeping the operation alive in the queue for a short period (1 minute) so that
/// when riverpod is refreshing queries, we can still keep the optimistic update intact.
///
/// Main reason for this is riverpod have no way to await for invalidation to complete,
/// so if we remove the operation from the queue immediately after applying it,
/// the query may refresh before the optimistic update is applied, causing a flicker in the UI.

@JsonPersist()
abstract class _$EditQueueBase extends $Notifier<List<EditOp>> {
  List<EditOp> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<EditOp>, List<EditOp>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<EditOp>, List<EditOp>>,
              List<EditOp>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Map view for [EditQueue].
/// This will exclude insert operations since they don't have an associated id.

@ProviderFor(editQueueById)
const editQueueByIdProvider = EditQueueByIdProvider._();

/// Map view for [EditQueue].
/// This will exclude insert operations since they don't have an associated id.

final class EditQueueByIdProvider
    extends
        $FunctionalProvider<
          Map<int, List<EditOp>>,
          Map<int, List<EditOp>>,
          Map<int, List<EditOp>>
        >
    with $Provider<Map<int, List<EditOp>>> {
  /// Map view for [EditQueue].
  /// This will exclude insert operations since they don't have an associated id.
  const EditQueueByIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editQueueByIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editQueueByIdHash();

  @$internal
  @override
  $ProviderElement<Map<int, List<EditOp>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<int, List<EditOp>> create(Ref ref) {
    return editQueueById(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, List<EditOp>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, List<EditOp>>>(value),
    );
  }
}

String _$editQueueByIdHash() => r'd2bb156f489018de855422f0698a1f84850ddd77';

/// List of pending (not yet applied) edit operations.

@ProviderFor(editQueuePending)
const editQueuePendingProvider = EditQueuePendingProvider._();

/// List of pending (not yet applied) edit operations.

final class EditQueuePendingProvider
    extends $FunctionalProvider<List<EditOp>, List<EditOp>, List<EditOp>>
    with $Provider<List<EditOp>> {
  /// List of pending (not yet applied) edit operations.
  const EditQueuePendingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editQueuePendingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editQueuePendingHash();

  @$internal
  @override
  $ProviderElement<List<EditOp>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<EditOp> create(Ref ref) {
    return editQueuePending(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EditOp> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EditOp>>(value),
    );
  }
}

String _$editQueuePendingHash() => r'd2aceae20f761fa77b913f3777004023c6a3912d';

// **************************************************************************
// JsonGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
abstract class _$EditQueue extends _$EditQueueBase {
  /// The default key used by [persist].
  String get key {
    const resolvedKey = "EditQueue";
    return resolvedKey;
  }

  /// A variant of [persist], for JSON-specific encoding.
  ///
  /// You can override [key] to customize the key used for storage.
  PersistResult persist(
    FutureOr<Storage<String, String>> storage, {
    String? key,
    String Function(List<EditOp> state)? encode,
    List<EditOp> Function(String encoded)? decode,
    StorageOptions options = const StorageOptions(),
  }) {
    return NotifierPersistX(this).persist<String, String>(
      storage,
      key: key ?? this.key,
      encode: encode ?? $jsonCodex.encode,
      decode:
          decode ??
          (encoded) {
            final e = $jsonCodex.decode(encoded);
            return (e as List)
                .map((e) => EditOp.fromJson(e as Map<String, Object?>))
                .toList();
          },
      options: options,
    );
  }
}
