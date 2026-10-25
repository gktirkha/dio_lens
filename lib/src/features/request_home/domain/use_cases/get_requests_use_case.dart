import '../../../../core/domain/use_case_base.dart';
import '../entities/request_filter_params.dart';
import '../entities/request_list_item_entity.dart';
import '../repositories/request_home_repository.dart';

/// Reads the requests matching a filter once.
class GetRequestsUseCase
    implements UseCaseBase<List<RequestListItemEntity>, RequestFilterParams> {
  /// Creates the use case over [RequestHomeRepository].
  const GetRequestsUseCase(this._repository);

  final RequestHomeRepository _repository;

  @override
  Future<List<RequestListItemEntity>> call(RequestFilterParams params) =>
      _repository.getRequests(params);
}
