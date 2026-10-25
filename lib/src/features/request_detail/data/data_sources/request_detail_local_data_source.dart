import '../../../../core/storage/dio_lens_store.dart';
import '../../domain/entities/request_detail_entity.dart';
import 'request_detail_data_source.dart';

/// [RequestDetailDataSource] over the requests captured by the interceptor.
class RequestDetailLocalDataSource implements RequestDetailDataSource {
  RequestDetailLocalDataSource(this._store);

  final DioLensStore _store;

  @override
  Stream<RequestDetailEntity?> watchRequest(String id) =>
      _store.watchRequests().map((requests) {
        for (final r in requests) {
          if (r.id == id) return r;
        }
        return null;
      }).distinct();
}
