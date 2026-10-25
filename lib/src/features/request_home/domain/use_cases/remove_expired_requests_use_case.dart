import '../../../../core/domain/unit.dart';
import '../../../../core/domain/use_case_base.dart';
import '../repositories/request_home_repository.dart';

class RemoveExpiredRequestsUseCase implements UseCaseBase<Unit, Unit> {
  const RemoveExpiredRequestsUseCase(this._repository);

  final RequestHomeRepository _repository;

  @override
  Future<Unit> call(Unit params) => _repository.removeExpired();
}
