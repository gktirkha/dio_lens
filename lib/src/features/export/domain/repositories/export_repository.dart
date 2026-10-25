import '../../../../core/enums/export_format.dart';
import '../entities/dio_lens_export_file.dart';

abstract interface class ExportRepository {
  Future<DioLensExportFile> exportRequests(DioLensExportFormat format);
}
