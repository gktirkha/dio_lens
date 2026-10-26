// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_stats_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestStatsEntity _$RequestStatsEntityFromJson(
  Map<String, dynamic> json,
) => _RequestStatsEntity(
  totalRequests: (json['total_requests'] as num).toInt(),
  finishedRequests: (json['finished_requests'] as num).toInt(),
  successCount: (json['success_count'] as num).toInt(),
  errorCount: (json['error_count'] as num).toInt(),
  totalBytes: (json['total_bytes'] as num).toInt(),
  averageLatency: json['average_latency'] == null
      ? null
      : Duration(microseconds: (json['average_latency'] as num).toInt()),
  p95Latency: json['p95_latency'] == null
      ? null
      : Duration(microseconds: (json['p95_latency'] as num).toInt()),
  statusDistribution:
      (json['status_distribution'] as List<dynamic>?)
          ?.map((e) => StatusShareEntity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <StatusShareEntity>[],
  slowestEndpoints:
      (json['slowest_endpoints'] as List<dynamic>?)
          ?.map(
            (e) => EndpointLatencyEntity.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <EndpointLatencyEntity>[],
  topFailingEndpoints:
      (json['top_failing_endpoints'] as List<dynamic>?)
          ?.map((e) => NamedCountEntity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <NamedCountEntity>[],
  largestResponses:
      (json['largest_responses'] as List<dynamic>?)
          ?.map((e) => EndpointSizeEntity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <EndpointSizeEntity>[],
  mostCalledEndpoints:
      (json['most_called_endpoints'] as List<dynamic>?)
          ?.map((e) => NamedCountEntity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <NamedCountEntity>[],
  topHosts:
      (json['top_hosts'] as List<dynamic>?)
          ?.map((e) => NamedCountEntity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <NamedCountEntity>[],
);

Map<String, dynamic> _$RequestStatsEntityToJson(_RequestStatsEntity instance) =>
    <String, dynamic>{
      'total_requests': instance.totalRequests,
      'finished_requests': instance.finishedRequests,
      'success_count': instance.successCount,
      'error_count': instance.errorCount,
      'total_bytes': instance.totalBytes,
      'average_latency': instance.averageLatency?.inMicroseconds,
      'p95_latency': instance.p95Latency?.inMicroseconds,
      'status_distribution': instance.statusDistribution
          .map((e) => e.toJson())
          .toList(),
      'slowest_endpoints': instance.slowestEndpoints
          .map((e) => e.toJson())
          .toList(),
      'top_failing_endpoints': instance.topFailingEndpoints
          .map((e) => e.toJson())
          .toList(),
      'largest_responses': instance.largestResponses
          .map((e) => e.toJson())
          .toList(),
      'most_called_endpoints': instance.mostCalledEndpoints
          .map((e) => e.toJson())
          .toList(),
      'top_hosts': instance.topHosts.map((e) => e.toJson()).toList(),
    };
