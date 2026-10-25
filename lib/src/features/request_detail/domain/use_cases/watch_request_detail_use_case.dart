import '../../../../core/domain/use_case_base.dart';
import '../entities/request_detail_entity.dart';
import '../repositories/request_detail_repository.dart';

/// Live details of one request, by id.
class WatchRequestDetailUseCase
    implements UseCaseBase<Stream<RequestDetailEntity?>, String> {
  const WatchRequestDetailUseCase(this._repository);

  final RequestDetailRepository _repository;

  @override
  Stream<RequestDetailEntity?> call(String id) => _repository.watchRequest(id);
}
