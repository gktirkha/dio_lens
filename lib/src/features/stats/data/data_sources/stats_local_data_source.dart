import '../../../../core/storage/dio_lens_store.dart';
import '../../../request_home/domain/entities/request_list_item_entity.dart';
import 'stats_data_source.dart';

/// [StatsDataSource] over the stored requests.
class StatsLocalDataSource implements StatsDataSource {
  /// Creates the data source over the store.
  StatsLocalDataSource(this._store);

  final DioLensStore _store;

  @override
  Stream<List<RequestListItemEntity>> watchRequests() => _store.watchRequests();
}
