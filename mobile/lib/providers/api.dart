import 'dart:async';

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
