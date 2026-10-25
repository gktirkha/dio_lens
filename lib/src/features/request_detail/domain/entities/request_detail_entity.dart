import 'dart:convert';

import 'package:dio/dio.dart' show DioExceptionType;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/request_state.dart';
import '../../../../core/enums/request_status_class.dart';

part 'request_detail_entity.freezed.dart';
part 'request_detail_entity.g.dart';

/// Everything captured about one request, for the detail screen.
@freezed
abstract class RequestDetailEntity with _$RequestDetailEntity {
  const RequestDetailEntity._();

  const factory RequestDetailEntity({
    @JsonKey(name: 'id') required String id,

    /// Upper-case HTTP method, e.g. `GET`, `QUERY`.
    @JsonKey(name: 'method') required String method,
    @JsonKey(name: 'uri') required Uri uri,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'state') required RequestState state,
    @JsonKey(name: 'status_code') int? statusCode,
    @JsonKey(name: 'duration') Duration? duration,

    /// e.g. `HTTP/2`; null when unknown.
    @JsonKey(name: 'protocol') String? protocol,

    /// Body sizes in bytes; null when unknown.
    @JsonKey(name: 'request_size') int? requestSize,
    @JsonKey(name: 'response_size') int? responseSize,
    @JsonKey(name: 'request_content_type') String? requestContentType,
    @JsonKey(name: 'response_content_type') String? responseContentType,
    @JsonKey(name: 'request_headers')
    @Default(<String, String>{})
    Map<String, String> requestHeaders,
    @JsonKey(name: 'response_headers')
    @Default(<String, String>{})
    Map<String, String> responseHeaders,

    /// Decoded body: a JSON map/list, a form map, a string, or null.
    @JsonKey(name: 'request_body') Object? requestBody,
    @JsonKey(name: 'response_body') Object? responseBody,

    /// Why the request failed without a response; null otherwise.
    @JsonKey(name: 'error_type') DioExceptionType? errorType,
    @JsonKey(name: 'error_message') String? errorMessage,
    @JsonKey(name: 'stack_trace') String? stackTrace,
  }) = _RequestDetailEntity;

  factory RequestDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$RequestDetailEntityFromJson(json);

  String get host => uri.host;

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
