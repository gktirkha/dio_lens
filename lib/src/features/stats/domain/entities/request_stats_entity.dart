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
    /// Every captured request.
    @JsonKey(name: 'total_requests') required int totalRequests,

    /// Completed or failed requests, i.e. not pending.
    @JsonKey(name: 'finished_requests') required int finishedRequests,

    /// 2xx responses.
    @JsonKey(name: 'success_count') required int successCount,

    /// Failed requests: no response, or a status the Dio's `validateStatus`
    /// rejected (4xx or 5xx when that is unknown). See
    /// `RequestListItemEntity.isFailure`.
    @JsonKey(name: 'error_count') required int errorCount,

    /// Sum of response body sizes, in bytes.
    @JsonKey(name: 'total_bytes') required int totalBytes,

    /// Average time to a response; null when none completed.
    @JsonKey(name: 'average_latency') Duration? averageLatency,

    /// 95th percentile time to a response; null when none completed.
    @JsonKey(name: 'p95_latency') Duration? p95Latency,

    /// Requests per status class, only classes that occur, in display order.
    @JsonKey(name: 'status_distribution')
    @Default(<StatusShareEntity>[])
    List<StatusShareEntity> statusDistribution,

    /// Endpoints by average latency, slowest first.
    @JsonKey(name: 'slowest_endpoints')
    @Default(<EndpointLatencyEntity>[])
    List<EndpointLatencyEntity> slowestEndpoints,

    /// Endpoints by number of failed calls (as counted by [errorCount]), most
    /// failures first; only endpoints that failed at least once.
    @JsonKey(name: 'top_failing_endpoints')
    @Default(<NamedCountEntity>[])
    List<NamedCountEntity> topFailingEndpoints,

    /// Endpoints by largest response, largest first.
    @JsonKey(name: 'largest_responses')
    @Default(<EndpointSizeEntity>[])
    List<EndpointSizeEntity> largestResponses,

    /// Endpoints by number of calls, most called first.
    @JsonKey(name: 'most_called_endpoints')
    @Default(<NamedCountEntity>[])
    List<NamedCountEntity> mostCalledEndpoints,

    /// Hosts by number of calls, busiest first.
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
