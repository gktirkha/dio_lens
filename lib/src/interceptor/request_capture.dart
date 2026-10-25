import 'dart:convert';
import 'dart:isolate';

import 'package:dio/dio.dart';

import '../core/enums/request_state.dart';
import '../core/utils/format_utils.dart';
import '../features/request_detail/domain/entities/request_detail_entity.dart';

/// A body made storable: JSON-encodable [body] and the full [size] in bytes.
typedef CapturedBody = ({Object? body, int? size});

/// Turns Dio's request, response and error objects into a
/// [RequestDetailEntity] whose bodies are JSON-encodable, so it can be
/// stored as is.
///
/// Body work (JSON round trips, decoding, base64, sizing) runs in a
/// background isolate; headers and metadata are read on the caller's.
abstract final class RequestCapture {
  /// The request part of a capture, still pending. Bodies over
  /// [maxBodyBytes] are cut (null keeps them whole).
  static Future<RequestDetailEntity> pending({
    required String id,
    required DateTime startedAt,
    required RequestOptions options,
    int? maxBodyBytes,
  }) async {
    final data = options.data;
    final contentType = data == null ? null : _requestContentType(options);
    final captured = await _capture(data, contentType, maxBodyBytes);
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
      requestContentType: captured.body == null ? null : contentType,
      requestBody: captured.body,
      requestSize: captured.size,
    );
  }

  /// [request] finished with [response] (any status code) at [finishedAt].
  static Future<RequestDetailEntity> completed(
    RequestDetailEntity request,
    Response<dynamic> response, {
    required DateTime finishedAt,
    int? maxBodyBytes,
  }) async {
    final contentType = response.headers.value(Headers.contentTypeHeader);
    final headers = {
      for (final e in response.headers.map.entries) e.key: e.value.join(', '),
    };
    final captured = await _capture(response.data, contentType, maxBodyBytes);
    final lengthHeader = response.headers.value(Headers.contentLengthHeader);
    return request.copyWith(
      state: RequestState.completed,
      statusCode: response.statusCode,
      duration: finishedAt.difference(request.startedAt),
      responseHeaders: headers,
      responseContentType: contentType,
      responseBody: captured.body,
      responseSize:
          (lengthHeader == null ? null : int.tryParse(lengthHeader)) ??
          captured.size,
    );
  }

  /// [request] failed without a response at [finishedAt].
  static RequestDetailEntity failed(
    RequestDetailEntity request,
    DioException error, {
    required DateTime finishedAt,
  }) => request.copyWith(
    state: RequestState.failed,
    duration: finishedAt.difference(request.startedAt),
    errorType: error.type,
    errorMessage: error.message ?? error.error?.toString(),
    stackTrace: error.stackTrace.toString(),
  );

  static String? _requestContentType(RequestOptions options) =>
      options.contentType ??
      (options.data is FormData ? Headers.multipartFormDataContentType : null);

  /// Form data and streams (which cannot be sent to an isolate) are handled
  /// here; every other body goes through [_process] in an isolate.
  static Future<CapturedBody> _capture(
    Object? data,
    String? contentType,
    int? maxBytes,
  ) async {
    switch (data) {
      case null || ResponseBody() || Stream<dynamic>():
        return (body: null, size: null);
      case FormData form:
        return (
          body: {
            for (final e in form.fields) e.key: e.value,
            for (final e in form.files)
              e.key: '${e.value.filename ?? 'file'} (${e.value.length} bytes)',
          },
          size: form.length,
        );
    }
    try {
      return await _processInIsolate(data, contentType, maxBytes);
    } catch (_) {
      // Not sendable (e.g. an object holding a closure): do it here.
      return _process(data, contentType, maxBytes);
    }
  }

  // Static, so the closure captures only its arguments.
  static Future<CapturedBody> _processInIsolate(
    Object data,
    String? contentType,
    int? maxBytes,
  ) => Isolate.run(() => _process(data, contentType, maxBytes));

  /// [data] made storable and sized. Runs in an isolate.
  static CapturedBody _process(Object data, String? contentType, int? max) {
    final type = (contentType ?? '').toLowerCase();
    switch (data) {
      case String text:
        return _text(text, utf8.encode(text), type, max);
      case List<int> bytes:
        if (bytes.isEmpty) return (body: null, size: 0);
        if (type.startsWith('image/')) {
          final fits = max == null || bytes.length <= max;
          return (body: fits ? base64Encode(bytes) : null, size: bytes.length);
        }
        if (_isJson(type) || type.startsWith('text/') || type.contains('xml')) {
          return _text(
            utf8.decode(bytes, allowMalformed: true),
            bytes,
            type,
            max,
          );
        }
        // Other binary bodies are not kept, only their size.
        return (body: null, size: bytes.length);
      default:
        final String encoded;
        try {
          encoded = jsonEncode(data, toEncodable: _toEncodable);
        } catch (_) {
          final text = data.toString();
          return (body: text, size: utf8.encode(text).length);
        }
        final bytes = utf8.encode(encoded);
        if (max != null && bytes.length > max) {
          return (body: _truncated(bytes, max), size: bytes.length);
        }
        return (body: jsonDecode(encoded), size: bytes.length);
    }
  }

  /// [text] (encoded as [bytes]) as decoded JSON when [type] says JSON and
  /// it parses, else as text; over [max] bytes, truncated text.
  static CapturedBody _text(
    String text,
    List<int> bytes,
    String type,
    int? max,
  ) {
    if (bytes.isEmpty) return (body: null, size: 0);
    if (max != null && bytes.length > max) {
      return (body: _truncated(bytes, max), size: bytes.length);
    }
    if (_isJson(type)) {
      try {
        return (body: jsonDecode(text), size: bytes.length);
      } on FormatException {
        // Not valid JSON: keep the text.
      }
    }
    return (body: text, size: bytes.length);
  }

  /// The first [max] bytes of [bytes] as text, with a note.
  static String _truncated(List<int> bytes, int max) =>
      '${utf8.decode(bytes.sublist(0, max), allowMalformed: true)}\n\n'
      '… Truncated by Dio Lens: showing the first '
      '${FormatUtils.bytes(max)} of ${FormatUtils.bytes(bytes.length)}.';

  static bool _isJson(String type) => type.contains('json');

  static String _headerValue(Object? value) => switch (value) {
    Iterable<dynamic> values => values.join(', '),
    _ => '$value',
  };

  /// Objects go through their `toJson()`, or `toString()` without one.
  static Object? _toEncodable(Object? value) {
    try {
      return (value as dynamic).toJson();
    } catch (_) {
      return value.toString();
    }
  }
}
