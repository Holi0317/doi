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
/// This will exclude insert operations since they don't have an associated id.

@ProviderFor(editQueueById)
const editQueueByIdProvider = EditQueueByIdProvider._();

/// Map view for [EditQueue].
/// This will exclude insert operations since they don't have an associated id.

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
  $FutureProviderElement<Map<int, List<EditOp>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<int, List<EditOp>>> create(Ref ref) {
    return editQueueById(ref);
  }
}

String _$editQueueByIdHash() => r'1f3d7cc0ef73b1a920f2af53710dcf57dcd6da71';

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
