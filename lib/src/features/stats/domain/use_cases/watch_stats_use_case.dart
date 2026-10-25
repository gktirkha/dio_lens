import '../../../../core/domain/unit.dart';
import '../../../../core/domain/use_case_base.dart';
import '../entities/request_stats_entity.dart';
import '../repositories/stats_repository.dart';

/// Watches the stats.
class WatchStatsUseCase
    implements UseCaseBase<Stream<RequestStatsEntity>, Unit> {
  /// Creates the use case over [StatsRepository].
  const WatchStatsUseCase(this._repository);

  final StatsRepository _repository;

  @override
  Stream<RequestStatsEntity> call(Unit params) => _repository.watchStats();
}
