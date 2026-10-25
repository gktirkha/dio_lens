import '../../../request_home/domain/entities/request_list_item_entity.dart';

abstract interface class StatsDataSource {
  Stream<List<RequestListItemEntity>> watchRequests();
}
