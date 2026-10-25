// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_detail_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestDetailEntity _$RequestDetailEntityFromJson(Map<String, dynamic> json) =>
    _RequestDetailEntity(
      id: json['id'] as String,
      method: json['method'] as String,
      uri: Uri.parse(json['uri'] as String),
      startedAt: DateTime.parse(json['started_at'] as String),
      state: $enumDecode(_$RequestStateEnumMap, json['state']),
      statusCode: (json['status_code'] as num?)?.toInt(),
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: (json['duration'] as num).toInt()),
      protocol: json['protocol'] as String?,
      requestSize: (json['request_size'] as num?)?.toInt(),
      responseSize: (json['response_size'] as num?)?.toInt(),
      requestContentType: json['request_content_type'] as String?,
      responseContentType: json['response_content_type'] as String?,
      requestHeaders:
          (json['request_headers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      responseHeaders:
          (json['response_headers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      requestBody: json['request_body'],
      responseBody: json['response_body'],
      errorType: $enumDecodeNullable(
        _$DioExceptionTypeEnumMap,
        json['error_type'],
      ),
      errorMessage: json['error_message'] as String?,
      stackTrace: json['stack_trace'] as String?,
      clientName: json['client_name'] as String?,
      hasFileUpload: json['has_file_upload'] as bool? ?? false,
      requestBodyIncomplete: json['request_body_incomplete'] as bool? ?? false,
    );

Map<String, dynamic> _$RequestDetailEntityToJson(
  _RequestDetailEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'method': instance.method,
  'uri': instance.uri.toString(),
  'started_at': instance.startedAt.toIso8601String(),
  'state': _$RequestStateEnumMap[instance.state]!,
  'status_code': instance.statusCode,
  'duration': instance.duration?.inMicroseconds,
  'protocol': instance.protocol,
  'request_size': instance.requestSize,
  'response_size': instance.responseSize,
  'request_content_type': instance.requestContentType,
  'response_content_type': instance.responseContentType,
  'request_headers': instance.requestHeaders,
  'response_headers': instance.responseHeaders,
  'request_body': instance.requestBody,
  'response_body': instance.responseBody,
  'error_type': _$DioExceptionTypeEnumMap[instance.errorType],
  'error_message': instance.errorMessage,
  'stack_trace': instance.stackTrace,
  'client_name': instance.clientName,
  'has_file_upload': instance.hasFileUpload,
  'request_body_incomplete': instance.requestBodyIncomplete,
};

const _$RequestStateEnumMap = {
  RequestState.pending: 'pending',
  RequestState.completed: 'completed',
  RequestState.failed: 'failed',
};

const _$DioExceptionTypeEnumMap = {
  DioExceptionType.connectionTimeout: 'connectionTimeout',
  DioExceptionType.sendTimeout: 'sendTimeout',
  DioExceptionType.receiveTimeout: 'receiveTimeout',
  DioExceptionType.badCertificate: 'badCertificate',
  DioExceptionType.badResponse: 'badResponse',
  DioExceptionType.cancel: 'cancel',
  DioExceptionType.connectionError: 'connectionError',
  DioExceptionType.unknown: 'unknown',
  DioExceptionType.transformTimeout: 'transformTimeout',
};
