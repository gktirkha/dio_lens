// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_list_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestListItemEntity _$RequestListItemEntityFromJson(
  Map<String, dynamic> json,
) => _RequestListItemEntity(
  id: json['id'] as String,
  method: json['method'] as String,
  uri: Uri.parse(json['uri'] as String),
  startedAt: DateTime.parse(json['started_at'] as String),
  state: $enumDecode(_$RequestStateEnumMap, json['state']),
  statusCode: (json['status_code'] as num?)?.toInt(),
  duration: json['duration'] == null
      ? null
      : Duration(microseconds: (json['duration'] as num).toInt()),
  responseSize: (json['response_size'] as num?)?.toInt(),
  errorType: json['error_type'] as String?,
);

Map<String, dynamic> _$RequestListItemEntityToJson(
  _RequestListItemEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'method': instance.method,
  'uri': instance.uri.toString(),
  'started_at': instance.startedAt.toIso8601String(),
  'state': _$RequestStateEnumMap[instance.state]!,
  'status_code': instance.statusCode,
  'duration': instance.duration?.inMicroseconds,
  'response_size': instance.responseSize,
  'error_type': instance.errorType,
};

const _$RequestStateEnumMap = {
  RequestState.pending: 'pending',
  RequestState.completed: 'completed',
  RequestState.failed: 'failed',
};
