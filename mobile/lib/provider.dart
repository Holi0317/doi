import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'client.dart';
import 'models/search_query.dart';
import 'models/search_response.dart';

part 'provider.g.dart';

@riverpod
Client client(Ref ref) {
  final client = Client();
  ref.onDispose(client.close);
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
  final client = ref.watch(clientProvider);
  return client.search(query, abortTrigger: _abortTrigger(ref));
}
