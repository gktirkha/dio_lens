import '../../../../core/domain/unit.dart';
import '../../../../core/domain/use_case_base.dart';
import '../entities/request_stats_entity.dart';
import '../repositories/stats_repository.dart';

/// Live stats for the dashboard.
class WatchStatsUseCase
    implements UseCaseBase<Stream<RequestStatsEntity>, Unit> {
  const WatchStatsUseCase(this._repository);

  final StatsRepository _repository;

  @override
  Stream<RequestStatsEntity> call(Unit params) => _repository.watchStats();
}
