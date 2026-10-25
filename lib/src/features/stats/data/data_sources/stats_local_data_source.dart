import '../../../../core/storage/dio_lens_store.dart';
import '../../../request_home/domain/entities/request_list_item_entity.dart';
import 'stats_data_source.dart';

class StatsLocalDataSource implements StatsDataSource {
  StatsLocalDataSource(this._store);

  final DioLensStore _store;

  @override
  Stream<List<RequestListItemEntity>> watchRequests() => _store.watchRequests();
}
