import '../../domain/entities/request_stats_entity.dart';
import '../../domain/repositories/stats_repository.dart';
import '../data_sources/stats_data_source.dart';
import '../utils/request_stats_calculator.dart';

class StatsRepositoryImpl implements StatsRepository {
  const StatsRepositoryImpl(this._dataSource);

  final StatsDataSource _dataSource;

  @override
  Stream<RequestStatsEntity> watchStats() =>
      _dataSource.watchRequests().map(RequestStatsCalculator.calculate);
}
