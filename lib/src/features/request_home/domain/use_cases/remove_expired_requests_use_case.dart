import '../../../../core/domain/unit.dart';
import '../../../../core/domain/use_case_base.dart';
import '../repositories/request_home_repository.dart';

/// Removes requests older than the retention allows.
class RemoveExpiredRequestsUseCase implements UseCaseBase<Unit, Unit> {
  /// Creates the use case over [RequestHomeRepository].
  const RemoveExpiredRequestsUseCase(this._repository);

  final RequestHomeRepository _repository;

  @override
  Future<Unit> call(Unit params) => _repository.removeExpired();
}
