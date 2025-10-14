// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiRepository)
const apiRepositoryProvider = ApiRepositoryProvider._();

final class ApiRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiRepository>,
          ApiRepository,
          FutureOr<ApiRepository>
        >
    with $FutureModifier<ApiRepository>, $FutureProvider<ApiRepository> {
  const ApiRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<ApiRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ApiRepository> create(Ref ref) {
    return apiRepository(ref);
  }
}

String _$apiRepositoryHash() => r'21919f719df517746b7d37a268d7045d48eb84dd';

@ProviderFor(AuthState)
const authStateProvider = AuthStateProvider._();

final class AuthStateProvider
    extends $NotifierProvider<AuthState, AuthStateEnum> {
  const AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  AuthState create() => AuthState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthStateEnum value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthStateEnum>(value),
    );
  }
}

String _$authStateHash() => r'bfd1e52fa621f5f305d06fa4c27e89a2588c5791';

abstract class _$AuthState extends $Notifier<AuthStateEnum> {
  AuthStateEnum build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AuthStateEnum, AuthStateEnum>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthStateEnum, AuthStateEnum>,
              AuthStateEnum,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(serverInfo)
const serverInfoProvider = ServerInfoProvider._();

final class ServerInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<ServerInfo>,
          ServerInfo,
          FutureOr<ServerInfo>
        >
    with $FutureModifier<ServerInfo>, $FutureProvider<ServerInfo> {
  const ServerInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverInfoHash();

  @$internal
  @override
  $FutureProviderElement<ServerInfo> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ServerInfo> create(Ref ref) {
    return serverInfo(ref);
  }
}

String _$serverInfoHash() => r'b8100684fa0ae47c089a3a5236e0b6bb62db599f';

@ProviderFor(search)
const searchProvider = SearchFamily._();

final class SearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<SearchResponse>,
          SearchResponse,
          FutureOr<SearchResponse>
        >
    with $FutureModifier<SearchResponse>, $FutureProvider<SearchResponse> {
  const SearchProvider._({
    required SearchFamily super.from,
    required SearchQuery super.argument,
  }) : super(
         retry: null,
         name: r'searchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchHash();

  @override
  String toString() {
    return r'searchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SearchResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SearchResponse> create(Ref ref) {
    final argument = this.argument as SearchQuery;
    return search(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchHash() => r'73d39db83864458076c1a1304c2f5ff4d1e5eebf';

final class SearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SearchResponse>, SearchQuery> {
  const SearchFamily._()
    : super(
        retry: null,
        name: r'searchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SearchProvider call(SearchQuery query) =>
      SearchProvider._(argument: query, from: this);

  @override
  String toString() => r'searchProvider';
}
