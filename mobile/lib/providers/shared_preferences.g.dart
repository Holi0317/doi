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
        isAutoDispose: false,
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
    r'2522b63a74451e60cc7b6b1e3b029adb36117950';

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
         isAutoDispose: false,
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

String _$preferenceHash() => r'8ae969c008048931a86ca139e967212e31a9d517';

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
        isAutoDispose: false,
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
