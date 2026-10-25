import '../../../../core/domain/use_case_base.dart';
import '../entities/request_filter_params.dart';
import '../entities/request_list_item_entity.dart';
import '../repositories/request_home_repository.dart';

class WatchRequestsUseCase
    implements
        UseCaseBase<Stream<List<RequestListItemEntity>>, RequestFilterParams> {
  const WatchRequestsUseCase(this._repository);

  final RequestHomeRepository _repository;

  @override
  Stream<List<RequestListItemEntity>> call(RequestFilterParams params) =>
      _repository.watchRequests(params);
}
