import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_list_item_entity.freezed.dart';
part 'request_list_item_entity.g.dart';

/// Lifecycle of a captured request.
enum RequestState {
  /// Sent, no response or error yet.
  pending,

  /// A response arrived (any status code).
  completed,

  /// No usable response: timeout, connection error, cancel, etc.
  failed,
}

/// Status bucket used for the list filters and badge colors.
enum RequestStatusClass {
  pending,
  informational,
  success,
  redirect,
  clientError,
  serverError,
  error,
}

/// One row of the request list on the home screen.
@freezed
abstract class RequestListItemEntity with _$RequestListItemEntity {
  const RequestListItemEntity._();

  const factory RequestListItemEntity({
    @JsonKey(name: 'id') required String id,

    /// Upper-case HTTP method, e.g. `GET`, `POST`.
    @JsonKey(name: 'method') required String method,
    @JsonKey(name: 'uri') required Uri uri,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'state') required RequestState state,

    /// HTTP status code; null while pending or when the request failed
    /// without a response.
    @JsonKey(name: 'status_code') int? statusCode,

    /// Time from send to response/error; null while pending.
    @JsonKey(name: 'duration') Duration? duration,

    /// Response body size in bytes; null when unknown.
    @JsonKey(name: 'response_size') int? responseSize,

    /// `DioExceptionType` name for failed requests, e.g. `connectionTimeout`.
    @JsonKey(name: 'error_type') String? errorType,
  }) = _RequestListItemEntity;

  factory RequestListItemEntity.fromJson(Map<String, dynamic> json) =>
      _$RequestListItemEntityFromJson(json);

  String get host => uri.host;

  String get path => uri.path.isEmpty ? '/' : uri.path;

  /// Query string without the leading `?`; null when there is none.
  String? get query => uri.hasQuery && uri.query.isNotEmpty ? uri.query : null;

  RequestStatusClass get statusClass {
    switch (state) {
      case RequestState.pending:
        return RequestStatusClass.pending;
      case RequestState.failed:
        return RequestStatusClass.error;
      case RequestState.completed:
        final code = statusCode;
        if (code == null) return RequestStatusClass.error;
        if (code >= 500) return RequestStatusClass.serverError;
        if (code >= 400) return RequestStatusClass.clientError;
        if (code >= 300) return RequestStatusClass.redirect;
        if (code >= 200) return RequestStatusClass.success;
        return RequestStatusClass.informational;
    }
  }
}
