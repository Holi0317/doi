// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_preferences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferences)
const sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  const SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'6c03b929f567eb6f97608f6208b95744ffee3bfd';

@ProviderFor(ApiUrlPreference)
const apiUrlPreferenceProvider = ApiUrlPreferenceProvider._();

final class ApiUrlPreferenceProvider
    extends $AsyncNotifierProvider<ApiUrlPreference, String> {
  const ApiUrlPreferenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiUrlPreferenceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiUrlPreferenceHash();

  @$internal
  @override
  ApiUrlPreference create() => ApiUrlPreference();
}

String _$apiUrlPreferenceHash() => r'25368420bd91c52e09a0574e7a0c004f3aa291fc';

abstract class _$ApiUrlPreference extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
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

@ProviderFor(ApiTokenPreference)
const apiTokenPreferenceProvider = ApiTokenPreferenceProvider._();

final class ApiTokenPreferenceProvider
    extends $AsyncNotifierProvider<ApiTokenPreference, String> {
  const ApiTokenPreferenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiTokenPreferenceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiTokenPreferenceHash();

  @$internal
  @override
  ApiTokenPreference create() => ApiTokenPreference();
}

String _$apiTokenPreferenceHash() =>
    r'7b5668024c2e48aebf9bb809afd3018081555aec';

abstract class _$ApiTokenPreference extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
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
