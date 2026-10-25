import '../../../../core/domain/unit.dart';
import '../entities/request_filter_params.dart';
import '../entities/request_list_item_entity.dart';

abstract interface class RequestHomeRepository {
  Stream<List<RequestListItemEntity>> watchRequests(RequestFilterParams params);

  Future<List<RequestListItemEntity>> getRequests(RequestFilterParams params);

  Future<Unit> deleteRequest(String id);

  Future<Unit> clearAll();

  Future<Unit> removeExpired();
}
