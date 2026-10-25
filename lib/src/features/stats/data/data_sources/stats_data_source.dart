import '../../../request_home/domain/entities/request_list_item_entity.dart';

/// Captured requests that stats are computed from.
abstract interface class StatsDataSource {
  /// Every stored request. Emits on listen and after every change.
  Stream<List<RequestListItemEntity>> watchRequests();
}
