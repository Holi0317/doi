// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(client)
const clientProvider = ClientProvider._();

final class ClientProvider extends $FunctionalProvider<Client, Client, Client>
    with $Provider<Client> {
  const ClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientHash();

  @$internal
  @override
  $ProviderElement<Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Client create(Ref ref) {
    return client(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Client>(value),
    );
  }
}

String _$clientHash() => r'97ca2a307ec7834dd231ff5ef90e2ad1c3b8f83b';

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

String _$searchHash() => r'81b5f8e82c6b4a3d6b6ac1e68c9ed5c514ec6c3f';

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
