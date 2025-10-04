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

String _$apiRepositoryHash() => r'b8abb8216e2b0c342d43666dbb89307c4e590515';

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

/// Search and paginate result. Returning PagingState for infinite_scroll_pagination package.
///
/// [query] is the query for first page. After that, this provider will fetch pages with given [cursors] parameter.
/// Widget should keep a list of cursors that needs to be fetched. You can get the cursor from `state.keys!.last`.
/// Make sure to check that cursor as non-empty string. The page might be in loading or error state and we use empty
/// string here as filler. This provider will assert that all cursors are non-empty string.
///
/// WARN: [cursors] list must be immutable for riverpod's change detection to work.

@ProviderFor(searchPaginated)
const searchPaginatedProvider = SearchPaginatedFamily._();

/// Search and paginate result. Returning PagingState for infinite_scroll_pagination package.
///
/// [query] is the query for first page. After that, this provider will fetch pages with given [cursors] parameter.
/// Widget should keep a list of cursors that needs to be fetched. You can get the cursor from `state.keys!.last`.
/// Make sure to check that cursor as non-empty string. The page might be in loading or error state and we use empty
/// string here as filler. This provider will assert that all cursors are non-empty string.
///
/// WARN: [cursors] list must be immutable for riverpod's change detection to work.

final class SearchPaginatedProvider
    extends
        $FunctionalProvider<
          PagingState<String, Link>,
          PagingState<String, Link>,
          PagingState<String, Link>
        >
    with $Provider<PagingState<String, Link>> {
  /// Search and paginate result. Returning PagingState for infinite_scroll_pagination package.
  ///
  /// [query] is the query for first page. After that, this provider will fetch pages with given [cursors] parameter.
  /// Widget should keep a list of cursors that needs to be fetched. You can get the cursor from `state.keys!.last`.
  /// Make sure to check that cursor as non-empty string. The page might be in loading or error state and we use empty
  /// string here as filler. This provider will assert that all cursors are non-empty string.
  ///
  /// WARN: [cursors] list must be immutable for riverpod's change detection to work.
  const SearchPaginatedProvider._({
    required SearchPaginatedFamily super.from,
    required (SearchQuery, List<String>) super.argument,
  }) : super(
         retry: null,
         name: r'searchPaginatedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchPaginatedHash();

  @override
  String toString() {
    return r'searchPaginatedProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<PagingState<String, Link>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PagingState<String, Link> create(Ref ref) {
    final argument = this.argument as (SearchQuery, List<String>);
    return searchPaginated(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PagingState<String, Link> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PagingState<String, Link>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SearchPaginatedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchPaginatedHash() => r'f30ea55a6c4236730106c98e02f6adef5f56b3dc';

/// Search and paginate result. Returning PagingState for infinite_scroll_pagination package.
///
/// [query] is the query for first page. After that, this provider will fetch pages with given [cursors] parameter.
/// Widget should keep a list of cursors that needs to be fetched. You can get the cursor from `state.keys!.last`.
/// Make sure to check that cursor as non-empty string. The page might be in loading or error state and we use empty
/// string here as filler. This provider will assert that all cursors are non-empty string.
///
/// WARN: [cursors] list must be immutable for riverpod's change detection to work.

final class SearchPaginatedFamily extends $Family
    with
        $FunctionalFamilyOverride<
          PagingState<String, Link>,
          (SearchQuery, List<String>)
        > {
  const SearchPaginatedFamily._()
    : super(
        retry: null,
        name: r'searchPaginatedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Search and paginate result. Returning PagingState for infinite_scroll_pagination package.
  ///
  /// [query] is the query for first page. After that, this provider will fetch pages with given [cursors] parameter.
  /// Widget should keep a list of cursors that needs to be fetched. You can get the cursor from `state.keys!.last`.
  /// Make sure to check that cursor as non-empty string. The page might be in loading or error state and we use empty
  /// string here as filler. This provider will assert that all cursors are non-empty string.
  ///
  /// WARN: [cursors] list must be immutable for riverpod's change detection to work.

  SearchPaginatedProvider call(SearchQuery query, List<String> cursors) =>
      SearchPaginatedProvider._(argument: (query, cursors), from: this);

  @override
  String toString() => r'searchPaginatedProvider';
}
