import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http.g.dart';

@riverpod
http.Client httpClient(Ref ref) {
  // FIXME: Use platform-specific http implementation
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
}
