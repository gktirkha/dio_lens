import '../../../../core/storage/dio_lens_store.dart';
import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';
import 'export_data_source.dart';

class ExportLocalDataSource implements ExportDataSource {
  ExportLocalDataSource(this._store);

  final DioLensStore _store;

  @override
  Future<List<RequestDetailEntity>> getRequests() async {
    await _store.ready;
    return _store.requests;
  }

  @override
  DioLensSettings get settings => _store.settings.value;
}
