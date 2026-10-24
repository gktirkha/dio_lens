import '../entities/request_stats_entity.dart';

/// Aggregated request statistics.
abstract interface class StatsRepository {
  /// Current stats on listen, then a fresh value after every change to the
  /// captured requests.
  Stream<RequestStatsEntity> watchStats();
}
