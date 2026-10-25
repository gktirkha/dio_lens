import '../../../../core/domain/unit.dart';
import '../entities/request_filter_params.dart';
import '../entities/request_list_item_entity.dart';

/// Captured requests for the home list.
abstract interface class RequestHomeRepository {
  /// Requests matching [params], newest first. Emits on listen and after every
  /// change.
  Stream<List<RequestListItemEntity>> watchRequests(RequestFilterParams params);

  /// Requests matching [params], newest first, once.
  Future<List<RequestListItemEntity>> getRequests(RequestFilterParams params);

  /// Removes the request with [id].
  Future<Unit> deleteRequest(String id);

  /// Removes every request.
  Future<Unit> clearAll();

  /// Removes requests older than the retention allows.
  Future<Unit> removeExpired();
}
