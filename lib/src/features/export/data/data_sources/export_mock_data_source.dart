import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';
import 'export_data_source.dart';

class ExportMockDataSource implements ExportDataSource {
  ExportMockDataSource({
    this.requests = const [],
    this.settings = const DioLensSettings(),
  });

  final List<RequestDetailEntity> requests;

  @override
  final DioLensSettings settings;

  @override
  Future<List<RequestDetailEntity>> getRequests() async => requests;
}
