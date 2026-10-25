import '../../../../core/storage/dio_lens_store.dart';
import '../../../request_home/data/mappers/request_list_item_mapper.dart';
import '../../../request_home/domain/entities/request_list_item_entity.dart';
import 'stats_data_source.dart';

/// [StatsDataSource] over the requests captured by the interceptor.
class StatsLocalDataSource implements StatsDataSource {
  StatsLocalDataSource(this._store);

  final DioLensStore _store;

  @override
  Stream<List<RequestListItemEntity>> watchRequests() => _store
      .watchRequests()
      .map((requests) => [for (final r in requests) r.toListItem()]);
}
