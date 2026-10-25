import '../../../../core/storage/dio_lens_store.dart';
import '../../domain/entities/request_list_item_entity.dart';
import 'request_home_data_source.dart';

class RequestHomeLocalDataSource implements RequestHomeDataSource {
  RequestHomeLocalDataSource(this._store);

  final DioLensStore _store;

  @override
  Stream<List<RequestListItemEntity>> watchRequests() => _store.watchRequests();

  @override
  Future<List<RequestListItemEntity>> getRequests() async {
    await _store.ready;
    return _store.requests;
  }

  @override
  Future<void> deleteRequest(String id) => _store.delete(id);

  @override
  Future<void> clearAll() => _store.clear();

  @override
  Future<void> removeExpired() => _store.removeExpired();
}
