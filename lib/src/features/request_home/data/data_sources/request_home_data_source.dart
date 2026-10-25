import '../../domain/entities/request_list_item_entity.dart';

/// Raw captured requests for the home list. Knows nothing about filtering; the
/// repository applies the filter.
abstract interface class RequestHomeDataSource {
  /// Every stored request, newest first. Emits on listen and after every
  /// change.
  Stream<List<RequestListItemEntity>> watchRequests();

  /// Every stored request, newest first.
  Future<List<RequestListItemEntity>> getRequests();

  /// Removes the request with [id].
  Future<void> deleteRequest(String id);

  /// Removes every request.
  Future<void> clearAll();

  /// Removes requests older than the retention allows.
  Future<void> removeExpired();
}
