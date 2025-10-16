// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_handler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_shareHandlerPlatform)
const _shareHandlerPlatformProvider = _ShareHandlerPlatformProvider._();

final class _ShareHandlerPlatformProvider
    extends
        $FunctionalProvider<
          ShareHandlerPlatform,
          ShareHandlerPlatform,
          ShareHandlerPlatform
        >
    with $Provider<ShareHandlerPlatform> {
  const _ShareHandlerPlatformProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_shareHandlerPlatformProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$_shareHandlerPlatformHash();

  @$internal
  @override
  $ProviderElement<ShareHandlerPlatform> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ShareHandlerPlatform create(Ref ref) {
    return _shareHandlerPlatform(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareHandlerPlatform value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareHandlerPlatform>(value),
    );
  }
}

String _$_shareHandlerPlatformHash() =>
    r'4052964f81abf4e80861df010adb514fd541af2a';

/// Stream of shared media received.
///
/// Currently this means links shared to the app.

@ProviderFor(sharedMedia)
const sharedMediaProvider = SharedMediaProvider._();

/// Stream of shared media received.
///
/// Currently this means links shared to the app.

final class SharedMediaProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedMedia>,
          SharedMedia,
          Stream<SharedMedia>
        >
    with $FutureModifier<SharedMedia>, $StreamProvider<SharedMedia> {
  /// Stream of shared media received.
  ///
  /// Currently this means links shared to the app.
  const SharedMediaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedMediaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedMediaHash();

  @$internal
  @override
  $StreamProviderElement<SharedMedia> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<SharedMedia> create(Ref ref) {
    return sharedMedia(ref);
  }
}

String _$sharedMediaHash() => r'35f058f7e365e80ee62d544cc297a6954ed4a368';
