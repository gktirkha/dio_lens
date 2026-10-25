import 'dart:convert';
import 'dart:isolate';

import 'package:dio/dio.dart';

import '../core/enums/request_state.dart';
import '../core/utils/format_utils.dart';
import '../features/request_detail/domain/entities/request_detail_entity.dart';

typedef CapturedBody = ({Object? body, int? size});

abstract final class RequestCapture {
  static Future<RequestDetailEntity> pending({
    required String id,
    required DateTime startedAt,
    required RequestOptions options,
    int? maxBodyBytes,
    String? clientName,
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
      clientName: clientName,
      hasFileUpload: data is FormData && data.files.isNotEmpty,
      requestBodyIncomplete: switch (data) {
        null || FormData() => false,
        Stream<dynamic>() => true,
        _ =>
          captured.body == null
              ? (captured.size ?? 0) > 0
              : maxBodyBytes != null && (captured.size ?? 0) > maxBodyBytes,
      },
    );
  }

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
      return _process(data, contentType, maxBytes);
    }
  }

  static Future<CapturedBody> _processInIsolate(
    Object data,
    String? contentType,
    int? maxBytes,
  ) => Isolate.run(() => _process(data, contentType, maxBytes));

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
      } on FormatException catch (_) {}
    }
    return (body: text, size: bytes.length);
  }

  static String _truncated(List<int> bytes, int max) =>
      '${utf8.decode(bytes.sublist(0, max), allowMalformed: true)}\n\n'
      '… Truncated by Dio Lens: showing the first '
      '${FormatUtils.bytes(max)} of ${FormatUtils.bytes(bytes.length)}.';

  static bool _isJson(String type) => type.contains('json');

  static String _headerValue(Object? value) => switch (value) {
    Iterable<dynamic> values => values.join(', '),
    _ => '$value',
  };

  static Object? _toEncodable(Object? value) {
    try {
      return (value as dynamic).toJson();
    } catch (_) {
      return value.toString();
    }
  }
}
