import '../../../request_home/domain/entities/request_list_item_entity.dart';

/// Raw captured requests that stats are computed from.
abstract interface class StatsDataSource {
  /// All stored requests. Emits the current list on listen and again after
  /// every change.
  Stream<List<RequestListItemEntity>> watchRequests();
}
