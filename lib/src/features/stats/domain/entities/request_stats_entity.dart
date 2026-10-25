import 'package:freezed_annotation/freezed_annotation.dart';

import 'endpoint_latency_entity.dart';
import 'endpoint_size_entity.dart';
import 'named_count_entity.dart';
import 'status_share_entity.dart';

part 'request_stats_entity.freezed.dart';
part 'request_stats_entity.g.dart';

/// Stats of the captured requests, for the stats page.
@freezed
abstract class RequestStatsEntity with _$RequestStatsEntity {
  const RequestStatsEntity._();

  /// Creates stats.
  const factory RequestStatsEntity({
    @JsonKey(name: 'total_requests') required int totalRequests,

    @JsonKey(name: 'finished_requests') required int finishedRequests,

    @JsonKey(name: 'success_count') required int successCount,

    @JsonKey(name: 'error_count') required int errorCount,

    @JsonKey(name: 'total_bytes') required int totalBytes,

    @JsonKey(name: 'average_latency') Duration? averageLatency,
    @JsonKey(name: 'p95_latency') Duration? p95Latency,

    @JsonKey(name: 'status_distribution')
    @Default(<StatusShareEntity>[])
    List<StatusShareEntity> statusDistribution,

    @JsonKey(name: 'slowest_endpoints')
    @Default(<EndpointLatencyEntity>[])
    List<EndpointLatencyEntity> slowestEndpoints,

    @JsonKey(name: 'largest_responses')
    @Default(<EndpointSizeEntity>[])
    List<EndpointSizeEntity> largestResponses,

    @JsonKey(name: 'most_called_endpoints')
    @Default(<NamedCountEntity>[])
    List<NamedCountEntity> mostCalledEndpoints,

    @JsonKey(name: 'top_hosts')
    @Default(<NamedCountEntity>[])
    List<NamedCountEntity> topHosts,
  }) = _RequestStatsEntity;

  /// Reads stats stored by `toJson`.
  factory RequestStatsEntity.fromJson(Map<String, dynamic> json) =>
      _$RequestStatsEntityFromJson(json);

  /// Stats of no requests.
  static const RequestStatsEntity empty = RequestStatsEntity(
    totalRequests: 0,
    finishedRequests: 0,
    successCount: 0,
    errorCount: 0,
    totalBytes: 0,
  );

  /// Whether there are no requests.
  bool get isEmpty => totalRequests == 0;

  /// Share of finished requests that succeeded, 0 to 1; null when none
  /// finished.
  double? get successRate =>
      finishedRequests == 0 ? null : successCount / finishedRequests;
}
