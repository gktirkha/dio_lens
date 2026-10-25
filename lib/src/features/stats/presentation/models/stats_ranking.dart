import '../../../../core/utils/format_utils.dart';
import '../../domain/entities/request_stats_entity.dart';
import '../widgets/ranked_list.dart';

/// The ranked lists on the stats page; each opens a full-list page.
enum StatsRanking {
  slowestEndpoints('Slowest endpoints'),
  mostCalledEndpoints('Most-called endpoints'),
  topHosts('Top hosts');

  const StatsRanking(this.title);

  final String title;

  /// Rows shown on the dashboard; the full list is one tap away.
  static const int previewCount = 5;

  /// Average latency above this is highlighted in [slowestEndpoints].
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
