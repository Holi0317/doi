// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_preferences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Underlying SharedPreferences singleton.

@ProviderFor(_sharedPreferences)
const _sharedPreferencesProvider = _SharedPreferencesProvider._();

/// Underlying SharedPreferences singleton.

final class _SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  /// Underlying SharedPreferences singleton.
  const _SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_sharedPreferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$_sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return _sharedPreferences(ref);
  }
}

String _$_sharedPreferencesHash() =>
    r'a20d3a2ec6ca1b476d47637177bb4ce55823fb2e';

@ProviderFor(Preference)
const preferenceProvider = PreferenceFamily._();

final class PreferenceProvider
    extends $AsyncNotifierProvider<Preference, String> {
  const PreferenceProvider._({
    required PreferenceFamily super.from,
    required SharedPreferenceKey super.argument,
  }) : super(
         retry: null,
         name: r'preferenceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$preferenceHash();

  @override
  String toString() {
    return r'preferenceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Preference create() => Preference();

  @override
  bool operator ==(Object other) {
    return other is PreferenceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$preferenceHash() => r'37461b5a463325dd022dd8b9c75fb69f20d87830';

final class PreferenceFamily extends $Family
    with
        $ClassFamilyOverride<
          Preference,
          AsyncValue<String>,
          String,
          FutureOr<String>,
          SharedPreferenceKey
        > {
  const PreferenceFamily._()
    : super(
        retry: null,
        name: r'preferenceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PreferenceProvider call(SharedPreferenceKey key) =>
      PreferenceProvider._(argument: key, from: this);

  @override
  String toString() => r'preferenceProvider';
}

abstract class _$Preference extends $AsyncNotifier<String> {
  late final _$args = ref.$arg as SharedPreferenceKey;
  SharedPreferenceKey get key => _$args;

  FutureOr<String> build(SharedPreferenceKey key);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
