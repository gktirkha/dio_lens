import '../entities/request_stats_entity.dart';

abstract interface class StatsRepository {
  Stream<RequestStatsEntity> watchStats();
}
