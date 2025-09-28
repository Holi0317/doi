import 'dart:convert';
import 'dart:io' show Cookie;

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/search_query.dart';
import 'package:mobile/models/search_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'models/edit_op.dart';
import 'models/insert_item.dart';
import 'models/link.dart';

class RequestException implements Exception {
  final String path;
  final String method;
  final int statusCode;
  final String body;

  const RequestException({
    required this.path,
    required this.method,
    required this.statusCode,
    required this.body,
  });

  @override
  String toString() {
    return "RequestException for $method $path $statusCode: $body";
  }
}

class Client {
  final http.Client _client;

  // FIXME: Move url/auth to ctor
  String get baseUrl => 'http://100.66.229.117:8787/api';

  String get authToken => '86ed8dece3ba61d2';

  // FIXME: Use platform-specific http implementation
  Client() : _client = http.Client();

  /// Cleanup resource associated with this client.
  ///
  /// After calling [close], this client can no longer be used.
  void close() {
    _client.close();
  }

  /// Send a request to the server.
  ///
  /// This will emit a [http.ClientException] if there is a transport-level
  /// failure when communication with the server. For example, if the server could
  /// not be reached.
  ///
  /// Throws a [RequestException] if the response got a non-success (>= 400) status code.
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
    Future<void>? abortTrigger,
  }) async {
    assert(path.startsWith('/'));

    final url = Uri.parse(
      '$baseUrl$path',
    ).replace(queryParameters: queryParameters);

    final cookie = Cookie('__Host-doi-auth', authToken);

    final req = http.AbortableRequest(method, url, abortTrigger: abortTrigger);
    req.headers['cookie'] = cookie.toString();
    // FIXME: What's our agent?
    req.headers['user-agent'] = '';

    if (body != null) {
      req.headers['content-type'] = 'application/json';
      req.body = jsonEncode(body);
    }

    final resp = await _client.send(req);

    if (resp.statusCode >= 400) {
      final respBody = await resp.stream.bytesToString();
      throw RequestException(
        method: method,
        path: path,
        body: respBody,
        statusCode: resp.statusCode,
      );
    }

    return resp;
  }

  /// Insert link into server.
  Future<void> insert(
    List<InsertItem> items, {
    Future<void>? abortTrigger,
  }) async {
    // Each batch only support at most 100 items
    for (final chunk in items.slices(100)) {
      await _request(
        'POST',
        '/insert',
        body: {'items': chunk},
        abortTrigger: abortTrigger,
      );
    }
  }

  /// Search (or list) links from server.
  Future<SearchResponse> search(
    SearchQuery query, {
    Future<void>? abortTrigger,
  }) async {
    final resp = await _request(
      'GET',
      '/search',
      queryParameters: query.toMap(),
      abortTrigger: abortTrigger,
    );

    final responseBodyString = await resp.stream.bytesToString();
    final jsonResponse = jsonDecode(responseBodyString);
    return SearchResponse.fromJson(jsonResponse as Map<String, dynamic>);
  }

  /// Get a single link from server.
  ///
  /// If the item ID is not found, a [RequestException] with `statusCode == 404`
  /// will be thrown.
  Future<Link> getItem(int id, {Future<void>? abortTrigger}) async {
    final resp = await _request('GET', '/item/$id', abortTrigger: abortTrigger);

    final responseBodyString = await resp.stream.bytesToString();
    final jsonResponse = jsonDecode(responseBodyString);
    return Link.fromJson(jsonResponse as Map<String, dynamic>);
  }

  /// Edit links.
  Future<void> edit(List<EditOp> op, {Future<void>? abortTrigger}) async {
    // Each batch only support at most 100 items
    for (final chunk in op.slices(100)) {
      await _request(
        'POST',
        '/edit',
        body: {'op': chunk},
        abortTrigger: abortTrigger,
      );
    }
  }
}
