import 'package:freezed_annotation/freezed_annotation.dart';

import 'endpoint_latency_entity.dart';
import 'named_count_entity.dart';
import 'status_share_entity.dart';

part 'request_stats_entity.freezed.dart';
part 'request_stats_entity.g.dart';

/// Aggregated figures for the stats dashboard.
@freezed
abstract class RequestStatsEntity with _$RequestStatsEntity {
  const RequestStatsEntity._();

  const factory RequestStatsEntity({
    @JsonKey(name: 'total_requests') required int totalRequests,

    /// Completed or failed, i.e. not pending.
    @JsonKey(name: 'finished_requests') required int finishedRequests,

    /// 2xx responses.
    @JsonKey(name: 'success_count') required int successCount,

    /// 4xx, 5xx and requests that failed without a response.
    @JsonKey(name: 'error_count') required int errorCount,

    /// Sum of response body sizes, in bytes.
    @JsonKey(name: 'total_bytes') required int totalBytes,

    /// Null when no request has finished yet.
    @JsonKey(name: 'average_latency') Duration? averageLatency,
    @JsonKey(name: 'p95_latency') Duration? p95Latency,

    /// Only status classes that occur, in display order.
    @JsonKey(name: 'status_distribution')
    @Default(<StatusShareEntity>[])
    List<StatusShareEntity> statusDistribution,

    /// Slowest first.
    @JsonKey(name: 'slowest_endpoints')
    @Default(<EndpointLatencyEntity>[])
    List<EndpointLatencyEntity> slowestEndpoints,

    /// Most called first.
    @JsonKey(name: 'most_called_endpoints')
    @Default(<NamedCountEntity>[])
    List<NamedCountEntity> mostCalledEndpoints,

    /// Busiest first.
    @JsonKey(name: 'top_hosts')
    @Default(<NamedCountEntity>[])
    List<NamedCountEntity> topHosts,
  }) = _RequestStatsEntity;

  factory RequestStatsEntity.fromJson(Map<String, dynamic> json) =>
      _$RequestStatsEntityFromJson(json);

  static const RequestStatsEntity empty = RequestStatsEntity(
    totalRequests: 0,
    finishedRequests: 0,
    successCount: 0,
    errorCount: 0,
    totalBytes: 0,
  );

  bool get isEmpty => totalRequests == 0;

  /// Share of finished requests that returned 2xx, 0–1; null when none
  /// finished.
  double? get successRate =>
      finishedRequests == 0 ? null : successCount / finishedRequests;
}
