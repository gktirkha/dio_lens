import '../../../../core/domain/use_case_base.dart';
import '../entities/request_detail_entity.dart';
import '../repositories/request_detail_repository.dart';

/// Watches one request by id.
class WatchRequestDetailUseCase
    implements UseCaseBase<Stream<RequestDetailEntity?>, String> {
  /// Creates the use case over [RequestDetailRepository].
  const WatchRequestDetailUseCase(this._repository);

  final RequestDetailRepository _repository;

  @override
  Stream<RequestDetailEntity?> call(String id) => _repository.watchRequest(id);
}
