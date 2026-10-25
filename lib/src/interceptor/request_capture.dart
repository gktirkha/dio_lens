import 'dart:convert';

import 'package:dio/dio.dart';

import '../core/enums/request_state.dart';
import '../features/request_detail/domain/entities/request_detail_entity.dart';

/// Turns Dio's request, response and error objects into a
/// [RequestDetailEntity] whose bodies are JSON-encodable, so it can be
/// stored as is.
abstract final class RequestCapture {
  /// Image bodies up to this size are kept (base64) for the preview.
  static const int maxImageBytes = 512 * 1024;

  /// The request part of a capture, still pending.
  static RequestDetailEntity pending({
    required String id,
    required DateTime startedAt,
    required RequestOptions options,
  }) {
    final data = options.data;
    final contentType = data == null ? null : _requestContentType(options);
    final body = _requestBody(data, contentType);
    return RequestDetailEntity(
      id: id,
      method: options.method.toUpperCase(),
      uri: options.uri,
      startedAt: startedAt,
      state: RequestState.pending,
      requestHeaders: {
        for (final e in options.headers.entries)
          if (e.value != null) e.key: _headerValue(e.value),
      },
      requestContentType: body == null ? null : contentType,
      requestBody: body,
      requestSize: _requestSize(data, body),
    );
  }

  /// [request] finished with [response] (any status code).
  static RequestDetailEntity completed(
    RequestDetailEntity request,
    Response<dynamic> response,
  ) {
    final contentType = response.headers.value(Headers.contentTypeHeader);
    final data = response.data;
    return request.copyWith(
      state: RequestState.completed,
      statusCode: response.statusCode,
      duration: DateTime.now().difference(request.startedAt),
      responseHeaders: {
        for (final e in response.headers.map.entries) e.key: e.value.join(', '),
      },
      responseContentType: contentType,
      responseBody: _responseBody(data, contentType),
      responseSize: _responseSize(response, data),
    );
  }

  /// [request] failed without a response.
  static RequestDetailEntity failed(
    RequestDetailEntity request,
    DioException error,
  ) => request.copyWith(
    state: RequestState.failed,
    duration: DateTime.now().difference(request.startedAt),
    errorType: error.type,
    errorMessage: error.message ?? error.error?.toString(),
    stackTrace: error.stackTrace.toString(),
  );

  static String? _requestContentType(RequestOptions options) =>
      options.contentType ??
      (options.data is FormData ? Headers.multipartFormDataContentType : null);

  static Object? _requestBody(Object? data, String? contentType) =>
      switch (data) {
        null => null,
        FormData form => {
          for (final e in form.fields) e.key: e.value,
          for (final e in form.files)
            e.key: '${e.value.filename ?? 'file'} (${e.value.length} bytes)',
        },
        String text => _decodeText(text, contentType),
        List<int> bytes => _decodeBytes(bytes, contentType),
        Stream<dynamic>() => null,
        _ => _jsonSafe(data),
      };

  static int? _requestSize(Object? data, Object? body) => switch (data) {
    null => null,
    FormData form => form.length,
    List<int> bytes => bytes.length,
    String text => utf8.encode(text).length,
    _ => body == null ? null : _encodedSize(body),
  };

  static Object? _responseBody(Object? data, String? contentType) =>
      switch (data) {
        null || ResponseBody() || Stream<dynamic>() => null,
        String text => _decodeText(text, contentType),
        List<int> bytes => _decodeBytes(bytes, contentType),
        _ => _jsonSafe(data),
      };

  static int? _responseSize(Response<dynamic> response, Object? data) {
    final header = response.headers.value(Headers.contentLengthHeader);
    if (header != null) {
      if (int.tryParse(header) case final length?) return length;
    }
    return switch (data) {
      null || ResponseBody() || Stream<dynamic>() => null,
      List<int> bytes => bytes.length,
      String text => utf8.encode(text).length,
      _ => _encodedSize(data),
    };
  }

  /// Text as decoded JSON when [contentType] says JSON and it parses.
  static Object? _decodeText(String text, String? contentType) {
    if (text.isEmpty) return null;
    if (_isJson(contentType)) {
      try {
        return jsonDecode(text);
      } on FormatException {
        return text;
      }
    }
    return text;
  }

  /// Small images as base64 (for the preview), text as text, other binary
  /// bodies dropped: only their size is kept.
  static Object? _decodeBytes(List<int> bytes, String? contentType) {
    if (bytes.isEmpty) return null;
    final type = (contentType ?? '').toLowerCase();
    if (type.startsWith('image/')) {
      return bytes.length <= maxImageBytes ? base64Encode(bytes) : null;
    }
    if (_isJson(type) || type.startsWith('text/') || type.contains('xml')) {
      return _decodeText(utf8.decode(bytes, allowMalformed: true), type);
    }
    return null;
  }

  static bool _isJson(String? contentType) =>
      (contentType ?? '').toLowerCase().contains('json');

  static String _headerValue(Object? value) => switch (value) {
    Iterable<dynamic> values => values.join(', '),
    _ => '$value',
  };

  /// [value] reduced to maps, lists, strings, numbers, booleans and null;
  /// objects go through their `toJson()`, or `toString()` without one.
  static Object? _jsonSafe(Object? value) {
    try {
      return jsonDecode(jsonEncode(value, toEncodable: _toEncodable));
    } catch (_) {
      return value.toString();
    }
  }

  static Object? _toEncodable(Object? value) {
    try {
      return (value as dynamic).toJson();
    } catch (_) {
      return value.toString();
    }
  }

  static int? _encodedSize(Object body) {
    try {
      return utf8.encode(jsonEncode(body)).length;
    } catch (_) {
      return null;
    }
  }
}
