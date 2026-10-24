import '../../domain/entities/request_list_item_entity.dart';

/// Raw storage for captured requests. Knows nothing about filtering; the
/// repository applies [RequestFilterParams] on top.
abstract interface class RequestHomeDataSource {
  /// All stored requests, newest first. Emits the current list on listen and
  /// again after every change.
  Stream<List<RequestListItemEntity>> watchRequests();

  /// All stored requests, newest first.
  Future<List<RequestListItemEntity>> getRequests();

  Future<void> deleteRequest(String id);

  Future<void> clearAll();
}
