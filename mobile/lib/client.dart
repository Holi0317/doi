import 'dart:convert';
import 'dart:io' show Cookie;

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/search_query.dart';
import 'package:mobile/models/search_response.dart';

import 'models/edit_op.dart';
import 'models/insert_item.dart';
import 'models/link.dart';

class ClientException implements Exception {
  final String message;
  final String? responseBody;

  ClientException(this.message, [this.responseBody]);

  @override
  String toString() {
    if (responseBody != null) {
      return "ClientException: $message - Response body: $responseBody";
    }
    return "ClientException: $message";
  }
}

class Client {
  final http.Client _client;

  String get baseUrl => 'http://127.0.0.1:8787/api';

  String get authToken => '';

  Client() : _client = http.Client();

  /// Send a request to the server.
  ///
  /// FIXME: This is ClientException from http. We should rename our exception.
  /// This will emit a [ClientException] if there is a transport-level
  /// failure when communication with the server. For example, if the server could
  /// not be reached.
  ///
  /// Throws a [ClientException] if the response got a non-success (>= 400) status code.
  ///
  /// [path] should begin with a `/`.
  ///
  /// If [body] is provided, request will be sent as json. Do not provide [body]
  /// on GET request.
  Future<http.StreamedResponse> _request(
    String method,
    String path, {
    Object? body,
    Map<String, String>? queryParameters,
  }) async {
    assert(path.startsWith('/'));

    final url = Uri.parse(
      '$baseUrl$path',
    ).replace(queryParameters: queryParameters);

    final cookie = Cookie('__Host-doi-auth', authToken);

    // FIXME: Add cancel context
    final req = http.AbortableRequest(method, url);
    req.headers['cookie'] = cookie.toString();
    // FIXME: What's our agent?
    req.headers['user-agent'] = '';

    if (body != null) {
      req.headers['content-type'] = 'application/json';
      req.body = jsonEncode(body);
    }

    final resp = await _client.send(req);

    if (resp.statusCode >= 400) {
      final responseBody = await resp.stream.bytesToString();
      throw ClientException('Request failed with status code ${resp.statusCode}', responseBody);
    }

    return resp;
  }

  Future<void> insert(List<InsertItem> items) async {
    // Each batch only support at most 100 items
    for (final chunk in items.slices(100)) {
      await _request('POST', '/insert', body: {'items': chunk});
    }
  }

  Future<SearchResponse> search(SearchQuery query) async {
    final resp = await _request(
      'GET',
      '/search',
      queryParameters: query.toMap(),
    );

    final responseBodyString = await resp.stream.bytesToString();
    final jsonResponse = jsonDecode(responseBodyString);
    return SearchResponse.fromJson(jsonResponse as Map<String, dynamic>);
  }

  Future<Link> getItem(int id) async {
    final resp = await _request(
      'GET',
      '/item/$id',
    );

    final responseBodyString = await resp.stream.bytesToString();
    final jsonResponse = jsonDecode(responseBodyString);
    return Link.fromJson(jsonResponse as Map<String, dynamic>);
  }

  Future<void> edit(List<EditOp> op) async {
    // Each batch only support at most 100 items
    for (final chunk in op.slices(100)) {
      await _request('POST', '/edit', body: {'op': chunk});
    }
  }
}
