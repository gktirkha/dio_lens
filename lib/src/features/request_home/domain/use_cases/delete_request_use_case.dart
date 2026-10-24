import '../../../../core/domain/unit.dart';
import '../../../../core/domain/use_case_base.dart';
import '../repositories/request_home_repository.dart';

/// Removes one captured request by id.
class DeleteRequestUseCase implements UseCaseBase<Unit, String> {
  const DeleteRequestUseCase(this._repository);

  final RequestHomeRepository _repository;

  @override
  Future<Unit> call(String id) => _repository.deleteRequest(id);
}
