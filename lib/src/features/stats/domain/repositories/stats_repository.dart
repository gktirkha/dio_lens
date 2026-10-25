import '../entities/request_stats_entity.dart';

/// Stats of the captured requests.
abstract interface class StatsRepository {
  /// The stats, recomputed after every change.
  Stream<RequestStatsEntity> watchStats();
}
