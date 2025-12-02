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

@ProviderFor(EditQueue)
@JsonPersist()
const editQueueProvider = EditQueueProvider._();

/// A queue (fifo) of edit operations [EditOp] to be performed when online.
///
/// This queue is persisted to sqlite local storage.
@JsonPersist()
final class EditQueueProvider
    extends $AsyncNotifierProvider<EditQueue, List<EditOp>> {
  /// A queue (fifo) of edit operations [EditOp] to be performed when online.
  ///
  /// This queue is persisted to sqlite local storage.
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
}

String _$editQueueHash() => r'b7e967edb90fff3361cfdc43a48e40cbef8edda3';

/// A queue (fifo) of edit operations [EditOp] to be performed when online.
///
/// This queue is persisted to sqlite local storage.

@JsonPersist()
abstract class _$EditQueueBase extends $AsyncNotifier<List<EditOp>> {
  FutureOr<List<EditOp>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<EditOp>>, List<EditOp>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<EditOp>>, List<EditOp>>,
              AsyncValue<List<EditOp>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Map view for [EditQueue].

@ProviderFor(editQueueById)
const editQueueByIdProvider = EditQueueByIdProvider._();

/// Map view for [EditQueue].

final class EditQueueByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<int, List<EditOp>>>,
          Map<int, List<EditOp>>,
          FutureOr<Map<int, List<EditOp>>>
        >
    with
        $FutureModifier<Map<int, List<EditOp>>>,
        $FutureProvider<Map<int, List<EditOp>>> {
  /// Map view for [EditQueue].
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
  $FutureProviderElement<Map<int, List<EditOp>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<int, List<EditOp>>> create(Ref ref) {
    return editQueueById(ref);
  }
}

String _$editQueueByIdHash() => r'6f076ed9dc435cccbcae4eea38cf31fa3e79b2e4';

/// A queue (fifo) of insert operations [InsertItem] to be performed when online.
///
/// This queue is persisted to sqlite local storage.

@ProviderFor(InsertQueue)
@JsonPersist()
const insertQueueProvider = InsertQueueProvider._();

/// A queue (fifo) of insert operations [InsertItem] to be performed when online.
///
/// This queue is persisted to sqlite local storage.
@JsonPersist()
final class InsertQueueProvider
    extends $AsyncNotifierProvider<InsertQueue, List<InsertItem>> {
  /// A queue (fifo) of insert operations [InsertItem] to be performed when online.
  ///
  /// This queue is persisted to sqlite local storage.
  const InsertQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insertQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insertQueueHash();

  @$internal
  @override
  InsertQueue create() => InsertQueue();
}

String _$insertQueueHash() => r'38d357b2510c869e9a2b96a9eeaee9b4644c49cf';

/// A queue (fifo) of insert operations [InsertItem] to be performed when online.
///
/// This queue is persisted to sqlite local storage.

@JsonPersist()
abstract class _$InsertQueueBase extends $AsyncNotifier<List<InsertItem>> {
  FutureOr<List<InsertItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<InsertItem>>, List<InsertItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<InsertItem>>, List<InsertItem>>,
              AsyncValue<List<InsertItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

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

abstract class _$InsertQueue extends _$InsertQueueBase {
  /// The default key used by [persist].
  String get key {
    const resolvedKey = "InsertQueue";
    return resolvedKey;
  }

  /// A variant of [persist], for JSON-specific encoding.
  ///
  /// You can override [key] to customize the key used for storage.
  PersistResult persist(
    FutureOr<Storage<String, String>> storage, {
    String? key,
    String Function(List<InsertItem> state)? encode,
    List<InsertItem> Function(String encoded)? decode,
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
                .map((e) => InsertItem.fromJson(e as Map<String, Object?>))
                .toList();
          },
      options: options,
    );
  }
}
