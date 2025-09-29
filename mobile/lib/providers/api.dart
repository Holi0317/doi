import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/search_query.dart';
import '../models/search_response.dart';
import '../repositories/api.dart';
import 'http.dart';

part 'api.g.dart';

@riverpod
ApiRepository apiRepository(Ref ref) {
  final httpClient = ref.watch(httpClientProvider);

  final client = ApiRepository(
    baseUrl: 'http://100.66.229.117:8787/api',
    authToken: '86ed8dece3ba61d2',
    transport: httpClient,
  );

  return client;
}

/// Create an abortTrigger for http library from riverpod [Ref].
Future<void> _abortTrigger(Ref ref) {
  final completer = Completer<void>();
  ref.onDispose(completer.complete);
  return completer.future;
}

@riverpod
Future<SearchResponse> search(Ref ref, SearchQuery query) async {
  final client = ref.watch(apiRepositoryProvider);
  return client.search(query, abortTrigger: _abortTrigger(ref));
}
