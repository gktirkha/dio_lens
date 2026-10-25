import '../../../../core/storage/dio_lens_store.dart';
import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';
import 'export_data_source.dart';

/// [ExportDataSource] over the stored requests and settings.
class ExportLocalDataSource implements ExportDataSource {
  /// Creates the data source over the store.
  ExportLocalDataSource(this._store);

  final DioLensStore _store;

  @override
  Future<List<RequestDetailEntity>> getRequests() => _store.getAllRequests();

  @override
  DioLensSettings get settings => _store.settings.value;
}
