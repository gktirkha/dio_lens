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
    @JsonKey(name: 'id') required String id,

    @JsonKey(name: 'method') required String method,
    @JsonKey(name: 'uri') required Uri uri,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'state') required RequestState state,

    @JsonKey(name: 'status_code') int? statusCode,

    @JsonKey(name: 'duration') Duration? duration,

    @JsonKey(name: 'response_size') int? responseSize,

    @JsonKey(name: 'error_type') DioExceptionType? errorType,

    @JsonKey(name: 'request_content_type') String? requestContentType,

    @JsonKey(name: 'response_content_type') String? responseContentType,
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
}
