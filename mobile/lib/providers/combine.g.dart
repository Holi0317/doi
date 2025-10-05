// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combine.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Combines [search] with [EditQueue] to apply pending edits to search results.

@ProviderFor(searchApplied)
const searchAppliedProvider = SearchAppliedFamily._();

/// Combines [search] with [EditQueue] to apply pending edits to search results.

final class SearchAppliedProvider
    extends
        $FunctionalProvider<
          AsyncValue<SearchResponse>,
          SearchResponse,
          FutureOr<SearchResponse>
        >
    with $FutureModifier<SearchResponse>, $FutureProvider<SearchResponse> {
  /// Combines [search] with [EditQueue] to apply pending edits to search results.
  const SearchAppliedProvider._({
    required SearchAppliedFamily super.from,
    required SearchQuery super.argument,
  }) : super(
         retry: null,
         name: r'searchAppliedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchAppliedHash();

  @override
  String toString() {
    return r'searchAppliedProvider'
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
    return searchApplied(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchAppliedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchAppliedHash() => r'27a37d72d128d201e7fa1e598d23bc6140fbaf84';

/// Combines [search] with [EditQueue] to apply pending edits to search results.

final class SearchAppliedFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SearchResponse>, SearchQuery> {
  const SearchAppliedFamily._()
    : super(
        retry: null,
        name: r'searchAppliedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Combines [search] with [EditQueue] to apply pending edits to search results.

  SearchAppliedProvider call(SearchQuery query) =>
      SearchAppliedProvider._(argument: query, from: this);

  @override
  String toString() => r'searchAppliedProvider';
}

/// Search and paginate result. Returning PagingState for infinite_scroll_pagination package.
///
/// This uses [searchApplied] to get search results, with edits from [EditQueue] applied to the result.
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
/// This uses [searchApplied] to get search results, with edits from [EditQueue] applied to the result.
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
  /// This uses [searchApplied] to get search results, with edits from [EditQueue] applied to the result.
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

String _$searchPaginatedHash() => r'8a0da3bbca2248dcd22da08dc37fa1a51260a19a';

/// Search and paginate result. Returning PagingState for infinite_scroll_pagination package.
///
/// This uses [searchApplied] to get search results, with edits from [EditQueue] applied to the result.
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
  /// This uses [searchApplied] to get search results, with edits from [EditQueue] applied to the result.
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
