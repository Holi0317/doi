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
    extends $FunctionalProvider<ApiRepository, ApiRepository, ApiRepository>
    with $Provider<ApiRepository> {
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
  $ProviderElement<ApiRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiRepository create(Ref ref) {
    return apiRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiRepository>(value),
    );
  }
}

String _$apiRepositoryHash() => r'ff8b7b26fc321ef042bcef58bc898de56adf5c32';

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

String _$searchHash() => r'82717a276c53679a308c2376fd987f6b464bebfd';

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
