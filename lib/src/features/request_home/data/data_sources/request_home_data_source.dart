import '../../domain/entities/request_list_item_entity.dart';

abstract interface class RequestHomeDataSource {
  Stream<List<RequestListItemEntity>> watchRequests();

  Future<List<RequestListItemEntity>> getRequests();

  Future<void> deleteRequest(String id);

  Future<void> clearAll();

  Future<void> removeExpired();
}
