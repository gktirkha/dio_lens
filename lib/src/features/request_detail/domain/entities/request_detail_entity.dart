import 'dart:convert';

import 'package:dio/dio.dart' show DioExceptionType;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/request_state.dart';
import '../../../../core/enums/request_status_class.dart';

part 'request_detail_entity.freezed.dart';
part 'request_detail_entity.g.dart';

/// Everything captured about one request.
@freezed
abstract class RequestDetailEntity with _$RequestDetailEntity {
  const RequestDetailEntity._();

  /// Creates a captured request.
  const factory RequestDetailEntity({
    /// Unique id of the capture.
    @JsonKey(name: 'id') required String id,

    /// Upper-case HTTP method, e.g. `GET`, `QUERY`.
    @JsonKey(name: 'method') required String method,

    /// Full request URL.
    @JsonKey(name: 'uri') required Uri uri,

    /// When the request was sent.
    @JsonKey(name: 'started_at') required DateTime startedAt,

    /// Whether the request is pending, completed or failed.
    @JsonKey(name: 'state') required RequestState state,

    /// HTTP status code; null while pending or when no response arrived.
    @JsonKey(name: 'status_code') int? statusCode,

    /// Whether the Dio's `validateStatus` accepted [statusCode]; null while
    /// pending, when no response arrived, or for requests captured before
    /// this was recorded.
    @JsonKey(name: 'valid_status') bool? validStatus,

    /// Time from send to response or error; null while pending.
    @JsonKey(name: 'duration') Duration? duration,

    /// Protocol, e.g. `HTTP/2`; null when unknown.
    @JsonKey(name: 'protocol') String? protocol,

    /// Request body size in bytes; null when unknown.
    @JsonKey(name: 'request_size') int? requestSize,

    /// Response body size in bytes; null when unknown.
    @JsonKey(name: 'response_size') int? responseSize,

    /// MIME type of the request body; null when there is none.
    @JsonKey(name: 'request_content_type') String? requestContentType,

    /// MIME type of the response body; null when there is none.
    @JsonKey(name: 'response_content_type') String? responseContentType,

    /// Request headers.
    @JsonKey(name: 'request_headers')
    @Default(<String, String>{})
    Map<String, String> requestHeaders,

    /// Response headers, multiple values joined with commas.
    @JsonKey(name: 'response_headers')
    @Default(<String, String>{})
    Map<String, String> responseHeaders,

    /// Decoded request body: a JSON map or list, a form map, text, or null.
    @JsonKey(name: 'request_body') Object? requestBody,

    /// Decoded response body: a JSON map or list, text, base64 image bytes, or
    /// null.
    @JsonKey(name: 'response_body') Object? responseBody,

    /// Why the request failed without a response; null otherwise.
    @JsonKey(name: 'error_type') DioExceptionType? errorType,

    /// Error message of a failed request.
    @JsonKey(name: 'error_message') String? errorMessage,

    /// Stack trace of a failed request.
    @JsonKey(name: 'stack_trace') String? stackTrace,

    /// Name of the interceptor's Dio, used to pick the Dio on replay.
    @JsonKey(name: 'client_name') String? clientName,

    /// Whether the request uploaded files, whose contents are not captured.
    @JsonKey(name: 'has_file_upload') @Default(false) bool hasFileUpload,

    /// Whether the captured request body differs from what was sent (truncated
    /// or not captured).
    @JsonKey(name: 'request_body_incomplete')
    @Default(false)
    bool requestBodyIncomplete,
  }) = _RequestDetailEntity;

  /// Reads a request stored by `toJson`.
  factory RequestDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$RequestDetailEntityFromJson(json);

  /// Host of [uri].
  String get host => uri.host;

  /// Path of [uri]; `/` when empty.
  String get path => uri.path.isEmpty ? '/' : uri.path;

  /// Query string without the leading `?`; null when there is none.
  String? get query => uri.hasQuery && uri.query.isNotEmpty ? uri.query : null;

  /// Decoded query parameters in URL order, duplicates kept.
  List<({String key, String value})> get queryParameters {
    final q = query;
    if (q == null) return const [];
    return [
      for (final pair in q.split('&'))
        if (pair.isNotEmpty) _decodePair(pair),
    ];
  }

  /// Category used for badges, filters and stats.
  RequestStatusClass get statusClass =>
      RequestStatusClass.resolve(state, statusCode);

  /// Equivalent `curl` command, one option per line.
  String get curl {
    final parts = <String>["curl -X $method '$uri'"];
    requestHeaders.forEach((k, v) => parts.add("-H '$k: $v'"));
    final body = requestBody;
    if (body != null) {
      final isForm =
          (requestContentType ?? '').toLowerCase().contains(
            'x-www-form-urlencoded',
          ) &&
          body is Map;
      final encoded = isForm
          ? body.entries
                .map(
                  (e) =>
                      '${Uri.encodeQueryComponent('${e.key}')}='
                      '${Uri.encodeQueryComponent('${e.value}')}',
                )
                .join('&')
          : body is String
          ? body
          : jsonEncode(body);
      parts.add("-d '$encoded'");
    }
    return parts.join(' \\\n  ');
  }

  static ({String key, String value}) _decodePair(String pair) {
    final i = pair.indexOf('=');
    String decode(String s) {
      try {
        return Uri.decodeQueryComponent(s);
      } on FormatException {
        return s;
      }
    }

    return i < 0
        ? (key: decode(pair), value: '')
        : (
            key: decode(pair.substring(0, i)),
            value: decode(pair.substring(i + 1)),
          );
  }
}
