import '../../../../core/enums/request_state.dart';
import '../../../../core/enums/request_status_class.dart';
import '../../../request_home/domain/entities/request_list_item_entity.dart';
import '../../domain/entities/endpoint_latency_entity.dart';
import '../../domain/entities/endpoint_size_entity.dart';
import '../../domain/entities/named_count_entity.dart';
import '../../domain/entities/request_stats_entity.dart';
import '../../domain/entities/status_share_entity.dart';

abstract final class RequestStatsCalculator {
  static const List<RequestStatusClass> distributionOrder = [
    RequestStatusClass.success,
    RequestStatusClass.redirect,
    RequestStatusClass.clientError,
    RequestStatusClass.serverError,
    RequestStatusClass.error,
    RequestStatusClass.pending,
    RequestStatusClass.informational,
  ];

  static RequestStatsEntity calculate(List<RequestListItemEntity> requests) {
    if (requests.isEmpty) return RequestStatsEntity.empty;

    final statusCounts = <RequestStatusClass, int>{};
    final latencies = <int>[];
    final latencyByPath = <String, List<int>>{};
    final largestByPath = <String, int>{};
    final callsByPath = <String, int>{};
    final callsByHost = <String, int>{};
    var finished = 0;
    var totalBytes = 0;

    for (final r in requests) {
      final statusClass = r.statusClass;
      statusCounts[statusClass] = (statusCounts[statusClass] ?? 0) + 1;
      if (r.state != RequestState.pending) finished++;
      if (r.responseSize case final size?) {
        totalBytes += size;
        if (size > (largestByPath[r.path] ?? -1)) largestByPath[r.path] = size;
      }
      callsByPath[r.path] = (callsByPath[r.path] ?? 0) + 1;
      callsByHost[r.host] = (callsByHost[r.host] ?? 0) + 1;

      final ms = r.duration?.inMilliseconds;
      if (ms != null && r.state == RequestState.completed) {
        latencies.add(ms);
        (latencyByPath[r.path] ??= []).add(ms);
      }
    }

    int count(RequestStatusClass c) => statusCounts[c] ?? 0;
    latencies.sort();

    return RequestStatsEntity(
      totalRequests: requests.length,
      finishedRequests: finished,
      successCount: count(RequestStatusClass.success),
      errorCount:
          count(RequestStatusClass.clientError) +
          count(RequestStatusClass.serverError) +
          count(RequestStatusClass.error),
      totalBytes: totalBytes,
      averageLatency: latencies.isEmpty
          ? null
          : Duration(
              milliseconds:
                  (latencies.reduce((a, b) => a + b) / latencies.length)
                      .round(),
            ),
      p95Latency: latencies.isEmpty
          ? null
          : Duration(milliseconds: _percentile(latencies, 0.95)),
      statusDistribution: [
        for (final c in distributionOrder)
          if (count(c) > 0) StatusShareEntity(statusClass: c, count: count(c)),
      ],
      slowestEndpoints: _top(
        latencyByPath.entries.map(
          (e) => EndpointLatencyEntity(
            path: e.key,
            averageLatency: Duration(
              milliseconds: (e.value.reduce((a, b) => a + b) / e.value.length)
                  .round(),
            ),
          ),
        ),
        (e) => e.averageLatency.inMilliseconds,
      ),
      largestResponses: _top(
        largestByPath.entries.map(
          (e) => EndpointSizeEntity(path: e.key, bytes: e.value),
        ),
        (e) => e.bytes,
      ),
      mostCalledEndpoints: _top(
        callsByPath.entries.map(
          (e) => NamedCountEntity(name: e.key, count: e.value),
        ),
        (e) => e.count,
      ),
      topHosts: _top(
        callsByHost.entries.map(
          (e) => NamedCountEntity(name: e.key, count: e.value),
        ),
        (e) => e.count,
      ),
    );
  }

  static int _percentile(List<int> sorted, double p) {
    final rank = (p * sorted.length).ceil().clamp(1, sorted.length);
    return sorted[rank - 1];
  }

  static List<T> _top<T>(Iterable<T> items, int Function(T) score) {
    final sorted = items.toList()..sort((a, b) => score(b).compareTo(score(a)));
    return List.unmodifiable(sorted);
  }
}
