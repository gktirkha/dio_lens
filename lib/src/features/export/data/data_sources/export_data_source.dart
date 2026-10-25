import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';

/// What an export is built from.
abstract interface class ExportDataSource {
  /// Every stored request, newest first.
  Future<List<RequestDetailEntity>> getRequests();

  /// Current settings (they decide what is masked).
  DioLensSettings get settings;
}
