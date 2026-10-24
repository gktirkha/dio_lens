// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endpoint_latency_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EndpointLatencyEntity _$EndpointLatencyEntityFromJson(
  Map<String, dynamic> json,
) => _EndpointLatencyEntity(
  path: json['path'] as String,
  averageLatency: Duration(
    microseconds: (json['average_latency'] as num).toInt(),
  ),
);

Map<String, dynamic> _$EndpointLatencyEntityToJson(
  _EndpointLatencyEntity instance,
) => <String, dynamic>{
  'path': instance.path,
  'average_latency': instance.averageLatency.inMicroseconds,
};
