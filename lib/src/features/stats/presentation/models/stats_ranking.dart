import '../../../../core/utils/format_utils.dart';
import '../../domain/entities/request_stats_entity.dart';
import '../widgets/ranked_list.dart';

/// The ranked lists of the stats page; each opens a full-list page.
enum StatsRanking {
  /// Endpoints by average latency.
  slowestEndpoints('Slowest endpoints'),

  /// Endpoints by number of failed calls.
  topFailingEndpoints('Top failing endpoints'),

  /// Endpoints by largest response.
  largestResponses('Largest responses'),

  /// Endpoints by number of calls.
  mostCalledEndpoints('Most-called endpoints'),

  /// Hosts by number of calls.
  topHosts('Top hosts');

  const StatsRanking(this.title);

  /// Panel title.
  final String title;

  /// Rows shown on the stats page; the full list is one tap away.
  static const int previewCount = 5;

  /// Average latency above this is highlighted.
  static const Duration slowThreshold = Duration(milliseconds: 400);

  /// Every row of this ranking, highest first.
  List<RankedItem> items(RequestStatsEntity stats) {
    switch (this) {
      case StatsRanking.slowestEndpoints:
        return [
          for (final e in stats.slowestEndpoints)
            (
              label: e.path,
              value: FormatUtils.duration(e.averageLatency),
              score: e.averageLatency.inMilliseconds.toDouble(),
              warn: e.averageLatency > slowThreshold,
            ),
        ];
      case StatsRanking.topFailingEndpoints:
        return [
          for (final e in stats.topFailingEndpoints)
            (
              label: e.name,
              value: '${e.count}×',
              score: e.count.toDouble(),
              warn: true,
            ),
        ];
      case StatsRanking.largestResponses:
        return [
          for (final e in stats.largestResponses)
            (
              label: e.path,
              value: FormatUtils.bytes(e.bytes),
              score: e.bytes.toDouble(),
              warn: false,
            ),
        ];
      case StatsRanking.mostCalledEndpoints:
        return [
          for (final e in stats.mostCalledEndpoints)
            (
              label: e.name,
              value: '${e.count}×',
              score: e.count.toDouble(),
              warn: false,
            ),
        ];
      case StatsRanking.topHosts:
        return [
          for (final e in stats.topHosts)
            (
              label: e.name,
              value: '${e.count}×',
              score: e.count.toDouble(),
              warn: false,
            ),
        ];
    }
  }
}
