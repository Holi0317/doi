import 'dart:async';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile/models/link.dart';
import 'package:mobile/providers/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/search_query.dart';
import '../models/search_response.dart';
import '../repositories/api.dart';
import './shared_preferences.dart';
import 'http.dart';

part 'api.g.dart';

@riverpod
Future<ApiRepository> apiRepository(Ref ref) async {
  final httpClient = ref.watch(httpClientProvider);

  final apiUrl = await ref.watch(apiUrlPreferenceProvider.future);
  final apiToken = await ref.watch(apiTokenPreferenceProvider.future);

  final client = ApiRepository(
    baseUrl: apiUrl,
    authToken: apiToken,
    transport: httpClient,
  );

  return client;
}

@riverpod
Future<SearchResponse> search(Ref ref, SearchQuery query) async {
  final client = await ref.watch(apiRepositoryProvider.future);
  return client.search(query, abortTrigger: ref.abortTrigger());
}

/// Search and paginate result. Returning PagingState for infinite_scroll_pagination package.
///
/// [query] is the query for first page. After that, this provider will fetch pages with given [cursors] parameter.
/// Widget should keep a list of cursors that needs to be fetched. You can get the cursor from `state.keys!.last`.
/// Make sure to check that cursor as non-empty string. The page might be in loading or error state and we use empty
/// string here as filler. This provider will assert that all cursors are non-empty string.
///
/// WARN: [cursors] list must be immutable for riverpod's change detection to work.
@riverpod
PagingState<String, Link> searchPaginated(
  Ref ref,
  SearchQuery query,
  List<String> cursors,
) {
  assert(
    cursors.every((c) => c.isNotEmpty),
    "Cursors must not be empty string.",
  );

  final queries = [
    query,
    ...cursors.map((cursor) => query.copyWith(cursor: cursor)),
  ];

  final values = queries.map((q) => ref.watch(searchProvider(q))).toList();

  return PagingState(
    isLoading: values.any((v) => v.isLoading),
    hasNextPage: values.last.value?.hasMore ?? false,
    error: values.where((v) => v.error != null).firstOrNull?.error,
    pages: values.map((v) => v.value?.items ?? []).toList(),
    keys: values.map((v) => v.value?.cursor ?? '').toList(),
  );
}
