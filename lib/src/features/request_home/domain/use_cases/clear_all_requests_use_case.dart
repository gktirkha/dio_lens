import '../../../../core/domain/unit.dart';
import '../../../../core/domain/use_case_base.dart';
import '../repositories/request_home_repository.dart';

/// Removes every captured request.
class ClearAllRequestsUseCase implements UseCaseBase<Unit, Unit> {
  /// Creates the use case over [RequestHomeRepository].
  const ClearAllRequestsUseCase(this._repository);

  final RequestHomeRepository _repository;

  @override
  Future<Unit> call(Unit params) => _repository.clearAll();
}
