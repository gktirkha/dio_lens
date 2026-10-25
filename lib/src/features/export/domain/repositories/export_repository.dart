import '../../../../core/enums/export_format.dart';
import '../entities/dio_lens_export_file.dart';

/// Builds exports of the stored requests.
abstract interface class ExportRepository {
  /// Every stored request in [format], masked as the settings say.
  Future<DioLensExportFile> exportRequests(DioLensExportFormat format);
}
