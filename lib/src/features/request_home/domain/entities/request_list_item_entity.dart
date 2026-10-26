import 'package:dio/dio.dart' show DioExceptionType;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/request_state.dart';
import '../../../../core/enums/request_status_class.dart';

part 'request_list_item_entity.freezed.dart';
part 'request_list_item_entity.g.dart';

/// One row of the request list: the summary of a captured request, without
/// headers or bodies.
@freezed
abstract class RequestListItemEntity with _$RequestListItemEntity {
  const RequestListItemEntity._();

  /// Creates a list row.
  const factory RequestListItemEntity({
    /// Unique id of the capture.
    @JsonKey(name: 'id') required String id,

    /// Upper-case HTTP method, e.g. `GET`, `POST`.
    @JsonKey(name: 'method') required String method,

    /// Full request URL.
    @JsonKey(name: 'uri') required Uri uri,

    /// When the request was sent.
    @JsonKey(name: 'started_at') required DateTime startedAt,

    /// Whether the request is pending, completed or failed.
    @JsonKey(name: 'state') required RequestState state,

    /// HTTP status code; null while pending or when no response arrived.
    @JsonKey(name: 'status_code') int? statusCode,

    /// Whether the Dio's `validateStatus` accepted [statusCode]; null when
    /// unknown.
    @JsonKey(name: 'valid_status') bool? validStatus,

    /// Time from send to response or error; null while pending.
    @JsonKey(name: 'duration') Duration? duration,

    /// Response body size in bytes; null when unknown.
    @JsonKey(name: 'response_size') int? responseSize,

    /// Why the request failed without a response; null otherwise.
    @JsonKey(name: 'error_type') DioExceptionType? errorType,

    /// MIME type of the request body; null when there is none.
    @JsonKey(name: 'request_content_type') String? requestContentType,

    /// MIME type of the response body; null when there is none.
    @JsonKey(name: 'response_content_type') String? responseContentType,

    /// Whether the request uploaded files, whose contents are not captured.
    @JsonKey(name: 'has_file_upload') @Default(false) bool hasFileUpload,

    /// Whether the captured request body differs from what was sent.
    @JsonKey(name: 'request_body_incomplete')
    @Default(false)
    bool requestBodyIncomplete,
  }) = _RequestListItemEntity;

  /// Reads a row stored by `toJson`.
  factory RequestListItemEntity.fromJson(Map<String, dynamic> json) =>
      _$RequestListItemEntityFromJson(json);

  /// Host of [uri].
  String get host => uri.host;

  /// Path of [uri]; `/` when empty.
  String get path => uri.path.isEmpty ? '/' : uri.path;

  /// Query string without the leading `?`; null when there is none.
  String? get query => uri.hasQuery && uri.query.isNotEmpty ? uri.query : null;

  /// Category used for badges, filters and stats.
  RequestStatusClass get statusClass =>
      RequestStatusClass.resolve(state, statusCode);

  /// Whether the request failed: no response arrived, or the Dio's
  /// `validateStatus` rejected the status code. When that verdict is unknown
  /// ([validStatus] is null), a 4xx or 5xx status counts as a failure.
  bool get isFailure => switch (state) {
    RequestState.pending => false,
    RequestState.failed => true,
    RequestState.completed => switch (validStatus) {
      final valid? => !valid,
      null => _failingClasses.contains(statusClass),
    },
  };

  /// Whether the request succeeded: a response arrived and the Dio's
  /// `validateStatus` accepted its status code. When that verdict is unknown
  /// ([validStatus] is null), a 2xx status counts as a success.
  bool get isSuccess => switch (state) {
    RequestState.pending || RequestState.failed => false,
    RequestState.completed => switch (validStatus) {
      final valid? => valid,
      null => statusClass == RequestStatusClass.success,
    },
  };

  static const Set<RequestStatusClass> _failingClasses = {
    RequestStatusClass.clientError,
    RequestStatusClass.serverError,
  };
}
