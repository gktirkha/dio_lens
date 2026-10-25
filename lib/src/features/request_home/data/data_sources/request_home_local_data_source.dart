import '../../../../core/storage/dio_lens_store.dart';
import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../../domain/entities/request_list_item_entity.dart';
import '../mappers/request_list_item_mapper.dart';
import 'request_home_data_source.dart';

/// [RequestHomeDataSource] over the requests captured by the interceptor.
class RequestHomeLocalDataSource implements RequestHomeDataSource {
  RequestHomeLocalDataSource(this._store);

  final DioLensStore _store;

  @override
  Stream<List<RequestListItemEntity>> watchRequests() =>
      _store.watchRequests().map(_toItems);

  @override
  Future<List<RequestListItemEntity>> getRequests() async {
    await _store.ready;
    return _toItems(_store.requests);
  }

  @override
  Future<void> deleteRequest(String id) => _store.delete(id);

  @override
  Future<void> clearAll() => _store.clear();

  static List<RequestListItemEntity> _toItems(
    List<RequestDetailEntity> requests,
  ) => [for (final r in requests) r.toListItem()];
}
