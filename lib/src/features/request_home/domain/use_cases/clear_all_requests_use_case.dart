import '../../../../core/domain/unit.dart';
import '../../../../core/domain/use_case_base.dart';
import '../repositories/request_home_repository.dart';

class ClearAllRequestsUseCase implements UseCaseBase<Unit, Unit> {
  const ClearAllRequestsUseCase(this._repository);

  final RequestHomeRepository _repository;

  @override
  Future<Unit> call(Unit params) => _repository.clearAll();
}
