import '../../../../core/domain/unit.dart';
import '../entities/request_filter_params.dart';
import '../entities/request_list_item_entity.dart';

/// Captured requests for the home list.
abstract interface class RequestHomeRepository {
  /// Requests matching [params], newest first. Emits the current list on
  /// listen and again whenever a request is added, updated or removed.
  Stream<List<RequestListItemEntity>> watchRequests(RequestFilterParams params);

  /// One-off snapshot of requests matching [params], newest first.
  Future<List<RequestListItemEntity>> getRequests(RequestFilterParams params);

  Future<Unit> deleteRequest(String id);

  Future<Unit> clearAll();
}
