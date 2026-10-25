import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Answers requests without a network, and records what was sent.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter([this.handler]);

  /// Builds the response; defaults to `200 {"ok":true}`.
  final Future<ResponseBody> Function(RequestOptions options)? handler;

  final List<RequestOptions> requests = [];
  final List<String> bodies = [];

  static ResponseBody json(Object body, [int status = 200]) =>
      ResponseBody.fromString(
        jsonEncode(body),
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final bytes = <int>[];
    if (requestStream != null) {
      await for (final chunk in requestStream) {
        bytes.addAll(chunk);
      }
    }
    bodies.add(utf8.decode(bytes, allowMalformed: true));
    return handler?.call(options) ?? json({'ok': true});
  }

  @override
  void close({bool force = false}) {}
}
