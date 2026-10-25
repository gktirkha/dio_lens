import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';

abstract interface class ExportDataSource {
  Future<List<RequestDetailEntity>> getRequests();

  DioLensSettings get settings;
}
