import '../../../../core/storage/dio_lens_store.dart';
import '../../domain/entities/request_detail_entity.dart';
import 'request_detail_data_source.dart';

/// [RequestDetailDataSource] over the stored requests.
class RequestDetailLocalDataSource implements RequestDetailDataSource {
  /// Creates the data source over the store.
  RequestDetailLocalDataSource(this._store);

  final DioLensStore _store;

  @override
  Stream<RequestDetailEntity?> watchRequest(String id) =>
      _store.watchRequest(id);
}
