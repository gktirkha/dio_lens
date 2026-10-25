import '../../../../core/enums/export_format.dart';
import '../entities/dio_lens_export_file.dart';

abstract interface class ExportRepository {
  /// Every stored request in [format], with sensitive values masked as
  /// the settings say.
  Future<DioLensExportFile> exportRequests(DioLensExportFormat format);
}
