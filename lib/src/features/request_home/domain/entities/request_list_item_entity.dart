import 'package:dio/dio.dart' show DioExceptionType;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/request_state.dart';
import '../../../../core/enums/request_status_class.dart';

part 'request_list_item_entity.freezed.dart';
part 'request_list_item_entity.g.dart';

@freezed
abstract class RequestListItemEntity with _$RequestListItemEntity {
  const RequestListItemEntity._();

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

  factory RequestListItemEntity.fromJson(Map<String, dynamic> json) =>
      _$RequestListItemEntityFromJson(json);

  String get host => uri.host;

  String get path => uri.path.isEmpty ? '/' : uri.path;

  String? get query => uri.hasQuery && uri.query.isNotEmpty ? uri.query : null;

  RequestStatusClass get statusClass =>
      RequestStatusClass.resolve(state, statusCode);
}
